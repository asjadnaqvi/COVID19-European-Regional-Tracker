clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Norway"



****** getting the IDs in order

insheet using spatial_merge.csv, clear
drop cntr_code nuts_name mount_type urbn_type coast_type fid
drop if nuts_id==""
ren nuts_id nuts3_id
compress
save lau_norway.dta, replace



********** at the NUTS3 level
insheet using "https://raw.githubusercontent.com/thohan88/covid19-nor-data/master/data/01_infected/msis/municipality.csv", clear 
save "$coviddir/04_master/norway_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/norway_data_original.csv", replace delim(;)



drop date_time



*ren region* y_*

gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)

order date
format date %tdDD-Mon-yyyy
sort date 

drop date2
drop year month day

*duplicates drop kommune_no, force
sort fylke_name kommune_no


*ren kommune_name lau_name




*****

merge m:1 kommune_no using lau_norway.dta


egen tag = tag(kommune_no)
sort kommune_no

list kommune_no kommune_name if tag==1 & _m==1
list kommune_no kommune_name if tag==1 & _m==2  // these are islands that are merged together

replace nuts3_id ="NO042" if kommune_name=="Svalbard"

drop if nuts3_id==""

*drop if _m!=3
drop _m
drop tag

collapse (sum) cases, by(nuts3_id date)


**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1

drop check


order date nuts3_id
compress
save "$coviddir/04_master/norway_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/norway_data.csv", replace delim(;)


cd "$coviddir"
