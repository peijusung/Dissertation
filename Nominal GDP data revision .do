
clear

import excel "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd1.xls", sheet("noutput1") firstrow allstring
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd1", replace
clear

import excel "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd2.xls", sheet("noutput2") firstrow allstring
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd2", replace
clear

import excel "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd3.xls", sheet("noutput3") firstrow allstring
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd3", replace
clear

import excel "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd4.xls", sheet("noutput4") firstrow allstring
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd4", replace
clear

import excel "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd5.xls", sheet("noutput5") firstrow allstring
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd5", replace
clear

import excel "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd6.xls", sheet("noutput6") firstrow allstring
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd6", replace
clear

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd1", clear

joinby(DATE) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd2", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd3", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd4", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd5", unmatched(both)
drop _merge
joinby(DATE) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutputMvQd6", unmatched(both)
drop _merge

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", replace

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", clear
sxpose, clear firstnames 

forvalues x = 1/271  {
gen v`x'= real( _var`x')
drop _var`x'
}
gen t=_n
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_xpose", replace

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_xpose",clear

xpose, clear

gen t=_n
drop t==272


forvalues x = 1/589 {
gen g`x'= 100*(ln(v`x')-ln(v`x'[_n-1]))
drop v`x'
}
replace g364 = g365 if g364==.
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_growth", replace

drop if t==1
drop t

xpose, clear

gen t=_n
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_xpose2", replace


use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_xpose2",clear
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/time", unmatched(both)
drop _merge
keep if month==2|month==5|month==8|month==11
drop t 
gen t=_n
forvalues x = 1/73 {
drop v`x'
}


forvalues x = 74/270 {
replace v`x'=0 if t~=`x'-73
}


gen preliminary=0

forvalues x = 74/270 {
replace preliminary=preliminary+v`x'
}
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/preliminary", replace



use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", clear
gen t=_n
drop if t<=74
keep t DATE 
drop t
gen t=_n

joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/preliminary", unmatched(both)
 
drop _merge

keep DATE t month preliminary

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/preliminary", replace


use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_xpose2",clear
forvalues x = 1/270 {
gen d`x'= v`x'-v`x'[_n-1]
}
forvalues x = 1/270 {
drop v`x'
}

drop t
 
xpose, clear
gen t=_n
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", replace
forvalues x = 1/589 {
replace  v`x'=0 if v`x'==.
}

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", replace

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", clear
gen t=_n
drop if t==1
drop t 
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", unmatched(both)
drop _merge
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", replace



use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", clear
gen t=_n
keep t DATE
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_growth",  unmatched(both)
drop _merge
drop if t==1
drop t

keep DATE g589 g571
rename g589 NOUTPUT14M11
rename g571 NOUTPUT13M05
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_final", replace

joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/preliminary",  unmatched(both)
drop if _merge==1
drop _merge

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_update", replace

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", clear
xpose, clear varname 
gen t=_n
drop if t==1
keep _varname
gen t=_n
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision_code", replace

** NOUTPUT86M1=243 NOUTPUT91M12=314 NOUTPUT96M1=363 NOUTPUT97M5=379 NOUTPUT99M11=409 NOUTPUT03M12=458 NOUTPUT11M8=550 NOUTPUT13M8=574 NOUTPUT09M8	526




use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", clear

gen benchmark1=v243+v314+v363+v379+v409+v458+v550
gen benchmark2=v243+v314+v363+v379+v409+v458+v550+v574
gen benchmark3=v243+v314+v363+v379+v409+v458+v550+v526
gen benchmark4=v243+v314+v363+v379+v409+v458+v550+v526+v574
keep DATE  benchmark1 benchmark2 benchmark3 benchmark4


joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_update",  unmatched(both)
drop if _merge==1
drop _merge
gen revision1 =NOUTPUT13M05-preliminary-benchmark1
gen revision2 =NOUTPUT14M11-preliminary-benchmark2
gen revision3 =NOUTPUT13M05-preliminary-benchmark3
gen revision4 =NOUTPUT14M11-preliminary-benchmark4
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_update1", replace




*******generate three year revision****

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", clear
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

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year", replace



forvalues x = 1/196 {
use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year", clear
keep v`x'
gen t=_n
keep if t>=3*`x'-2 & t<=3*`x'+33
drop t
gen t=_n
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year_`x'", replace
}


forvalues x = 2/196 {
use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year_1", clear

joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year_`x'", unmatched(both)
drop _merge

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year_1", replace
}

drop t
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year_1", replace
xpose, clear

gen revision_three_year=0
forvalues x = 1/36 {
replace revision_three_year=revision_three_year+v`x'
}
gen t=_n
drop if revision_three_year==.
keep t revision_three_year
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/three_year_revision", replace

joinby(t ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_update1",  unmatched(both)

drop if _merge==2
drop _merge

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_update1", replace

**************** regressions for the results in Table 2 





use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/factor6_update.dta", clear
rename date DATE
keep DATE q nonbenchmark4_100 revision_noutput00m6 revision Q1 Q2 Q3 monthtreasuryrate yeartreasuryrate consumersentiment unemployment snp uncertainty high low  recession exp r_preliminary e_preliminary l_consumersentiment  r_snp r_month r_year r_consumer r_unemployment e_snp e_month e_year e_consumer e_unemployment  h_snp h_month h_year h_unemployment h_preliminary h_consumer  l_snp l_month l_year l_consumer l_unemployment l_preliminary  revision_update d_revision_update d_revision1 y_revision d_revision  abs_revision l_abs_revision


joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput_update1",  unmatched(both)
drop if _merge~=3
drop _merge
drop t
gen t=_n

reg revision2 t Q1 Q2 Q3
predict y, xb
gen resi=revision2-y
drop y
rename resi y


drop high low h_preliminary l_preliminary h_snp h_month h_year h_unemployment l_snp l_month l_year h_consumer l_consumer l_unemployment 


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


reg y r_preliminary r_snp r_month r_year r_consumer r_unemployment e_preliminary e_unemployment e_consumer e_year e_month e_snp exp recession , noconstant
test e_preliminary=e_snp=e_month=e_year=e_consumer=e_unemployment==exp=0
test r_preliminary=r_snp=r_month=r_year=r_consumer=r_unemployment=recession=0
reg y high low h_preliminary l_preliminary h_unemployment h_consumer h_year h_month h_snp  l_unemployment l_consumer l_year l_month l_snp, noconstant
test h_preliminary=h_snp=h_month=h_year=h_consumer=h_unemployment=high=0
test l_preliminary=l_snp=l_month=l_year=l_consumer=l_unemployment=low=0





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







save "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", replace
use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
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
esttab  using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table2_1.csv",label b(a3)  nostar  ar2 p replace
eststo clear

eststo:reg y exp recession e_preliminary r_preliminary e_unemployment e_snp e_month e_year  e_consumer  r_unemployment r_snp r_month r_year r_consumer  , noconstant
esttab  using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table2_2.csv",  label b(a3)  nostar  ar2 p replace
eststo clear

eststo:  reg y high low h_preliminary l_preliminary h_unemployment h_snp h_month h_year  h_consumer l_unemployment l_snp l_month l_year l_consumer  , noconstant
esttab  using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table2_3.csv",label b(a3)  nostar  ar2 p replace
eststo clear


**Adj. $R^2$  & 0.023 &    0.019       &      0.031 \\
use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
gen abs=revision_three_year if revision_three_year>=0
replace abs=revision_three_year*-1 if revision_three_year<0
gen labs=ln(abs)
reg labs t Q1 Q2 Q3
predict y2, xb
gen resi=labs-y2
drop y2
rename resi y2
save "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", replace
reg  y2 unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment  
reg  y2 uncertainty
reg  y2 unemployment snp monthtreasuryrate yeartreasuryrate l_consumersentiment  uncertainty


use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
eststo: reg  y2 unemployment snp  monthtreasuryrate yeartreasuryrate l_consumersentiment  
eststo: reg  y2 uncertainty
eststo: reg  y2 unemployment snp monthtreasuryrate yeartreasuryrate l_consumersentiment  uncertainty
esttab  using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table4.csv", label b(a3) nostar ar2 p replace
eststo clear


******************

***** out of sample prediction


use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40)recursive: reg labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp t Q1 Q2 Q3
        gen t=_n
        save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.1", replace


use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
keep if t>=53
rename t time 
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.1", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)

gen error1= (labs-yhat)^2

keep DATE error1 time
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.1", replace
****
use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40)recursive: reg labs  uncertainty t Q1 Q2 Q3
        gen t=_n
        save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.2", replace


use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
keep if t>=53
rename t time 
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.2", unmatched(both)

gen yhat= _b_cons +(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)

gen error2= (labs-yhat)^2

keep DATE error2 time
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.2", replace


****
use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40)recursive: reg labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty t Q1 Q2 Q3
        gen t=_n
        save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.3", replace


use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
keep if t>=53
rename t time 
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.3", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)

gen error3= (labs-yhat)^2

keep DATE error3 time
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.3", replace


****

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.1", clear
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.2", unmatched(both)
drop _merge
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.3", unmatched(both)
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
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_recursive", replace
********************** rolling

use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40): reg  labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp t Q1 Q2 Q3
       rename start t
       save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.4", replace



use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
keep if t>=53
rename t time
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.4", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)
gen error1= (labs-yhat)^2
keep DATE error1 time 
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.4", replace


*****************************
use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40):reg  labs uncertainty t Q1 Q2 Q3
       rename start t
       save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.5", replace



use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
keep if t>=53
rename t time
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.5", unmatched(both)

gen yhat= _b_cons +(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)
gen error2= (labs-yhat)^2
keep DATE error2 time 
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.5", replace
**************************
use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
        tsset t
        rolling _b rmse=e(rmse), window(40): reg  labs monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty t Q1 Q2 Q3
       rename start t
       save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.6", replace



use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear
keep if t>=53
rename t time
gen t=_n
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.6", unmatched(both)

gen yhat= _b_cons +(monthtreasuryrate * _b_monthtreasuryrate)+ (yeartreasuryrate * _b_yeartreasuryrate)+(l_consumersentiment * _b_l_consumersentiment)+(unemployment * _b_unemployment)+ (snp * _b_snp)+(uncertainty*_b_uncertainty)+(time *_b_t)+(Q1* _b_Q1)+(Q2* _b_Q2)+(Q3* _b_Q3)
gen error3= (labs-yhat)^2
keep DATE error3 time 
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.6", replace
***************
use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.4", clear
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.5", unmatched(both)
drop _merge
joinby(t) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.6", unmatched(both)
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



save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_rolling", replace




***** fix period

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/noutput", clear
keep DATE NOUTPUT00M5 NOUTPUT00M6
gen output05=real(NOUTPUT00M5)
gen output06=real(NOUTPUT00M6)
replace output05=output06 if output05==.
drop NOUTPUT00M6 NOUTPUT00M5 output06
gen NOUTPUT00M5=100*(ln(output05)-ln(output05[_n-1]))
drop output05

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/fix_final", replace
joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/preliminary",  unmatched(both)
drop if _merge==1
drop _merge

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/fix", replace


** NOUTPUT86M1=243 NOUTPUT91M12=314 NOUTPUT96M1=363 NOUTPUT97M5=379 NOUTPUT99M11=409 NOUTPUT03M12=458 NOUTPUT11M8=550 NOUTPUT13M8=574 NOUTPUT09M8	526

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/revision", clear

gen benchmark5=v243+v314+v363+v379+v409
keep DATE  benchmark5

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/fix_revision", replace

joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/fix",  unmatched(both)

drop if _merge==1
drop _merge

gen revision_NOUTPUT00M5=NOUTPUT00M5-preliminary-benchmark5
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/fix", replace




use "/Users/abusung/Dropbox/data revision/data/Nominal GDP/read_do/noutput_result.dta", clear



keep DATE Q1 Q2 Q3 monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty  NOUTPUT14M11 

joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/fix",  unmatched(both)

drop if _merge~=3
drop _merge
drop t
gen t=_n



gen abs_NOUTPUT00M5= revision_NOUTPUT00M5 if revision_NOUTPUT00M5>=0
replace abs_NOUTPUT00M5= revision_NOUTPUT00M5*-1 if revision_NOUTPUT00M5<0
gen labs_NOUTPUT00M5=ln(abs_NOUTPUT00M5)
replace labs_NOUTPUT00M5=. if t>=50
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_fix", replace
 

reg labs_NOUTPUT00M5 monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp t Q1 Q2 Q3 


predict yhat1, xb
keep if t>=63

gen error1= (NOUTPUT14M11-yhat)^2
keep DATE error1
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.7", replace

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_fix",clear

reg labs_NOUTPUT00M5 uncertainty t Q1 Q2 Q3 


predict yhat2, xb
keep if t>=63

gen error2= (NOUTPUT14M11-yhat)^2
keep DATE error2
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.8", replace

use "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_fix",clear

reg labs_NOUTPUT00M5 monthtreasuryrate yeartreasuryrate l_consumersentiment unemployment snp uncertainty  t Q1 Q2 Q3 


predict yhat3, xb
keep if t>=63

gen error3= (NOUTPUT14M11-yhat)^2
keep DATE error3
save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.9", replace

joinby(DATE) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.7",  unmatched(both)
drop _merge
joinby(DATE ) using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6.8",  unmatched(both)

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

save "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_fix", replace
append using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_rolling"
append using "/Users/abusung/Dropbox/chapter_3/data update for chapter 1/table6_recursive"

gen  method="recursive" if meth==1
replace  method="rolling" if meth==2
replace  method="fixed-sample" if meth==3
sort meth


estpost tabstat rmse1 rmse2 rmse3, by (method)

***** moving average *********
mvsumm uncertainty, stat(mean) win(8) gen(meanEPU)
mvsumm uncertainty, stat(sd) win(8) gen(sdEPU)

