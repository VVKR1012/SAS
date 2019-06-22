%let folder_path=%bquote(C:\Users\Vijaya\Desktop);
%put &=folder_path;
filename indata pipe "dir/TC %bquote("&folder_path.") /b";
data file_list;
length fname $100;
infile indata truncover; /* infile statement for file names */
input fname; /* read the file names from the directory */
fileid_text=compress(fname); /* delete leading and trailing spaces*/  
run;
