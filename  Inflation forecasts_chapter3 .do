
 *****The Impact of Uncertainty on Inflation Forecasts Using Real-time Output Gap Estimates*****
 

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd1", clear

joinby(DATE) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd2", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd3", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd4", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd5", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd6", unmatched(both)
drop _merge

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", replace

****** transfor the data from string to number

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear

sxpose, clear firstnames 

forvalues x = 1/271  {
gen v`x'= real( _var`x')
drop _var`x'
}


xpose, clear



save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose", replace

*******************************

****** transfor the data from value to annual growth rate
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose", clear

forvalues x = 1/589 {
gen g`x'= 100*(ln(v`x')-ln(v`x'[_n-4]))
drop v`x'
}

replace g364 = g365 if g364==.
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_growth", replace

***** first-released growth rate



use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_growth", clear

xpose, clear

gen t=_n


joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/time", unmatched(both)

drop _merge
keep if month==2|month==5|month==8|month==11


forvalues x = 1/74 {
drop v`x'
}
drop t
gen t=_n

forvalues x = 75/271 {
replace v`x'=0 if t~=`x'-74
}


gen preliminary=0

forvalues x = 75/271 {
replace preliminary=preliminary+v`x'
}


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary_growth", replace



use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear

gen t=_n
drop if t<=74
keep t DATE 
drop t
gen t=_n

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary_growth", unmatched(both)
 
drop _merge

keep DATE t month preliminary

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary_growth", replace



****** first-released linear output gap

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose",clear


forvalues x = 1/589 {
gen g`x'= ln(v`x')
drop v`x'
}

replace g364 = g365 if g364==.

gen t=_n


forvalues x = 1/589 {

reg g`x' t 

predict y`x', xb

gen l_gap`x'=g`x'-y`x'

drop  y`x' g`x'

}



drop t


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_routput_gap", replace

****** first-released Q output gap

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose",clear


forvalues x = 1/589 {
gen g`x'= ln(v`x')
drop v`x'
}

replace g364 = g365 if g364==.

gen t=_n
gen t_2=t^2

forvalues x = 1/589 {


reg g`x' t t_2

predict y`x', xb
gen q_gap`x'=g`x'-y`x'

drop  y`x' g`x'

}



drop t
drop t_2


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_routput_gap", replace

***************************first-released linear output gap





use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_routput_gap", clear

xpose, clear

gen t=_n


joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/time", unmatched(both)

drop _merge
keep if month==2|month==5|month==8|month==11


forvalues x = 1/74 {
drop v`x'
}

drop t
gen t=_n

forvalues x = 75/271 {
replace v`x'=0 if t~=`x'-74
}


gen preliminary=0

forvalues x = 75/271 {
replace preliminary=preliminary+v`x'
}


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_preliminary_gap", replace



use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear

gen t=_n
drop if t<=74
keep t DATE 
drop t
gen t=_n

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_preliminary_gap", unmatched(both)
 
drop _merge

keep DATE t month preliminary
rename preliminary l_preliminary_gap

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_preliminary_gap", replace






***************************first-released quadratic output gap





use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_routput_gap", clear

xpose, clear

gen t=_n


joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/time", unmatched(both)

drop _merge
keep if month==2|month==5|month==8|month==11


forvalues x = 1/74 {
drop v`x'
}

drop t
gen t=_n

forvalues x = 75/271 {
replace v`x'=0 if t~=`x'-74
}


gen preliminary=0

forvalues x = 75/271 {
replace preliminary=preliminary+v`x'
}


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_preliminary_gap", replace



use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear

gen t=_n
drop if t<=74
keep t DATE 
drop t
gen t=_n

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_preliminary_gap", unmatched(both)
 
drop _merge

keep DATE t month preliminary
rename preliminary q_preliminary_gap

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_preliminary_gap", replace


***************************
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_growth", clear
gen t=_n
forvalues x = 1/589 {
rename g`x'  growth`x'

}


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_growth", replace
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_growth",  unmatched(both)
drop _merge

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/output_time", unmatched(both)

drop _merge

keep DATE t year quarter growth589 growth571
rename growth589 growth14M11
rename growth571 growth13M05


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_growth", replace




***************************

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_routput_gap", clear
gen t=_n


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_l", replace
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_l",  unmatched(both)
drop _merge

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/output_time", unmatched(both)

drop _merge

keep DATE t year quarter l_gap589 l_gap571
rename l_gap589 l_gap14M11
rename l_gap571 l_gap13M05


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_l", replace




***************************





use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_routput_gap", clear
gen t=_n


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_q", replace
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_q",  unmatched(both)
drop _merge

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/output_time", unmatched(both)

drop _merge

keep DATE t year quarter q_gap589 q_gap571
rename q_gap589 q_gap14M11
rename q_gap571 q_gap13M05


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_q", replace



***************************
***************************
***************************
***************************

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_l", clear
drop t
joinby ( year quarter ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/quarterly_uncertainty", unmatched(both)
gen high=0
replace high=1 if uncertainty > uncertainty[_n-4]
gen low=0
replace low=1 if uncertainty < uncertainty[_n-4]
drop _merge
drop t
joinby ( DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/q_preliminary_gap", unmatched(both)
drop if _merge~=3
drop _merge
drop t
joinby ( DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/l_preliminary_gap", unmatched(both)
drop if _merge~=3
drop _merge
drop t
joinby ( DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary_growth", unmatched(both)
drop if _merge~=3
drop _merge
drop t
joinby ( DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_gap_q", unmatched(both)

drop if _merge~=3

drop _merge
drop t
joinby ( DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/final_routput_growth", unmatched(both)

drop if _merge~=3
drop _merge


drop t
gen t=_n

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table1", replace

joinby ( DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/DATE", unmatched(both)

drop if _merge~=3
drop _merge


joinby ( year quarter ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/inflation", unmatched(both)


save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table1", replace




******** Table 2
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table1", clear



gen l_gap14M11_4=l_gap14M11[_n-4]
gen l_gap14M11_5=l_gap14M11[_n-5]
gen q_gap14M11_4=q_gap14M11[_n-4]
gen q_gap14M11_5=q_gap14M11[_n-5]
gen growth14M11_4=growth14M11[_n-4]
gen growth14M11_5=growth14M11[_n-5]

reg  inflation infl4 infl5 l_gap14M11_4 l_gap14M11_5 growth14M11_4 growth14M11_5  t 




reg  inflation infl4 infl5 q_gap14M11_4 q_gap14M11_5 growth14M11_4 growth14M11_5  t 






