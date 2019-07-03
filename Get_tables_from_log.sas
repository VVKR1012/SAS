filename wkly "C:\Users\Vijaya\ABC.log";

data read_log_1;
infile wkly truncover;
input line $500.;
run;

data read_log_2;
set read_log_1(where=(line not ? 'clearworklib.sas'));
if (index(line,'\programs\') > 0) or (index(line,'NOTE: The data set') > 0) or (index(line,'NOTE: Table') > 0) or 
(index(line,'updated in') > 0) or (index(line,'inserted into') > 0) then output;
run;

data read_log_3;
set read_log_2(where=(line not ? 'WORK.'));
retain sq 0;
if index(line,'\programs\') > 0 then sq=sq+1;
else sq=sq;
run;

data read_log_4(drop=ds) read_log_5(rename=(line=line2)drop=pgm);
set read_log_3;
if (index(line,'NOTE: The data set') > 0) then do;
	ds=scan(line,5,'');
	output read_log_5;
end;
else if (index(line,'NOTE: Table') > 0) then do;
	ds=scan(line,3,'');
	output read_log_5;
end;
else if (index(line,'updated in') > 0) or (index(line,'inserted into') > 0) then do;
	ds=scan(line,7,'');
	output read_log_5;
end;
else do;
	pgm=scan(scan(line,3,'\'),1,'"');
	output read_log_4;
end;
run;

proc sql noprint;
create table read_log_6 as select line,line2,pgm,ds from read_log_4 a left join read_log_5 b on a.sq=b.sq order by a.sq;
quit;
