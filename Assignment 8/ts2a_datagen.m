%{
Benjamin Strelitz
G14s3649
ts2a_datagen
%}
clc 
clear
close all

%defining initial conditions x(1)=1, x(2)=1, x(3)=1.5, n= no. of terms
x(1)=1;x(2)=1;x(3)=1.5; n=100;
for i=4:n
    x(i)=0.1*x(i-3)+.25*x(i-2)+.76*x(i-1);
end
save ts1seq.mat