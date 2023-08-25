* Set the directory to the data folder
cd "/Users/wangyi/Desktop/Visualization_maps/"

* Read the index data and save as .dta file
import excel "Index_final.xlsx", firstrow clear 
gen str5 GEOID = string(fips, "%05.0f")
save "index.dta", replace 

* Install necessary commands.
cap ssc install shp2dta 
cap ssc install spmap

* Create needed datasets: counties and cntycoord. 
clear
shp2dta using cb_2016_us_county_500k.shp, ///
                database(counties) coordinates(cntycoord) genid(id) replace
			
*Create two datasets for outlines of U.S. states: states and statecoord.
shp2dta using cb_2016_us_state_500k.shp, ///
                database(states) coordinates(statecoord) genid(id) replace
				
*Drop the observations from unincorporated territories, islands, Hawaii, and Alaska ect.
use statecoord, clear
drop if _ID == 2
drop if _ID == 11
drop if _ID == 34
drop if _ID == 54
drop if _ID == 33
drop if _ID == 56
drop if _ID == 55

save "statecoord.dta", replace

* Merge Index file with counties.dta file. 
use "index.dta", clear
merge 1:1 GEOID using "counties.dta"

* Draw the map for all counties 
spmap index using cntycoord if STATEFP!="15" & STATEFP!="02" & STATEFP!="72" & STATEFP!="44" & STATEFP!="78" & STATEFP!="66" & STATEFP!="78" & STATEFP!="69" & STATEFP!="60", id(id) ocolor(gs10 gs9 gs8 gs7) clnumber(5) ///  
fcolor("224 224 224" "192 192 192" "128 128 128" "64 64 64" "0 0 0") polygon(data(statecoord.dta) ocolor(black)) ///
legend(title("Strength of Local Food Systems", pos(11) size(4)))

graph export "indexmap4allcounties.png", replace


