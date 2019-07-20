filename env pipe "set"; /* In Windows */
filename env pipe "printenv"; /* In UNIX */

data environment_variables;
infile env truncover;
input line $1000.;
run;

/* Few environment variables are available in Automatic Macro Variables */
%put &=SYSENCODING;
%put &=SYSERRORTEXT;
%put &=SYSHOSTNAME;
%put &=SYSLOGAPPLNAME;
%put &=SYSTCPIPHOSTNAME;
%put &=SYSWARNINGTEXT;
