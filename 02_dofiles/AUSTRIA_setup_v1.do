clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Austria"



*** raw data


copy "https://covid19-dashboard.ages.at/data/data.zip" "data.zip", replace
unzipfile "data.zip", replace



*** clean the main file

insheet using CovidFaelle_Timeline_GKZ.csv, clear delim(;)
save "$coviddir/04_master/austria_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/austria_data_original.csv", replace delim(;)



ren gkz id
ren anzeinwohner pop
ren anzahlfaelle cases_daily
ren anzahlfaellesum cases
ren anzahlfaelle7tage cases_7day
ren anzahltottaeglich deaths_daily
ren anzahltotsum deaths 
ren anzahlgeheilttaeglich recovered_daily 
ren anzahlgeheiltsum recovered
ren siebentageinzidenzfaelle incidence_7day

cap ren Time time

replace incidence_7day = subinstr(incidence_7day, ",",".",.)
destring incidence_7day, replace

gen day   = substr(time,1,2)
gen month = substr(time,4,2)
gen year  = substr(time,7,4)

destring month day year, replace
gen date = mdy(month,day,year)
drop month day year
format date %tdDD-Mon-YYYY
order date
drop time


sort date id



merge m:1 id using Austria_NUTS3_Bezirk_mapping
drop if _m!=3  // drop empty row
drop _m


*** here we keep the following variables
collapse (sum) cases cases_daily deaths deaths_daily recovered recovered_daily, by(date nuts3_id)

order nuts3_id date
sort  nuts3_id date


**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check
drop check

compress
save "$coviddir/04_master/austria_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/austria_data.csv", replace delim(;)


cd "$coviddir"