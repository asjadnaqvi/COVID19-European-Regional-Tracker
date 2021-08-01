clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/03_GIS"
*net install tsg_schemes, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
*net install palettes, replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
*net install colrspace, replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")
*set scheme white_tableau

use nuts3_mix, clear

		
*** merge with the datafile
	merge 1:m nuts_id using "$coviddir/04_master/EUROPE_COVID19_master.dta"

	egen tag = tag(nuts_id)

		list nuts_id  if tag==1 & _m==1
		list nuts_id  if tag==1 & _m==2

		drop _m

		


*** drop dates for which countries are missing data points

drop tag

summ date
drop if date >= `r(max)' - 4  // drop the last 2 or 3 observations to avoid incompleteness

// probably wrong by makes life easier. only very few regions have this problem
replace cases    	= 0 if cases       < 0  
replace cases_daily = 0 if cases_daily < 0  


*** drop all the days when no cases exist
bysort country date: egen total = sum(cases_daily)
drop if total == 0
drop total



*** generate a variable for the last observation for each country



gen last = .
gen change14 = .
gen change14_abs	 = .
gen change14_abs_pop = .

sort nuts_id date

levelsof nuts_id, local(lvls)
local i = 1

foreach x of local lvls {

	*display "`x'"
	
	qui summ date if nuts_id=="`x'" & cases_daily!=.
	local last   = `r(max)'

	qui replace last   = 1 if date==`r(max)' & nuts_id=="`x'"
	
	_dots `i' 0
	local i = `i' + 1
	
	}
	
	
*** calculate the difference from the last 14 days. Since there gaps in the data we need to identify the correct observations for the difference



levelsof nuts_id, local(lvls)
local i = 1
local dot = 0

foreach x of local lvls {


qui summ date if last==1 & nuts_id=="`x'"

if `r(N)' > 0 {
local datesub = `r(max)' - 14

qui summ cases if date==`datesub' & nuts_id=="`x'"

if `r(N)' > 0 {

	qui replace change14 = ((cases - `r(mean)') / `r(mean)') * 100 		if last==1 & nuts_id=="`x'"   // %change change in cases
	qui replace change14_abs_pop = ((cases - `r(mean)') * 10000) / pop  if last==1 & nuts_id=="`x'"   // absolute change in cases per pop
	qui replace change14_abs	 = ((cases - `r(mean)'))   				if last==1 & nuts_id=="`x'"   // absolute change in cases per pop	
}
else {
    local dot = 1
}

}
	
local i = `i' + 1	
	
_dots `i' `dot'

local dot = 0
}	
	
	

	
	

*** adding the code for doubling time especially if it becomes an issue
cap drop doublingtime_cases
sort nuts_id date
bysort nuts_id: gen doublingtime_cases = ((date - date[_n - 10]) * log(2)) / (log(cases) - log(cases[_n - 10]))
replace doublingtime_cases = .  if doublingtime_cases < 0


	
*** this is just for maps to label them as "No Cases"

recode cases_pop 		(0=.) 
recode cases_daily 		(0=.)  
recode cases_daily_pop 	(0=.)  
recode change14			(0=.)
recode change14_abs		(0=.)
recode change14_abs_pop	(0=.)

format cases_daily		%9.0f
format cases_daily_pop 	%9.2f	



	
	
**** graphs below

local date: display %tdd_m_y date(c(current_date), "DMY")
display "`date'"

local date2 = subinstr(trim("`date'"), " ", "_", .)
display "`date2'"

summ date
	local ldate = `r(max)'
	local ldate : di %tdd_m_y `ldate'

display "`ldate'"



**********************************		
*** graph of cumulative cases  ***
**********************************


colorpalette viridis, ipolate(15, power(1.4)) reverse nograph
local colors `r(p)'

spmap cases using "nuts3_mix_shp.dta" if last==1, /// 
id(_ID) cln(14) clm(k)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 cumulative cases (15 Jan 20 - `ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_cases_total.png", replace wid(2000)


****************************************************		
*** graph of cumulative cases per 10k population ***
****************************************************


format cases_pop 	%9.0f		
		

colorpalette viridis, ipolate(15, power(1.2)) reverse nograph
local colors `r(p)'

spmap cases_pop using "nuts3_mix_shp.dta" if last==1, /// 
id(_ID) cln(14) clm(k)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 cumulative cases per 10,000 pop (15 Jan 20 - `ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_casespop_total.png", replace wid(2000)
		


		
	
*** sometimes countries or even some regions fall off the radar. 
**   Dont plot data points if there is no information 14 days before
***  the last data point in the Tracker.

summ date
replace last = . if last==1 & date < r(max) - 14
			
******************************************
*** graph of last reported daily cases ***
******************************************

colorpalette viridis, ipolate(17, power(1.4)) reverse nograph
local colors `r(p)'

spmap cases_daily using "nuts3_mix_shp.dta" if last==1, ///  
id(_ID) cln(15)  fcolor("`colors'")  /// 
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 new cases (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data source: Misc. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
		
		graph export "../05_figures/COVID19_EUROPE_cases_today.png", replace wid(2000)



		
		
**************************************************************		
*** graph of last reported daily cases per 10k population  ***
**************************************************************


colorpalette viridis, ipolate(17, power(1.4)) reverse nograph
local colors `r(p)'

spmap cases_daily_pop using "nuts3_mix_shp.dta" if last==1, /// 
id(_ID) cln(15)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 new cases per 10,000 pop (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_casespop_today.png", replace wid(2000)
	
			
			
		
*****************************************
*** graph of 2 week increase in cases ***
*****************************************


format change14 	%9.2f		
		
colorpalette viridis,  ipolate(15, power(1.4)) reverse nograph

local colors `r(p)'

spmap change14 using "nuts3_mix_shp.dta" if last==1, /// 
id(_ID) cln(14) clm(k)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("Dropped") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: % change in COVID-19  cases in the past 14 days (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_change14.png", replace wid(2000)
	
	
***********************************************************	
*** graph of 2 week absolute increase in cases per pop  ***
***********************************************************


format change14_abs_pop 	%9.0f		
		

colorpalette viridis,  ipolate(15, power(1.4)) reverse nograph
local colors `r(p)'

spmap change14_abs_pop using "nuts3_mix_shp.dta" if last==1, /// 
id(_ID) cln(14)  clm(k)    fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs2 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("Dropped") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: Absolute change in COVID-19 cases/10k pop in the last 14 days (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_change14_abs_pop.png", replace wid(2000)

			
***************************************************
*** graph of 2 week absolute increase in cases  ***
***************************************************

format change14_abs_pop 	%9.0f		
		

colorpalette viridis,  ipolate(15, power(1.4)) reverse nograph
local colors `r(p)'

spmap change14_abs using "nuts3_mix_shp.dta" if last==1, /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(14) clm(k)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs2 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("Dropped") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: Absolute change in COVID-19 cases in the last 14 days (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_change14_abs.png", replace wid(2000)

			
				
			
			
*******************************************		
***** country specific graphs below   *****
*******************************************

** these countries are off the radar
drop if nuts0_id=="IE" | nuts0_id=="LV"  


summ date
	local ldate = `r(max)'
	local ldate : di %tdd_m_y `ldate'

display "`ldate'"

levelsof nuts0_id, local(cntry)

foreach x of local cntry {

display "`x'"

	preserve
	
		keep if nuts0_id=="`x'"
		sort _ID

		summ date
			local ldate1 = `r(max)'
			local ldate2 : di %tdd_m_y `ldate1'

		colorpalette viridis, ipolate(6, power(1.2)) reverse nograph
		local colors `r(p)'

			spmap cases_daily using "nuts3_shp_`x'.dta" if last==1, ///
			id(_ID) cln(5)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
				ocolor(gs6 ..) osize(vthin ..) ///
				ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
					legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
					polygon(data("nuts1_shp_`x'") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
					title("{fontface Arial Bold: COVID-19 new cases - `x' (`ldate2')}", size(*0.7)) ///
					note("Map layer: Eurostat GISCO 2016 NUTS layers.", size(tiny))

			graph export "../05_figures/covid19_`x'.png", replace wid(2000)

	restore	
	
	}

		*label(data("nuts_label_`x'") x(_CX) y(_CY) label(nuts_name) size(*0.5 ..) length(30)) ///	


levelsof nuts0_id , local(cntry)

foreach x of local cntry {

display "`x'"

	preserve
	
		keep if nuts0_id=="`x'"
		sort _ID

		summ date
			local ldate1 = `r(max)'
			local ldate2 : di %tdd_m_y `ldate1'

		colorpalette viridis, ipolate(6, power(1.2)) reverse nograph
		local colors `r(p)'

			spmap cases_daily_pop using "nuts3_shp_`x'.dta" if last==1, ///
			id(_ID) cln(5)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
				ocolor(gs6 ..) osize(vthin ..) ///
				ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
					legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
					polygon(data("nuts1_shp_`x'") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
					title("{fontface Arial Bold: COVID-19 new cases per 10,000 pop - `x' (`ldate2')}", size(*0.7)) ///
					note("Map layer: Eurostat GISCO 2016 NUTS layers.", size(tiny))

			graph export "../05_figures/covid19_`x'_pop.png", replace wid(2000)

	restore	
	
}

/*

// test map for checking stuff

		colorpalette viridis, ipolate(6, power(1.2)) reverse nograph
		local colors `r(p)'

			spmap change14 using "nuts3_shp_CH.dta" if last==1 & nuts0_id=="CH", ///
			id(_ID) cln(5)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
				ocolor(gs6 ..) osize(vthin ..) ///
				ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases") ///
					legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
					polygon(data("nuts1_shp_CH") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
					title("{fontface Arial Bold: COVID-19 new cases }", size(*0.7)) ///
					note("Map layer: Eurostat GISCO 2016 NUTS layers.", size(tiny))




****** END OF FILE ******
	
	
	
		