clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/04_master"


************************
***  COVID 19 data   ***
************************

insheet using "https://covid.ourworldindata.org/data/owid-covid-data.csv", clear


gen date2 = date(date, "YMD")
format date2 %tdDD-Mon-yy
drop date
ren date2 date

ren location country
replace country = "Slovak Republic" if country == "Slovakia"

drop if date < 21915  // 1st January

gen control = .

replace control = 1 if ///
	country=="Austria"  	| 	///
	country=="Belgium"  	|	///
	country=="Croatia"  	|	///
	country=="Czechia"  	|	///
	country=="Denmark"  	|	///
	country=="Estonia"  	|	///
	country=="Finland"  	|	///
	country=="France"  		|	///
	country=="Germany"  	|	///
	country=="Greece"  		|	///	
	country=="Hungary"  	|	///
	country=="Ireland"  	|	///
	country=="Italy"  		|	///
	country=="Latvia"  		|	///
	country=="Netherlands"  |	///
	country=="Norway"  		|	///
	country=="Poland" 	 	|	///
	country=="Portugal"  	|	///
	country=="Romania"  	|	///
	country=="Slovak Republic"  	|	///
	country=="Slovenia"  	|	///
	country=="Spain"	  	|	///	
	country=="Sweden"	  	|	///
	country=="Switzerland" 	
	
keep if control==1
drop control
	

keep country date new_cases	

replace new_cases = . if new_cases < 0

ren new_cases cases_daily_OWID
	
compress
save "OWID_data.dta", replace




**** data summary graphs below. Can mark this out
use "EUROPE_COVID19_master.dta", clear


collapse (sum) cases_daily, by(nuts0_id country date)




merge 1:1 country date using OWID_data
keep if _m==3
drop _m


gen diff = cases_daily - cases_daily_OWID


/*
twoway ///
	(scatter cases_daily_OWID cases_daily, mcolor(%20) msymbol(circle) mlwidth(vvthin)), ///
		ytitle("Our World in Data") ///
		xtitle("Regional Tracker") ///
		by(country, yrescale xrescale)
	*graph export "../05_figures/validation1.png", replace wid(3000)
*/	
	
set scheme white_w3d	
		
twoway ///
	(scatter diff date, mcolor(%30) msize(vsmall) msymbol(circle) mlwidth(vvthin)), ///
		ytitle("Difference in the Tracker and OWID daily cases", size(small)) ///
		xtitle("") ///
			yline(0) ///
			xline(22189 22250) ///
			xlabel(, angle(vertical) format(%tdD-m-Y)) ///
			by(, note("Data trends start deviating after 1st October 2020. OWID formally announces switch from ECDC to JHU dataset starting 1st Nov 2020 (https://ourworldindata.org/covid-data-switch-jhu).", size(*0.6))) by(country, yrescale)		
	graph export "../05_figures/validation.png", replace wid(3000)		
*	graph export "../05_figures/validation.pdf", replace




***** Adding the stringency heatplot

clear

insheet using "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv", clear

ren countryname country


gen group = .

replace group = 1 if ///
	country == "Austria" 			|	///	
	country == "Belgium" 			|	///
	country == "Croatia"		 	|	///
	country == "Czech Republic" 	|	///
	country == "Denmark"    		| 	///
	country == "Estonia"   			|	///
	country == "Finland"   			|	///
	country == "France" 			|	///
	country == "Germany" 			|	///
	country == "Greece" 			|	///
	country == "Hungary" 			|	///
	country == "Ireland"			| 	///
	country == "Italy" 				|	///
	country == "Latvia" 			|	///
	country == "Netherlands" 		|	///
	country == "Norway" 			| 	///
	country == "Poland" 			|	///
	country == "Portugal" 			| 	///
	country == "Romania" 			| 	///
	country == "Slovenia" 			|	///
	country == "Slovak Republic" 	| 	///
	country == "Spain"				| 	///
	country == "Sweden"				|	///
	country == "Switzerland"		|	///
	country == "United Kingdom" 	 	
	 		

keep if group==1


keep country date stringencyindexfordisplay
ren stringencyindexfordisplay stringency

sort country
encode country , gen(country2) 

*** fix the date

tostring date, gen(date2)    // string the date variable
drop date
gen date = date(date2,"YMD")
format date %tdDD-Mon-yyyy
drop date2
drop if date < 21915    // 1st January

order country date
sort country date


heatplot stringency i.country2 date, ///
	bins(100) cuts(0(10)100) color(viridis, ipolate(10, power(1.5)) reverse) ///
	p(lc(white) lw(0.04)) ///
	ylabel(, nogrid labsize(*0.6)) ///
	xlabel(#18, labsize(*0.6) angle(vertical) format(%tdDD-Mon-yy) nogrid) ///
	xtitle("") ///
	ramp(bottom length(80) space(7) subtitle("")) ///
	title("{fontface Arial Bold:COVID-19 Policy Stringency Index}") ///
	note("Source: Oxford COVID-19 Government Response Tracker (OxCGRT)", size(1.5))
	
	graph export "../05_figures/policystringency.png", replace wid(3000)		
	