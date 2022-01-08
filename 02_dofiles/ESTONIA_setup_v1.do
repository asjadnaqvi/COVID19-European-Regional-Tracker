clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir./01_raw/Estonia"

*** lau codes

import excel using LAU.xlsx, clear first
drop if lau_id==.
compress
drop area_m2
save lau_Estonia.dta, replace


** https://www.terviseamet.ee/et/koroonaviirus/avaandmed
import delim using "https://opendata.digilugu.ee/opendata_covid19_test_location.csv", clear
save "$coviddir/04_master/estonia_data_original.dta", replace

export delimited using "$coviddir/04_master/csv_original/estonia_data_original.csv", replace delim(;)



ren communeehak lau_id
ren statisticsdate date
sort date


ren date date2
gen date = date(date2, "YMD")
format date %tdDD-Mon-yy
drop date2



// minor cleaning due to renaming of LAUs
replace lau_id = 304 if lau_id==305
replace lau_id = 718 if lau_id==719
drop if lau_id==.

merge m:1 lau_id using lau_Estonia.dta

*egen tag = tag(lau_id)
*br if _m!=3 & tag==1

sort lau_id date


*** drop if result value = N (negative tested): see https://www.terviseamet.ee/et/koroonaviirus/avaandmed for notes

drop if resultvalue=="N"

*** this is a massive approximation
gen cases = round((totalcasesfrom + totalcasesto) / 2)  


collapse (sum) cases , by(date nuts3_id)

**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check



sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1 // this is also likely to be distorted.

drop check

order date nuts3_id
sort date nuts3_id
compress

compress
save "$coviddir/04_master/estonia_data.dta", replace		
export delimited using "$coviddir/04_master/csv_nuts/estonia_data.csv", replace delim(;)



cd "$coviddir"
