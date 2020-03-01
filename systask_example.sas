systask command "find /I /C ""Table_name"" C:\Programs\*.SAS > C:\Search\find_table_name.txt" taskname=tshsrch status=srchst wait shell;

/* Calling SYSTASK in data step through call execute and passing macro variable into SYSTASK */
data _null_;
set r2;
call execute('systask command "find /I /C ""'||strip(program)||'"" C:\Programs\*.SAS > ""&file_path.""\find_""'||strip(program)||'"".txt" taskname=tshsrch status=srchst wait shell;');
run;

/* Passing macro variables into SYSTASK */
%let m_f=EMP_Table;
%put &=m_f.;
systask command "find /I /C ""&m_f."" C:\Programs\*.SAS > ""&file_path.""\find_""&m_f."".txt" taskname=tshsrch status=srchst wait shell;
