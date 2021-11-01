clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir"



**** get the population file in order. File from Eurostat (one time run)

/*
use "./01_raw/Eurostat/demo_r_pjangrp3", clear   
*export delimited using "./01 raw/Eurostat/demo_r_pjangrp3.csv", clear delim(;)

	gen country=substr(geo,1,2)
	keep if (year==2020 & country!="UK") | (year==2019 & country=="UK")  // UK NUTS data removed from Eurostat 2020
	drop country
	drop year
	keep if sex=="T"
	drop sex
	drop unit
	keep if age=="TOTAL"
	drop age
	keep if length(geo)==5 | length(geo)==4  // EL/PL are at NUTS2 level
	ren geo nuts_id
	ren y population
	compress
save "./04_master/NUTS_POPULATION.dta", replace
*export delimited using "./04_master/csv_/NUTS_POPULATION.csv", replace delim(;)
*/

**** get the NUTS names in order (one time run)

/*
import excel using "./01_raw/LAU/NUTS_2016_names.xlsx", clear first

cap drop G-L
cap drop MSORDER
cap drop SORTINGORDER

ren NUTSCODE nuts_id
ren NUTSLEVEL level
ren COUNTRYCODE country
ren NUTSLABEL x

drop if level==.
drop if level==0 | level==1

replace x = trim(x)
split x, p("(" ")")

gen nuts_name = x
replace nuts_name = x
replace nuts_name = x2 if country=="EL" // Greece
replace nuts_name = x2 if country=="BG" // Bulgaria
replace nuts_name = subinstr(nuts_name, " and",",", .)
replace nuts_name = subinstr(nuts_name, ", Kreisfreie Stadt", "", .) if country=="DE" // Germany
replace nuts_name = trim(nuts_name)
replace nuts_name = "Brussels" if nuts_name=="Région de Bruxelles-Capitale/ Brussels Hoofdstedelijk Gewest"
replace nuts_name = "Arr. de Bruxelles-Capitale" if nuts_name=="Arr. de Bruxelles-Capitale/Arr. van Brussel-Hoofdstad"
replace nuts_name = "Bezirk Verviers" if nuts_name=="Bezirk Verviers — Deutschsprachige Gemeinschaft"
replace nuts_name = "Arr. Verviers" if nuts_name=="Arr. Verviers — communes francophones"

replace nuts_name = "Bath, NE Somerset, N. Somerset, S. Gloucestershire" if nuts_name=="Bath, North East Somerset, North Somerset, South Gloucestershire"
replace nuts_name = "E. Dunbartonshire, W. Dunbartonshire, Helensburgh & Lomond" if nuts_name=="East Dunbartonshire, West Dunbartonshire, Helensburgh & Lomond"
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""
replace nuts_name = "" if nuts_name==""


drop x*
compress
save "./04_master/NUTS_NAME.dta", replace
*/



***** merge all the files together


cd "./04_master/"


*** NUTS 3
use "austria_data.dta", clear
keep date cases cases_daily nuts3_id

append using belgium_data, 		keep(date cases cases_daily nuts3_id)
append using croatia_data, 		keep(date cases cases_daily nuts3_id)
append using czechia_data, 		keep(date cases cases_daily nuts3_id)
append using denmark_data, 		keep(date cases cases_daily nuts3_id)
append using england_data, 		keep(date cases cases_daily nuts3_id ctry)  // for differentiating UK
append using estonia_data, 		keep(date cases cases_daily nuts3_id)
append using finland_data, 		keep(date cases cases_daily nuts3_id)
append using france_data, 		keep(date cases cases_daily nuts3_id)
append using germany_data, 		keep(date cases cases_daily nuts3_id)
append using hungary_data,		keep(date cases cases_daily nuts3_id)
append using ireland_data, 		keep(date cases cases_daily nuts3_id)
append using italy_data, 		keep(date cases cases_daily nuts3_id)
append using latvia_data, 		keep(date cases cases_daily nuts3_id)
append using netherlands_data, 	keep(date cases cases_daily nuts3_id)
append using norway_data, 		keep(date cases cases_daily nuts3_id nuts3_name)  // for the names (non EU)
append using portugal_data, 	keep(date cases cases_daily nuts3_id)
append using romania_data, 		keep(date cases cases_daily nuts3_id)
append using scotland_data, 	keep(date cases cases_daily nuts3_id ctry)  // for differentiating UK
append using slovakrep_data, 	keep(date cases cases_daily nuts3_id)
append using slovenia_data, 	keep(date cases cases_daily nuts3_id)
append using spain_data, 		keep(date cases cases_daily nuts3_id)
append using sweden_data, 		keep(date cases cases_daily nuts3_id)
append using switzerland_data, 	keep(date cases cases_daily nuts3_id nuts3_name)  // for the names (non EU)


*** NUTS 2
append using poland_data, 		keep(date cases cases_daily nuts2_id)
append using greece_data, 		keep(date cases cases_daily nuts2_id)


gen nuts_id = nuts3_id
replace nuts_id = nuts2_id if nuts3_id==""

drop if nuts_id==""

gen nuts0_id = substr(nuts_id, 1,2)





// merge to get population
merge m:1 nuts_id using NUTS_POPULATION
drop if _m==2
drop _m

// merge to get names
merge m:1 nuts_id using NUTS_NAME
drop if _m==2
drop _m
drop country level

replace nuts_name = nuts3_name if nuts0_id=="NO"
replace nuts_name = nuts3_name if nuts0_id=="CH"

drop nuts3_name
order  nuts0_id nuts2_id nuts3_id nuts_id nuts_name


// clean up the dates
drop if date==.
drop if date<21915  //  1st Jan 2020
drop if date<21929  // 15th Jan 2020


*gen flag = 1 if cases_daily < 0
*lab de flag 1 "Decrease in daily cases"
*lab val flag flag


gen cases_daily_pop = (cases_daily / pop) * 10000  	// new cases / 10k population


**** generate back cumulative cases missing for countries

sort nuts_id date
by nuts_id (date): gen cases2 = sum(cases_daily)
replace cases = cases2 if cases==. & cases2!=.
drop cases2


gen country = ""
	replace country = "Austria" 			if nuts0_id=="AT"
	replace country = "Belgium" 			if nuts0_id=="BE"
	replace country = "Croatia" 			if nuts0_id=="HR"
	replace country = "Czechia" 			if nuts0_id=="CZ"
	replace country = "Denmark" 			if nuts0_id=="DK"
	replace country = "Estonia" 			if nuts0_id=="EE"
	replace country = "Finland" 			if nuts0_id=="FI"
	replace country = "France" 				if nuts0_id=="FR"
	replace country = "Germany" 			if nuts0_id=="DE"
	replace country = "Greece" 				if nuts0_id=="EL"
	replace country = "Hungary" 			if nuts0_id=="HU"
	replace country = "Ireland" 			if nuts0_id=="IE"
	replace country = "Italy" 				if nuts0_id=="IT"
	replace country = "Latvia" 				if nuts0_id=="LV"
	replace country = "Netherlands" 		if nuts0_id=="NL"
	replace country = "Norway" 				if nuts0_id=="NO"
	replace country = "Poland" 				if nuts0_id=="PL"
	replace country = "Portugal" 			if nuts0_id=="PT"
	replace country = "Romania" 			if nuts0_id=="RO"
	replace country = "Slovak Republic" 	if nuts0_id=="SK"
	replace country = "Slovenia" 			if nuts0_id=="SI"
	replace country = "Spain" 				if nuts0_id=="ES"
	replace country = "Sweden" 				if nuts0_id=="SE"
	replace country = "Switzerland" 		if nuts0_id=="CH"
	
	replace country = "England (UK)" 		if ctry=="England"
	replace country = "Scotland (UK)" 		if ctry=="Scotland"



*** if the sum of all entries of a country on a given day are zero, then drop that date (e.g. portugal)
bysort country date: egen total = sum(cases_daily)
drop if total == 0
drop total

drop ctry

gen cases_pop = (cases / pop) * 10000 


lab var country 		"Country"	
lab var nuts0_id 		"NUTS 0"
lab var nuts2_id 		"NUTS 2"
lab var nuts3_id 		"NUTS 3"
lab var nuts_id  		"NUTS2 or NUTS3"
lab var nuts_name  		"NUTS name"
lab var population 		"Population"
lab var date 	 		"Date"
lab var cases 	 		"Culumative cases"
lab var cases_pop  		"Culumative cases per 10,000 population"
lab var cases_daily 	"Daily cases"
lab var cases_daily_pop "Daily cases per 10,000 population"
*lab var flag 			"Flagged observations"

	
order country nuts0_id nuts2_id nuts3_id nuts_id nuts_name date population cases cases_daily cases_pop cases_daily_pop
sort  nuts0_id nuts_id date


// save final data file
compress
save "EUROPE_COVID19_master.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/EUROPE_COVID19_master.csv", replace delim(;)




// export only the last data points for visualization on Datawrapper

sort nuts_id date


// change in cases in the past two weeks
by nuts_id: gen change14_abs 	 = (cases - cases[_n-14])

// last data point
by nuts_id: egen temp = max(date) if cases_daily!=.
gen last = 1 if date == temp  // last observation of each NUTS region
drop temp

// highest daily cases
by nuts_id: egen high = max(cases_daily) if cases_daily!=.
gen high_date=date if cases_daily==high
bysort nuts_id: carryforward high_date, replace
format high_date %tdDD-Mon-YY

keep if last==1
drop last
gen nuts_name2 = nuts_name + " (" + nuts_id + ")"
order country nuts0_id nuts2_id nuts3_id nuts_id nuts_name nuts_name2

export delimited using "$coviddir/04_master/csv_nuts/EUROPE_COVID19_last.csv", replace delim(;)







**** data summary graphs below. Can be marked out

set scheme white_tableau, perm

use "EUROPE_COVID19_master.dta", clear

format date %tdDD-Mon-YY
set scheme white_w3d, perm
graph set window fontface "Arial Narrow"

gen nuts_name2 = nuts_name + " (" + nuts_id + ")"

// scatter of nuts date combinations

twoway ///
	(scatter cases_daily_pop date if cases_daily_pop >= 0 & cases_daily_pop <= 30, mcolor(black%8) msize(*0.25) msymbol(smcircle) mlwidth(vvthin)) ///
	, ///
	legend(off) ///
		xtitle("") xlabel(#22, labsize(vsmall) angle(vertical)) ///
		note("Few observations over 30 cases per 10k population have been removed from the figure for visibility", size(vsmall)) ///
		title("{fontface Arial Bold:Regional distribution of daily cases}") ///
		xsize(2) ysize(1)  
		
	graph export "../05_figures/range_newcasepop.png", replace wid(2000)
   *graph export "../05_figures/range_newcasepop.pdf", replace
	


// Data range

gen first = .
gen last = .

levelsof country, local(lvls)
foreach x of local lvls {

qui summ date if country=="`x'"
qui replace first = 1 if date==`r(min)' &   country=="`x'"

qui summ date if country=="`x'"
qui replace last  = 1 if date==`r(max)' &   country=="`x'"
}


tab country date if last==1, m

*duplicates drop country date, force
*gen 	range = 1


cap drop tag
egen tag = tag(country date)


encode country, gen(nuts0)




twoway ///
	(scatter nuts0 date if tag==1, mcolor(black%50) msize(vsmall) msymbol(smcircle) mlwidth(vvthin)), ///
		ytitle("") yscale(noline) ///
		ylabel(1(1)26, labsize(vsmall) valuelabel) ///
			xtitle("") ///
			xlabel(#22, labsize(vsmall) angle(vertical)) ///
			title("{fontface Arial Bold:Data range for countries}") ///
			xsize(2) ysize(1)
	graph export "../05_figures/range_date.png", replace wid(2000) 
   *graph export "../05_figures/range_date.pdf", replace
	


// heatplot of countries

levelsof country if country!="Ireland", local(lvls)

foreach x of local lvls {

preserve
	
	qui summ date
	local xmin = `r(min)'
	local xmax = `r(max)'
		
		
		cap drop id
		keep if country=="`x'"
		encode nuts_name2, gen(id)
		
			qui summ id if country=="`x'"
			local ymin = `r(min)'
			local ymax = `r(max)'


	local height = (((`ymax' - `ymin') / (`xmax' - `xmin')) * 25)
	display `height'


		if `height' > 1 {
			local ys = int(`height' * 5)
			local xs  = 10
		}
		else {
			local ys = 10
			local xs  = int((1 / `height') * 5) // double the width
		}

		display "`x': Height = `ys', Width = `xs'"

		heatplot cases_daily_pop i.id date if country=="`x'" & cases_daily_pop >= 0 & cases_daily_pop <= 30, ///
			levels(30) xbins(160) color(plasma, reverse) ///
			p(lc(white) lw(0.04)) ///
			ylabel(, nogrid labsize(1.8)) ///
			xlabel(#30, labsize(1.8) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
			xtitle("") ///
			ramp(bottom space(8) subtitle("")) ///
			title("Regional data - `x'") ///
				xsize(`xs') ysize(`ys')

		graph export "../05_figures/range_date_`x'.png", replace wid(2000)


restore
	
}


/*** test code below


encode nuts_id, gen(id)

summ id if country=="Ireland"
local ymin = `r(min)'
local ymax = `r(max)'

summ date
local xmin = `r(min)'
local xmax = `r(max)'

local height = (((`ymax' - `ymin') / (`xmax' - `xmin')) * 25)
display `height'


  *  local ys = min(int(`height' * 5),80)
*	local xs  = 8


if `height' > 1 {
    local ys = int(`height' * 5)
	local xs  = 10
}
else {
    local ys = 10
	local xs  = int((1 / `height') * 5) // double the width
}


display "x: `xs', y: `ys'"

heatplot cases_daily_pop i.id date if country=="Ireland" & cases_daily_pop >= 0 & cases_daily_pop <= 30, ///
	levels(30) xbins(160) color(plasma, reverse) ///
	p(lc(white) lw(0.04)) ///
	ylabel(, nogrid labsize(1.8)) ///
	xlabel(#30, labsize(1.8) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xtitle("") ///
	ramp(bottom space(10) subtitle("")) ///
	title("Data range check - `x'") ///
		xsize(`xs') ysize(`ys') 


