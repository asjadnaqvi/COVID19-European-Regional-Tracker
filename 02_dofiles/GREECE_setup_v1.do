clear

cap cd "D:\Programs\Dropbox\Dropbox\PROJECT COVID"
cap cd "C:\Users\asjad\Dropbox\PROJECT COVID"

global mapdir ".\PROJECT COVID maps"
*** getting the raw data from the website https://info.gesundheitsministerium.at/



********** at the NUTS3 level
*https://github.com/Covid-19-Response-Greece/covid19-data-greece/blob/master/data/greece/isMOOD/cases_by_region_timeline.csv

insheet using "https://raw.githubusercontent.com/Covid-19-Response-Greece/covid19-data-greece/master/data/greece/isMOOD/cases_by_region_timeline.csv", nonames clear

save ./extracted/greece_raw.dta, replace


*** backfill from here:
*https://github.com/kargig/covid19-gr-json
*https://github.com/Covid-19-Response-Greece/covid19-data-greece/tree/master/data/greece/NPHO


insheet using "https://raw.githubusercontent.com/Sandbird/covid19-Greece/master/regions.csv", clear


gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)
drop year month day

order date
format date %tdDD-Mon-yyyy
sort region date 

drop date2

/*

                               region |      Freq.     Percent        Cum.
--------------------------------------+-----------------------------------
                               Attica |        185        6.25        6.25
                       Central Greece |        185        6.25       12.50
                    Central Macedonia |        185        6.25       18.75
                                Crete |        185        6.25       25.00
         Eastern Macedonia and Thrace |        185        6.25       31.25
                               Epirus |        185        6.25       37.50
                       Ionian Islands |        185        6.25       43.75
                          Mount Athos |        185        6.25       50.00
                         North Aegean |        185        6.25       56.25
                          Peloponnese |        185        6.25       62.50
                         South Aegean |        185        6.25       68.75
                             Thessaly |        185        6.25       75.00
                  Under Investigation |        185        6.25       81.25
                       Western Greece |        185        6.25       87.50
                    Western Macedonia |        185        6.25       93.75
Without permanent residency in Greece |        185        6.25      100.00
--------------------------------------+-----------------------------------
                                Total |      2,960      100.00
*/

gen nuts2_id = ""

replace nuts2_id="EL30" if region=="Attica"
replace nuts2_id="EL64" if region=="Central Greece"
replace nuts2_id="EL52" if region=="Central Macedonia"
replace nuts2_id="EL43" if region=="Crete"
replace nuts2_id="EL51" if region=="Eastern Macedonia and Thrace"
replace nuts2_id="EL54" if region=="Epirus"
replace nuts2_id="EL62" if region=="Ionian Islands"
replace nuts2_id="" 	if region=="Mount Athos"
replace nuts2_id="EL41" if region=="North Aegean"
replace nuts2_id="EL65" if region=="Peloponnese"
replace nuts2_id="EL42" if region=="South Aegean"
replace nuts2_id="EL61" if region=="Thessaly"
replace nuts2_id="EL63" if region=="Western Greece"
replace nuts2_id="EL53" if region=="Western Macedonia"

drop if nuts2_id==""


order nuts2_id


sort nuts2_id date
bysort nuts2_id: gen cases_daily = cases - cases[_n-1]



sort date nuts2_id 
compress
save ./GIS/greece_data.dta, replace

