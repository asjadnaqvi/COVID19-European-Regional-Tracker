clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Sweden"


*** data is hidden here in the second tab on the map
* https://experience.arcgis.com/experience/a6d20c1544f34d33b60026f45b786230

**** data can be downloaded from this link given at the very bottom of the page
*https://fohm.maps.arcgis.com/sharing/rest/content/items/b5e7488e117749c19881cce45db13f7e/data

import excel using Folkhalsomyndigheten_Covid19.xlsx, clear first sheet("Antal per dag region")
save sweden_raw.dta, replace
export delimited using sweden_raw.csv, replace delim(;)

ren Statistikdatum date
drop Totalt_antal_fall


format date %tdDD-Mon-yyyy

foreach x of varlist Blekinge- Östergötland {
	ren `x' y`x'
}


reshape long y, i(date) j(region) string



gen nuts3_id=""

replace nuts3_id="SE221" if region=="Blekinge"	
replace nuts3_id="SE312" if region=="Dalarna"	
replace nuts3_id="SE214" if region=="Gotland"	
replace nuts3_id="SE313" if region=="Gävleborg"	
replace nuts3_id="SE231" if region=="Halland"	
replace nuts3_id="SE322" if region=="Jämtland_Härjedalen"	
replace nuts3_id="SE211" if region=="Jönköping"	
replace nuts3_id="SE213" if region=="Kalmar"	
replace nuts3_id="SE212" if region=="Kronoberg"	
replace nuts3_id="SE332" if region=="Norrbotten"	
replace nuts3_id="SE224" if region=="Skåne"	
replace nuts3_id="SE110" if region=="Stockholm"	
replace nuts3_id="SE122" if region=="Sörmland"	
replace nuts3_id="SE121" if region=="Uppsala"	
replace nuts3_id="SE311" if region=="Värmland"	
replace nuts3_id="SE331" if region=="Västerbotten"	
replace nuts3_id="SE321" if region=="Västernorrland"	
replace nuts3_id="SE125" if region=="Västmanland"	
replace nuts3_id="SE124" if region=="Örebro"	
replace nuts3_id="SE123" if region=="Östergötland"	
replace nuts3_id="SE232" if region=="Västra_Götaland"	


order nuts3_id date 
sort nuts3_id date 


ren y cases_daily
gen cases = .

sort nuts3_id date

// generate cumulative sum of cases
levelsof nuts3_id, local(nuts)
levelsof date, local(lvls)


foreach x of local nuts {

display "`x'"
	
	foreach y of local lvls {	
		qui summ cases_daily 			if date <= `y' & nuts3_id=="`x'"
		qui replace cases = `r(sum)' 	if date == `y' & nuts3_id=="`x'"
	}
}


compress
save "$coviddir/04_master/sweden_data.dta", replace
export delimited using "$coviddir/04_master/csv/sweden_data.csv", replace	delim(;)

cd "$coviddir"

