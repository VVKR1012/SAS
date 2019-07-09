data _null_;
array nam [3] $8 ('Amar' 'Balu' 'Chandra');
array sub [3] $10 ('Telugu' 'English' 'Hindhi');
do I = 1 to dim(nam);
	do j = 1 to dim(sub);
		put nam[I] 'studying ' sub[J] ' paper.';
	end;
end;
run;
