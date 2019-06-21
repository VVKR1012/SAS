/* DROP and KEEP keywords in SAS PROC SQL*/
proc sql noprint;
create table class as select * from sashelp.class (DROP=sex);
create table cars as select * from sashelp.class (KEEP=model);
quit;
