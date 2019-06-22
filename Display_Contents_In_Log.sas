/* Display Table Contents on SAS Log window */
proc sql;
describe table dictionary.tables;
describe view sashelp.vtable;
quit;
