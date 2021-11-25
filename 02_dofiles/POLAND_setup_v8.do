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


****************
** OLD DATA  ***
****************

***https://github.com/covid19-eu-zh/covid19-eu-data


*import delim using "https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-pl.csv", clear

// for wierd unicode characters using insheet
insheet using "https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-pl.csv", clear

save "$coviddir/04_master/poland_data_original1.dta", replace
export delimited using "$coviddir/04_master/csv_original/poland_data_original1.csv", replace delim(;)


ren datetime date

gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)   
gen day   = substr(date, 9, 2)
destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy


ren nuts_2 nuts2_name
gen nuts2_id=""


replace nuts2_id="PL21" if nuts2_name=="małopolskie"		// Małopolskie
replace nuts2_id="PL22" if nuts2_name=="śląskie"			// Śląskie
replace nuts2_id="PL41" if nuts2_name=="wielkopolskie"  	// Wielkopolskie
replace nuts2_id="PL42" if nuts2_name=="zachodniopomorskie"	// Zachodniopomorskie
replace nuts2_id="PL43" if nuts2_name=="lubuskie"			// Lubuskie
replace nuts2_id="PL51" if nuts2_name=="dolnośląskie"		// Dolnośląskie
replace nuts2_id="PL52" if nuts2_name=="opolskie"			// Opolskie
replace nuts2_id="PL61" if nuts2_name=="kujawsko-pomorskie"	 // Kujawsko-pomorskie
replace nuts2_id="PL62" if nuts2_name=="warmińsko-mazurskie" // Warmińsko-mazurskie
replace nuts2_id="PL63" if nuts2_name=="pomorskie"			 // Pomorskie
replace nuts2_id="PL71" if nuts2_name=="łódzkie"			// Łódzkie
replace nuts2_id="PL72" if nuts2_name=="świętokrzyskie"		// Świętokrzyskie
replace nuts2_id="PL81" if nuts2_name=="lubelskie"			// Lubelskie
replace nuts2_id="PL82" if nuts2_name=="podkarpackie"		// Podkarpackie
replace nuts2_id="PL84" if nuts2_name=="podlaskie"			// Podlaskie
replace nuts2_id="PL91"	if nuts2_name=="mazowieckie"		// Mazowieckie + Warsaw

// some wierd names appearing in the database

replace nuts2_id="PL62" if nuts2_name=="warmiñsko-mazurskie"
replace nuts2_id="PL62" if nuts2_name=="warmiÅsko-mazurskie"
replace nuts2_id="PL21" if nuts2_name=="maÅopolskie"
replace nuts2_id="PL21" if nuts2_name=="ma³opolskie"
replace nuts2_id="PL51" if nuts2_name=="dolnoÅlÄskie"
replace nuts2_id="PL51" if nuts2_name=="dolnol¹skie"
replace nuts2_id="PL72" if nuts2_name=="wiêtokrzyskie"
replace nuts2_id="PL22" if nuts2_name=="l¹skie"
replace nuts2_id="PL71" if nuts2_name=="³ódzkie"
replace nuts2_id="PL72" if nuts2_name=="ÅwiÄtokrzyskie"
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""


tab nuts2_name if nuts2_id==""
drop if nuts2_id==""

**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts2_id date
bysort nuts2_id: gen check = date - date[_n-1]
tab check


sort nuts2_id date
bysort nuts2_id: gen cases_daily = cases - cases[_n-1] if check==1
sort nuts2_id date
bysort nuts2_id: gen deaths_daily = deaths - deaths[_n-1]  if check==1
drop check

replace cases_daily = . if cases_daily < 0
replace deaths_daily = . if deaths_daily < 0


keep  date nuts2_id nuts2_name date cases cases_daily deaths deaths_daily
order date nuts2_id nuts2_name date cases cases_daily deaths deaths_daily


*** for merging with the new dataset renaming variables

ren cases 			cases_old
ren cases_daily 	cases_daily_old
ren deaths			deaths_old
ren deaths_daily 	deaths_daily_old



sum date
*drop if date>=r(max) - 1  // lags in data. not all regions are updated

compress
save "$coviddir/01_raw/poland_data_old.dta", replace		


****************
** NEW DATA  ***
****************


import delim using "https://raw.githubusercontent.com/piotrek124-1/zakazenia-Covid19/main/plotData/wojewodztwa_kompletne.csv", clear

destring _all, replace


save "$coviddir/04_master/poland_data_original2.dta", replace
export delimited using "$coviddir/04_master/csv_original/poland_data_original2.csv", replace delim(;)


ren stan_rekordu_na date
ren wojewodztwo 						nuts2_name
ren liczba_przypadkow 					cases_daily
ren liczba_na_10_tys_mieszkancow		cases_10k
ren zgony								deaths_daily


gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)   //
gen day   = substr(date, 9, 2)
destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy



// Cały kraj = whole country

gen nuts2_id=""


replace nuts2_id="PL21" if nuts2_name=="małopolskie"		// Małopolskie
replace nuts2_id="PL22" if nuts2_name=="śląskie"			// Śląskie

replace nuts2_id="PL41" if nuts2_name=="wielkopolskie"  	// Wielkopolskie
replace nuts2_id="PL42" if nuts2_name=="zachodniopomorskie"	// Zachodniopomorskie
replace nuts2_id="PL43" if nuts2_name=="lubuskie"			// Lubuskie

replace nuts2_id="PL51" if nuts2_name=="dolnośląskie"		// Dolnośląskie
replace nuts2_id="PL52" if nuts2_name=="opolskie"			// Opolskie

replace nuts2_id="PL61" if nuts2_name=="kujawsko-pomorskie"	 // Kujawsko-pomorskie
replace nuts2_id="PL62" if nuts2_name=="warmińsko-mazurskie" // Warmińsko-mazurskie
replace nuts2_id="PL63" if nuts2_name=="pomorskie"			 // Pomorskie

replace nuts2_id="PL71" if nuts2_name=="łódzkie"			// Łódzkie
replace nuts2_id="PL72" if nuts2_name=="świętokrzyskie"		// Świętokrzyskie

replace nuts2_id="PL81" if nuts2_name=="lubelskie"			// Lubelskie
replace nuts2_id="PL82" if nuts2_name=="podkarpackie"		// Podkarpackie
replace nuts2_id="PL84" if nuts2_name=="podlaskie"			// Podlaskie

replace nuts2_id="PL91"	if nuts2_name=="mazowieckie"		// Mazowieckie + Warsaw

// some wierd names appearing in the database

replace nuts2_id="PL62" if nuts2_name=="warmiñsko-mazurskie"
replace nuts2_id="PL62" if nuts2_name=="warmiÅsko-mazurskie"
replace nuts2_id="PL21" if nuts2_name=="maÅopolskie"
replace nuts2_id="PL21" if nuts2_name=="ma³opolskie"
replace nuts2_id="PL51" if nuts2_name=="dolnoÅlÄskie"
replace nuts2_id="PL51" if nuts2_name=="dolnol¹skie"
replace nuts2_id="PL72" if nuts2_name=="wiêtokrzyskie"
replace nuts2_id="PL22" if nuts2_name=="l¹skie"
replace nuts2_id="PL71" if nuts2_name=="³ódzkie"

replace nuts2_id="PL51" if nuts2_name=="dolnoĹ›lÄ…skie"
replace nuts2_id="PL71" if nuts2_name=="Ĺ‚Ăłdzkie"
replace nuts2_id="PL21" if nuts2_name=="maĹ‚opolskie"
replace nuts2_id="PL71" if nuts2_name=="Ĺ›lÄ…skie"
replace nuts2_id="PL72" if nuts2_name=="Ĺ›wiÄ™tokrzyskie"
replace nuts2_id="PL62" if nuts2_name=="warmiĹ„sko-mazurskie"
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""
replace nuts2_id="" if nuts2_name==""


tab nuts2_name if nuts2_id==""
drop if nuts2_id==""


keep  date nuts2_id nuts2_name  date cases_daily deaths_daily
order date nuts2_id nuts2_name  date cases_daily deaths_daily


destring deaths_daily, replace force




duplicates drop nuts2_id date, force

compress
save "$coviddir/01_raw/poland_data_new.dta", replace	


*******************************
**  MERGE THE TWO TOGETHER   **
*******************************
	

merge 1:1 nuts2_id date using "$coviddir/01_raw/poland_data_old.dta"
sort nuts2_id date

// the old data has valued shifted forward by one date. 
// Assuming the new one is more accurate, backfilling the new column 
// with old values if missing and shifting up by one

replace cases_daily = cases_daily_old[_n+1] if cases_daily==. & cases_daily_old!=.
replace deaths_daily = deaths_daily_old[_n+1] if deaths_daily==. & deaths_daily_old!=.

drop *_old _m


*** sum up for totals

sort nuts2_id date
by nuts2_id: gen cases  = sum(cases_daily)
by nuts2_id: gen deaths = sum(deaths_daily)

*** duplicating PL91 into PL92. They should be merged into PL90.

expand 2 if nuts2_id=="PL91"
egen tag = tag(date nuts2_id) if nuts2_id=="PL91"
replace nuts2_id="PL92" if tag==0 & nuts2_id=="PL91"
drop tag 


order nuts2_id date 
sort nuts2_id date 


sum date
drop if date>=r(max) - 1  // lags in data. not all regions are updated



compress
save "$coviddir/04_master/poland_data.dta", replace				
export delimited using "$coviddir/04_master/csv_nuts/poland_data.csv", replace delim(;)


cd "$coviddir"