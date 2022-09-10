clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Portugal"


** IDs

import excel using "https://github.com/bruno-leal/covid19-portugal-data/blob/master/portugal_municipalities.xlsx?raw=true", clear first
compress
sort name

replace name = subinstr(name,"-","", .)
replace name = subinstr(name," ","", .)
replace name = lower(name)

destring _all, replace
save PT_regions.dta, replace


**** for old data to fill the gaps:
import delim using "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data_concelhos.csv", clear

/*
foreach x of varlist _all {
	local header = `x'[1]
	local header = subinstr("`header'","(","", .)
	local header = subinstr("`header'",")","", .)
	local header = subinstr("`header'","/","_", .)
	local header = subinstr("`header'"," ","_", .)
	local header = subinstr("`header'","-","_", .)
	
	cap ren `x' y`header'
}

drop in 1
*/

foreach x of varlist abrantes-óbidos {
	ren `x' y`x'
}


ren data date2
gen date = date(date2,"DMY")
order date
format date %tdDD-Mon-yy
sort date
drop date2

*destring _all, replace



reshape long y, i(date) j(concelho) string

ren y cases  
destring _all, replace
sort concelho date
drop if cases==.

replace concelho = lower(concelho)
replace concelho = subinstr(concelho,"murÇa", "murça", .)
replace concelho = subinstr(concelho,"mêda","mÊda", .)
replace concelho = subinstr(concelho,"nazarÉ","nazaré", .)
replace concelho = subinstr(concelho,"ílhavo","Ílhavo", .)
replace concelho = subinstr(concelho,"óbidos","Óbidos", .)
replace concelho = subinstr(concelho,"águeda","Águeda", .)
replace concelho = subinstr(concelho,"évora","Évora", .)
replace concelho = subinstr(concelho,"mÊda","mêda", .)
replace concelho = subinstr(concelho,"lagoafaro","lagos", .)
replace concelho = subinstr(concelho,"calhetaaçores","lajesdasflores", .)




*replace concelho = subinstr(concelho,"alcobaça","alcobaÇa", .)



sort concelho date
bysort concelho: gen check = date - date[_n-1]

tab check

sort concelho date
bysort concelho: gen cases_daily_old = cases - cases[_n-1] if check==1 // there are some negative values in cases
replace cases_daily_old = 0 if cases_daily_old < 0

ren concelho name 
merge m:m name using PT_regions
drop _m

compress
save portugal_old.dta, replace

*tab name if _m==1
*tab name if _m==2


**** new data
import delim using "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data_concelhos_new.csv", clear




drop incidencia*
drop population*
drop densidade*



	replace concelho = subinstr(concelho,"(","", .)
	replace concelho = subinstr(concelho,")","", .)
	replace concelho = subinstr(concelho,"/","_", .)
	replace concelho = subinstr(concelho," ","_", .)
	replace concelho = subinstr(concelho,"-","_", .)
	replace concelho = subinstr(concelho,"_","", .)
	replace concelho = lower(concelho)
	
		ren data date2
		gen date = date(date2,"DMY")
		order date
		format date %tdDD-Mon-yy
		sort date
		drop date2		

// duplicate entries (15.12.2021)		
duplicates drop concelho date, force
		
*merge 1:1 concelho date using portugal_old
*sort concelho _merge

*bysort concelho: carryforward dicofre, replace
*bysort concelho: carryforward ars, replace
*bysort concelho: carryforward distrito, replace
*drop _merge

save "$coviddir/04_master/portugal_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/portugal_data_original.csv", replace delim(;)


ren dicofre code_lau
destring _all, replace


sort code_lau date


merge m:1 code_lau using PT_regions
append using portugal_old

drop if date==.

*sort concelho date
*br code_nuts3 date concelho code_lau _merge


order code_nuts3 date
*ren code_nuts3 nuts3_id
drop code_district_island- _merge
compress

ren code_nuts3  nuts3_id 

sort nuts3_id date
*bysort nuts3_id: gen temp = date - date[_n-1]





ren confirmados_1 cases_daily


replace cases_daily = cases_daily_old if cases_daily==. & cases_daily_old!=.

collapse (sum) cases_daily, by(nuts3_id date)


*** last update to data was 26th Oct. Check.


order  nuts3_id date
sort  nuts3_id date 
compress
save "$coviddir/04_master/portugal_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/portugal_data.csv", replace delim(;)



cd "$coviddir"

