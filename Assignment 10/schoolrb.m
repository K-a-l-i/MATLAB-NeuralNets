%{
G14s3649
Benjamin Strelitz
school rb
%}

clc;clear;

%load and organise the data
Data=importdata('school.txt');
P=Data(:,[1 2]);T=Data(:,[3]);
p=P';t=T';
%number of centres
m=20;
%training index: choose m centres randomly
tri=randperm(70);
tri=tri(1:m);
%test index
ti=setdiff([1:70],tri);
%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);
%max dist and spread
d=max(max(dist(ptrain',ptrain)))
ss=d*sqrt(log(2))/sqrt(m)
S=linspace(ss-.2,ss+.2,30);
C=[];
for s=S
%form the net: exact design
net=newrb(ptrain,ttrain,0.7,s,m,1);
%simulate
atest=sim(net,ptest);
%assess
%r2
r2sim=rsq(atest,ttest);
C=[C; s  r2sim];
end
disp('   spread       r2 ')
disp(C)
disp('best spread for best r2 ')
disp(C)
[br2,i]=max(C(:,2));
best=C(i,1);
fprintf('Now performing simulation for chosen spread of %.6f\n ',best(1,1))

%r2=best(3);
%form the net: exact design
net=newrb(ptrain,ttrain,0.7,best(1,1),m,1);
%simulate
atrain=sim(net,ptrain);
atest=sim(net,ptest);

%assess Training
%R^2 statistic
 r2=rsq(atrain,ttrain);
 %corrcoeff
 [R1,PV1]=corrcoef(atrain,ttrain);
 fprintf('Training: \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2)
 disp('----------------------------------------------------------------------')
 %assess Testing
 %R^2 statistic
 r2=rsq(atest,ttest);
 %corrcoeff
 [R1,PV1]=corrcoef(atest,ttest);
 fprintf('Testing: \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2)
 disp('----------------------------------------------------------------------')

%Plot for training:
    figure
    hold on
    plot(ttrain,ttrain)
    plot(ttrain,atrain,'*')
    title(sprintf('Training with %g samples',size(tri,2)))
    hold off
%Plot for testing:
    figure
    hold on
    plot(ttest,ttest)
    plot(ttest,atest,'*')
    title(sprintf('Test with %g samples',size(ti,2)))
    hold off    




