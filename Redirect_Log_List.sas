options compress=yes linesize=max pagesize=max mprint;
%let prgm=%bquote(Program1);
data _null_;call symput('dt',catx('_',put(date(),date9.),compress(put(time(),tod5.),':')));run;
%let folder_path=%bquote(C:\Users\Vijaya\Desktop);
filename Logfile "&folder_path.\&prgm._&dt..log";
filename Lisfile "&folder_path.\&prgm._&dt..lis";
proc printto log=Logfile print=Lisfile new;run;
proc contents data=sashelp.eismbrp;quit;
proc printto;run;
