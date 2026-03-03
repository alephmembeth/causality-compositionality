/* Header */
version 14.2

set more off, permanently
set scheme sj


/* Labels */
use "causality_compositionality_pilot_data.dta", clear

label define gen_lb 1 "Female" ///
                    2 "Diverse" ///
                    3 "Male"
   label values gen gen_lb

label define edu_lb 1 "Without School Qualification" ///
                    2 "Still in School" ///
                    3 "Secondary Modern School Qualification" ///
                    4 "Polytechnic Secondary School Qualification" ///
                    5 "Secondary School Qualification" ///
                    6 "University (of Applied Sciences) Entrance Qualification" ///
                    7 "Dual Vocational Education and Training" ///
                    8 "Professional School Degree" ///
                    9 "University of Applied Sciences Degree" ///
                   10 "University Degree" ///
                   11 "Bachelor" ///
                   12 "Master" ///
                   13 "Magister" ///
                   14 "Diploma" ///
                   15 "Doctorate" ///
                   16 "Habilitation"
   label values edu edu_lb

la var id    "Identification Number"
la var study "Study"
la var rep1  "Replication 1"
la var rep2  "Replication 2"
la var eve11 "Event (1) 1"
la var eve12 "Event (1) 2"
la var eve21 "Event (2) 1"
la var eve22 "Event (2) 2"
la var def11 "Term (1) 1"
la var def12 "Term (1) 2"
la var def21 "Term (2) 1"
la var def22 "Term (2) 1"
la var cha1  "Chain 1"
la var cha2  "Chain 2"
la var cha3  "Chain 3"
la var com11 "Combination (1) 1"
la var com12 "Combination (1) 2"
la var com13 "Combination (1) 3"
la var com21 "Combination (2) 1"
la var com22 "Combination (2) 1"
la var com23 "Combination (2) 1"
la var qua1  "Control Question 1"
la var qua2  "Control Question 2"
la var age   "Age"
la var pol   "Political Orientation"
la var gen   "Gender"
la var edu   "Education"


/* Recoding */
gen defrec11 = .
   replace defrec11 = 1 if def11 == 7
   replace defrec11 = 2 if def11 == 6
   replace defrec11 = 3 if def11 == 5
   replace defrec11 = 4 if def11 == 4
   replace defrec11 = 5 if def11 == 3
   replace defrec11 = 6 if def11 == 2
   replace defrec11 = 7 if def11 == 1

   la var defrec11 "Term 1, Statement 1 (Recoded)"
   drop def11

gen defrec12 = .
   replace defrec12 = 1 if def12 == 7
   replace defrec12 = 2 if def12 == 6
   replace defrec12 = 3 if def12 == 5
   replace defrec12 = 4 if def12 == 4
   replace defrec12 = 5 if def12 == 3
   replace defrec12 = 6 if def12 == 2
   replace defrec12 = 7 if def12 == 1

   la var defrec12 "Term 1, Statement 2 (Recoded)"
   drop def12

gen comrec11 = .
   replace comrec11 = 1 if com11 == 7
   replace comrec11 = 2 if com11 == 6
   replace comrec11 = 3 if com11 == 5
   replace comrec11 = 4 if com11 == 4
   replace comrec11 = 5 if com11 == 3
   replace comrec11 = 6 if com11 == 2
   replace comrec11 = 7 if com11 == 1

   la var comrec11 "Combination 1, Statement 1 (Recoded)"
   drop com11

gen comrec12 = .
   replace comrec12 = 1 if com12 == 7
   replace comrec12 = 2 if com12 == 6
   replace comrec12 = 3 if com12 == 5
   replace comrec12 = 4 if com12 == 4
   replace comrec12 = 5 if com12 == 3
   replace comrec12 = 6 if com12 == 2
   replace comrec12 = 7 if com12 == 1

   la var comrec12 "Combination 1, Statement 2 (Recoded)"
   drop com12

gen comrec13 = .
   replace comrec13 = 1 if com13 == 7
   replace comrec13 = 2 if com13 == 6
   replace comrec13 = 3 if com13 == 5
   replace comrec13 = 4 if com13 == 4
   replace comrec13 = 5 if com13 == 3
   replace comrec13 = 6 if com13 == 2
   replace comrec13 = 7 if com13 == 1

   la var comrec13 "Combination 1, Statement 3 (Recoded)"
   drop com13


/* Summaries */
preserve
   keep if rep1 != .

   tab gen
   sum age, detail

   ci means rep1
   ci means rep2
restore

preserve
   keep if eve11 != .

   tab gen
   sum age, detail

   ci means eve11
   ci means eve12
restore

preserve
   keep if eve21 != .

   tab gen
   sum age, detail

   ci means eve21
   ci means eve22
restore

preserve
   keep if defrec11 != .

   tab gen
   sum age, detail

   ci means defrec11
   ci means defrec12
restore

preserve
   keep if def21 != .

   tab gen
   sum age, detail

   ci means def21
   ci means def22
restore

preserve
   keep if cha1 != .

   tab gen
   sum age, detail

   ci means cha1
   ci means cha2
   ci means cha3
restore

preserve
   keep if comrec11 != .

   tab gen
   sum age, detail

   ci means comrec11
   ci means comrec12
   ci means comrec13
restore

preserve
   keep if com21 != .

   tab gen
   sum age, detail

   ci means com21
   ci means com22
   ci means com23
restore


/* Graphs */
preserve
   reshape long rep, i(id) j(statement)

   collapse (mean) meantemp = rep (sd) sdtemp = rep (count) n = rep, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_1.pdf", as(pdf) replace
restore

preserve
   reshape long eve1, i(id) j(statement)

   collapse (mean) meantemp = eve1 (sd) sdtemp = eve1 (count) n = eve1, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_2.pdf", as(pdf) replace
restore

preserve
   reshape long eve2, i(id) j(statement)

   collapse (mean) meantemp = eve2 (sd) sdtemp = eve2 (count) n = eve2, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_3.pdf", as(pdf) replace
restore

preserve
   reshape long defrec1, i(id) j(statement)

   collapse (mean) meantemp = defrec1 (sd) sdtemp = defrec1 (count) n = defrec1, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_4.pdf", as(pdf) replace
restore

preserve
   reshape long def2, i(id) j(statement)

   collapse (mean) meantemp = def2 (sd) sdtemp = def2 (count) n = def2, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_5.pdf", as(pdf) replace
restore

preserve
   reshape long cha, i(id) j(statement)

   collapse (mean) meantemp = cha (sd) sdtemp = cha (count) n = cha, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "Nele") label(4 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_6.pdf", as(pdf) replace
restore

preserve
   reshape long comrec1, i(id) j(statement)

   collapse (mean) meantemp = comrec1 (sd) sdtemp = comrec1 (count) n = comrec1, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "Nele") label(4 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_7.pdf", as(pdf) replace
restore

preserve
   reshape long com2, i(id) j(statement)

   collapse (mean) meantemp = com2 (sd) sdtemp = com2 (count) n = com2, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)2) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "Nele") label(4 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "causality_compositionality_pilot_8.pdf", as(pdf) replace
restore


/* Tests */
preserve
   ren eve11 temp1
   ren eve21 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore

preserve
   ren eve21 temp1
   ren eve22 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore

preserve
   ren defrec11 temp1
   ren def21 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore

preserve
   ren defrec12 temp1
   ren def22 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore

preserve
   ren comrec11 temp1
   ren com21 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore

preserve
   ren comrec12 temp1
   ren com22 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore

preserve
   ren comrec13 temp1
   ren com23 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
restore


exit
