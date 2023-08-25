clear all

cd "/Users/feiqin/Library/CloudStorage/OneDrive-purdue.edu/AAEA 2023/Local food data competition"

***********************
*** Import data
***********************

import excel "/Users/feiqin/Library/CloudStorage/OneDrive-purdue.edu/AAEA 2023/Local food data competition/Economic and SNAP.xlsx", sheet("Data") firstrow

tab state_name , mi
split state_name , parse(", ")
replace state_name1 = state_name2 if state_name2 != ""
tab state_name1 , mi
replace state_name = state_name1
drop state_name1 state_name2
drop if state_name == "NA"
drop if county_name == "NA"
tab state_name , mi
codebook fips

save "economics_fnp.dta" , replace

**
import excel "/Users/feiqin/Library/CloudStorage/OneDrive-purdue.edu/AAEA 2023/Local food data competition/variables_community.xlsx", sheet("Data") firstrow clear

tab state_name , mi
drop if state_name == "NA"
drop if county_name == "NA"
tab state_name , mi
codebook fips

save "foodaccess.dta" , replace

** append two datasets

append using "economics_fnp.dta"

**
drop category topic_area category_owndef

** rename variables
replace variable_name = "wage_ttl_crp_111" if variable_name == "total_annual_wages_NAICS 111 Crop production"
replace variable_name = "wage_ttl_anm_112" if variable_name == "total_annual_wages_NAICS 112 Animal production and aquaculture"
drop if variable_name == "total_annual_wages_NAICS 114 Fishing, hunting and trapping"
replace variable_name = "wage_ttl_for_115" if variable_name == "total_annual_wages_NAICS 115 Agriculture and forestry support activities"
replace variable_name = "wage_ttl_fman_311" if variable_name == "total_annual_wages_NAICS 311 Food manufacturing"
replace variable_name = "wage_ttl_fstr_445" if variable_name == "total_annual_wages_NAICS 445 Food and beverage stores"
replace variable_name = "wage_ttl_tru_484" if variable_name == "total_annual_wages_NAICS 484 Truck transportation"
replace variable_name = "wage_ttl_str_493" if variable_name == "total_annual_wages_NAICS 493 Warehousing and storage"
replace variable_name = "wage_ttl_fser_722" if variable_name == "total_annual_wages_NAICS 722 Food services and drinking places"


replace variable_name = "lq_crp_111" if variable_name == "lq_annual_avg_emplvl_NAICS 111 Crop production"
replace variable_name = "lq_anm_112" if variable_name == "lq_annual_avg_emplvl_NAICS 112 Animal production and aquaculture"
drop if variable_name == "lq_annual_avg_emplvl_NAICS 114 Fishing, hunting and trapping"
replace variable_name = "lq_for_115" if variable_name == "lq_annual_avg_emplvl_NAICS 115 Agriculture and forestry support activities"
replace variable_name = "lq_fman_311" if variable_name == "lq_annual_avg_emplvl_NAICS 311 Food manufacturing"
replace variable_name = "lq_fstr_445" if variable_name == "lq_annual_avg_emplvl_NAICS 445 Food and beverage stores"
replace variable_name = "lq_tru_484" if variable_name == "lq_annual_avg_emplvl_NAICS 484 Truck transportation"
replace variable_name = "lq_str_493" if variable_name == "lq_annual_avg_emplvl_NAICS 493 Warehousing and storage"
replace variable_name = "lq_fser_722" if variable_name == "lq_annual_avg_emplvl_NAICS 722 Food services and drinking places"


** drop irrelavant variables
drop if variable_name == "median_earnings_male_food_preparation_serving" | variable_name == "median_earnings_male_farming_fishing" | variable_name == "median_earnings_female_food_preparation_serving" | variable_name == "median_earnings_female_farming_fishing"  | variable_name == "number_farmers_markets"

** rename variables
replace variable_name = "m_earn_fm_ff" if variable_name == "median_earnings_female_percent_male_farming_fishing"
replace variable_name = "m_earn_fm_fps" if variable_name == "median_earnings_female_percent_male_food_preparation_serving"



** For SNAP, only keep 2020 data
duplicates report fips county_name state_name variable_name
drop if substr(variable_name, 1, 4) == "SNAP" & (year == 2017 | year == 2018 | year == 2019)
drop year

** rename SNAP variables
replace variable_name = "snap_p_asi" if variable_name == "SNAP_percent_asian_alone"
replace variable_name = "snap_p_blk" if variable_name == "SNAP_percent_black_alone"
drop if variable_name == "SNAP_percent_hispanic_any_race"
replace variable_name = "snap_p_haw" if variable_name == "SNAP_percent_native_hawaiian_alone"
replace variable_name = "snap_p_ind" if variable_name == "SNAP_percent_indian_alone"
replace variable_name = "snap_p_oth" if variable_name == "SNAP_percent_other_race_alone"
drop if  variable_name == "SNAP_percent_two_or_more_races"
replace variable_name = "snap_p_wht" if variable_name == "SNAP_percent_white_alone"
drop if variable_name == "SNAP_percent_white_alone_not_hispanic"



** reshape data
reshape wide value , i(fips county_name state_name) j(variable_name) string


** drop the states with few data points
drop if state_name == "American Samoa" | state_name == "Guam" | state_name == "Northern Mariana Islands" | state_name == "Puerto Rico" | state_name == "U.S. Minor Outlying Islands" | state_name == "U.S. Virgin Islands" | state_name == "Alaska" | state_name == "Hawaii"


** rename
foreach i in broad_16 convspth d2c_only_p deposits ffrpth fmrktpth grocpth intermediated_only_p local_p lq_anm_112 lq_crp_111 lq_fman_311 lq_for_115 lq_fser_722 lq_fstr_445 lq_str_493 lq_tru_484 m_earn_fm_ff m_earn_fm_fps number_CSAs snap_p_asi snap_p_blk snap_p_haw snap_p_ind snap_p_oth snap_p_wht  snapspth specspth supercpth wage_ttl_anm_112 wage_ttl_crp_111 wage_ttl_fman_311 wage_ttl_for_115 wage_ttl_fser_722 wage_ttl_fstr_445 wage_ttl_str_493 wage_ttl_tru_484 {
	
	rename value`i' `i' 
	
}

** generate total SNAP participation percent
gen snap_p = snap_p_asi + snap_p_blk  + snap_p_haw + snap_p_ind + snap_p_oth  + snap_p_wht 

sum snap_p

drop snap_p_asi  snap_p_blk  snap_p_haw snap_p_ind  snap_p_oth  snap_p_wht 


** drop variables that have lots of missing values
drop lq_anm_112 lq_crp_111  lq_fman_311 lq_for_115 lq_str_493 m_earn_fm_ff wage_ttl_anm_112  wage_ttl_crp_111 wage_ttl_fman_311 wage_ttl_for_115 wage_ttl_str_493  

** keep counties that have all the information we indicate
*gen keep = 1 if broad_16!= . & convspth!= . & d2c_only_p!= . & deposits!= . & ffrpth!= . & fmrktpth!= . & grocpth!= . & intermediated_only_p!= . & local_p!= . & lq_fser_722!= . & lq_fstr_445!= . & lq_tru_484!= . & m_earn_fm_fps!= . & number_CSAs!= .  & snap_p!= . & specspth!= . & supercpth!= . & wage_ttl_fser_722!= . & wage_ttl_fstr_445!= . & wage_ttl_tru_484!= . 

gen keep = 1 if broad_16!= . & convspth!= . & d2c_only_p!= . & deposits!= . & ffrpth!= . & fmrktpth!= . & grocpth!= . & intermediated_only_p!= . & local_p!= . & m_earn_fm_fps!= . & number_CSAs!= .  & snap_p!= . & specspth!= . & supercpth!= .  

**
keep if keep == 1
drop keep

******************************************************
**** Variables transformation and standarization
******************************************************

sktest broad_16-snap_p

** log transformation
foreach i in broad_16 convspth d2c_only_p deposits ffrpth fmrktpth grocpth intermediated_only_p local_p m_earn_fm_fps number_CSAs snap_p snapspth specspth supercpth {
	
	gen lg_`i' = ln(`i'+0.01)
}


** standardize the variable (min-max method)
foreach i in lg_broad_16 lg_convspth lg_d2c_only_p lg_deposits lg_ffrpth lg_fmrktpth lg_grocpth lg_intermediated_only_p lg_local_p  lg_m_earn_fm_fps lg_number_CSAs lg_snap_p lg_snapspth lg_specspth lg_supercpth {
	qui sum `i'
	gen std_`i' = (`i' - `r(min)')/(`r(max)' - `r(min)')
}

** group the variables in the same dimension together

** economics
order std_lg_deposits, after(std_lg_broad_16)
order std_lg_m_earn_fm_fps, after(std_lg_deposits) 

** social support (SNAP participation)
order std_lg_snap_p, after(std_lg_m_earn_fm_fps) 

** local food supply chain
order std_lg_d2c_only_p, after(std_lg_snap_p) 
order std_lg_intermediated_only_p, after(std_lg_d2c_only_p)
order std_lg_local_p, after(std_lg_intermediated_only_p) 
order std_lg_number_CSAs, after(std_lg_local_p) 

** the rest variables are local food access


******************************************************
**** Correlations of Variables 
******************************************************

* rename variables to create the correlation heatplot
rename std_lg_broad_16 telecom
rename std_lg_deposits deposit
rename std_lg_m_earn_fm_fps earning_fmp
rename std_lg_snap_p snap_percent
rename std_lg_d2c_only_p d2c_per
rename std_lg_intermediated_only_p interm_per
rename std_lg_local_p local_per
rename std_lg_number_CSAs numberCSAs
rename std_lg_convspth convs_pth
rename std_lg_ffrpth ffr_pth
rename std_lg_fmrktpth fmrkt_pth
rename std_lg_grocpth groc_pth
rename std_lg_snapspth snaps_pth
rename std_lg_specspth specs_pth
rename std_lg_supercpth superc_pth

**
correlate telecom-superc_pth
return list

matrix corrmatrix = r(C)

** Correlation heatplot
heatplot corrmatrix,  color(hcl  diverging, gscale intensity(.7))  legend(off) aspectratio(1) lower  xlabel(, ang(v) labsize(small)) ylabel(, labsize(small))




******************************************************
**** Index
******************************************************


*********************
** Economics
** high correlation
** simple mean
*********************

gen economics = (telecom+ deposit + earning_fmp)/3

*********************
** Social support
** only one variable
*********************

gen social_support = snap_p

*********************
** Local food supply chain
** high correlation
** simple mean
*********************

gen lfsc = (d2c_per+interm_per+local_per+numberCSAs)/4

*********************
** Local food access
** low correlation
** geometric mean
*********************

gen lfa = (convs_pth+ffr_pth+fmrkt_pth+groc_pth+snaps_pth+specs_pth+superc_pth)/7

******************
** aggreagte index
** geometric mean
******************

gen index = (economics*social_support*lfsc*lfa)^(1/4)

histogram index

** export
export excel fips county_name state_name economics social_support lfsc lfa index using "/Users/feiqin/Library/CloudStorage/OneDrive-purdue.edu/AAEA 2023/Local food data competition/Index_final.xlsx", firstrow(variables) sheet("Sheet1", replace)
