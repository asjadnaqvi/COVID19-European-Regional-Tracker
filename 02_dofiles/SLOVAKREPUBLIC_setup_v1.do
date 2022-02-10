clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Slovakia"




****** https://github.com/radoondas/covid-19-slovakia/blob/master/data/covid-19-slovensko.csv

import delim using "https://raw.githubusercontent.com/radoondas/covid-19-slovakia/master/data/covid-19-slovensko.csv", clear
save "$coviddir/04_master/slovakrep_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/slovakrep_data_original.csv", replace delim(;)




ren v1 date	
ren v2 city
ren v3 infected
ren v4 gender
ren v5 note_1
ren v6 note_2
ren v7 healthy
ren v8 died
ren v9 region
ren v10 age
ren v11 district




gen year  = substr(date, 7, 4)
gen month = substr(date, 4, 2)
gen day   = substr(date, 1, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
order date


/*
          region |      Freq.     Percent        Cum.
-----------------+-----------------------------------
 Banskobystrický |        179        8.05        8.05
    Bratislavský |        440       19.78       27.83
         Košický |        282       12.68       40.51
       Neuvedené |        137        6.16       46.67   // this stands for unknown
      Nitriansky |        143        6.43       53.10
       Prešovský |        304       13.67       66.77
     Trenčiansky |        291       13.08       79.86
        Trnavský |        174        7.82       87.68
        Žilinský |        274       12.32      100.00
-----------------+-----------------------------------
           Total |      2,224      100.00

*/

gen nuts3_id = ""
replace nuts3_id = "SK010" if region == "Bratislavský"
replace nuts3_id = "SK021" if region == "Trnavský"
replace nuts3_id = "SK022" if region == "Trenčiansky"
replace nuts3_id = "SK023" if region == "Nitriansky"
replace nuts3_id = "SK031" if region == "Žilinský"
replace nuts3_id = "SK032" if region == "Banskobystrický"
replace nuts3_id = "SK041" if region == "Prešovský"
replace nuts3_id = "SK042" if region == "Košický"
replace nuts3_id = "" if region == ""
replace nuts3_id = "" if region == ""


drop if nuts3_id == ""

ren infected cases_daily

sort nuts3_id date city

collapse (sum) cases_daily , by(date nuts3_id) cw


order nuts3_id date
sort nuts3_id date


compress
save "$coviddir/04_master/slovakrep_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/slovakrep_data.csv", replace delim(;)


cd "$coviddir"