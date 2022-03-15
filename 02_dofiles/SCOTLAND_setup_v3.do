clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Scotland"




*** save region information. one time

/*
insheet using UK_LAD2.csv, clear
drop objectid lad19nmw bng_e bng_n longitude latitude st_areasha st_lengths levl_code cntr_code mount_type urbn_type coast_type fid nuts_name
ren lad19cd lad_id
ren lad19nm lad_name
ren nuts_id nuts3_id

keep if substr(lad_id,1,1)=="S"

compress
save Scotland_regions.dta, replace
*/


*** data here: Daily cases trends by local authority
*https://www.opendata.nhs.scot/dataset/covid-19-in-scotland  


copy "https://www.opendata.nhs.scot/dataset/b318bddf-a4dc-4262-971f-0ba329e09b87/resource/427f9a25-db22-4014-a3bc-893b68243055/download/trend_ca_20220310.csv" "scotland_raw.csv", replace

		
import delim using scotland_raw.csv, clear

save "$coviddir/04_master/scotland_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/scotland_data_original.csv", replace delim(;)


tostring date, replace

gen year  = substr(date, 1, 4)
gen month = substr(date, 5, 2)
gen day   = substr(date, 7, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy




ren dailypositive cases_daily
ren cumulativepositive cases

ren ca lad_id

	
merge m:1 lad_id using Scotland_regions


drop _m



collapse (sum) cases_daily cases, by(date nuts3_id)

order nuts3_id date
sort nuts3_id date

gen ctry = "Scotland"  // just for UK differentiation

compress
save "$coviddir/04_master/scotland_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/scotland_data.csv", replace delim(;)

cd "$coviddir"
