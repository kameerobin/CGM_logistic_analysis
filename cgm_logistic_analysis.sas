/* De-identified SAS Code: Logistic Regression Analysis on CGM Use in Pregnancy */

/* Importing raw CSV file (original data path removed for privacy) */
PROC IMPORT datafile='mock_CGM_data.csv'
	out=CGMData
	dbms=csv
	replace;
	getnames=yes;
	guessingrows=max;
run;

/* Data step: filtering and formatting */
data CGM;
	set CGMData;
	if cgm_prior = . then delete;
	if dm_type ne 1 then delete;
	if cgmdata_y ne 1 then delete;

	deldttm = input(del_time, anydtdtm19.);
	deldate = datepart(deldttm);
	format deldate mmddyy10.;

	/* Keeping only de-identified, non-PHI variables */
	keep race___1-race___6 race___88 cgm_prior ethnicity term preterm bmi_prepreg marital_status insurance prepreg_hba1c hb_a1c_1 hb_a1c_1_date chtn 
		ckd dm_class dx_year pump tobacco del_type pph edd deldate;
run;

/* Format yes/no values */
proc format;
	value resp 1 = '1. Yes'
				0 = '2. No';
run;

/* Main dataset for analysis */
data CGMTBL;
	set CGM;

	firstdt = edd - 280;
	format firstdt mmddyy10.;

	age = yrdif('01JAN1980'd, firstdt, 'AGE'); /* Mock DOB used for illustration only */

	/* Race/ethnicity grouping */
	if ethnicity = 1 then racegr = 3;
	else if race___3 = 1  then racegr = 4;
	else if race___88 = 1 then racegr = 4;
	else if race___1 = 1 then racegr = 2;
	else if race___2 = 1 then racegr = 1;

	if racegr in (1, 4) then racegr1 = 1;
	else if racegr in (2, 3) then racegr1 = 0;

	/* Nulliparity */
	if term = 0 and preterm = 0 then nullip = 1;
	else if term > 0 or preterm > 0 then nullip = 0;
	else nullip = .;

	/* Recoding marital status */
	if marital_status = 1 then married = 1;
	else if marital_status in (99,.) then married = .;
	else married = 0;

	/* Insurance recoding */
	if insurance = 1 then privins = 1;
	else if insurance = 2 then privins = 0;

	if insurance = 2 then pubins = 1;
	else if insurance = 1 then pubins = 0;

	ga_hb1 = (280 - (edd - hb_a1c_1_date))/7;

	if prepreg_hba1c ne . then pre1st_a1c = prepreg_hba1c;
	else if ga_hb1 ne . and ga_hb1 lt 12 then pre1st_a1c = hb_a1c_1;
	else pre1st_a1c = .;

	/* Recode DM class */
	if dm_class in (3,4,5,6) then dmclass = 4;
	else if dm_class = 0 then dmclass = 1;
	else if dm_class = 1 then dmclass = 2;
	else if dm_class = 2 then dmclass = 3;
	else dmclass = .;

	pregyear = year(firstdt);
	dbdxyr = pregyear - dx_year;

	/* Tobacco */
	if tobacco in (.,99) then smoke = .;
	else if tobacco = 1 then smoke = 1;
	else smoke = 0;
run;

/* Frequencies for categorical vars */
proc freq order=formatted;
	table (racegr1 nullip married pubins chtn ckd dmclass pump smoke pregyear)*cgm_prior / chisq exact norow nopercent;
run;

/* T-tests for continuous vars */
proc ttest;
	var age bmi_prepreg pre1st_a1c dbdxyr;
	class cgm_prior;
run;

/* Nonparametric test for skewed variable */
proc npar1way wilcoxon;
	var pregyear;
	class cgm_prior;
run;

/* Logistic regression model */
proc logistic data=CGMTBL;
	class racegr1 (ref='1') married (ref='1') privins (ref='0') smoke (ref='0') nullip (ref='1') chtn (ref='0') ckd (ref='0') dmclass (ref='1') / param=ref;
	model cgm_prior (event='0') = age racegr1 nullip married pubins pre1st_a1c chtn ckd dmclass dbdxyr smoke bmi_prepreg / selection = backward slstay = 0.05 details;
run;
proc logistic data=CGMTBL;
class racegr1 (ref='1') pump (ref='1') married (ref='1') privins (ref='0') smoke (ref='0') nullip (ref='1') chtn (ref='0') ckd (ref='0') dmclass (ref='1')
                / param=ref;
model cgm_prior (event='0') = age racegr1 nullip pubins;
run;
