options minoperator mlogic;
%let cno=20;
%macro test_in(clist)/mindelimiter=',';
	%if &cno. in  &clist. %then %put ------ Condition Working ------;
	%else %put ****** Condition NOT Working ******;
%mend test_in;
%test_in(%bquote(01,02,20,25));
