clear
******** import data
import excel "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd1.xls", sheet("routput1") firstrow allstring
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd1", replace
clear

import excel "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd2.xls", sheet("routput2") firstrow allstring
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd2", replace
clear

import excel "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd3.xls", sheet("routput3") firstrow allstring
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd3", replace
clear

import excel "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd4.xls", sheet("routput4") firstrow allstring
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd4", replace
clear

import excel "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd5.xls", sheet("routput5") firstrow allstring
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd5", replace
clear

import excel "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd6.xls", sheet("routput6") firstrow allstring
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routputMvQd6", replace
clear



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
gen t=_n
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose", replace


****** transfor the data from value to quarterly growth rate
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose",clear

xpose, clear

gen t=_n
drop if t==272


forvalues x = 1/589 {
gen g`x'= 100*(ln(v`x')-ln(v`x'[_n-1]))
drop v`x'
}

replace g364 = g365 if g364==.
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_growth", replace

****** generate the preliminaey releases ( month=2, 5, 8, and 11 )
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_growth", clear


drop t

xpose, clear

gen t=_n
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose2", replace

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose2",clear
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
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary", replace



 
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
gen t=_n
drop if t<=74
keep t DATE 
drop t
gen t=_n

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary", unmatched(both)
 
drop _merge

keep DATE t month preliminary

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary", replace


****** generate revisions fro each vintage


use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_xpose2",clear
forvalues x = 1/270 {
gen d`x'= v`x'-v`x'[_n-1]
}
forvalues x = 1/270 {
drop v`x'
}

drop t
 
xpose, clear
gen t=_n
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", replace
forvalues x = 1/589 {
replace  v`x'=0 if v`x'==.
}

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", replace

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
gen t=_n
drop if t==1
drop t 
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", unmatched(both)
drop _merge
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", replace

******* generate the final value

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_growth",  unmatched(both)
drop _merge
drop if t==1
drop t

keep DATE g589 g571
rename g589 routput14M11
rename g571 routput13M05
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_final", replace

**** merge the final value with first releases of the data 

joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary",  unmatched(both)
drop if _merge==1
drop _merge
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_update", replace

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
xpose, clear varname 
gen t=_n
drop if t==1
keep _varname
gen t=_n
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision_code", replace


***** remove the benchmark revisions 
** Benchmark revisions: routput86M1=243 routput91M12=314 routput96M1=363 routput97M5=379 routput99M11=409 routput03M12=458 routput11M8=550 routput13M8=574 routput09M8	526




use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", clear

gen benchmark1=v243+v314+v363+v379+v409+v458+v550
gen benchmark2=v243+v314+v363+v379+v409+v458+v550+v574
gen benchmark3=v243+v314+v363+v379+v409+v458+v550+v526
gen benchmark4=v243+v314+v363+v379+v409+v458+v550+v526+v574
keep DATE  benchmark1 benchmark2 benchmark3 benchmark4


joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_update",  unmatched(both)
drop if _merge==1
drop _merge
gen revision1 =routput13M05-preliminary-benchmark1
gen revision2 =routput14M11-preliminary-benchmark2
gen revision3 =routput13M05-preliminary-benchmark3
gen revision4 =routput14M11-preliminary-benchmark4
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_update1", replace




*******generate three year revision (for out-of-sample prediction  ) ****

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", clear
replace v124=0 
replace v183=0 
replace v243=0 
replace v314=0
replace v363=0
replace v379=0
replace v409=0
replace v458=0
replace v550=0
replace v574=0

keep if t>=74
drop v1 t DATE
xpose, clear

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year", replace



forvalues x = 1/196 {
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year", clear
keep v`x'
gen t=_n
keep if t>=3*`x'-2 & t<=3*`x'+33
drop t
gen t=_n
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year_`x'", replace
}


forvalues x = 2/196 {
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year_1", clear

joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year_`x'", unmatched(both)
drop _merge

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year_1", replace
}

drop t
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year_1", replace
xpose, clear

gen revision_three_year=0
forvalues x = 1/36 {
replace revision_three_year=revision_three_year+v`x'
}
gen t=_n
drop if revision_three_year==.
keep t revision_three_year
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/three_year_revision", replace

joinby(t ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_update1",  unmatched(both)

drop if _merge==2
drop _merge

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_update1", replace


**************** regressions for the results in Table 3


use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/factor6_update.dta", clear

rename date DATE
keep DATE q  Q1 Q2 Q3 monthtreasuryrate yeartreasuryrate consumersentiment unemployment snp uncertainty high low  recession exp  l_consumersentiment  r_snp r_month r_year r_consumer r_unemployment e_snp e_month e_year e_consumer e_unemployment  h_snp h_month h_year h_unemployment h_consumer  l_snp l_month l_year l_consumer l_unemployment  

joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput_update1",  unmatched(both)
drop if _merge~=3
drop _merge
drop t
gen t=_n
gen r_preliminary=recession*preliminary

gen e_preliminary=exp* preliminary


reg revision4 t Q1 Q2 Q3
predict y, xb
gen resi=revision4-y
drop y
rename resi y


drop high low  h_snp h_month h_year h_unemployment l_snp l_month l_year h_consumer l_consumer l_unemployment 



gen high=0
replace high=1 if uncertainty>uncertainty[_n-4] 

gen low=0
replace low=1 if high==0

gen h_preliminary=high*preliminary

gen l_preliminary=low* preliminary

gen  h_unemployment=high*unemployment

gen h_snp=high* snp

gen h_month=high* monthtreasuryrate 

gen h_year=high*yeartreasuryrate

gen h_consumer=high*l_consumersentiment

gen  l_unemployment=low*unemployment

gen  l_snp =low*snp

gen l_month =low*monthtreasuryrate 

gen l_year =low*yeartreasuryrate

gen  l_consumer=low*l_consumersentiment

label  variable preliminary  "First release"
label  variable unemployment "Unemployment "
label  variable snp "S\&P500 "
label  variable  monthtreasuryrate "3 month Treasury"
label  variable  yeartreasuryrate "10 year Treasury"
label  variable l_consumersentiment "Consumer sentiment "
label  variable high "$\alpha_1$"
label  variable low "$\alpha_2$"
label  variable h_preliminary "First release  $(S_t=1)$"
label  variable l_preliminary "First release  $(S_t=0)$"
label  variable h_unemployment "Unemployment  $(S_t=1)$"
label  variable h_snp "S\&P500  $(S_t=1)$"
label  variable h_month  "3 month Treasury  $(S_t=1)$"
label  variable h_year "10 year Treasury $(S_t=1)$"
label  variable  h_consumer "Consumer sentiment  $(S_t=1)$"
label  variable l_unemployment "Unemployment  $(S_t=0)$"
label  variable l_snp "S\&P500  $(S_t=0)$"
label  variable l_month "3 month Treasury  $(S_t=0)$"
label  variable l_year "10 year Treasury $(S_t=0)$"
label  variable l_consumer   "Consumer sentiment  $(S_t=0)$"
label  variable uncertainty "Uncertainty"
label  variable exp "$\alpha_1$"
label  variable rec "$\alpha_2$"
label  variable e_preliminary "First release  $(S_t=1)$"
label  variable r_preliminary "First release  $(S_t=0)$"
label  variable e_unemployment "Unemployment  $(S_t=1)$"
label  variable e_snp "S\&P500  $(S_t=1)$"
label  variable e_month  "3 month Treasury  $(S_t=1)$"
label  variable e_year "10 year Treasury $(S_t=1)$"
label  variable  e_consumer "Consumer sentiment  $(S_t=1)$"
label  variable r_unemployment "Unemployment  $(S_t=0)$"
label  variable r_snp "S\&P500  $(S_t=0)$"
label  variable r_month "3 month Treasury  $(S_t=0)$"
label  variable r_year "10 year Treasury $(S_t=0)$"
label  variable r_consumer   "Consumer sentiment  $(S_t=0)$"



save "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", replace
use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
tsset t
newey y preliminary unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment,lag(4) 
test preliminary=unemployment =snp = monthtreasuryrate= yeartreasuryrate =l_consumersentiment=0
reg y exp recession e_preliminary r_preliminary e_unemployment e_snp e_month e_year  e_consumer  r_unemployment r_snp r_month r_year r_consumer    , noconstant
test e_preliminary=e_snp=e_month=e_year=e_consumer=e_unemployment==exp=0
test r_preliminary=r_snp=r_month=r_year=r_consumer=r_unemployment=recession=0
reg y high low h_preliminary l_preliminary h_unemployment h_snp h_month h_year  h_consumer l_unemployment l_snp l_month l_year l_consumer  , noconstant
test h_preliminary=h_snp=h_month=h_year=h_consumer=h_unemployment=high=0
test l_preliminary=l_snp=l_month=l_year=l_consumer=l_unemployment=low=0


eststo: newey y preliminary unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment,lag(4)  
eststo:reg y exp recession e_preliminary r_preliminary e_unemployment e_snp e_month e_year  e_consumer  r_unemployment r_snp r_month r_year r_consumer  , noconstant
esttab  using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table3_1.tex", label b(a3) star(+ 0.10 * 0.05 ** 0.01) ar2 p replace

eststo clear
eststo: newey y preliminary unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment,lag(4)
eststo: reg y high low h_preliminary l_preliminary h_unemployment h_snp h_month h_year  h_consumer l_unemployment l_snp l_month l_year l_consumer  , noconstant
esttab  using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table3_2.tex",  label b(a3) star(+ 0.10 * 0.05 ** 0.01) ar2 p replace
eststo clear



save "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", replace







use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
gen abs=revision_three_year if revision_three_year>=0
replace abs=revision_three_year*-1 if revision_three_year<0
gen labs=ln(abs)
reg labs t Q1 Q2 Q3
predict y2, xb
gen resi=labs-y2
drop y2
rename resi y2
 
reg  y2 unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment  
reg  y2 uncertainty
reg  y2 unemployment snp monthtreasuryrate yeartreasuryrate l_consumersentiment  uncertainty

save "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", replace


eststo: reg  y2 unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment  
eststo: reg  y2 uncertainty
eststo: reg  y2 unemployment snp monthtreasuryrate yeartreasuryrate l_consumersentiment  uncertainty
esttab  using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table4.tex", label b(a3) p ar2 replace
eststo clear
**Adj. $R^2$  & 0.025 &    0.029     &     0.062 \\

***** out of sample prediction


use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40)recursive: reg labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp t Q1 Q2 Q3
        gen t=_n
        save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.1", replace


use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
keep if t>=53
rename t time 
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.1", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)

gen error1= (labs-yhat)^2

keep DATE error1 time
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.1", replace
****
use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40)recursive: reg labs  uncertainty t Q1 Q2 Q3
        gen t=_n
        save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.2", replace


use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
keep if t>=53
rename t time 
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.2", unmatched(both)

gen yhat= _b_cons +(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)

gen error2= (labs-yhat)^2

keep DATE error2 time
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.2", replace


****
use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40)recursive: reg labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty t Q1 Q2 Q3
        gen t=_n
        save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.3", replace


use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
keep if t>=53
rename t time 
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.3", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)

gen error3= (labs-yhat)^2

keep DATE error3 time
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.3", replace


****

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.1", clear
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.2", unmatched(both)
drop _merge
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.3", unmatched(both)
sum error1 error2 error3
drop _merge
gen meth=1
egen mse1= mean(error1)
egen mse2= mean(error2)
egen mse3= mean(error3)
gen rmse1= mse1^0.5
gen rmse2= mse2^0.5
gen rmse3= mse3^0.5
label  variable  rmse1  "B.C. Indicators"
label  variable  rmse2  "Uncertainty"
label  variable  rmse3  "B.C. indicator & Uncertainty"

keep rmse1 rmse2 rmse3 meth
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7_recursive", replace
********************** rolling

use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40): reg  labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp t Q1 Q2 Q3
       rename start t
       save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.4", replace



use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
keep if t>=53
rename t time
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.4", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)
gen error1= (labs-yhat)^2
keep DATE error1 time 
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.4", replace


*****************************
use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40):reg  labs uncertainty t Q1 Q2 Q3
       rename start t
       save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.5", replace



use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
keep if t>=53
rename t time
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.5", unmatched(both)

gen yhat= _b_cons +(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)
gen error2= (labs-yhat)^2
keep DATE error2 time 
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.5", replace
**************************
use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40): reg  labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty t Q1 Q2 Q3
       rename start t
       save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.6", replace



use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear
keep if t>=53
rename t time
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.6", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)
gen error3= (labs-yhat)^2
keep DATE error3 time 
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.6", replace
***************
use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.4", clear
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.5", unmatched(both)
drop _merge
joinby(t) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.6", unmatched(both)
drop _merge
gen meth=2
egen mse1= mean(error1)
egen mse2= mean(error2)
egen mse3= mean(error3)
gen rmse1= mse1^0.5
gen rmse2= mse2^0.5
gen rmse3= mse3^0.5
label  variable  rmse1  "B.C. Indicators"
label  variable  rmse2  "Uncertainty"
label  variable  rmse3 "B.C. indicator & Uncertainty"

keep rmse1 rmse2 rmse3 meth



save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7_rolling", replace




***** fix period

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/routput", clear
keep DATE ROUTPUT00M5 ROUTPUT00M6
gen output05=real(ROUTPUT00M5)
gen output06=real(ROUTPUT00M6)
replace output05=output06 if output05==.
drop ROUTPUT00M6 ROUTPUT00M5 output06
gen ROUTPUT00M5=100*(ln(output05)-ln(output05[_n-1]))
drop output05

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/fix_final", replace
joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/preliminary",  unmatched(both)
drop if _merge==1
drop _merge

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/fix", replace


** Benchmark revisions: routput86M1=243 routput91M12=314 routput96M1=363 routput97M5=379 routput99M11=409 routput03M12=458 routput11M8=550 routput13M8=574 routput09M8	526


use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/revision", clear

gen benchmark5=v243+v314+v363+v379+v409
keep DATE  benchmark5

save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/fix_revision", replace

joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/fix",  unmatched(both)

drop if _merge==1
drop _merge

gen revision_ROUTPUT00M5=ROUTPUT00M5-preliminary-benchmark5
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/fix", replace




use "/Users/abusung/Dropbox/Abu's Dropbox/data revision/data/Nominal GDP/read_do/routput_result.dta", clear



keep DATE Q1 Q2 Q3 monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty  routput14M11 labs

joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/fix",  unmatched(both)

drop if _merge~=3
drop _merge
drop t
gen t=_n



gen abs_ROUTPUT00M5= revision_ROUTPUT00M5 if revision_ROUTPUT00M5>=0
replace abs_ROUTPUT00M5= revision_ROUTPUT00M5*-1 if revision_ROUTPUT00M5<0
gen labs_ROUTPUT00M5=ln(abs_ROUTPUT00M5)
replace labs_ROUTPUT00M5=. if t>=50
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7_fix", replace
 

reg labs_ROUTPUT00M5 monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp t Q1 Q2 Q3 


predict yhat1, xb
keep if t>=63

gen error1= (routput14M11-yhat)^2
keep DATE error1
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.7", replace

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7_fix",clear

reg labs_ROUTPUT00M5 uncertainty t Q1 Q2 Q3 


predict yhat2, xb
keep if t>=63

gen error2= (routput14M11-yhat)^2
keep DATE error2
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.8", replace

use "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7_fix",clear

reg labs_ROUTPUT00M5 monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty  t Q1 Q2 Q3 


predict yhat3, xb
keep if t>=63

gen error3= (routput14M11-yhat)^2
keep DATE error3
save "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.9", replace

joinby(DATE) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.7",  unmatched(both)
drop _merge
joinby(DATE ) using "/Users/abusung/Dropbox/Abu's Dropbox/chapter_3/data update for chapter 1/table7.8",  unmatched(both)

gen meth=3
egen mse1= mean(error1)
egen mse2= mean(error2)
egen mse3= mean(error3)
gen rmse1= mse1^0.5
gen rmse2= mse2^0.5
gen rmse3= mse3^0.5
label  variable  rmse1  "B.C. Indicators"
label  variable  rmse2  "Uncertainty"
label  variable  rmse3  "B.C. indicator & Uncertainty"

keep rmse1 rmse2 rmse3 meth

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table7_fix", replace
append using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table7_rolling"
append using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table7_recursive"

gen  method="recursive" if meth==1
replace  method="rolling" if meth==2
replace  method="fixed-sample" if meth==3
sort meth

estpost tabstat rmse1 rmse2 rmse3, by (method)




******


*************
*sutex rmse1 rmse2 rmse3, label
*sutex rmse4 rmse5 rmse6, label

***** install
*drop high low h_preliminary l_preliminary h_snp h_month h_year h_unemployment l_snp l_month l_year h_consumer l_consumer l_unemployment
*ssc install 




