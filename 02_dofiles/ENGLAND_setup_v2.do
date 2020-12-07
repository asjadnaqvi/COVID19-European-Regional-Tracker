clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/England"



**** GIS data: http://geoportal.statistics.gov.uk/datasets/1d78d47c87df4212b79fe2323aae8e08_0/data

**** LAD/NUTS3 data from web matching

insheet using UK_LAD2.csv, clear
drop objectid lad19nmw bng_e bng_n longitude latitude st_areasha st_lengths levl_code cntr_code mount_type urbn_type coast_type fid nuts_name
ren lad19cd lad_id
ren lad19nm lad_name
ren nuts_id nuts3_id
compress
save UK_regions.dta, replace





*** ENGLAND

**https://raw.githubusercontent.com/odileeds/covid-19-uk-datasets/master/data/england-cases.csv

insheet using "https://raw.githubusercontent.com/odileeds/covid-19-uk-datasets/master/data/england-cases.csv", clear n

save england_raw.dta, replace
export delimited using england_raw.csv, replace delim(;)


gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
ren totalcases cases
ren dailycases cases_daily
ren areacode lad_id
compress
save england.dta, replace




merge m:1 lad_id using UK_regions

*duplicates drop lad_id, force


egen tag = tag(lad_id)
list lad_id lad_name nuts3_id _m if _m==1 & tag==1
list lad_id lad_name nuts3_id _m if _m==2 & tag==1

drop if _m!=3
drop _m





collapse (sum) cases, by(nuts3_id date)

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1]


sum date
*drop if date>=r(max)-2

compress
save "$coviddir/04_master/england_data.dta", replace	
export delimited using "$coviddir/04_master/csv/england_data.csv", replace delim(;)


cd "$coviddir"

