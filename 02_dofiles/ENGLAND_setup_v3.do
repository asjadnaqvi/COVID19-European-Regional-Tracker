clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/England"




**** GIS data: http://geoportal.statistics.gov.uk/datasets/1d78d47c87df4212b79fe2323aae8e08_0/data

/*
insheet using UK_LAD2.csv, clear
drop objectid lad19nmw bng_e bng_n longitude latitude st_areasha st_lengths levl_code cntr_code mount_type urbn_type coast_type fid nuts_name
ren lad19cd lad_id
ren lad19nm lad_name
ren nuts_id nuts3_id

drop if substr(lad_id,1,1)=="N"
drop if substr(lad_id,1,1)=="W"
drop if substr(lad_id,1,1)=="S"

compress
save UK_regions.dta, replace
*/


*** ENGLAND

**ONS data: https://coronavirus.data.gov.uk/details/download. Download the LTLA file.

copy "https://api.coronavirus.data.gov.uk/v2/data?areaType=ltla&metric=newCasesBySpecimenDateAgeDemographics&format=csv" "LTLA.csv", replace



// LTLA
import delim using LTLA.csv, clear

keep if age=="60+" | age=="00_59"  // dropping age cateogies to make the file size reasonable. Remove this line if you want the full dataset.

save "$coviddir/04_master/england_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/england_data_original.csv", replace delim(;)

drop areatype
drop rollingrate rollingsum





ren date date2
gen date = date(date2, "YMD")
format date %tdDD-Mon-yy
drop date2





replace areacode="E06000052" if areacode=="E06000053"
replace areaname="Cornwall" if areaname=="Cornwall and Isles of Scilly"
replace areaname="Cornwall" if areaname=="Isles of Scilly"

replace areacode="E09000001" if areacode=="E09000012"
replace  areaname="City of London" if areaname=="Hackney and City of London"


collapse (sum) cases, by(areacode areaname date)

order areacode areaname date
ren cases cases_daily

ren areacode lad_id
ren areaname lad_name





merge m:1 lad_id lad_name using UK_regions

egen tag = tag(lad_id)
list lad_id lad_name nuts3_id _m if _m==1 & tag==1
list lad_id lad_name nuts3_id _m if _m==2 & tag==1

drop if _m!=3
drop _m
drop tag

collapse (sum) cases_daily, by(nuts3_id date)


// add back cases in
gen cases = .

levelsof date, local(dts)
foreach x of local dts {
	bysort nuts3_id: egen temp= sum(cases_daily) if date <= `x'
	qui cap replace cases = temp	if date == `x'
	qui drop temp
}


order nuts3_id date cases cases_daily
sort nuts3_id date  


gen ctry = "England"

compress
save "$coviddir/04_master/england_data.dta", replace	
export delimited using "$coviddir/04_master/csv_nuts/england_data.csv", replace delim(;)


cd "$coviddir"
