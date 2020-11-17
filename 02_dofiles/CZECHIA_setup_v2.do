clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"



cd "$coviddir/01_raw/Czechia"


*** https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19

insheet using "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/kraj-okres-nakazeni-vyleceni-umrti.csv", clear
save czechia_raw.dta, replace
export delimited using czechia_raw.csv, replace delim(;)


ren datum date

gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy

ren kumulativni_pocet_nakazenych 	cases
ren kumulativni_pocet_vylecenych 	recovered
ren kumulativni_pocet_umrti 		dead
ren kraj_nuts_kod 					nuts3_id
ren okres_lau_kod					lau_id


collapse (sum) cases recovered dead, by(nuts3_id date)

order nuts3_id  date 
sort nuts3_id date 

bysort nuts3_id: gen cases_daily = cases - cases[_n-1]



compress
save "$coviddir/04_master/czechia_data.dta", replace		
export delimited using "$coviddir/04_master/csv/czechia_data.csv", replace delim(;)


cd "$coviddir"
