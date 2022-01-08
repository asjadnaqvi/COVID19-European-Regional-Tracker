clear


cd "$coviddir/01_raw/France"


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


ren date date2
gen date = date(date2, "YMD")
format date %tdDD-Mon-yy
drop date2



ren nb_pos  cases_daily
ren nb_test tested

drop nb_test_h- nb_pos_f

drop if date >= 22048   // drop everything after 13th may. after this france moved to a better dataset below
order date nuts3_id
compress
save "france_data_old.dta", replace


*** raw data from here
*https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-resultats-des-tests-virologiques-covid-19/



import delimited using "sp-pos-quot-dep.csv", clear
save "$coviddir/04_master/france_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/france_data_original.csv", replace delim(;)




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

ren date date2
gen date = date(date2, "YMD")
format date %tdDD-Mon-yy
drop date2


ren p cases_daily
ren t tested

order date nuts3_id

merge 1:1 date nuts3_id using france_data_old
drop _m

drop Name HASC Reg FIPS NUTS capital area_km2



compress
sort nuts3_id date 
compress
save "$coviddir/04_master/france_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/france_data.csv", replace delim(;)



cd "$coviddir"