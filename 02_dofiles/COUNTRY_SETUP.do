clear


/// set this to your path directory:
global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


// install these packages if you don't have them.
* net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
* net install palettes, replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
* net install colrspace, replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")

// set the color scheme for the figures
set scheme cleanplots, perm


cd "$coviddir"




**** run all the country dofiles:


do "./02_dofiles/AUSTRIA_setup_v1.do"
do "./02_dofiles/BELGIUM_setup_v3.do"
do "./02_dofiles/CROATIA_setup_v2.do"
do "./02_dofiles/CZECHIA_setup_v2.do"
do "./02_dofiles/DENMARK_setup_v1.do"   
do "./02_dofiles/ENGLAND_setup_v2.do"		
do "./02_dofiles/ESTONIA_setup_v1.do"
do "./02_dofiles/FINLAND_setup_v1.do"			
do "./02_dofiles/FRANCE_setup_v1.do" 		
do "./02_dofiles/GERMANY_setup_v1.do"
do "./02_dofiles/GREECE_setup_v2.do"   		
do "./02_dofiles/HUNGARY_setup_v1.do"
do "./02_dofiles/IRELAND_setup_v2.do"       
do "./02_dofiles/ITALY_setup_v1.do"
do "./02_dofiles/LATVIA_setup_v1.do"
do "./02_dofiles/NETHERLANDS_setup_v1.do"
do "./02_dofiles/NORWAY_setup_v1.do"
do "./02_dofiles/POLAND_setup_v3.do"  		
do "./02_dofiles/PORTUGAL_setup_v1.do"			
do "./02_dofiles/ROMANIA_setup_v1.do"			
do "./02_dofiles/SCOTLAND_setup_v1.do" 	
do "./02_dofiles/SLOVENIA_setup_v1.do" 					 
do "./02_dofiles/SLOVAKIA_setup_v1.do" 					
do "./02_dofiles/SPAIN_setup_v1.do"
do "./02_dofiles/SWEDEN_setup_v2.do"
do "./02_dofiles/SWITZERLAND_setup_v1.do"




