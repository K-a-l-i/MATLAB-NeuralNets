%{
Benjamin Strelitz
G14s3649
question 4a) 'concrete2'
%}
clc;clear;close all

%Importing dataset
Data=xlsread('Concrete_Data.xls');
P=Data(:,[ 1:8]);T=Data(:,[9]);
p=P';t=T';

%network architecture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%number of centres
m=600;
%training index: choose m centres randomly
Tri=randperm(1030);
tri=Tri(1:m);
%test index
ti=Tri;
ti(:,tri)=[];
%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);
%max dist and spread
d=max(max(dist(ptrain',ptrain)));
ss=d*sqrt(log(2))/sqrt(m);
S=linspace(ss-10,ss+1,5);
R=[];
for s=S
%form the net: exact design
net=newrb(ptrain,ttrain,0.1,s,m,1);
%simulate
a=sim(net,ptest);
%assess
[r2, r]=correlation(a,ttest);
[Z,PV]=corrcoef(ttest,a);
R=[R; [s r2 r Z(1,2)]];
end
disp(' spread      r2     r     corr coef')
disp(R)
[bestcor,i]=max(R(:,4));
[bestr2,j]=max(R(:,2));
fprintf('best r statistic on simulation was %.6f, resuting from a spread of %.6f\n', bestcor, R(i,1))
fprintf('best r2 statistic on simulation was %.6f, resuting from a spread of %.6f\n', bestr2, R(j,1))

%-----------------------------------------------------------------------------------------------------------

%form the net: using best spread with respect to correlation coefficient
net=newrb(ptrain,ttrain,0.1,R(i,1),m,1);
%simulate
atrain=sim(net,ptrain);
atest=sim(net,ptest);

%assess Training
%R^2 statistic
 r2=rsq(atrain,ttrain);
 %corrcoeff
 [R1,PV1]=corrcoef(atrain,ttrain);
 
 %assess Testing
 %R^2 statistic
 r2t=rsq(atest,ttest);
 %corrcoeff
 [R1t,PV1t]=corrcoef(atest,ttest);
 

%Plot for training:
    figure
    hold on
    plot(ttrain,ttrain)
    plot(ttrain,atrain,'*')
    title(sprintf('Training (wrt r2) with %g samples',size(tri,2)))
    hold off
%Plot for testing:
    figure
    hold on
    plot(ttest,ttest)
    plot(ttest,atest,'*')
    title(sprintf('Test (wrt r2) with %g samples',size(ti,2)))
    hold off    
    
%---------------------------------------------------------------------- 

%form the net: using best spread with respect to r2 statistic
net2=newrb(ptrain,ttrain,0.1,R(j,1),m,1);
%simulate
atrain=sim(net2,ptrain);
atest=sim(net2,ptest);

%assess Training
%R^2 statistic
 r2_2=rsq(atrain,ttrain);
 %corrcoeff
 [R1_2,PV1_2]=corrcoef(atrain,ttrain);
 
 
 %assess Testing
 %R^2 statistic
 r2_2t=rsq(atest,ttest);
 %corrcoeff
 [R1_2t,PV1_2t]=corrcoef(atest,ttest);
 
 %Plot for training:
    figure
    hold on
    plot(ttrain,ttrain)
    plot(ttrain,atrain,'*')
    title(sprintf('Training (wrt corrcoef) with %g samples',size(tri,2)))
    hold off
%Plot for testing:
    figure
    hold on
    plot(ttest,ttest)
    plot(ttest,atest,'*')
    title(sprintf('Test (wrt corrcoef) with %g samples',size(ti,2)))
    hold off    
 
 %--------------------------------------------------------------------------
 
 %final output:
 d
 ss
 
 fprintf('Training (best s wrt corr coef): \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2)
 disp('----------------------------------------------------------------------')
 
 fprintf('Testing (best s wrt cor coef): \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1t(1,2),PV1t(1,2),r2t)
 disp('----------------------------------------------------------------------')
 
 fprintf('Training (best s wrt r2): \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1_2(1,2),PV1_2(1,2),r2_2)
 disp('----------------------------------------------------------------------')
 
 fprintf('Testing (best s wrt r2): \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1_2t(1,2),PV1_2t(1,2),r2_2t)
 disp('----------------------------------------------------------------------')
 

 
 

 