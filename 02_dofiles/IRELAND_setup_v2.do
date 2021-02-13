clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Ireland"




*** manually download here: https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0

insheet using "Covid19CountyStatisticsHPSCIreland.csv", clear non
save "$coviddir/04_master/ireland_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/ireland_data_original.csv", replace delim(;)



drop v1 v2 v6 v7 v8 v9 v10 v12 v15 v16

foreach x of varlist v* {
		local header = `x'[1]
		local header = lower("`header'")
		ren `x' `header'
}

drop in 1
destring _all, replace



ren timestamp date
gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy



ren confirmedcovidcases cases
ren populationcensus16 population

drop confirmedcoviddeaths confirmedcovidrecovered

sort county date
bysort county: gen cases_daily = cases - cases[_n-1]


gen nuts3_id=""


replace nuts3_id="IE041" if county=="Donegal"
replace nuts3_id="IE041" if county=="Sligo"
replace nuts3_id="IE041" if county=="Leitrim"
replace nuts3_id="IE041" if county=="Cavan"
replace nuts3_id="IE041" if county=="Monaghan"
replace nuts3_id="IE042" if county=="Galway"
replace nuts3_id="IE042" if county=="Mayo"
replace nuts3_id="IE042" if county=="Roscommon"
replace nuts3_id="IE051" if county=="Clare"
replace nuts3_id="IE051" if county=="Tipperary"
replace nuts3_id="IE051" if county=="Limerick"
replace nuts3_id="IE052" if county=="Waterford"
replace nuts3_id="IE052" if county=="Kilkenny"
replace nuts3_id="IE052" if county=="Carlow"
replace nuts3_id="IE052" if county=="Wexford"
replace nuts3_id="IE053" if county=="Cork"
replace nuts3_id="IE053" if county=="Kerry"
replace nuts3_id="IE061" if county=="Dublin"
replace nuts3_id="IE062" if county=="Wicklow"
replace nuts3_id="IE062" if county=="Kildare"
replace nuts3_id="IE062" if county=="Meath"
replace nuts3_id="IE062" if county=="Louth"
replace nuts3_id="IE063" if county=="Longford"
replace nuts3_id="IE063" if county=="Westmeath"
replace nuts3_id="IE063" if county=="Offaly"
replace nuts3_id="IE063" if county=="Laois"


order date county nuts3_id 




collapse (sum) cases cases_daily, by(nuts3_id date)


compress
save "$coviddir/04_master/ireland_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/ireland_data.csv", replace delim(;)


cd "$coviddir"

