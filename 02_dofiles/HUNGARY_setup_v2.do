clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


*cd "$coviddir/01_raw/Hungary"



********** at the NUTS3 level

insheet using "https://raw.githubusercontent.com/mollac/CoVid-19/master/korona_megyei.csv", nonames clear
save hungary_raw, replace
export delimited using hungary_raw.csv, replace delim(;)


foreach x of varlist v* {
	replace `x' = subinstr(`x', "-", "_", .)
	}
	


foreach x of varlist v* {
	local header = `x'[1]
	*display "`header'"
	lab var `x' "`header'"
	*ren `x' v`header'
	}

	
drop in 1	
	

ren v1 date

cap drop v22 
cap drop v23
destring _all, replace	
	
reshape long v, i(date) j(region)

	
lab de region 	6 "Budapest" 	///
				15 "Pest" 		///
				3 "Baranya" 	///
				4 "Békés" 		///
				5 "Borsod_Abaúj_Zemplén" ///
				7 "Csongrád"	///
				8 "Fejér"  		///
				11 "Heves" 		///
				10 "Hajdú_Bihar" ///
				14 "Nógrád" 	///
				12 "Jász_Nagykun_Szolnok" ///
				17 "Szabolcs_Szatmár_Bereg" ///
				2 "Bács_Kiskun" ///
				18 "Tolna" 		///
				20 "Veszprém" 	///
				16 "Somogy" 	///
				13 "Komárom_Esztergom" ///
				9 "Győr_Moson_Sopron" ///
				19 "Vas" ///
				21 "Zala"
				
				
ren v cases

lab val region region				

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


compress

gen nuts3_id = ""

replace nuts3_id="HU110" if region==6
replace nuts3_id="HU120" if region==15
replace nuts3_id="HU211" if region==8
replace nuts3_id="HU212" if region==13
replace nuts3_id="HU213" if region==20
replace nuts3_id="HU221" if region==9
replace nuts3_id="HU222" if region==19
replace nuts3_id="HU223" if region==21
replace nuts3_id="HU231" if region==3
replace nuts3_id="HU232" if region==16
replace nuts3_id="HU233" if region==18
replace nuts3_id="HU311" if region==5
replace nuts3_id="HU312" if region==11
replace nuts3_id="HU313" if region==14
replace nuts3_id="HU321" if region==10
replace nuts3_id="HU322" if region==12
replace nuts3_id="HU323" if region==17
replace nuts3_id="HU331" if region==2
replace nuts3_id="HU332" if region==4
replace nuts3_id="HU333" if region==7

order nuts3_id
drop date2

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1]


compress
save "$coviddir/04_master/hungary_data.dta", replace
export delimited using "$coviddir/04_master/csv/hungary_data.csv", replace delim(;)




cd "$coviddir"