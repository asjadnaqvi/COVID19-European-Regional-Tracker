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
save "$coviddir/04_master/belgium_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/belgium_data_original.csv", replace delim(;)




foreach x of varlist _all {
local header = lower(`x'[1])
ren `x' `header'
}

drop in 1

save belgium_raw.dta, replace
export delimited using belgium_raw.csv, replace delim(;)



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
ren tx_descr_nl 	 municipality
ren tx_adm_dstr_descr_nl district




replace district = trim(subinstr(district, "Arrondissement" , "", .))
replace province = trim(subinstr(province, "Provincie" , "", .))


ren date date2
gen date = date(date2, "YMD")
format date %tdDD-Mon-yyyy
drop date2

order date lau


**** fixing IDS. some municipalities were merged together

replace lau = 44001 if municipality=="Aalter"
replace lau = 56011 if municipality=="Binche"
replace lau = 44011 if municipality=="Deinze"
replace lau = 55010 if municipality=="Edingen"
replace lau = 56085 if municipality=="Estinnes"
replace lau = 55022 if municipality=="La Louvière"
replace lau = 55023 if municipality=="Lessen"
replace lau = 44036 if municipality=="Lievegem"
replace lau = 52043 if municipality=="Manage"
replace lau = 54007 if municipality=="Moeskroen"
replace lau = 56087 if municipality=="Morlanwelz"
replace lau = 52063 if municipality=="Seneffe"
replace lau = 12030 if municipality=="Puurs-Sint-Amands"
replace lau = 45017 if municipality=="Kruisem"
replace lau = 55039 if municipality=="Opzullik"
replace lau = 54010 if municipality=="Komen-Waasten"
replace lau = 71047 if municipality=="Oudsbergen"
replace lau = 72025 if municipality=="Pelt"



**** merge with nuts3 code

merge m:1 lau using lau_belgium.dta

tab municipality if _m==1 // fix these
tab lau_name     if _m==2



drop if _m!=3  
drop _m

ren nuts3 nuts3_id





collapse (sum) cases_daily population, by(date nuts3_id)


order nuts3_id date
sort nuts3_id date

summ date
drop if date==`r(max)'

compress
save "$coviddir/04_master/belgium_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/belgium_data.csv", replace delim(;)


cd "$coviddir"


