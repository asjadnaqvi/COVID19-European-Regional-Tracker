clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir"



**** get the population file in order. File from Eurostat

use "./01 raw/Eurostat/demo_r_pjangrp3", clear   
*export delimited using "./01 raw/Eurostat/demo_r_pjangrp3.csv", clear delim(;)

	keep if year==2019
	drop year
	keep if sex=="T"
	drop sex
	drop unit
	keep if age=="TOTAL"
	drop age
	keep if length(geo)==5 | length(geo)==4  // some countries are at NUTS2 level
	ren geo nuts_id
	ren y population
	compress
save "./04 master/NUTS_POPULATION.dta", replace
export delimited using "./04 master/csv/NUTS_POPULATION.csv", replace delim(;)




***** merge all the files together


cd "./04 master/"


*** NUTS 3
use "austria_data.dta", clear
keep date cases cases_daily nuts3_id

append using belgium_data, 		keep(date cases cases_daily nuts3_id)
append using croatia_data, 		keep(date cases cases_daily nuts3_id)
append using czechia_data, 		keep(date cases cases_daily nuts3_id)
append using denmark_data, 		keep(date cases cases_daily nuts3_id)
append using england_data, 		keep(date cases cases_daily nuts3_id)
append using estonia_data, 		keep(date cases cases_daily nuts3_id)
append using finland_data, 		keep(date cases cases_daily nuts3_id)
append using france_data, 		keep(date cases cases_daily nuts3_id)
append using germany_data, 		keep(date cases cases_daily nuts3_id)
append using hungary_data,		keep(date cases cases_daily nuts3_id)
append using ireland_data, 		keep(date cases cases_daily nuts3_id)
append using italy_data, 		keep(date cases cases_daily nuts3_id)
append using latvia_data, 		keep(date cases cases_daily nuts3_id)
append using netherlands_data, 	keep(date cases cases_daily nuts3_id)
append using norway_data, 		keep(date cases cases_daily nuts3_id)
append using portugal_data, 	keep(date cases cases_daily nuts3_id)
append using romania_data, 		keep(date cases cases_daily nuts3_id)
append using scotland_data, 	keep(date cases cases_daily nuts3_id)
append using slovakia_data, 	keep(date cases cases_daily nuts3_id)
append using slovenia_data, 	keep(date cases cases_daily nuts3_id)
append using spain_data, 		keep(date cases cases_daily nuts3_id)
append using sweden_data, 		keep(date cases cases_daily nuts3_id)
append using switzerland_data, 	keep(date cases cases_daily nuts3_id)


*** NUTS 2
append using poland_data, 		keep(date cases cases_daily nuts2_id)
append using greece_data, 		keep(date cases cases_daily nuts2_id)


gen nuts_id = nuts3_id
replace nuts_id = nuts2_id if nuts3_id==""

drop if nuts_id==""

gen nuts0_id = substr(nuts_id, 1,2)
order nuts0_id nuts2_id nuts3_id nuts_id





merge m:1 nuts_id using NUTS_POPULATION
drop if _m==2
drop _m


drop if date==.
drop if date<21915

replace cases_daily = 0 if cases_daily < 0  		// afew outliers that we make zero
gen cases_daily_pop = (cases_daily / pop) * 10000  	// new cases / 10k population


order nuts0_id nuts2_id nuts3_id nuts_id date
sort nuts0_id nuts_id date

lab var nuts0_id 		"NUTS 0 (Country)"
lab var nuts2_id 		"NUTS 2"
lab var nuts3_id 		"NUTS 3"
lab var nuts_id  		"NUTS2 or NUTS3"
lab var population 		"Population"
lab var date 	 		"Date"
lab var cases 	 		"Culumative cases"
lab var cases_daily 	"Daily cases"
lab var cases_daily_pop "Daily cases per 10,000 population"


drop if date < 21929

compress
save "EUROPE_COVID19_master.dta", replace
export delimited using "$coviddir/04 master/csv/EUROPE_COVID19_master.csv", replace delim(;)




**** data summary graphs below. Can mark this out

use "EUROPE_COVID19_master.dta", clear


gen first = .
gen last = .

levelsof nuts0_id, local(lvls)
foreach x of local lvls {

summ date if nuts0_id=="`x'"
replace first = 1 if date==`r(min)' &   nuts0_id=="`x'"

summ date if nuts0_id=="`x'"
replace last  = 1 if date==`r(max)' &   nuts0_id=="`x'"
}


tab nuts0_id date if last==1, m

duplicates drop nuts0_id date, force
gen 	range = 1

encode nuts0_id, gen(nuts0)

format date %tdDD-Mon-YY

twoway ///
	(scatter nuts0 date, mcolor(black%50) msize(vsmall) msymbol(smcircle) mlwidth(vvthin)), ///
		ytitle("") yscale(noline) ///
		ylabel(1(1)25, labsize(vsmall) valuelabel) ///
			xtitle("") ///
			xlabel(#20, labsize(vsmall) angle(vertical)) ///
			title("{fontface Arial Bold: European COVID-19 regional tracker - Date Range for Countries}")
	graph export "../05 figures/range_date.png", replace wid(3000)



twoway ///
	(scatter cases_daily_pop date, mcolor(black%80) msize(vsmall) msymbol(smcircle) mlwidth(vvthin)), ///
		xtitle("") ///
		title("{fontface Arial Bold: Regional distribution of daily cases}")
	graph export "../05 figures/range_newcasepop.png", replace wid(3000)

/*
twoway ///
	(scatter cases_daily_pop date, mcolor(black%80) msize(vsmall) msymbol(smcircle) mlwidth(vvthin)) ///
		if cases_daily_pop < 25, ///
		xtitle("") ///
		title("{fontface Arial Bold: Regional distribution of daily cases}")
	graph export "../05 figures/range_newcasepop2.png", replace wid(3000)


