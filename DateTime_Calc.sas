/*****************************************************
Calculate the difference between two SAS dates.
Below code return Hours, Minitus, Seconds.
******************************************************/
data _null_;
	st='12Jul2019:10:00:00'dt;
	en=datetime();
	days=int(intck('second',st,en)/86400); /* Days variable created extra, it generate days bettwen 2 days however Hours variable populate taotal hours between two days */
	hours=int(intck('second',st,en)/3600);
	minutes=int(mod(intck('second',st,en),3600)/60);
	seconds=int(mod((intck ('second',st,en)),60));
	put days= hours= minutes= seconds=;
run;
