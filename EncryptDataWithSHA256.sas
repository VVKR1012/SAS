/*******************************************************
PROGRAM NAME - EncryptDataWithSHA256.sas
PROGRAMMER - Vijaya Kumar Reddy Varadabandi.
USAGE - Encript data
DATE - Started 03/14/2023
DESCRIPTION - This program encrypt data with SHA-256 Hash Generator.
*******************************************************/

/* Below code encrypt data with SHA-256 Hash Generator */

Data _null_;
set sashelp.class;
enc_name=lowcase(put(sha256(name),$hex64.)); /*SAS sha256 function encrypt data in upper case hence used LOWCASE function to convert lower case.*/
put enc_name;
run;
