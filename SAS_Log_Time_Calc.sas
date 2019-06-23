filename wkly "C:\Users\Vijaya\ABCD.log";
data read_log_1;
infile wkly truncover;
input line $500.;
run;

data read_log_2;
set read_log_1;
if index(line,'\programs\') > 0 then output;
if index(line,'Timestamp') > 0 then output;
run;

data read_log_3;
set read_log_2;
retain sq 0;
if index(line,'\programs\') > 0 then sq=sq+1;
if index(line,'Timestamp') > 0 then sq=sq;
run;

data read_log_4(drop=line2) read_log_5(drop=pgm);
set read_log_3;
format line2 datetime19.;
if index(line,'Timestamp') > 0 then do;
	line2=input(substr(line,21),mdyampm25.);
	output read_log_5;
end;
else do;
	pgm=scan(scan(line,3,'\'),1,'"');
	output read_log_4;
end;
run;

data read_log_6;
set read_log_5(drop=line);
by sq;
if first.sq or last.sq then do;
	ordr=_n_;
	output;
end;
run;

proc sql noprint;
create table read_log_7 as select a.*,b.line2 from read_log_4 a left join read_log_6 b on a.sq=b.sq order by ordr;
quit;

data read_log_8(rename=(line2=start_tm)) read_log_9(rename=(line2=end_tm));
set read_log_7;
by sq;
if index(lowcase(line),'.sas') > 0 then do;
	if first.sq then output read_log_8;
	if last.sq then output read_log_9;
end;
run;

data read_log_10(drop=sq line);
merge read_log_8(in=a) read_log_9(in=b);
by sq;
if a and b then do;
	h1=int((mod(intck('minute',start_tm,end_tm),1440))/60);
	m1=int(mod(intck('minute',start_tm,end_tm),60));
	if h1 gt 0 then calc=cat(h1,' Hours & ',m1,' Minutes');
	else calc=cat(m1,' Minutes');
	output;
end;
run;
