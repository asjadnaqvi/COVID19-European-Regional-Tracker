clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Spain"



***** fixing iso3

import excel using iso.xlsx, clear first
	replace iso3_code = subinstr(iso3_code, "ES-", "", .)
	replace iso3_code = strtrim(iso3_code)
	gen 	test	  = regexs(0) if regexm(iso3_code, "^[A-Z]+")
	replace iso3_code = test if iso3_code!=test
	drop test
	drop if iso3_code==""
	compress
save iso.dta, replace


***** fixing raw cases


insheet using "https://cnecovid.isciii.es/covid19/resources/casos_diagnostico_provincia.csv", clear
save "$coviddir/04_master/spain_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/spain_data_original.csv", replace delim(;)




ren fecha date
ren provincia_iso 				iso3_code
ren num_casos 					cases_daily
ren num_casos_prueba_pcr 		test_pcr
ren num_casos_prueba_test_ac 	test_ac
*ren num_casos_prueba_otras 		test_other
ren num_casos_prueba_desconocida 	test_unknown

order date iso3_code





gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)
drop day month year

order date
format date %tdDD-Mon-yyyy
sort iso3_code date 

replace iso3_code = subinstr(iso3_code, " ", "", .)
replace iso3_code = trim(iso3_code)


merge m:1 iso3_code using iso



tab iso3_code if _m==1
tab iso3_code if _m==2



egen tag = tag(iso3_code _m) if _m!=3

drop if _m!=3
drop tag
drop _m

compress


summ date 
drop if date==r(max)

order nuts3_id date
sort nuts3_id date


compress
save "$coviddir/04_master/spain_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/spain_data.csv", replace delim(;)

cd "$coviddir"
