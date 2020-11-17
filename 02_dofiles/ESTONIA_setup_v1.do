clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir./01 raw/Estonia"

*** lau codes

import excel using LAU.xlsx, clear first
drop if lau_id==.
compress
drop area_m2
save lau_Estonia.dta, replace


** https://www.terviseamet.ee/et/koroonaviirus/avaandmed
insheet using "https://opendata.digilugu.ee/opendata_covid19_test_location.csv", clear

save estonia_raw.dta, replace
export delimited using estonia_raw.csv, replace delim(;)


ren communeehak lau_id
ren statisticsdate date
sort date

gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
order date

replace lau_id = 304 if lau_id==305
replace lau_id = 718 if lau_id==719
drop if lau_id==.

merge m:1 lau_id using lau_Estonia.dta

*egen tag = tag(lau_id)
*br if _m!=3 & tag==1

sort lau_id date

*** this is a massive approximation
gen cases = round((totalcasesfrom + totalcasesto) / 2)  


collapse (sum) cases , by(date nuts3_id) cw

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] // this is also likely to be distorted.


order date nuts3_id
sort date nuts3_id
compress

compress
save "$coviddir/04 master/estonia_data.dta", replace		
export delimited using "$coviddir/04 master/csv/estonia_data.csv", replace delim(;)



cd "$coviddir"
