clear
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/03 GIS"



**** NUTS 2015 layers from the GISCO webpage


*** NUTS0
spshape2dta NUTS_RG_03M_2016_4326_LEVL_0, replace saving(nuts0) 

use nuts0, clear
	ren NUTS_ID nuts0_id
	cap ren NAME_LATN nuts0_name  
	cap ren NUTS_NAME nuts0_name
	drop if CNTR_CODE=="TR"      // drop Turkey for now
	compress
	sort _ID
save, replace


use nuts0_shp, clear
	merge m:1 _ID using nuts0
	drop if _m!=3
	keep _ID _X _Y
	keep if _X > -10 & _Y >20  						// get rid of the small islands
	geo2xy _Y _X, proj (web_mercator) replace	   
	sort _ID
save, replace

*** NUTS1
spshape2dta NUTS_RG_03M_2016_4326_LEVL_1, replace saving(nuts1) 

use nuts1, clear
	ren NUTS_ID nuts1_id
	cap ren NAME_LATN nuts1_name  
	cap ren NUTS_NAME nuts1_name
	drop if CNTR_CODE=="TR"      // drop Turkey for now
	compress
	sort _ID
save, replace


use nuts1_shp, clear
	merge m:1 _ID using nuts1
	drop if _m!=3
	keep _ID _X _Y
	keep if _X > -10 & _Y >20  						// get rid of the small islands
	geo2xy _Y _X, proj (web_mercator) replace	   
	sort _ID
save, replace



*** NUTS2
spshape2dta NUTS_RG_03M_2016_4326_LEVL_2, replace saving(nuts2) 


use nuts2, clear
	ren NUTS_ID nuts2_id
	cap ren NAME_LATN nuts2_name  
	cap ren NUTS_NAME nuts2_name
	compress

	*** manually shift the IDs of Poland and Greece
	keep if CNTR_CODE=="PL" | ///
			CNTR_CODE=="EL"
	replace _ID = _ID + 4000
	sort _ID
save, replace

use nuts2_shp, clear
	replace _ID = _ID + 4000
	merge m:1 _ID using nuts2
	drop if _m!=3
	keep _ID _X _Y
	keep if _X > -10 & _Y >20  		// get rid of the small islands
	geo2xy _Y _X, proj (web_mercator) replace	  
	sort _ID
save, replace


*** NUTS3

spshape2dta NUTS_RG_03M_2016_4326_LEVL_3, replace saving(nuts3) 


use nuts3, clear
	ren NUTS_ID nuts3_id
	cap ren NAME_LATN nuts3_name
	cap ren NUTS_NAME nuts3_name
	compress
	drop if CNTR_CODE=="TR"
	
	drop if CNTR_CODE=="PL" | ///
			CNTR_CODE=="EL"
	sort _ID
save, replace


use nuts3_shp, clear
	merge m:1 _ID using nuts3
	drop if _m!=3
	keep _ID _X _Y
	keep if _X > -10 & _Y >20  // get rid of the small islands
	geo2xy _Y _X, proj (web_mercator) replace
	sort _ID
save, replace


*** combining the NUTS2 and NUTS3 shapefiles


use nuts3_shp, clear
	append using nuts2_shp
	sort _ID
save nuts3_mix_shp.dta, replace



use nuts3, clear
	append using nuts2
	gen nuts_id = nuts3_id
		replace nuts_id = nuts2_id if nuts3_id==""
	
	gen nuts_name = nuts3_name
		replace nuts_name = nuts2_name if nuts3_name==""
	
gen nuts0_id = substr(nuts_id,1,2)	
save nuts3_mix, replace


*** generate shape files for countries from the mixed shapefile for NUTS2/NUTS3


use nuts3_mix_shp, clear
		merge m:1 _ID using nuts3_mix
		keep _ID _X _Y nuts0_id

		
levelsof nuts0_id, local(lvls)
	foreach x of local lvls {
		preserve
			keep if nuts0_id=="`x'"
			drop nuts0_id
			sort _ID
			save nuts3_shp_`x'.dta, replace
		restore
		}

		
**** for labels
use nuts3_mix, clear
		keep _ID _CX _CY nuts_id nuts_name
		keep if _CX > -10 & _CY >20  // get rid of the small islands
		geo2xy _CY _CX, proj (web_mercator) replace
		gen nuts0_id = substr(nuts_id,1,2)

levelsof nuts0_id, local(lvls)
	foreach x of local lvls {
		preserve
			keep if nuts0_id=="`x'"
			sort _ID
			save nuts_label_`x'.dta, replace
		restore
		}				
		
	
*** generate shape files for country boundaries from the mixed shapefile
use nuts0_shp, clear
	merge m:1 _ID using nuts0
		keep _ID _X _Y nuts0_id
	
levelsof nuts0_id, local(lvls)
	foreach x of local lvls {
		preserve
			keep if nuts0_id=="`x'"
			drop nuts0_id
			sort _ID
			save nuts0_shp_`x'.dta, replace
		restore
		}
	
	
*** generate shape files for countries from the mixed shapefile	for NUTS1	

	
		

**** for boundaries
use nuts1_shp, clear
	merge m:1 _ID using nuts1
		keep _ID _X _Y nuts1_id
		gen nuts0_id = substr(nuts1_id,1,2)
	
	
levelsof nuts0_id, local(lvls)
	foreach x of local lvls {
		preserve
			keep if nuts0_id=="`x'"
			drop nuts1_id nuts0_id
			sort _ID
			save nuts1_shp_`x'.dta, replace
		restore
		}	
	
	
	
	
	
	
	