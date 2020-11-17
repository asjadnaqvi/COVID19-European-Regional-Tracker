clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"



cd "$coviddir/01_raw/Poland"


***https://github.com/covid19-eu-zh/covid19-eu-data

insheet using "https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-pl.csv", clear
save poland_raw.dta, replace
export delimited using poland_raw.csv, replace delim(;)


ren datetime date


gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy


ren nuts_2 nuts2_name


gen nuts2_id=""

replace nuts2_id="PL61" if nuts2_name=="kujawsko-pomorskie"	// Kujawsko-pomorskie
replace nuts2_id="PL51" if nuts2_name=="dolnośląskie"		// Dolnośląskie
replace nuts2_id="PL81" if nuts2_name=="lubelskie"			// Lubelskie
replace nuts2_id="PL43" if nuts2_name=="lubuskie"			// Lubuskie
replace nuts2_id="PL22" if nuts2_name=="śląskie"			// Śląskie
replace nuts2_id="PL42" if nuts2_name=="zachodniopomorskie"		// Zachodniopomorskie
replace nuts2_id="PL71" if nuts2_name=="łódzkie"				// Łódzkie
replace nuts2_id="PL52" if nuts2_name=="opolskie"				// Opolskie
replace nuts2_id="PL21" if nuts2_name=="małopolskie"		// Małopolskie
replace nuts2_id="PL41" if nuts2_name=="wielkopolskie"  	// Wielkopolskie
replace nuts2_id="PL82" if nuts2_name=="podkarpackie"		// Podkarpackie
replace nuts2_id="PL84" if nuts2_name=="podlaskie"			// Podlaskie
replace nuts2_id="PL63" if nuts2_name=="pomorskie"			// Pomorskie
replace nuts2_id="PL62" if nuts2_name=="warmińsko-mazurskie"		// Warmińsko-mazurskie
replace nuts2_id="PL72" if nuts2_name=="świętokrzyskie"			// Świętokrzyskie
replace nuts2_id="PL91"	if nuts2_name=="mazowieckie"			// Mazowieckie + Warsaw


drop if nuts2_id==""

*** duplicating PL91 into PL92. They should be merged into PL90.

expand 2 if nuts2_id=="PL91"
egen tag = tag(date nuts2_id) if nuts2_id=="PL91"
replace nuts2_id="PL92" if tag==0 & nuts2_id=="PL91"
drop tag 


order nuts2_id date 
sort nuts2_id date 

sort nuts2_id date
bysort nuts2_id: gen cases_daily = cases - cases[_n-1]
sort nuts2_id date
bysort nuts2_id: gen deaths_daily = deaths - deaths[_n-1]

compress
save "$coviddir/04_master/poland_data.dta", replace				
export delimited using "$coviddir/04_master/csv/poland_data.csv", replace delim(;)


cd "$coviddir"