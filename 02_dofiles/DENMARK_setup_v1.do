clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir./01_raw/Denmark"


**** IDs 
import excel using LAU_Denmark.xlsx, clear first
replace lau = subinstr(lau,"-", "_", .)
sort lau
drop area_m2
ren pop population
compress
save LAU_Denmark.dta, replace


*** file updated from
*https://covid19.ssi.dk/overvagningsdata/ugentlige-opgorelser-med-overvaagningsdata


insheet using "Municipality_cases_time_series.csv", clear delim(";") nonames
save denmark_raw.dta, replace




ren v1 date

foreach x of varlist v* {
	local header = `x'[1]
	local header : subinstr loc header  "-"  "_" 
		ren `x' v_`header'
	}

drop in 1

reshape long v_, i(date) j(region) string

ren v_ cases

destring _all, replace



*** fix date
gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy

destring _all, replace



ren region lau
replace lau = "København" if lau=="Copenhagen"


merge m:1 lau using LAU_Denmark

list lau if _m==1
list lau if _m==2  // one observation does not match

drop if _m!=3
drop _m


sort  nuts3_id date
order nuts3_id date

ren cases cases_daily
collapse (sum) cases_daily, by(nuts3_id date)

sort  nuts3_id date
order nuts3_id date

compress
save "$coviddir/04_master/denmark_data.dta", replace		
export delimited using "$coviddir/04_master/csv/denmark_data.csv", replace delim(;)



cd "$coviddir"
