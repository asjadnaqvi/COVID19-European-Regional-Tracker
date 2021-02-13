clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"



cd "$coviddir/01_raw/Poland"


***** govt is now publishing daily nuts3 level data since november

/*
*** data here: https://www.gov.pl/web/koronawirus/mapa-zarazen-koronawirusem-sars-cov-2-powiaty?show-table=true

insheet using "20210101054526_rap_gov_pow_eksport.csv", clear delim(;)

import delim using "20210101054526_rap_gov_pow_eksport.csv", clear varn(1)

ren wojewodztwo 					nuts2_name
ren powiat_miasto  					nuts3_name
ren liczba_przypadkow 					cases
ren liczba_na_10_tys_mieszkancow 		cases_per10k
ren zgony 								deaths_all
ren zgony_w_wyniku_covid_bez_chorob_    deaths_covid19
ren zgony_w_wyniku_covid_i_chorob_ws 	deaths_comorbidities
ren teryt							nuts3_id_orig
drop in 1

*/


***https://github.com/covid19-eu-zh/covid19-eu-data

insheet using "https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-pl.csv", clear
save "$coviddir/04_master/poland_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/poland_data_original.csv", replace delim(;)


ren datetime date


gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)   // here is an error in the dates from Feb 3 2021 onward. day and month are switched
gen day   = substr(date, 9, 2)

destring year month day, replace



gen month1 = day   if year==2021 & day==2 & month > 2
gen   day1 = month if year==2021 & day==2 & month > 2

replace month = month1 if month1 !=.
replace day   = day1 if month1 !=.

drop month1 day1


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

// update 01.01.2021: data switched to daily from cumulative

gen cases_daily2  = cases if date >= 22243
gen deaths_daily2 = deaths if date >= 22243
replace cases = . if date >= 22243
replace deaths = . if date >= 22243

*gen date2 = date
drop if date==22079 // this date is problematic. drop it



**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts2_id date
bysort nuts2_id: gen check = date - date[_n-1]

tab check



sort nuts2_id date
bysort nuts2_id: gen cases_daily = cases - cases[_n-1] if check==1
sort nuts2_id date
bysort nuts2_id: gen deaths_daily = deaths - deaths[_n-1]  if check==1

replace cases_daily = cases_daily2 if cases_daily==. & cases_daily2!=.
replace deaths_daily = deaths_daily2 if deaths_daily==. & deaths_daily2!=.

drop cases_daily2
drop deaths_daily2
drop check


sum date
drop if date>=r(max) - 3  // lags in data. not all regions are updated

compress
save "$coviddir/04_master/poland_data.dta", replace				
export delimited using "$coviddir/04_master/csv_nuts/poland_data.csv", replace delim(;)


cd "$coviddir"