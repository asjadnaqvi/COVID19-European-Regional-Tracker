clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir./01_raw/Denmark"


**** IDs. Need to run it just one time.

/*
import excel using LAU_Denmark.xlsx, clear first
replace lau = subinstr(lau,"-", "_", .)
sort lau
drop area_m2
ren pop population
compress
save LAU_Denmark.dta, replace
*/

*** file updated from
*https://covid19.ssi.dk/overvagningsdata/ugentlige-opgorelser-med-overvaagningsdata
*https://covid19.ssi.dk/overvagningsdata/download-fil-med-overvaagningdata

import delimited using "./Kommunalt_DB/07_bekraeftede_tilfaelde_pr_dag_pr_kommune.csv", clear varn(nonames)
save "$coviddir/04_master/denmark_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/denmark_data_original.csv", replace delim(;)




ren v1 region_id
ren v2 region
ren v3 date
ren v4 cases_daily

drop in 1

destring _all, replace


replace region = subinstr(region,"-", "_", .)


*reshape long v_, i(date) j(region) string
*ren v_ cases
*destring _all, replace



*** fix date
gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy

destring _all, replace




ren region lau
replace lau = "Aarhus" 				if lau=="Århus"
replace lau = "Vesthimmerlands" 	if lau== "Vesthimmerland"
replace lau = "Nordfyns" 	if lau== "Nordfyn"
replace lau = "Høje_Taastrup" if lau== "Høje Tåstrup"
replace lau = "" if lau== ""
replace lau = "" if lau== ""
replace lau = "" if lau== ""


merge m:1 lau using LAU_Denmark

list lau if _m==1
list lau if _m==2  // one observation does not match

drop if _m==1
drop _m

replace nuts3_id="DK014" if lau=="Christiansø"


sort  nuts3_id date
order nuts3_id date

*ren cases cases_daily
collapse (sum) cases_daily, by(nuts3_id date)

gen cases = .

levelsof date, local(dts)
foreach x of local dts {
	bysort nuts3_id: egen temp= sum(cases_daily) if date <= `x'
	qui cap replace cases = temp	if date == `x'
	qui drop temp
}




sort  nuts3_id date
order nuts3_id date

compress
save "$coviddir/04_master/denmark_data.dta", replace		
export delimited using "$coviddir/04_master/csv_nuts/denmark_data.csv", replace delim(;)



cd "$coviddir"
