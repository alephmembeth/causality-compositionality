/* header */
version 14.2

set more off, permanently
set scheme sj


/* pilot, labels */
use "causality_compositionality_pilot.dta", clear

label define gen_lb 1 "Female" 2 "Diverse" 3 "Male"
   label values gen gen_lb

label define edu_lb 1 "Without School Qualification" 2 "Still in School" 3 "Secondary Modern School Qualification" 4 "Polytechnic Secondary School Qualification" 5 "Secondary School Qualification" 6 "University (of Applied Sciences) Entrance Qualification" 7 "Dual Vocational Education and Training" 8 "Professional School Degree" 9 "University of Applied Sciences Degree" 10 "University Degree" 11 "Bachelor" 12 "Master" 13 "Magister" 14 "Diploma" 15 "Doctorate" 16 "Habilitation"
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


/* pilot, recoding */
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


/* pilot, summaries */
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


/* pilot, graphs */
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
   graph export "pilot_study_1.pdf", as(pdf) replace
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
   graph export "pilot_study_2.pdf", as(pdf) replace
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
   graph export "pilot_study_3.pdf", as(pdf) replace
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
   graph export "pilot_study_4.pdf", as(pdf) replace
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
   graph export "pilot_study_5.pdf", as(pdf) replace
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
   graph export "pilot_study_6.pdf", as(pdf) replace
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
   graph export "pilot_study_7.pdf", as(pdf) replace
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
   graph export "pilot_study_8.pdf", as(pdf) replace
restore


/* pilot, tests */
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


/* main study, labels */
use "causality_compositionality_main.dta", clear

label define gen_lb 1 "Female" 2 "Diverse" 3 "Male"
   label values gen gen_lb

label define edu_lb 1 "Without School Qualification" 2 "Still in School" 3 "Secondary Modern School Qualification" 4 "Polytechnic Secondary School Qualification" 5 "Secondary School Qualification" 6 "University (of Applied Sciences) Entrance Qualification" 7 "Dual Vocational Education and Training" 8 "Professional School Degree" 9 "University of Applied Sciences Degree" 10 "University Degree" 11 "Bachelor" 12 "Master" 13 "Magister" 14 "Diploma" 15 "Doctorate" 16 "Habilitation"
   label values edu edu_lb

la var id           "Identification Number"
la var lastpage     "Last Page"
la var study        "Study"
la var vig1rep1     "Vignette 1, Replication 1"
la var vig1rep2     "Vignette 1, Replication 2"
la var vig1eve11    "Vignette 1, Event 1"
la var vig1eve12    "Vignette 1, Event 2"
la var vig1eve21    "Vignette 1, Event Without Name 1"
la var vig1eve22    "Vignette 1, Event Without Name 2"
la var vig1def1     "Vignette 1, Term 1"
la var vig1def2     "Vignette 1, Term 2"
la var vig1cha1     "Vignette 1, Chain 1"
la var vig1cha2     "Vignette 1, Chain 2"
la var vig1cha3     "Vignette 1, Chain 3"
la var vig1com1     "Vignette 1, Combination 1"
la var vig1com2     "Vignette 1, Combination 2"
la var vig1com3     "Vignette 1, Combination 3"
la var vig1qua1     "Vignette 1, Control Question 1"
la var vig1qua2     "Vignette 1, Control Question 2"
la var vig1qua3     "Vignette 1, Control Question 3"
la var vig2rep1     "Vignette 2, Replication 1"
la var vig2rep2     "Vignette 2, Replication 2"
la var vig2rep3     "Vignette 2, Replication 3"
la var vig2rep4     "Vignette 2, Replication 4"
la var vig2eve1     "Vignette 2, Event 1"
la var vig2eve2     "Vignette 2, Event 2"
la var vig2eve3     "Vignette 2, Event 3"
la var vig2eve4     "Vignette 2, Event 4"
la var vig2def1     "Vignette 2, Term 1"
la var vig2def2     "Vignette 2, Term 2"
la var vig2def3     "Vignette 2, Term 3"
la var vig2def4     "Vignette 2, Term 4"
la var vig2cha1     "Vignette 2, Chain 1"
la var vig2cha2     "Vignette 2, Chain 2"
la var vig2cha3     "Vignette 2, Chain 3"
la var vig2cha4     "Vignette 2, Chain 4"
la var vig2com1     "Vignette 2, Combination 1"
la var vig2com2     "Vignette 2, Combination 2"
la var vig2com3     "Vignette 2, Combination 3"
la var vig2com4     "Vignette 2, Combination 4"
la var vig2qua1     "Vignette 2, Control Question 1"
la var veg2qua2     "Vignette 2, Control Question 2"
la var vig2qua3     "Vignette 2, Control Question 3"
la var vig3rep1     "Vignette 3, Replication 1"
la var vig3rep2     "Vignette 3, Replication 2"
la var vig3eve1     "Vignette 3, Event 1"
la var vig3eve2     "Vignette 3, Event 2"
la var vig3def11    "Vignette 3, Term With Conditional 1"
la var vig3def12    "Vignette 3, Term With Conditional 2"
la var vig3def21    "Vignette 3, Term 1"
la var vig3def22    "Vignette 3, Term 2"
la var vig3cha1     "Vignette 3, Chain 1"
la var vig3cha2     "Vignette 3, Chain 2"
la var vig3cha3     "Vignette 3, Chain 3"
la var vig3com11    "Vignette 3, Combination With Conditional 1"
la var vig3com12    "Vignette 3, Combination With Conditional 2"
la var vig3com13    "Vignette 3, Combination With Conditional 3"
la var vig3com21    "Vignette 3, Combination 1"
la var vig3com22    "Vignette 3, Combination 2"
la var vig3com23    "Vignette 3, Combination 3"
la var vig3qua1     "Vignette 3, Control Question 1"
la var vig3qua2     "Vignette 3, Control Question 2"
la var vig3qua3     "Vignette 3, Control Question 3"
la var age          "Age"
la var pol          "Political Orientation"
la var gen          "Gender"
la var edu          "Education"


/* main study, quality fails */
gen quality_fail = .
   encode vig1qua1, generate(quality_1)
   encode vig1qua2, generate(quality_2)
   encode vig1qua3, generate(quality_3)
   encode vig2qua1, generate(quality_4)
   encode veg2qua2, generate(quality_5)
   encode vig2qua3, generate(quality_6)
   encode vig3qua1, generate(quality_7)
   encode vig3qua2, generate(quality_8)
   encode vig3qua3, generate(quality_9)

   replace quality_fail = 1 if quality_1 == 2
   replace quality_fail = 1 if quality_2 == 2
   replace quality_fail = 1 if quality_3 == 1
   replace quality_fail = 1 if quality_4 == 2
   replace quality_fail = 1 if quality_5 == 2
   replace quality_fail = 1 if quality_6 == 1
   replace quality_fail = 1 if quality_7 == 2
   replace quality_fail = 1 if quality_8 == 1
   replace quality_fail = 1 if quality_9 == 1

   drop quality_1
   drop quality_2
   drop quality_3
   drop quality_4
   drop quality_5
   drop quality_6
   drop quality_7
   drop quality_8
   drop quality_9

   la var quality_fail "Quality Fail"


/* main study, sippy cup */
drop if quality_fail == 1
keep if lastpage == 37


preserve /* vignette 1, replication */
   keep if vig1rep1 != .
   keep if vig1qua1 != ""

   tab gen
   sum age, detail
   sum vig1rep1
   ci means vig1rep1
   sum vig1rep2
   ci means vig1rep2

   signrank vig1rep1 = 4
      di r(z) / sqrt(50)

   signrank vig1rep2 = 4
      di r(z) / sqrt(50)

   hist vig1rep1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_rep_hist_1.pdf", as(pdf) replace

   hist vig1rep2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_rep_hist_2.pdf", as(pdf) replace

   reshape long vig1rep, i(id) j(statement)

   collapse (mean) meantemp = vig1rep (sd) sdtemp = vig1rep (count) n = vig1rep, by(statement)

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
   graph export "cup_rep_bar.pdf", as(pdf) replace
restore


preserve /* vignette 1, event */
   keep if vig1eve11 != .
   keep if vig1qua1  != ""

   tab gen
   sum age, detail
   sum vig1eve11
   ci means vig1eve11
   sum vig1eve12
   ci means vig1eve12

   signrank vig1eve11 = 4
      di r(z) / sqrt(67)

   signrank vig1eve12 = 4
      di r(z) / sqrt(67)

   hist vig1eve11, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ioc_1_hist_1.pdf", as(pdf) replace

   hist vig1eve12, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ioc_1_hist_2.pdf", as(pdf) replace

   reshape long vig1eve1, i(id) j(statement)

   collapse (mean) meantemp = vig1eve1 (sd) sdtemp = vig1eve1 (count) n = vig1eve1, by(statement)

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
   graph export "cup_ioc_1_bar.pdf", as(pdf) replace
restore


preserve /* vignette 1, event without name */
   keep if vig1eve21 != .
   keep if vig1qua1  != ""
   drop if age       == 606
   drop if age       == 9999

   tab gen
   sum age, detail
   sum vig1eve21
   ci means vig1eve21
   sum vig1eve22
   ci means vig1eve22

   signrank vig1eve21 = 4
      di r(z) / sqrt(89)

   signrank vig1eve22 = 4
      di r(z) / sqrt(89)

   hist vig1eve21, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ioc_2_hist_1.pdf", as(pdf) replace

   hist vig1eve22, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ioc_2_hist_2.pdf", as(pdf) replace

   reshape long vig1eve2, i(id) j(statement)

   collapse (mean) meantemp = vig1eve2 (sd) sdtemp = vig1eve2 (count) n = vig1eve2, by(statement)

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
   graph export "cup_ioc_2_bar.pdf", as(pdf) replace
restore


preserve /* vignette 1, term */
   keep if vig1def1 != .
   keep if vig1qua1 != ""

   tab gen
   sum age, detail

   sum vig1def1
      ci means vig1def1

   sum vig1def2
      ci means vig1def2

   signrank vig1def1 = 4
      di r(z) / sqrt(86)

   signrank vig1def2 = 4
      di r(z) / sqrt(86)

   hist vig1def1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_crc_hist_1.pdf", as(pdf) replace

   hist vig1def2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_crc_hist_2.pdf", as(pdf) replace

   reshape long vig1def, i(id) j(statement)

   collapse (mean) meantemp = vig1def (sd) sdtemp = vig1def (count) n = vig1def, by(statement)

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
   graph export "cup_crc_bar.pdf", as(pdf) replace
restore


preserve /* vignette 1, chain */
   keep if vig1cha1 != .
   keep if vig1qua1 != ""

   tab gen
   sum age, detail

   sum vig1cha1
      ci means vig1cha1

   sum vig1cha2
      ci means vig1cha2

   sum vig1cha3
      ci means vig1cha3

   signrank vig1cha1 = 4
      di r(z) / sqrt(61)

   signrank vig1cha2 = 4
      di r(z) / sqrt(61)

   signrank vig1cha3 = 4
      di r(z) / sqrt(61)

   hist vig1cha1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ceq_hist_1.pdf", as(pdf) replace

   hist vig1cha2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ceq_hist_2.pdf", as(pdf) replace

   hist vig1cha3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_ceq_hist_3.pdf", as(pdf) replace

   reshape long vig1cha, i(id) j(statement)

   collapse (mean) meantemp = vig1cha (sd) sdtemp = vig1cha (count) n = vig1cha, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)3) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "Nele") label(4 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "cup_ceq_bar.pdf", as(pdf) replace
restore


preserve /* vignette 1, combination */
   keep if vig1com1 != .
   keep if vig1qua1 != ""

   tab gen
   sum age, detail

   sum vig1com1
      ci means vig1com1

   sum vig1com2
      ci means vig1com2

   sum vig1com3
      ci means vig1com3

   signrank vig1com1 = 4
      di r(z) / sqrt(59)

   signrank vig1com2 = 4
      di r(z) / sqrt(59)

   signrank vig1com3 = 4
      di r(z) / sqrt(59)

   hist vig1com1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_com_hist_1.pdf", as(pdf) replace

   hist vig1com2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_com_hist_2.pdf", as(pdf) replace

   hist vig1com3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cup_com_hist_3.pdf", as(pdf) replace

   reshape long vig1com, i(id) j(statement)

   collapse (mean) meantemp = vig1com (sd) sdtemp = vig1com (count) n = vig1com, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)3) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Gabi") label(2 "Kathrin") label(3 "Nele") label(4 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "cup_com_bar.pdf", as(pdf) replace
restore


preserve /* vignette 1, ranksum tests */
   ren vig1rep1 temp1
   ren vig1eve11 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep2 temp1
   ren vig1eve12 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep1 temp1
   ren vig1eve21 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep2 temp1
   ren vig1eve22 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep1 temp1
   ren vig1def1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep2 temp1
   ren vig1def2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep1 temp1
   ren vig1cha1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep2 temp1
   ren vig1cha2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep1 temp1
   ren vig1com1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig1rep2 temp1
   ren vig1com2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore


/* main study, revolver */
preserve /* vignette 2, replication */
   keep if vig2rep1 != .
   keep if vig2qua1 != ""

   input   ls1   ls2   ls3   ls4
           1     1     3     7
           5     6     2     4
           5     7     4     7
           6     1     1     5
           6     2     2     2
           6     2     2     6
           6     3     3     7
           6     4     4     6
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     1
           7     1     1     4
           7     1     1     4
           7     1     1     7
           7     1     1     7
           7     1     1     7
           7     1     1     7
           7     1     1     7
           7     1     1     7
           7     1     1     7
           7     1     1     7
           7     2     2     4
           7     2     2     6
           7     2     2     7
           7     2     2     7
           7     4     4     4
           7     4     4     4
           7     4     4     4
           7     4     4     7
           7     4     4     7
           7     5     2     7
           7     6     6     6
           7     7     4     7
           7     7     7     7
           7     7     7     7
           7     7     7     7
           7     7     7     7
   end

   sum ls1 ls2 ls3 ls4

   signrank ls1 = 4
      di r(z) / sqrt(63)

   signrank ls2 = 4
      di r(z) / sqrt(63)

   signrank ls3 = 4
      di r(z) / sqrt(63)

   signrank ls4 = 4
      di r(z) / sqrt(63)

   tab gen
   sum age, detail

   sum vig2rep1
      ci means vig2rep1

   sum vig2rep2
      ci means vig2rep2

   sum vig2rep3
      ci means vig2rep3

   sum vig2rep4
      ci means vig2rep4

   signrank vig2rep1 = 4
      di r(z) / sqrt(63)

   signrank vig2rep2 = 4
      di r(z) / sqrt(63)

   signrank vig2rep3 = 4
      di r(z) / sqrt(63)

   signrank vig2rep4 = 4
      di r(z) / sqrt(63)

   hist vig2rep1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_rep_hist_1.pdf", as(pdf) replace

   hist vig2rep2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_rep_hist_2.pdf", as(pdf) replace

   hist vig2rep3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
	  ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_rep_hist_3.pdf", as(pdf) replace

   hist vig2rep4, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_rep_hist_4.pdf", as(pdf) replace

   reshape long vig2rep, i(id) j(statement)

   collapse (mean) meantemp = vig2rep (sd) sdtemp = vig2rep (count) n = vig2rep, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs6) barw(0.4)) ///
                (bar meantemp statement if statement == 4, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)4) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Leeve") label(2 "Hammer") label(3 "Gunpowder") label(4 "Bullet") label(5 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "rev_rep_bar.pdf", as(pdf) replace
restore


preserve /* vignette 2, event */
   keep if vig2eve1 != .
   keep if vig2qua1 != ""

   tab gen
   sum age, detail

   sum vig2eve1
      ci means vig2eve1

   sum vig2eve2
      ci means vig2eve2

   sum vig2eve3
      ci means vig2eve3

   sum vig2eve4
   ci means vig2eve4

   signrank vig2eve1 = 4
      di r(z) / sqrt(54)

   signrank vig2eve2 = 4
      di r(z) / sqrt(54)

   signrank vig2eve3 = 4
      di r(z) / sqrt(54)

   signrank vig2eve4 = 4
      di r(z) / sqrt(54)

   hist vig2eve1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ioc_hist_1.pdf", as(pdf) replace

   hist vig2eve2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ioc_hist_2.pdf", as(pdf) replace

   hist vig2eve3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ioc_hist_3.pdf", as(pdf) replace

   hist vig2eve4, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ioc_hist_4.pdf", as(pdf) replace

   reshape long vig2eve, i(id) j(statement)

   collapse (mean) meantemp = vig2eve (sd) sdtemp = vig2eve (count) n = vig2eve, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs6) barw(0.4)) ///
                (bar meantemp statement if statement == 4, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)4) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Leeve") label(2 "Hammer") label(3 "Gunpowder") label(4 "Bullet") label(5 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "rev_ioc_bar.pdf", as(pdf) replace
restore


preserve /* vignette 2, term */
   keep if vig2def1 != .
   keep if vig2qua1 != ""

   tab gen
   sum age, detail

   sum vig2def1
      ci means vig2def1

   sum vig2def2
      ci means vig2def2

   sum vig2def3
      ci means vig2def3

   sum vig2def4
      ci means vig2def4

   signrank vig2def1 = 4
      di r(z) / sqrt(50)

   signrank vig2def2 = 4
      di r(z) / sqrt(50)

   signrank vig2def3 = 4
      di r(z) / sqrt(50)

   signrank vig2def4 = 4
      di r(z) / sqrt(50)

   hist vig2def1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_crc_hist_1.pdf", as(pdf) replace

   hist vig2def2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_crc_hist_2.pdf", as(pdf) replace

   hist vig2def3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_crc_hist_3.pdf", as(pdf) replace

   hist vig2def4, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_crc_hist_4.pdf", as(pdf) replace

   reshape long vig2def, i(id) j(statement)

   collapse (mean) meantemp = vig2def (sd) sdtemp = vig2def (count) n = vig2def, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs6) barw(0.4)) ///
                (bar meantemp statement if statement == 4, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)4) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Leeve") label(2 "Hammer") label(3 "Gunpowder") label(4 "Bullet") label(5 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "rev_crc_bar.pdf", as(pdf) replace
restore


preserve /* vignette 2, chain */
   keep if vig2cha1 != .
   keep if vig2qua1 != ""

   tab gen
   sum age, detail

   sum vig2cha1
      ci means vig2cha1

   sum vig2cha2
      ci means vig2cha2

   sum vig2cha3
      ci means vig2cha3

   sum vig2cha4
      ci means vig2cha4

   signrank vig2cha1 = 4
      di r(z) / sqrt(53)

   signrank vig2cha2 = 4
      di r(z) / sqrt(53)

   signrank vig2cha3 = 4
      di r(z) / sqrt(53)

   signrank vig2cha4 = 4
      di r(z) / sqrt(53)

   hist vig2cha1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ceq_hist_1.pdf", as(pdf) replace

   hist vig2cha2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ceq_hist_2.pdf", as(pdf) replace

   hist vig2cha3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
	graph export "rev_ceq_hist_3.pdf", as(pdf) replace

   hist vig2cha4, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_ceq_hist_4.pdf", as(pdf) replace

   reshape long vig2cha, i(id) j(statement)

   collapse (mean) meantemp = vig2cha (sd) sdtemp = vig2cha (count) n = vig2cha, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs6) barw(0.4)) ///
                (bar meantemp statement if statement == 4, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)4) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Leeve") label(2 "Hammer") label(3 "Gunpowder") label(4 "Bullet") label(5 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "rev_ceq_bar.pdf", as(pdf) replace
restore


preserve /* vignette 2, combination */
   keep if vig2com1 != .
   keep if vig2qua1 != ""

   tab gen
   sum age, detail

   sum vig2com1
      ci means vig2com1

   sum vig2com2
      ci means vig2com2

   sum vig2com3
      ci means vig2com3

   sum vig2com4
      ci means vig2com4

   signrank vig2com1 = 4
      di r(z) / sqrt(50)

   signrank vig2com2 = 4
      di r(z) / sqrt(50)

   signrank vig2com3 = 4
      di r(z) / sqrt(50)

   signrank vig2com4 = 4
      di r(z) / sqrt(50)

   hist vig2com1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_com_hist_1.pdf", as(pdf) replace

   hist vig2com2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_com_hist_2.pdf", as(pdf) replace

   hist vig2com3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_com_hist_3.pdf", as(pdf) replace

   hist vig2com4, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "rev_com_hist_4.pdf", as(pdf) replace

   reshape long vig2com, i(id) j(statement)

   collapse (mean) meantemp = vig2com (sd) sdtemp = vig2com (count) n = vig2com, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs6) barw(0.4)) ///
                (bar meantemp statement if statement == 4, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)4) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Leeve") label(2 "Hammer") label(3 "Gunpowder") label(4 "Bullet") label(5 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "rev_com_bar.pdf", as(pdf) replace
restore


preserve /* vignette 2, ranksum tests */
   ren vig2rep1 temp1
   ren vig2eve1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep2 temp1
   ren vig2eve2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep3 temp1
   ren vig2eve3 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep4 temp1
   ren vig2eve4 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep1 temp1
   ren vig2def1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep2 temp1
   ren vig2def2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep3 temp1
   ren vig2def3 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep4 temp1
   ren vig2def4 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep1 temp1
   ren vig2cha1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep2 temp1
   ren vig2cha2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep3 temp1
   ren vig2cha3 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep4 temp1
   ren vig2cha4 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep1 temp1
   ren vig2com1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep2 temp1
   ren vig2com2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep3 temp1
   ren vig2com3 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig2rep4 temp1
   ren vig2com4 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore


/* main study, experiment */
preserve /* vignette 3, replication */
   keep if vig3rep1 != .
   keep if vig3qua1 != ""

   tab gen
   sum age, detail

   sum vig3rep1
      ci means vig3rep1

   sum vig3rep2
      ci means vig3rep2

   signrank vig3rep1 = 4
      di r(z) / sqrt(60)

   signrank vig3rep2 = 4
      di r(z) / sqrt(60)

   hist vig3rep1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_rep_hist_1.pdf", as(pdf) replace

   hist vig3rep2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_rep_hist_2.pdf", as(pdf) replace

   reshape long vig3rep, i(id) j(statement)

   collapse (mean) meantemp = vig3rep (sd) sdtemp = vig3rep (count) n = vig3rep, by(statement)

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
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "cir_rep_bar.pdf", as(pdf) replace
restore


preserve /* vignette 3, event */
   keep if vig3eve1 != .
   keep if vig3qua1 != ""

   tab gen
   sum age, detail

   sum vig3eve1
      ci means vig3eve1

   sum vig3eve2
      ci means vig3eve2

   signrank vig3eve1 = 4
      di r(z) / sqrt(64)

   signrank vig3eve2 = 4
      di r(z) / sqrt(64)

   hist vig3eve1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_ioc_hist_1.pdf", as(pdf) replace

   hist vig3eve2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_ioc_hist_2.pdf", as(pdf) replace

   reshape long vig3eve, i(id) j(statement)

   collapse (mean) meantemp = vig3eve (sd) sdtemp = vig3eve (count) n = vig3eve, by(statement)

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
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "cir_ioc_bar.pdf", as(pdf) replace
restore


preserve /* vignette 3, term with conditional */
   keep if vig3def11 != .
   keep if vig3qua1  != ""

   tab gen
   sum age, detail

   sum vig3def11
      ci means vig3def11

   sum vig3def12
      ci means vig3def12

   signrank vig3def11 = 4
      di r(z) / sqrt(50)

   signrank vig3def12 = 4
      di r(z) / sqrt(50)

   hist vig3def11, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_crc_hist_1.pdf", as(pdf) replace

   hist vig3def12, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_crc_hist_2.pdf", as(pdf) replace

   reshape long vig3def1, i(id) j(statement)

   collapse (mean) meantemp = vig3def1 (sd) sdtemp = vig3def1 (count) n = vig3def1, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ytitle(Mean of Agreement) ///
                xlabel(1(1)2) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "cir_crc_bar.pdf", as(pdf) replace
restore


preserve /* vignette 3, term */
   keep if vig3def21 != .
   keep if vig3qua1  != ""

   tab gen
   sum age, detail

   sum vig3def21
      ci means vig3def21

   sum vig3def22
      ci means vig3def22

   signrank vig3def21 = 4
      di r(z) / sqrt(59)

   signrank vig3def22 = 4
      di r(z) / sqrt(59)

   hist vig3def21, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))

   hist vig3def22, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))

   reshape long vig3def2, i(id) j(statement)

   collapse (mean) meantemp = vig3def2 (sd) sdtemp = vig3def2 (count) n = vig3def2, by(statement)

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
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "95% CI")) ///
                graphregion(fcolor(white))
restore


preserve /* vignette 3, chain */
   keep if vig3cha1 != .
   keep if vig3qua1 != ""

   tab gen
   sum age, detail

   sum vig3cha1
      ci means vig3cha1

   sum vig3cha2
      ci means vig3cha2

   sum vig3cha3
      ci means vig3cha3

   signrank vig3cha1 = 4
      di r(z) / sqrt(64)

   signrank vig3cha2 = 4
      di r(z) / sqrt(64)

   signrank vig3cha3 = 4
      di r(z) / sqrt(64)

   hist vig3cha1, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_ceq_hist_1.pdf", as(pdf) replace

   hist vig3cha2, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_ceq_hist_2.pdf", as(pdf) replace

   hist vig3cha3, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_ceq_hist_3.pdf", as(pdf) replace

   reshape long vig3cha, i(id) j(statement)

   collapse (mean) meantemp = vig3cha (sd) sdtemp = vig3cha (count) n = vig3cha, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)3) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "Lamp") label(4 "95% CI")) ///
                graphregion(fcolor(white))
   graph export "cir_ceq_bar.pdf", as(pdf) replace
restore


preserve /* vignette 3, combination with conditional */
   keep if vig3com11 != .
   keep if vig3qua1  != ""

   tab gen
   sum age, detail

   sum vig3com11
      ci means vig3com11

   sum vig3com12
      ci means vig3com12

   sum vig3com13
      ci means vig3com13

   signrank vig3com11 = 4
      di r(z) / sqrt(59)

   signrank vig3com12 = 4
      di r(z) / sqrt(59)

   signrank vig3com13 = 4
      di r(z) / sqrt(59)

   hist vig3com11, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_com_hist_1.pdf", as(pdf) replace

   hist vig3com12, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_com_hist_2.pdf", as(pdf) replace

   hist vig3com13, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))
   graph export "cir_com_hist_3.pdf", as(pdf) replace

   reshape long vig3com1, i(id) j(statement)

   collapse (mean) meantemp = vig3com1 (sd) sdtemp = vig3com1 (count) n = vig3com1, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)3) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "Lamp") label(4 "95% CI")) ///
				graphregion(fcolor(white))
   graph export "cir_com_bar.pdf", as(pdf) replace
restore


preserve /* vignette 3, combination */
   keep if vig3com21 != .
   keep if vig3qua1  != ""

   tab gen
   sum age, detail

   sum vig3com21
      ci means vig3com21

   sum vig3com22
      ci means vig3com22

   sum vig3com23
      ci means vig3com23

   signrank vig3com21 = 4
      di r(z) / sqrt(65)

   signrank vig3com22 = 4
      di r(z) / sqrt(65)

   signrank vig3com23 = 4
      di r(z) / sqrt(65)

   hist vig3com21, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))

   hist vig3com22, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))

   hist vig3com23, percent discrete barwidth(.8) ///
      xtitle(Responses) ///
      xlabel(1(1)7) ///
      yscale(range(0 100)) ///
      ylabel(0(10)100, angle(0)) ///
      graphregion(fcolor(white))

   reshape long vig3com2, i(id) j(statement)

   collapse (mean) meantemp = vig3com2 (sd) sdtemp = vig3com2 (count) n = vig3com2, by(statement)

   generate hitemp = meantemp + invttail(n - 1,0.025) * (sdtemp / sqrt(n))
   generate lotemp = meantemp - invttail(n - 1,0.025) * (sdtemp / sqrt(n))

   graph twoway (bar meantemp statement) (rcap hitemp lotemp statement)
   graph twoway (bar meantemp statement if statement == 1, bcolor(gs2) barw(0.4)) ///
                (bar meantemp statement if statement == 2, bcolor(gs4) barw(0.4)) ///
                (bar meantemp statement if statement == 3, bcolor(gs8) barw(0.4)) ///
                (rcap hitemp lotemp statement), ///
                xtitle(Statement) ///
                xlabel(1(1)3) ///
                ytitle(Mean of Agreement) ///
                ylabel(1(1)7, angle(0)) ///
                legend(label(1 "Pipe") label(2 "Circuit") label(3 "Lamp") label(4 "95% CI")) ///
                graphregion(fcolor(white))
restore


preserve /* vignette 3, ranksum tests */
   ren vig3rep1 temp1
   ren vig3eve1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep2 temp1
   ren vig3eve2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep1 temp1
   ren vig3def11 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep2 temp1
   ren vig3def12 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep1 temp1
   ren vig3def21 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep2 temp1
   ren vig3def22 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep1 temp1
   ren vig3cha1 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep2 temp1
   ren vig3cha2 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep1 temp1
   ren vig3com11 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep2 temp1
   ren vig3com12 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep1 temp1
   ren vig3com21 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore

preserve
   ren vig3rep2 temp1
   ren vig3com22 temp2

   reshape long temp, i(id) j(condition)

   ranksum temp, by(condition)
   esize twosample temp, by(condition) glassdelta
restore


exit
