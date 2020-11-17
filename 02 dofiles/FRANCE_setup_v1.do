clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01 raw/France"


**** sorting out the mapping of regions

import excel using departments.xlsx, first clear
compress
replace departement = "01" if departement=="1"
replace departement = "02" if departement=="2"
replace departement = "03" if departement=="3"
replace departement = "04" if departement=="4"
replace departement = "05" if departement=="5"
replace departement = "06" if departement=="6"
replace departement = "07" if departement=="7"
replace departement = "08" if departement=="8"
replace departement = "09" if departement=="9"

drop if departement==""
save france_departments.dta, replace


****** let's get the old france data in order:

insheet using "donnees-tests-covid19-labo-quotidien-2020-05-29-19h00.csv", clear delim(;)

ren dep departement
ren clage_covid age
ren jour date

keep if age=="0"  // this is for all age classes
drop age

merge m:1 departement using france_departments
tab departement if _m==1
drop if _m==1
drop _m

gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy

ren nb_pos  cases_daily
ren nb_test tested

drop nb_test_h- nb_pos_f

drop if date >= 22048   // drop everything after 13th may. after this france moved to a better dataset below
order date nuts3_id
compress
save "france_data_old.dta", replace


*** raw data from here
*https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-resultats-des-tests-virologiques-covid-19/

insheet using "sp-pos-quot-dep-2020-11-13-19h15.csv", clear delim(;)
save france_raw.dta, replace
export delimited using france_raw.csv, replace delim(;)



ren dep departement
ren cl_age90 age
ren jour date


keep if age==0  // this is for all age classes
drop age

merge m:1 departement using france_departments
tab departement if _m==1
drop if _m==1  // these are territories outside of mainland Europe
drop _m

*ren NUTS nuts3_id

gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy

ren p cases_daily
ren t tested

order date nuts3_id

merge 1:1 date nuts3_id using france_data_old
drop _m

drop Name HASC Reg FIPS NUTS capital area_km2



compress
sort nuts3_id date 
compress
save "$coviddir/04 master/france_data.dta", replace
export delimited using "$coviddir/04 master/csv/france_data.csv", replace delim(;)



cd "$coviddir"