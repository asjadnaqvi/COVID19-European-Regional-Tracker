clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/03_GIS"

global mapdir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe/06_animation"


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



*** drop all the days when no cases exist
bysort nuts0_id date: egen total = sum(cases_daily)
drop if total == 0
drop total

*** this is just for maps to label them as "No Cases"
recode cases_daily 		(0=.)  
recode cases_daily_pop 	(0=.)  








**** graphs below

local date: display %tdd_m_yy date(c(current_date), "DMY")
display "`date'"

local date2 = subinstr(trim("`date'"), " ", "_", .)
display "`date2'"



format cases_daily %9.0f

replace cases_daily = . if cases_daily <= 0

summ date
summ cases_daily if date==`r(max)'



preserve
	summ date
	keep if date==`r(max)'
	keep if cases_daily>0 & cases_daily!=.
	keep _ID nuts_name _CX _CY cases_daily
	geo2xy _CY _CX, proj (web_mercator) replace	   // this is the one to use
	gen name2 = nuts_name + " (" +  string(cases_daily) + ")"
	duplicates drop name , force
	save cases_label.dta, replace
restore		

sort date nuts3_id




	summ date
		local ldate = `r(max)'
		local ldate : di %tdd_m_yy `ldate'

format cases_daily %9.0f	

/*
colorpalette matplotlib autumn, n(18) reverse nograph
*colorpalette cranberry orange gray, ipolate(10) reverse nograph
local colors `r(p)'

summ date



spmap cases_daily using "nuts3_shp.dta" if last==1, ///
id(_ID) cln(15)  fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
	ocolor(gs6 ..) osize(vvthin ..) ///
	ndfcolor(gs8) ndocolor(gs2 ..) ndsize(vvthin ..) ndlabel("No cases") ///
		legend(pos(10) size(*0.8) symx(*0.8) symy(*0.8) forcesize) legstyle(2) legjunction(" - ")  ///		
		polygon(data("nuts0_shp")  ocolor(black)   osize(vthin) legenda(on) legl("Regions")) ///
		title("COVID-19 new cases at NUTS-3 (`ldate')", size(*0.7)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS layers. Data: Misc sources.", size(tiny))
		graph export "$mapdir/covid19_europe.png", replace wid(5000)	

*/

gen date2 = date
drop if date < 21989
replace cases_daily_pop = . if cases_daily_pop <= 0

summ cases_daily_pop, d
kdensity cases_daily_pop if cases_daily_pop < 4



summ date
		local ldate = `r(max)'
		local ldate : di %tdd_m_yy `ldate'

format cases_daily_pop %9.1f	

*colorpalette matplotlib autumn, n(20) reverse nograph
colorpalette red yellow gs6, ipolate(22, power(0.8)) reverse nograph
local colors `r(p)'

summ date


levelsof date, local(lvls)

foreach x of local lvls {

summ date if date==`x'
		local ldate = `r(max)'
		local ldate : di %tdd_m_yy `ldate'

	local t : label date `x'
	display "`t'"


spmap cases_daily_pop using "nuts3_mix_shp.dta" if date==`x', ///
id(_ID) clm(custom) clbreaks(0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 3 4 5 10 15 20 50 110 130 150)   fcolor("`colors'")  /// //  clm(custom) clbreaks(0(5)45) 
	ocolor(white ..) osize(vvthin ..) ///
	ndfcolor(gs4) ndocolor(white ..) ndsize(vvthin ..) ndlabel("No reported cases") ///
		legend(pos(10) size(*0.8) symx(*0.8) symy(*0.8) forcesize)  legend(color(white)) legstyle(2) legjunction(" - ")  ///		
		polygon(data("nuts0_shp")  ocolor(gs12)   osize(thin) legenda(on) legl("Country boundaries")) ///
		title("{fontface Arial Bold: COVID-19 daily cases per 10k population (`ldate')}", size(*0.65)  color(white)) ///
		graphregion(fcolor(gs2)) ///
		note("Map layer: Eurostat GISCO 2016 NUTS 3 layer used for base map. Data: Misc sources. Data is at NUTS-3 level except for Poland and Greece.", size(tiny) color(white))
		graph export "$mapdir/casespop_`x'.png", replace wid(3000)	
		
}	



****** film export stuff below

*** animation stuff below



global ffmpegLocation "D:/Software/ffmpeg/bin"		
global graphLocation  "D:\Programs\Dropbox\Dropbox\PROJECT COVID Europe\06_animation"		
global outputLocation "D:\Programs\Dropbox\Dropbox\PROJECT COVID Europe\06_animation"		// Where you want to save the movie

! "$ffmpegLocation/ffmpeg.exe" -y -framerate 10 -start_number 21989 -i "$graphLocation/casespop_%02d.png" -c:v libx264 -crf 5 -r 28 -filter:v "scale='min(1920,iw)':min'(1080,ih)':force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" "$outputLocation/Video.mp4"

*! "$ffmpegLocation/ffmpeg.exe" -y -s 1920x1080 -framerate 10 -start_number 21989 -i "$graphLocation/casespop_%02d.png" -c:v libx264 -crf 8 -r 30 -filter:v "scale='min(1920,iw)':min'(1080,ih)':force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" "$outputLocation/Video.mp4"

*! "$ffmpegLocation/ffmpeg.exe" -y             -framerate 10 -start_number 21989 -i "$graphLocation/casespop_%02d.png" -c:v libx264 -crf 8 -r 30  "scale='min(1920,iw)':min'(1080,ih)':force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" -pix_fmt yuv420p  "$outputLocation/Video.mp4"


*! "$ffmpegLocation/ffmpeg.exe" -y -i "$outputLocation/Video.mp4" -filter:v "setpts=1.5*PTS" "$outputLocation/Video2.mp4"    // increase the frames
! "$ffmpegLocation/ffmpeg.exe" -y -i "$outputLocation/Video.mp4" -filter "minterpolate='mi_mode=blend:fps=120'" "$outputLocation/Video_smooth.mp4" // increase the framerate
*! "$ffmpegLocation/ffmpeg.exe" -y -i "$outputLocation/Video_smooth.mp4" -filter:v "scale='min(1280,iw)':min'(720,ih)':force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" -pix_fmt yuv420p "$outputLocation/Video_smooth2.mp4"							

/*
global butterflowLocation "C:/butterflow"
! "${butterflowLocation}/butterflow.exe" -r 5x -v --poly-s=0.02 --fast-pyr -o "$outputLocation/smoothVideo_blend.mp4" "$outputLocation/Video_smooth.mp4"



	
		
*subtitle("Total change in cases  = `today'") ///		
*label(data("cases_label.dta") x(_CX) y(_CY) label(name2) size(*0.3 ..) length(30)) ///				
		
*
		
/*	
summ date		
spmap using "germany_shp.dta" if date==`r(max)', ///
	id(_ID) ocolor(gs4 ..) osize(vvthin ..)  ///
	legend(pos(11) size(*1.5) symx(*1) symy(*1) forcesize)  ///
  	    polygon(data("germany_nuts2_shp")  ocolor(black)   osize(thin) legenda(on) legl("Bundesländer")) 
		graph export "$mapdir/Germany_overview.png", replace wid(4000)	
		

	