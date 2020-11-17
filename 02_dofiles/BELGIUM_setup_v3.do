clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Belgium"


***** LAU 1
import excel using "LAU1.xlsx", first clear
ren NUTS3CODE nuts3
ren LAUCODE lau
ren LAUNAMENATIONAL lau_name
ren POPULATION population
ren TOTALAREAm2 area_m2
drop area_m2
compress
save lau_belgium.dta, replace



***** excel data from website

insheet using "https://epistat.sciensano.be/Data/COVID19BE_CASES_MUNI.csv", clear
save belgium_raw.dta, replace
export delimited using belgium_raw.csv, replace delim(;)



foreach x of varlist _all {
local header = lower(`x'[1])
ren `x' `header'
}

drop in 1
cap drop tx_descr_fr 
cap drop tx_adm_dstr_descr_fr 
cap drop tx_prov_descr_fr 
cap drop tx_rgn_descr_fr
cap drop if nis5=="NA"
drop if date=="NA"      

replace cases = "1" if cases=="<5"   // judgement call
ren cases cases_daily

destring _all, replace


ren nis5 lau
ren tx_adm_dstr_descr_nl lau_name
cap ren tx_prov_descr_nl province

cap drop tx_rgn_descr_nl

replace lau_name = trim(subinstr(lau_name, "Arrondissement" , "", .))
replace province = trim(subinstr(province, "Provincie" , "", .))


gen year  = substr(date, 1,4)
gen month = substr(date, 6,2)
gen day = substr(date, 9,2)

drop date
destring _all, replace
gen date = mdy(month,day, year)
drop year month day

format date %tdDD-Mon-yyyy

order date lau


**** merge with nuts3 code

merge m:1 lau using lau_belgium.dta

tab lau_name if _m==1 // fix these
tab lau_name if _m==2



drop if _m!=3  
drop _m




collapse (sum) cases_daily population, by(date nuts3)

ren nuts3 nuts3_id
order nuts3_id date
sort nuts3_id date

summ date
drop if date==`r(max)'

compress
save "$coviddir/04_master/belgium_data.dta", replace
export delimited using "$coviddir/04_master/csv/belgium_data.csv", replace delim(;)


cd "$coviddir"

