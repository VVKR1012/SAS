options fullstimer mprint mlogic noxwait xsync;
dm "log; clear; ";

filename wincmd pipe 'findstr /I "ACTNUM" C:\Users\user_name\programs\*.sas 2>&1'; /* Serach word should be in double quotes, here ACTNUM is seraching word */

data _null_;
infile wincmd;
input;
put _infile_;
run;

filename wincmd pipe "findstr /I %bquote("ACTNUM") C:\Users\user_name\programs\*.sas 2>&1"; /* ACTNUM in %bquote macro function cause whole command in double quotes */

data _null_;
infile wincmd;
input;
put _infile_;
run;

/* Write a macro to search a string */
%macro search(find_word,path);
	filename wincmd pipe "findstr /I &find_word. &path. 2>&1";

	data _null_;
	infile wincmd;
	input;
	put _infile_;
	run;
%mend search;

%search(%bquote("ACTNUM"),%bquote(C:\Users\user_name\lib\*.sas));
%search(%bquote("ACTNUM"),%bquote(C:\Users\user_name\job\*.sas));
%search(%bquote("ACTNUM"),%bquote(C:\Users\user_name\program\*.sas));
