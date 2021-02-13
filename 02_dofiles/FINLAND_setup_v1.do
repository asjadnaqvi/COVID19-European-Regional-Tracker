clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Finland"

*https://github.com/HS-Datadesk/koronavirus-avoindata
*** date source: https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/processedThlData


copy "https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/processedThlData" "finland_data.txt", replace

filefilter "finland_data.txt" "finland_data2.txt", from({"value") to(\r{"value") replace

infix str300 line 1-300 using "finland_data2.txt", clear
compress


split line, p(":" ",")

drop in 1

ren line2 cases
ren line4 region
ren line6 date

drop line*

replace region = subinstr(region, `"""', "",.)
replace date = subinstr(date, `"""', "",.)

destring _all, replace



**** clean it up

gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
order date

destring _all, replace


save "$coviddir/04_master/finland_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/finland_data_original.csv", replace delim(;)



/*

                   region |      Freq.     Percent        Cum.
--------------------------+-----------------------------------
               Ahvenanmaa |        243        4.55        4.55
            Etelä-Karjala |        243        4.55        9.09
          Etelä-Pohjanmaa |        243        4.55       13.64
               Etelä-Savo |        243        4.55       18.18
                      HUS |        243        4.55       22.73
                 Itä-Savo |        243        4.55       27.27
Kaikki sairaanhoitopiirit |        243        4.55       31.82 // all hospital districts
                   Kainuu |        243        4.55       36.36
               Kanta-Häme |        243        4.55       40.91
          Keski-Pohjanmaa |        243        4.55       45.45
              Keski-Suomi |        243        4.55       50.00
              Kymenlaakso |        243        4.55       54.55
                    Lappi |        243        4.55       59.09
              Länsi-Pohja |        243        4.55       63.64 // sub-region of Lappi (a hospital district)
                Pirkanmaa |        243        4.55       68.18
          Pohjois-Karjala |        243        4.55       72.73
        Pohjois-Pohjanmaa |        243        4.55       77.27
             Pohjois-Savo |        243        4.55       81.82
              Päijät-Häme |        243        4.55       86.36
                Satakunta |        243        4.55       90.91
                    Vaasa |        243        4.55       95.45  // city in Pohjanmaa
          Varsinais-Suomi |        243        4.55      100.00
--------------------------+-----------------------------------
                    Total |      5,346      100.00

*/

drop if region=="Kaikki sairaanhoitopiirit"  // all hospital districts

gen nuts3_id = ""

replace nuts3_id = "FI200" if region == "Ahvenanmaa"
replace nuts3_id = "FI1C5" if region == "Etelä-Karjala"
replace nuts3_id = "FI194" if region == "Etelä-Pohjanmaa"
replace nuts3_id = "FI1D1" if region == "Etelä-Savo"
replace nuts3_id = "FI1B1" if region == "HUS"
replace nuts3_id = "FI1D1" if region == "Itä-Savo"
*replace nuts3_id = "" if region == "Kaikki sairaanhoitopiirit"
replace nuts3_id = "FI1D8" if region == "Kainuu"
replace nuts3_id = "FI1C2" if region == "Kanta-Häme"
replace nuts3_id = "FI1D5" if region == "Keski-Pohjanmaa"
replace nuts3_id = "FI193" if region == "Keski-Suomi"
replace nuts3_id = "FI1C4" if region == "Kymenlaakso"
replace nuts3_id = "FI1D7" if region == "Lappi"
replace nuts3_id = "FI1D7" if region == "Länsi-Pohja"
replace nuts3_id = "FI197" if region == "Pirkanmaa"
replace nuts3_id = "FI1D3" if region == "Pohjois-Karjala"
replace nuts3_id = "FI1D9" if region == "Pohjois-Pohjanmaa"
replace nuts3_id = "FI1D2" if region == "Pohjois-Savo"
replace nuts3_id = "FI1C3" if region == "Päijät-Häme"
replace nuts3_id = "FI196" if region == "Satakunta"
replace nuts3_id = "FI195" if region == "Vaasa"
replace nuts3_id = "FI1C1" if region == "Varsinais-Suomi"
replace nuts3_id = "" if region == ""
replace nuts3_id = "" if region == ""
replace nuts3_id = "" if region == ""

collapse (sum) cases , by(date nuts3_id) cw
ren cases cases_daily


order  nuts3_id date
sort  nuts3_id date 
compress
save "$coviddir/04_master/finland_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/finland_data.csv", replace delim(;)


cd "$coviddir"