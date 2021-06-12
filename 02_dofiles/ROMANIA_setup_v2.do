clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Romania"

***** county_codes
import excel using romania_county_codes.xlsx, clear first
drop FIPS area_km2

compress
save county_code.dta, replace



*** data file: https://datelazi.ro/


**** here we use a file cleaned from a json reader: https://json-csv.com/

insheet using "date_12_iunie_la_13_00.csv", clear non


foreach x of varlist v* {
	if regexm(`x'[1], "currentDayStats__") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "charts") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "lasUpdatedOn") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "number") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "fileName") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "complete") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "average") == 1 {
		drop `x'
	}
}


foreach x of varlist v* {
			if regexm(`x'[1], "percentageOf") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "distribution") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "parsedOn") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "incidence") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
			if regexm(`x'[1], "vaccines") == 1 {
		drop `x'
	}
}



foreach x of varlist v* {
	replace `x' = subinstr(`x', "historicalData__|__countyInfectionsNumbers__", "county_",1)
}

foreach x of varlist v* {
	replace `x' = subinstr(`x', "historicalData__|", "date",1)
}


foreach x of varlist v* {
			if regexm(`x'[1], "historicalData__|__countyInfectionsNumbers") == 1 {
		drop `x'
	}
}


foreach x of varlist v* {
			if regexm(`x'[1], "county_-") == 1 {
		drop `x'
	}
}

foreach x of varlist v* {
	local header = `x'[1]
	ren `x' `header'
	
}




cap drop v*
drop in 1
destring _all, replace


drop if date==""

save "$coviddir/04_master/romania_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/romania_data_original.csv", replace delim(;)


ren date date2
gen date = date(date2, "YMD")
format date %tdDD-Mon-yy


drop date2


duplicates tag date, gen(dups)
tab dups
drop dups

reshape long county_, i(date) j(county) string

ren county_ cases
drop if cases==.

ren county ISO
replace ISO = upper(ISO)


merge m:1 ISO using county_code.dta
drop _m

order nuts3_id date
sort nuts3_id date

**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1

drop check


order  nuts3_id date
sort  nuts3_id date 
compress
save "$coviddir/04_master/romania_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/romania_data.csv", replace delim(;)


cd "$coviddir"
