%143649
%Benjamin Strelitz
%Using bodyfatnet to predict fody fat for newp

clear all
clc
format short
load bodyfat_train.mat
Data=importdata('pnew.txt');

%simulate on all pnew
y=bodyfatnet(Data);

fprintf('   predicted bodyfat percentages for the given data are:\n')
disp('   -----------------------------------------------------------------------------')

disp(y)


