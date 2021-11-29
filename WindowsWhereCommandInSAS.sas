dm "log; clear; ";

filename wincmd pipe 'where /r "C:\Users\user_name\programs\" ABC.txt 2>&1'; /* Serach for ABC.txt file in Programs folder and sub-folder  */

data _null_;
infile wincmd;
input;
put _infile_;
run;

/* Execute above command with SAS macro */
%let m_path=%bquote(C:\Users\user_name\programs\);
%let m_file=%bquote(ABC.txt);

/* If macros in filename statement then command should be in double quotes(") */
filename wincmd pipe "where /r %bquote("&m_path.") &m_file. 2>&1"; /* Serach for ABC.txt file in Programs folder and sub-folder  */

data _null_;
infile wincmd;
input;
put _infile_;
run;

/* Call BAT file in filename statement */
filename calbat pipe 'C:\Users\user_name\programs\list.BAT 2>&1'; /* write list of windows commands in BAT file and redirect results in BAT file itself */

data _null_;
infile calbat;
input;
put _infile_;
run;
