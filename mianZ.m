
clc
clear

% %%%%%%%%%%%% step1�� pair CV
format short
cv_flag = 1;
M_D = chuli_opt();
main_cv1(cv_flag,M_D);


% %%%%%%%%%%%%step2�� row CV
cv_flag = 2;
M_D = chuli_opt();
main_cv1(cv_flag,M_D);

% %%%%%%%%%%%%step3�� column CV
cv_flag = 3;
M_D = chuli_opt();
main_cv1(cv_flag,M_D);
