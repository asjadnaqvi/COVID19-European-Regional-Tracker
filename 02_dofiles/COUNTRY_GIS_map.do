clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/03_GIS"

*net install palettes, replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
*net install colrspace, replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")

use nuts3_mix, clear
*drop if CNTR_CODE=="PT"
		
*** merge with the datafile
	merge 1:m nuts_id using "$coviddir/04_master/EUROPE_COVID19_master.dta"

	egen tag = tag(nuts_id)

		list nuts_id  if tag==1 & _m==1
		list nuts_id  if tag==1 & _m==2

		drop _m



*** drop dates for which countries are missing data points

drop tag

summ date
drop if date >= `r(max)' - 3  // drop the last 2 or three observations to avoid incompleteness

*** drop all the days when no cases exist
bysort country date: egen total = sum(cases_daily)
drop if total == 0
drop total


gen cases_pop = (cases / pop) * 10000 


*** generate a variable for the last observation for each country
gen last = .
gen change14 = .
gen change14_abs	 = .
gen change14_abs_pop = .

sort nuts_id date

levelsof nuts_id, local(lvls)
foreach x of local lvls {

	display "`x'"
	
	qui summ date if nuts_id=="`x'" & cases_daily!=.
	local last   = `r(max)'

	
	
	qui replace last   = 1 if date==`r(max)' & nuts_id=="`x'"
	
	qui replace change14 = ((cases - cases[_n-14]) / cases[_n-14]) * 100  // %change change in cases
	qui replace change14_abs_pop = ((cases - cases[_n-14]) * 10000) / pop         // absolute change in cases per pop
	qui replace change14_abs	 = ((cases - cases[_n-14]))          // absolute change in cases per pop
	
	}




	
*** this is just for maps to label them as "No Cases"


recode cases_pop 		(0=.) 
recode cases_daily 		(0=.)  
recode cases_daily_pop 	(0=.)  
recode change14			(0=.)
recode change14_abs		(0=.)
recode change14_abs_pop	(0=.)

replace last = . if nuts0_id=="PT"


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

***** graph of last reported daily cases

colorpalette viridis, ipolate(17, power(1.4)) reverse nograph
local colors `r(p)'

spmap cases_daily using "nuts3_mix_shp.dta" if last==1 , ///  // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(15)  fcolor("`colors'")  /// 
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases on the last reported date") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 new cases (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data source: Misc. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
		
		graph export "../05_figures/COVID19_EUROPE_cases_today.png", replace wid(2000)
		*graph export "../05_figures/COVID19_EUROPE_cases_today.pdf", replace


		
		
		
***** graph of last reported daily cases per 10k population


colorpalette viridis, ipolate(17, power(1.4)) reverse nograph
local colors `r(p)'

spmap cases_daily_pop using "nuts3_mix_shp.dta" if last==1 , /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(15)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases/missing data") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 new cases per 10,000 pop (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_casespop_today.png", replace wid(2000)
		*graph export "../05_figures/COVID19_EUROPE_casespop_today.pdf", replace		

**** graph of cumulative cases 


colorpalette viridis, ipolate(15, power(1.4)) reverse nograph
local colors `r(p)'

spmap cases using "nuts3_mix_shp.dta" if last==1 , /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(14) clm(k)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases/missing data") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 cumulative cases (15 Jan 20 - `ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_cases_total.png", replace wid(2000)
		graph export "../05_figures/COVID19_EUROPE_cases_total.pdf", replace	

**** graph of cumulative cases per population


format cases_pop 	%9.0f		
		

colorpalette viridis, ipolate(15, power(1.2)) reverse nograph
local colors `r(p)'

spmap cases_pop using "nuts3_mix_shp.dta" if last==1 , /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(14) clm(k)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("No cases/missing data") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: COVID-19 cumulative cases per 10,000 pop (15 Jan 20 - `ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_casespop_total.png", replace wid(2000)
		graph export "../05_figures/COVID19_EUROPE_casespop_total.pdf", replace 		
	

***** graph of 2 week increase in cases


replace change14 = . if change14==0
replace change14 = . if nuts0_id=="PT"

format change14 	%9.2f		
		
colorpalette viridis,  ipolate(15, power(1.4)) reverse nograph

local colors `r(p)'

spmap change14 using "nuts3_mix_shp.dta" if last==1 & country!="PT", /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(14) clm(k)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("Dropped") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: % change in COVID-19  cases in the past 14 days (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_change14.png", replace wid(2000)
		*graph export "../05_figures/COVID19_EUROPE_change14.pdf", replace 	

		
***** graph of 2 week absolute increase in cases per pop


replace change14_abs_pop = . if change14==0
replace change14_abs_pop = . if nuts0_id=="PT"

format change14_abs_pop 	%9.0f		
		

colorpalette viridis,  ipolate(15, power(1.4)) reverse nograph
local colors `r(p)'

spmap change14_abs_pop using "nuts3_mix_shp.dta" if last==1 & country!="PT", /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(14)  clm(k)    fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs2 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("Dropped") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: Absolute change in COVID-19 cases/10k pop in the last 14 days (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_change14_abs_pop.png", replace wid(2000)

			

***** graph of 2 week absolute increase in cases 


replace change14_abs = . if change14_abs==0
replace change14_abs = . if nuts0_id=="PT"

format change14_abs_pop 	%9.0f		
		

colorpalette viridis,  ipolate(15, power(1.4)) reverse nograph
*colorpalette gs14 dkorange red,  ipolate(15, power(1)) nograph

local colors `r(p)'

spmap change14_abs using "nuts3_mix_shp.dta" if last==1 & country!="PT", /// // & (nuts0_id!="PT" & nuts0_id!="EL")
id(_ID) cln(14) clm(k)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45)  clbreaks(0 5 10 25 50 75 100 150 200 400 500 700 1000 1500 3000 8000)
	ocolor(gs2 ..) osize(vvthin ..) ///
	ndfcolor(gs14) ndocolor(gs4 ..) ndsize(*0.1 ..) ndlabel("Dropped") ///
		legend(pos(10) size(*1) symx(*0.8) symy(*0.8) forcesize) legstyle(2)   ///		
		polygon(data("nuts0_shp") ocolor(black) osize(vthin) legenda(on) legl("Regions")) ///
		title("{fontface Arial Bold: Absolute change in COVID-19 cases in the last 14 days (`ldate')}", size(2.5)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny))
			
		graph export "../05_figures/COVID19_EUROPE_change14_abs.png", replace wid(2000)

			
				
			
			
		
***** country specific graphs below


summ date
	local ldate = `r(max)'
	local ldate : di %tdd_m_y `ldate'

display "`ldate'"

levelsof nuts0_id if nuts0_id!="PT", local(cntry)

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


levelsof nuts0_id if nuts0_id!="PT", local(cntry)

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







*label(data("nuts_label_`x'") x(_CX) y(_CY) label(nuts_name) size(1.4 ..) length(30)) ///

****** END OF FILE ******
	
	
	
	

	
	
		