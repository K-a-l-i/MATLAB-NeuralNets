%{
Benjamin Strelitz
G14s3649
question 4 'ugrad rbf'
%}

clc;clear;close all

%load and organise the data
Data=xlsread('mayflydata.xls');
P=Data(3:35,3:28);T=Data(3:35,1);
p=P';t=T';

%test index
ptest=importdata('mayflypnew.txt');

d=dist(p',p);
dm=max(max(d));
fprintf('max distance between inputs = %4.2f\n',dm)
%sr=input(’spread range = [min, max] =  ’);
sr=[0.1,6];
%use this procedure to find the best spread:
%matrix for storing spread and r
R=[];
%spread range

for s=linspace(sr(1),sr(2),50)
%train on training set
net=newrbe(p,t,s);
atrain=sim(net,p);
[r2, r]=correlation(atrain,t);
R=[R;[s r2 r]];
end

%find the best spread wrt r2 stat (sem1)
[mr2,i]=max(R(:,2));
bs2=R(i,1);
%find the best spread wrt r: correlation coeff (sem1)
[mr1,j]=max(R(:,3));
bs=R(j,1);

%simulate with best spread wrt r stat
net=newrbe(p,t,bs);
atest=round(sim(net,ptest));
fprintf("\nthe species numbers for the given sample data in mayflypnew are as follows:\n")
disp(atest)

% %simulate with best spread wrt r2 stat
% net2=newrbe(p,t,bs2);
% atest2=round(sim(net,ptest));
% disp(atest)

