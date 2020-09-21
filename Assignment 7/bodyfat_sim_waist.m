%143649
%Benjamin Strelitz
%bodyfat_sim_waist
% show how body fat depends on abdomen circumference (waist size)

clear all
clc
format short
load bodyfat_train.mat

%index to vary
%waist size
k=6;
%simulate on all p
y=bodyfatnet(p);
%sort on row (feature) 6
[c,i]=sort(p(6,:));
%corresponding activations
v=y(i);
%plot 1 in 10
close all
x=c([1:10:end]);
y=v([1:10:end]);
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
xlabel('abdomen circumference (waist size)')
ylabel('body fat')


