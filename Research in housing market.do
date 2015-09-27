

*****Data source:the National Association of Realtors (NAR)


forvalues x = 68/112 {
use "/Users/abusung/Dropbox/monetary2/data.dta", clear

keep if year==`x'

gen month=_n


save "/Users/abusung/Dropbox/report 6/`x'.dta", replace

}

clear
use "/Users/abusung/Dropbox/report 6/68.dta", clear
 
forvalues x = 69/112  {
 
append using "/Users/abusung/Dropbox/report 6/`x'.dta"
}

save "/Users/abusung/Dropbox/monetary2/data1.dta", replace
keep if month<=3
gen q=1
save "/Users/abusung/Dropbox/report 6/1.dta", replace

use "/Users/abusung/Dropbox/monetary2/data1.dta", clear

keep if month<=6 & month>=4

gen q=2
save "/Users/abusung/Dropbox/report 6/2.dta", replace

use "/Users/abusung/Dropbox/monetary2/data1.dta", clear

keep if month<=9 & month>=7

gen q=3
save "/Users/abusung/Dropbox/report 6/3.dta", replace

use "/Users/abusung/Dropbox/monetary2/data1.dta", clear

keep if month<=12 & month>=10

gen q=4
save "/Users/abusung/Dropbox/report 6/4.dta", replace



clear
use "/Users/abusung/Dropbox/report 6/1.dta", clear
 
forvalues x = 2/4  {
 
append using "/Users/abusung/Dropbox/report 6/`x'.dta"
}
save "/Users/abusung/Dropbox/monetary2/data1.dta", replace

forvalues x = 68/112 {
use "/Users/abusung/Dropbox/monetary2/data1.dta", clear

keep if year==`x'


collapse(mean) avg_price employment existing_home_sales number_homeowner_rate hpi medianprice real_per_income re_cost d_cost population number_of_households mortgage_rate supply_of_h_market cpi NHO N aPR mPR aKHH mKHH aQd mQd UC RPRC YR pop employment_01 EMP year d interpr intern PR group1 group2 group3 N0 N1 aPR0 aPR1 laPR laQd month , by( q)
save "/Users/abusung/Dropbox/report 6/`x'.dta", replace

}

clear
use "/Users/abusung/Dropbox/report 6/68.dta", clear
 
forvalues x = 69/112  {
 
append using "/Users/abusung/Dropbox/report 6/`x'.dta"
}






reg3 (N EMP UC aPR)(aKHH aPR UC YR)(aPR RPRC aQd N)(NHO UC YR pop)if year<92 &year>85
reg3 (N EMP UC PR interPR1985)(KHH PR UC YR)(PR RPRC Qd N interN1985)(NHO UC YR pop) 
L.PR L.N YR pop RPRC UC NHO KHH
gen UC_01= UC[_n-1]
gen dUC=ln(UC)-ln(UC_01)
reg3 (N EMP UC PR PRinfla season1 season2 season3 dummy2008)(KHH PR UC YR season1 season2 season3 dummy2008)(PR RPRC Qd N Ninfla season1 season2 season3 dummy2008)(NHO UC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP UC PR interPR1982 PRinfla season1 season2 season3 dummy2008)(KHH PR UC YR PRinfla season1 season2 season3 dummy2008)(PR RPRC Qd N interN1982 PRinfla season1 season2 season3 dummy2008)(NHO UC YR pop PRinfla season1 season2 season3 dummy2008) 
reg3 (N EMP UC PR interPR1982  season1 season2 season3 dummy2008)(KHH PR UC YR season1 season2 season3 dummy2008)(PR RPRC Qd N interN1982 season1 season2 season3 dummy2008)(NHO UC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP UC PR interPR2005  season1 season2 season3 dummy2008)(KHH PR UC YR season1 season2 season3 dummy2008)(PR RPRC Qd N interN2005 season1 season2 season3 dummy2008)(NHO UC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP UC PR interPR2008  season1 season2 season3 dummy2008)(KHH PR UC YR season1 season2 season3 dummy2008)(PR RPRC Qd N interN2008 season1 season2 season3 dummy2008)(NHO UC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP UC PR interPR2008  season1 season2 season3 )(KHH PR UC YR season1 season2 season3 )(PR RPRC Qd N interN2008 season1 season2 season3 )(NHO UC YR pop season1 season2 season3 ) 
reg3 (N EMP UC PR interPR1987  season1 season2 season3 dummy2008)(KHH PR UC YR season1 season2 season3 dummy2008)(PR RPRC Qd N interN1987 season1 season2 season3 dummy2008)(NHO UC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP UC PR interPR2003  season1 season2 season3 dummy2008)(KHH PR UC YR season1 season2 season3 dummy2008)(PR RPRC Qd N interN2003 season1 season2 season3 dummy2008)(NHO UC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP dUC PR PRfirstbuy  season1 season2 season3 dummy2008)(KHH PR lnUC YR season1 season2 season3 dummy2008)(PR RPRC Qd N Nfirstbuy season1 season2 season3 dummy2008)(NHO lnUC YR pop season1 season2 season3 dummy2008) 
reg3 (N EMP dUC pr i1 season1 season2 season3 dummy2008)(lnkhh pr lnUC YR season1 season2 season3 dummy2008)(pr RPRC Qd N in1 season1 season2 season3 dummy2008)(NHO lnUC YR pop season1 season2 season3 dummy2008), endog (i1 in1 Qd)
reg3 (N EMP dUC PR PRfirstbuy  season1 season2 season3 dummy2008)(lnKHH PR lnUC YR season1 season2 season3 dummy2008)(PR RPRC lnQd N Nfirstbuy season1 season2 season3 dummy2008)(lnNHO lnUC YR pop season1 season2 season3 dummy2008) , endog (Nfirstbuy PRfirstbuy lnQd)
reg3 (N EMP dUC PR PRfirstbuy  season1 season2 season3 dummy2008)(KHH PR lnUC YR season1 season2 season3 dummy2008)(PR RPRC Qd N Nfirstbuy season1 season2 season3 dummy2008)(NHO lnUC YR pop season1 season2 season3 dummy2008), endog (Nfirstbuy PRfirstbuy lnQd)
reg3 (N EMP dUC PR PRfirstbuy  season1 season2 season3 dummy2008)(lnKHH PR lnUC YR firstbuy season1 season2 season3 dummy2008)(PR RPRC lnQd N Nfirstbuy season1 season2 season3 dummy2008)(lnNHO lnUC YR pop season1 season2 season3 dummy2008) , endog (Nfirstbuy PRfirstbuy lnQd)
reg3 (N EMP dUC PR PRinfla inflation  season1 season2 season3 dummy2008)(lnKHH PR lnUC YR firstbuy season1 season2 season3 dummy2008)(PR RPRC lnQd N Ninfla inflation season1 season2 season3 dummy2008)(lnNHO lnUC YR pop season1 season2 season3 dummy2008) , endog (Ninfla PRinfla lnQd)
