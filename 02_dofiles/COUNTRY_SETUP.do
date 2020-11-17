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


do "./02 dofiles/AUSTRIA_setup_v1.do"
do "./02 dofiles/BELGIUM_setup_v3.do"
do "./02 dofiles/CROATIA_setup_v2.do"
do "./02 dofiles/CZECHIA_setup_v2.do"
do "./02 dofiles/DENMARK_setup_v1.do"   
do "./02 dofiles/ENGLAND_setup_v2.do"		
do "./02 dofiles/ESTONIA_setup_v1.do"
do "./02 dofiles/FINLAND_setup_v1.do"			
do "./02 dofiles/FRANCE_setup_v1.do" 		
do "./02 dofiles/GERMANY_setup_v1.do"
do "./02 dofiles/GREECE_setup_v2.do"   		
do "./02 dofiles/HUNGARY_setup_v1.do"
do "./02 dofiles/IRELAND_setup_v2.do"       
do "./02 dofiles/ITALY_setup_v1.do"
do "./02 dofiles/LATVIA_setup_v1.do"
do "./02 dofiles/NETHERLANDS_setup_v1.do"
do "./02 dofiles/NORWAY_setup_v1.do"
do "./02 dofiles/POLAND_setup_v3.do"  		
do "./02 dofiles/PORTUGAL_setup_v1.do"			
do "./02 dofiles/ROMANIA_setup_v1.do"			
do "./02 dofiles/SCOTLAND_setup_v1.do" 	
do "./02 dofiles/SLOVENIA_setup_v1.do" 					 
do "./02 dofiles/SLOVAKIA_setup_v1.do" 					
do "./02 dofiles/SPAIN_setup_v1.do"
do "./02 dofiles/SWEDEN_setup_v2.do"
do "./02 dofiles/SWITZERLAND_setup_v1.do"




