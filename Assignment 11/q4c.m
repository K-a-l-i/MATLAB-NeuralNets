%{
Benjamin Strelitz
G14s3649
question 4c) 
investigating the effect of age and cement on concrete stength
%}
clc;clear;close all

%loading net
load Concretenet.mat

%Importing dataset
Data=xlsread('Concrete_Data.xls');
D=Data(:,[ 1:8]);T=Data(:,[9]);
p=D';t=T';

%number of input patterns
q=size(p,2);

%fixing variables as constants, leaving age
x=[540;140;100;150;15;1000;750];
x=repmat(x,1,q);
p=[x;p(8,:)];

%index to vary
%waist size
k=8;
%simulate on all p
y=Concretenet(p);
%sort on row (feature) 6
[c,i]=sort(p(8,:));
%corresponding activations
v=y(i);
%plot 1 in 10
close all
x=c;
y=v;
%list
[x(:) y(:)];
%linear regression
X=[x(:) ones(length(x),1)];
%coefficients
C=X\y(:);
a=C(1);
b=C(2);
t=linspace(x(1),x(end),100);
z=a*t+b;
figure
hold on
plot(x,y,'.')
plot(t,z)
hold off
xlabel('age( time in days)')
ylabel('compressive strength')
title('concrete')
%--------------------------------------------------------------------------
%now investigating effect of cement
%returning p to original data
p=D';

%fixing variables as constants, leaving cement
x=[140;100;150;15;1000;750;100];
x=repmat(x,1,q);
p=[p(1,:);x];


%waist size
k=1;
%simulate on all p
y=Concretenet(p);
%sort on row (feature) 6
[c,i]=sort(p(1,:));
%corresponding activations
v=y(i);
%plot 1 in 10
% close all
x=c;
y=v;
%list
[x(:) y(:)];
%linear regression
X=[x(:) ones(length(x),1)];
%coefficients
C=X\y(:);
a=C(1);
b=C(2);
t=linspace(x(1),x(end),100);
z=a*t+b;
figure
hold on
plot(x,y,'.')
plot(t,z)
hold off
xlabel('cement content')
ylabel('compressive strength')
title('concrete')