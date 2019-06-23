data time_calculation;
infile cards dlm='|';
attrib ld length=8 informat=MDYAMPM. format=MDYAMPM.
	cd length=8 informat=MDYAMPM. format=MDYAMPM.;
input ld cd ;
ms=intck('minute',cd,ld);
d1=int((intck('minute',cd,ld)/1440));
h1=int((mod(intck('minute',cd,ld),1440))/60);
m1=int(mod(intck('minute',cd,ld),60));
put d1 'Days ' h1 'Hours & ' m1 'Minutes ';
cards;
06/22/2019 11:53:25 AM|06/16/2019 04:23:33 AM
;
run;
