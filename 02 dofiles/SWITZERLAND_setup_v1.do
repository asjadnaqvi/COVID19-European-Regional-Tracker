clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01 raw/Switzerland"


********** at the NUTS3 level


import delimited using "https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-ch.csv", clear
save switzerland_raw.dta, replace
export delimited using switzerland_raw.csv, replace delim(;)


ren datetime date
gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)
drop year month day

order date
format date %tdDD-Mon-yyyy
drop date2

drop if nuts_3==""

ren nuts_3 nuts3_name
drop nuts_3_code  // this is actually the ISO names for the Cantons. wrongly labeled in Data.



/*

            nuts3_name |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
                Aargau |        219        3.85        3.85
Appenzell Ausserrhoden |        219        3.85        7.69
 Appenzell Innerrhoden |        219        3.85       11.54
      Basel-Landschaft |        219        3.85       15.38
           Basel-Stadt |        219        3.85       19.23
                 Berne |        219        3.85       23.08
              Fribourg |        219        3.85       26.92
                Geneva |        219        3.85       30.77
                Glarus |        219        3.85       34.62
               Grisons |        219        3.85       38.46
                  Jura |        219        3.85       42.31
               Lucerne |        219        3.85       46.15
             Neuchâtel |        219        3.85       50.00
             Nidwalden |        219        3.85       53.85
              Obwalden |        219        3.85       57.69
          Schaffhausen |        219        3.85       61.54
                Schwyz |        219        3.85       65.38
             Solothurn |        219        3.85       69.23
            St. Gallen |        219        3.85       73.08
               Thurgau |        219        3.85       76.92
                Ticino |        219        3.85       80.77
                   Uri |        219        3.85       84.62
                Valais |        219        3.85       88.46
                  Vaud |        219        3.85       92.31
                   Zug |        219        3.85       96.15
                Zürich |        219        3.85      100.00
-----------------------+-----------------------------------

*/

gen nuts3_id = ""

replace nuts3_id="CH033" if nuts3_name=="Aargau"
replace nuts3_id="CH053" if nuts3_name=="Appenzell Ausserrhoden"
replace nuts3_id="CH054" if nuts3_name=="Appenzell Innerrhoden"
replace nuts3_id="CH032" if nuts3_name=="Basel-Landschaft"
replace nuts3_id="CH031" if nuts3_name=="Basel-Stadt"
replace nuts3_id="CH021" if nuts3_name=="Berne"
replace nuts3_id="CH022" if nuts3_name=="Fribourg"
replace nuts3_id="CH013" if nuts3_name=="Geneva"
replace nuts3_id="CH051" if nuts3_name=="Glarus"
replace nuts3_id="CH056" if nuts3_name=="Grisons"
replace nuts3_id="CH025" if nuts3_name=="Jura"
replace nuts3_id="CH061" if nuts3_name=="Lucerne"
replace nuts3_id="CH024" if nuts3_name=="Neuchâtel"
replace nuts3_id="CH065" if nuts3_name=="Nidwalden"
replace nuts3_id="CH064" if nuts3_name=="Obwalden"
replace nuts3_id="CH052" if nuts3_name=="Schaffhausen"
replace nuts3_id="CH063" if nuts3_name=="Schwyz"
replace nuts3_id="CH023" if nuts3_name=="Solothurn"
replace nuts3_id="CH055" if nuts3_name=="St. Gallen"
replace nuts3_id="CH057" if nuts3_name=="Thurgau"
replace nuts3_id="CH070" if nuts3_name=="Ticino"
replace nuts3_id="CH062" if nuts3_name=="Uri"
replace nuts3_id="CH012" if nuts3_name=="Valais"
replace nuts3_id="CH011" if nuts3_name=="Vaud"
replace nuts3_id="CH066" if nuts3_name=="Zug"
replace nuts3_id="CH040" if nuts3_name=="Zürich"




drop if nuts3_id==""
order nuts3_id


sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1]


// since there are delays in data updates, drop the last four observations
summ date
drop if date >= `r(max)' - 4   

compress
save "$coviddir/04 master/switzerland_data.dta", replace		
export delimited using "$coviddir/04 master/csv/switzerland_data.csv", replace	delim(;)

cd "$coviddir" // reset the directory for batch processing