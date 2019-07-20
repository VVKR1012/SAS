/*
This project is to prepare and analyze Transportation Security Administration (TSA) Airport Claims data from 2002 through 2017. The TSA is an agency of the United States Department of Homeland Security that has authority over the security of the traveling public. A claim is filed if you are injured or your property is lost or damaged during the screening process at an airport.
To complete your project, you follow your supervisor's requirements, which are in Section 1.3 of this document. Here is what you need to do:
• Prepare the data.
• Create one PDF report that analyzes the overall data as well as the data for a dynamically specified state.

The data that you use is TSAClaims2002_2017.csv, which was created from the following:
• TSA Airport Claims data from https://www.dhs.gov/tsa-claims-data.
• FAA Airport Facilities data from https://www.faa.gov/airports/airport_safety/airportdata_5010/.
*/
/*Import the raw data file TSAClaims2002_2017.csv.*/
/* Note:- Create file_path1 macro variable with TSAClaims2002_2017.csv folder path */
proc import datafile="&file_path1./TSAClaims2002_2017.csv" 
	dbms=csv 
	out=tsa.ClaimsImport replace; 
	guessingrows=max; 
run;

/*The final data should be in the permanent library tsa, and the data set should be named claims_cleaned.*/
/*Entirely duplicated records need to be removed from the data set.*/
proc sort data=tsa.ClaimsImport out=tsa.Claims_NoDups nodupkey; 
by _all_; 
run;

/*All missing and “-“ values in the columns Claim_Type, Claim_Site, and Disposition must be changed to Unknown.*/
/*Values in the columns Claim_Type, Claim_Site, and Disposition must follow the requirements in the data layout.*/
/*All StateName values should be in proper case.*/
/*All State values should be in uppercase.*/
/*You create a new column named Date_Issues with a value of Needs Review to indicate that a row has a date issue. Date issues consist of the following:*/
/*– a missing value for Incident_Date or Date_Received*/
/*– an Incident_Date or Date_Received value out of the predefined year range of 2002 through 2017*/
/*– an Incident_Date value that occurs after the Date_Received value*/
/*Remove the County and City columns.*/
/*Currency should be permanently formatted with a dollar sign and include two decimal points.*/
/*All dates should be permanently formatted in the style 01JAN2000.*/
/*Permanent labels should be assigned columns by replacing the underscores with a space.*/
data tsa.claims_cleaned(drop=County City);
set tsa.Claims_NoDups;
format Incident_Date Date_Received date9. Close_Amount Dollar20.2;
label Airport_Code="Airport Code" 
	Airport_Name="Airport Name" 
	Claim_Number="Claim Number" 
	Claim_Site="Claim Site" 
	Claim_Type="Claim Type" 
	Close_Amount="Close Amount" 
	Date_Issues="Date Issues" 
	Date_Received="Date Received" 
	Incident_Date="Incident Date" 
	Item_Category="Item Category";
State=upcase(state); 
StateName=propcase(StateName);
if Claim_Site in ('-',"") then Claim_Site="Unknown";
if Disposition in ("-","") then Disposition='Unknown'; 
else if Disposition='Closed: Canceled' then Disposition='Closed:Canceled'; 
else if Disposition='losed: Contractor Claim' then Disposition='Closed:Contractor Claim';
if Claim_Type in ("-","") then Claim_Type="Unknown"; 
else if Claim_Type = 'Passenger Property Loss/Personal Injur' then Claim_Type='Passenger Property Loss'; 
else if Claim_Type = 'Passenger Property Loss/Personal Injury' then Claim_Type='Passenger Property Loss'; 
else if Claim_Type = 'Property Damage/Personal Injury' then Claim_Type='Property Damage';StateName=propcase(StateName);
if missing(Incident_Date)=1 or missing(Incident_Date)=1 or 
	year(Incident_Date) < 2002 or year(Incident_Date) > 2017 or 
	year(Date_Received) < 2002 or year(Date_Received) > 2017 then Date_Issues='Needs Review';
run;


/*Report Requirements*/
/*The final single PDF report needs to exclude all rows with date issues in the analysis and answer the following questions:*/
/*1. How many date issues are in the overall data?*/
/*2. How many claims per year of Incident_Date are in the overall data? Be sure to include a plot.*/
/*3. Lastly, a user should be able to dynamically input a specific state value and answer the following:*/
/*a. What are the frequency values for Claim_Type for the selected state?*/
/*b. What are the frequency values for Claim_Site for the selected state?*/
/*c. What are the frequency values for Disposition for the selected state?*/
/*d. What is the mean, minimum, maximum, and sum of Close_Amount for the selected state? Round to the nearest integer.*/
title "Overall Date Issues in the Data"; 
proc freq data=TSA.Claims_Cleaned; 
table Date_Issues / nocum nopercent; 
run; 

title; 
ods graphics on; 
title "Overall Claims by Year"; 
proc freq data=TSA.Claims_Cleaned; 
table Incident_Date / nocum nopercent plots=freqplot; 
format Incident_Date year4.; 
where Date_Issues is null; 
run; 
title;

%let StateName=California; 
title "&StateName Claim Types, Claim Sites and Disposition Frequencies";
proc freq data=TSA.Claims_Cleaned order=freq; 
table Claim_Type Claim_Site Disposition / nocum nopercent; 
where StateName="&StateName" and Date_Issues is null; 
run; 
title "Close_Amount Statistics for &StateName"; 
proc means data=TSA.Claims_Cleaned mean min max sum maxdec=0; 
var Close_Amount; where StateName="&StateName" and Date_Issues is null; 
run; 
title;

ods pdf file="&file_path1.\ClaimsReports.pdf" style=Meadow;
ods proclabel "Enter new procedure title";
