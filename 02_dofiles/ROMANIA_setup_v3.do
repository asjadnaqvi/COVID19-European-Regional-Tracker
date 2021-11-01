clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Romania"

***** county_codes (one time setup)

/*
import excel using romania_county_codes.xlsx, clear first
drop FIPS area_km2

compress
save county_code.dta, replace
*/


*** data file: https://datelazi.ro/
**** here we use a file cleaned from a json reader: https://json-csv.com/

// update: Oct 21: data strcuture changed in the link above. switching to https://github.com/denesdata/roeim


import delimited using "https://github.com/denesdata/roeim/blob/master/data/time_series_ro_counties_daily.csv?raw=true", clear

drop lang
drop id
drop case_14
drop case_14_cap
drop case_cap
drop pop

ren date date2
gen double date = date(date2, "YMD")
format date %tdDD-Mon-yy
drop date2

order county date

destring _all, replace


compress
save "$coviddir/04_master/romania_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/romania_data_original.csv", replace delim(;)



drop if cases==.
ren iso ISO


merge m:1 ISO using county_code.dta
drop _m

order nuts3_id date
sort nuts3_id date

**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]
tab check

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1

drop check


order  nuts3_id date
sort  nuts3_id date 
compress
save "$coviddir/04_master/romania_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/romania_data.csv", replace delim(;)


cd "$coviddir"
