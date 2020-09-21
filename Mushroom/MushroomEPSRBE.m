%{
G14s3649
Benjamin Strelitz
MushroomBio RBE
%}

clc;clear;close all

%load and organise the data
Data=xlsread('MushDatabEPS.xlsx');
p=[Data(1:33,2:5)]'; t=Data(1:33,7)';

[r,q]=size(p);
%number of centres
m=28;
%training index: choose m centres randomly
tri=randperm(q);
tri=tri(1:m);
%test index
ti=setdiff([1:q],tri);
%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);
%max dist and spread
d=max(max(dist(ptrain',ptrain)))
ss=d*sqrt(log(2))/sqrt(m);


for i=1:20
S=linspace(ss-2/(i*20),ss+2/(i*20),20);
C=[];

for s=S
%form the net: exact design
mushepsrbe=newrbe(p,t,s);
%simulate
atrain=sim(mushepsrbe,ptrain);
clc;
%assess
%r2
[R,PV]=corrcoef(ttrain,atrain);
if size(R,2)>1
    r2=R(1,2)^2;
else
    r2=R^2;
    R=[R,R];
    PV=[PV,PV];
end
C=[C;s,  r2];
fprintf('Current spread:\n %g \nWith a coefficient of determination (r2) on training of:\n %g',s,r2)
end

[br2,i]=max(C(:,2));
best=C(i,1);
ss=best;
end
clc;
[br2,i]=max(C(:,2));
best=C(i,1);



%form the net: exact design
mushepsrbe=newrbe(ptrain,ttrain,best);
%simulate
atrain=sim(mushepsrbe,ptrain);
atest=sim(mushepsrbe,ptest);
a=sim(mushepsrbe,p);

%assess Training

 %corrcoeff
 [R,PV]=corrcoef(atrain,ttrain);
 if size(R,2)>1
    r2=R(1,2)^2;
 else
    r2=R^2;
    R=[R,R];
    PV=[PV,PV];
 end
 clc;
 disp('----------------------------------------------------------------------');
 disp('               - RESULTS ON FINAL SIMULATION -                        ');
 disp('----------------------------------------------------------------------');
 fprintf('Training: \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
 disp('----------------------------------------------------------------------')

 %assess Testing
 
 %corrcoeff
 [R,PV]=corrcoef(atest,ttest);
 if size(R,2)>1
    r2=R(1,2)^2;
 else
    r2=R^2;
    R=[R,R];
    PV=[PV,PV];
 end
 fprintf('Testing: \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
 disp('----------------------------------------------------------------------')

%Plots for training:
    figure
    hold on
    plot(ttrain,ttrain)
    plot(ttrain,atrain,'*')
    title(sprintf('Training with %g samples',size(tri,2)))
    hold off
    
    figure
    hold on
    plot([1:length(atrain)],ttrain,'o')
    plot([1:length(atrain)],atrain,'*')
    title(sprintf('activation on training set'))
    hold off

%Plots for testing:
    figure
    hold on
    plot(ttest,ttest)
    plot(ttest,atest,'*')
    title(sprintf('Test with %g samples',size(ti,2)))
    hold off    

    figure
    hold on
    plot([1:length(atest)],ttest,'o')
    plot([1:length(atest)],atest,'*')
    title(sprintf('activation on test set'))
    hold off
    
    
    %Plots for all:
    figure
    hold on
    plot([1:length(a)],t,'o')
    plot([1:length(a)],a,'*')
    title(sprintf('activation on all'))
    hold off

    save MushroomEPSRBE.mat