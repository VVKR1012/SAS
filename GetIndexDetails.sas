options compress=yes linesize=MAX pagesize=MAX mprint;

%macro Getindx(ip_ds,ab);

	proc contents data = &ip_ds. noprint out2 = out2ds;run;
	%let dsid = %sysfunc(open(work.out2ds, IS));
	%let nlobs = %sysfunc(attrn(&dsid,nlobs));
	%let rc = %sysfunc(close(&dsid));
	%put &=dsid &=nlobs &=rc;

	%if &nlobs ne 0 %then %do;
		%if %sysfunc(exist(&&ab._Index)) eq 0 %then %do;
			proc sql;
			create table &&ab._Index(Libname char(8),Member char(32),Name char(32),Type char(12),Recreate char(200));
			quit;
		%end;
		proc sql noprint;
			insert into &ab._Index select Libname,Member,Name,Type,Recreate from out2ds;
			select name into :m_ind_&ab. separated by ' ' from out2ds where type='Index';
		quit;
		proc delete data = out2ds (gennum=all); run;
		%put m_ind_&ab. = &&&m_ind_&ab.;
		%symdel m_ind_&ab./nowarn;
	%end;

%mend Getindx;

%macro Validate_index(uds);
	
	proc sort data=&uds.;
	by Libname Member;
	run;

	data _null_;
	set &uds. nobs=last_obs;
	ds_nm=upcase(symget('uds'));
	/* Write out header text information for the first observation in each conc*/
 	if _n_ =1 then do;
		put @5 10*'+-----' '+';
		put @5 '+' 2*'******' ' OutPut of ' ds_nm ' dataset ' 2*'******' '+';
		put @5 10*'+-----' '+';
		put @5 'Libname' @15 'Member' @37 'Name' @57 'Type' @63 'Recreate';
		put @5 10*'+-----' '+';
 	end;
	/* Write out the data for all records */
	put @5 Libname @15 Member @37 Name @57 Type @63 Recreate;
	if _n_ =last_obs then put @5 10*'+-----' '+'; 
	run;
	Title "------ &uds. table output ------";
/*	proc print data = &uds.; run;*/

%mend Validate_index;

proc append data=sashelp.adomsg base=adomsg; run;

%Getindx(work.adomsg,before);

proc sql noprint;
	create index level on adomsg(level);
quit;

%Getindx(work.adomsg,after);

%Validate_index(before_index);
%Validate_index(after_index);
