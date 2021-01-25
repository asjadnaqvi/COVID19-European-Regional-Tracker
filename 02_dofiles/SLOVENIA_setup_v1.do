clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Slovenia"



****** getting the IDs in order

import excel using "LAU.xlsx", first clear
sort lau_id
compress
save LAU_slovenia.dta, replace




*** second id file
insheet using "https://raw.githubusercontent.com/sledilnik/data/master/csv/dict-municipality.csv", clear

ren region region2

replace id = subinstr(id, "-", "_", .)

gen region = region2 + "_" + id
order region region2 id
drop if iso_code==""
drop name_alt

replace iso_code = subinstr(iso_code, "SI-", "", .)
destring iso_code, replace
sort iso_code
ren iso_code lau_id

merge 1:1 lau_id using LAU_slovenia
drop region2 id name area pop_dens _merge
drop population area_m2


replace region="mb_sveta_trojica_v_slovenskih" 	if region=="mb_sveta_trojica_v_slovenskih_goricah"
replace region="sg_mislinja" 					if region=="ce_mislinja"
replace region="nm_kostanjevica_na_krki" 		if region=="kk_kostanjevica_na_krki"
replace region="mb_sveti_andraž_v_slovenskih" 	if region=="mb_sveti_andraž_v_slovenskih_goricah"
replace region="kk_kostanjevica_na_krki" 		if region=="nm_kostanjevica_na_krki"
replace region="mb_sveti_jurij_v_slovenskih" 	if region=="mb_sveti_jurij_v_slovenskih_goricah"


order region
save "slovenia_id.dta", replace



********** at the NUTS3 level

**** official data is in a google doc sheet: https://docs.google.com/spreadsheets/d/1N1qLMoWyi3WFGhIpPFzKsFmVE0IwNP3elb_c18t2DwY/edit#gid=0



*** https://github.com/joahim/covid-19
***https://github.com/sledilnik/data/blob/master/csv/active-regions.csv
* https://covid-19.sledilnik.org/sl/datasources


insheet using "https://raw.githubusercontent.com/sledilnik/data/master/csv/municipality-confirmed.csv", clear non
save slovenia_raw.dta, replace
export delimited using slovenia_raw.csv, replace delim(;)



ren v1 date



foreach x of varlist v* {
	local header = `x'[1]
	local header = subinstr("`header'","region.","", .)
	local header = subinstr("`header'","_goricah","", .)
	local header = subinstr("`header'","-","_", .)
	local header = subinstr("`header'",".","_", .)
	cap ren `x' y_`header'
	}

*cap drop *_active
*cap drop *_deceased*


		 
drop in 1
destring _all, replace	



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


reshape long y_, i(date) j(region) string

recode y_ (. = 0)

ren y_ cases
compress

sort region date


merge m:1 region using slovenia_id.dta


egen tag = tag(region)

list region  if tag==1 & _m==1
list region  if tag==1 & _m==2

drop if _m!=3
drop _m
drop tag
drop region

collapse (sum) cases, by(nuts3_id date)

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1]



compress
save "$coviddir/04_master/slovenia_data.dta", replace
export delimited using "$coviddir/04_master/csv/slovenia_data.csv", replace delim(;)


cd "$coviddir"


