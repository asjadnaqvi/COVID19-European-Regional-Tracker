clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Portugal"


** IDs

import excel using "https://github.com/bruno-leal/covid19-portugal-data/blob/master/portugal_municipalities.xlsx?raw=true", clear first
compress
sort name
destring _all, replace
save PT_regions.dta, replace




**** for old data to fill the gaps:
insheet using "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data_concelhos.csv", clear non


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

ren ydata date2
gen date = date(date2,"DMY")
order date
format date %tdDD-Mon-yyyy
sort date
drop date2

*destring _all, replace



reshape long y, i(date) j(concelho) string

ren y cases  
destring _all, replace
sort concelho date
drop if cases==.

*replace concelho = lower(concelho)



sort concelho date
bysort concelho: gen check = date - date[_n-1]

tab check

sort concelho date
bysort concelho: gen cases_daily_old = cases - cases[_n-1] if check==1 // there are some negative values in cases
replace cases_daily_old = 0 if cases_daily_old < 0


compress
save portugal_old.dta, replace



**** new data
insheet using "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data_concelhos_new.csv", clear




drop incidencia*
drop population*
drop densidade*



	replace concelho = subinstr(concelho,"(","", .)
	replace concelho = subinstr(concelho,")","", .)
	replace concelho = subinstr(concelho,"/","_", .)
	replace concelho = subinstr(concelho," ","_", .)
	replace concelho = subinstr(concelho,"-","_", .)
	
		ren data date2
		gen date = date(date2,"DMY")
		order date
		format date %tdDD-Mon-yyyy
		sort date
		drop date2		

merge 1:1 concelho date using portugal_old
sort concelho _merge

bysort concelho: carryforward dicofre, replace
bysort concelho: carryforward ars, replace
bysort concelho: carryforward distrito, replace
drop _merge

save "$coviddir/04_master/portugal_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/portugal_data_original.csv", replace delim(;)


ren dicofre code_lau
destring _all, replace


sort code_lau date


merge m:1 code_lau using PT_regions


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

