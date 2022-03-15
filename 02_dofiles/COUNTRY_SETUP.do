clear
/// set this to your path directory:
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


// install these packages 
* ssc install schemepack, replace  // schemes
* set scheme white_tableau		   // clean scheme

* ssc install palettes, replace    // for colors 
* ssc install colrspace, replace   // color libraries
* ssc install heatplot, replace    // heatplots
* ssc install spmap				   // maps	
* ssc install geo2xy			   // projection change


// set the color scheme for the figures
*set scheme white_tableau, replace


cd "$coviddir"

**** run all the country dofiles:

** auto updated

do "./02_dofiles/AUSTRIA_setup_v1.do"
do "./02_dofiles/BELGIUM_setup_v4.do"
do "./02_dofiles/CROATIA_setup_v3.do"
do "./02_dofiles/CZECHIA_setup_v2.do"
do "./02_dofiles/ENGLAND_setup_v3.do"		
do "./02_dofiles/ESTONIA_setup_v1.do"
do "./02_dofiles/FINLAND_setup_v1.do"			
do "./02_dofiles/GERMANY_setup_v1.do"
do "./02_dofiles/GREECE_setup_v2.do"   		
do "./02_dofiles/HUNGARY_setup_v2.do"
do "./02_dofiles/ITALY_setup_v1.do"
do "./02_dofiles/LATVIA_setup_v1.do"
do "./02_dofiles/NETHERLANDS_setup_v1.do"
do "./02_dofiles/NORWAY_setup_v1.do"
do "./02_dofiles/POLAND_setup_v8.do"  		
do "./02_dofiles/PORTUGAL_setup_v2.do"			
do "./02_dofiles/ROMANIA_setup_v3.do"	 	
do "./02_dofiles/SLOVAKREPUBLIC_setup_v1.do" 	
do "./02_dofiles/SLOVENIA_setup_v1.do" 					 
do "./02_dofiles/SPAIN_setup_v1.do"
do "./02_dofiles/SWITZERLAND_setup_v1.do"


** require manual update

do "./02_dofiles/DENMARK_setup_v1.do" 	  	// manual data update  
do "./02_dofiles/FRANCE_setup_v1.do"  	  	// manual data update	
do "./02_dofiles/IRELAND_setup_v2.do" 	  	// manual data update      
do "./02_dofiles/SCOTLAND_setup_v3.do" 	  	// manually update the date in the code
do "./02_dofiles/SWEDEN_setup_v2.do"		// manual date update



****< END OF FILE: run the COUNTRY_MERGE_v3.do file next >****
