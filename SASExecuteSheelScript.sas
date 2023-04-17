/*******************************************************
PROGRAM NAME - SASExecuteSheelScript.sas
PROGRAMMER - Vijaya Kumar Reddy Varadabandi.
USAGE - Execute shell script from SAS program and print results on SAS Log
DATE - Started 03/14/2023
DESCRIPTION - This program Execute shell script from SAS program and print results on SAS Log.
              
*******************************************************/

/* Below code call and run Sheel Script  */

data _null_;
infile "sh /home/user/test.sh 2>&1" pipe;
input;
put _infile_;
run;
