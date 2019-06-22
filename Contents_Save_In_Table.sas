ods output Attributes=work.Attributes EngineHost=work.EngineHost Variables=work.Variables; /* Define tables*/
ods output close; /* Turn off ODS output before contents */
proc contents data=sashelp.shoes;run;
ods output; /* Turn on ODS output */

/* Contents also available in View */
data vtable;
set sashelp.vtable; /* VTABLE is view it create from dictionary.tables */
run;

proc sql noprint;
create table view_tables as select * from dictionary.tables;
create table view_columns as select * from dictionary.columns; /* Reading all table columns */
quit;
