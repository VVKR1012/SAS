/* To eliminate duplicates with MAX date and self(Inner) join */
data get_max_date_input;
infile cards dlm='*';
input name $ sno date1;
informat date1 mmddyy10.;
format date1 mmddyy10.;
cards;
ABCD*112233*03/28/2008
ABCD*112233*04/16/2008
ABCD*112233*06/15/2015
ABCD*445566*04/28/2009
ABCD*445566*05/23/2016
ABCD*445566*08/15/2019
EFGH*777888*07/22/2009
EFGH*777888*02/22/2016
EFGH*999999*06/25/2019
EFGH*999999*08/23/2009
;
run;

proc sql noprint;
	create table get_max_date_output as select a.* from get_max_date_input a inner join 
	(select name,max(date1) as max_date1 from get_max_date_input group by name) b 
		on a.name = b.name and a.date1=b.max_date1 where missing(sno)=0;
quit;
