%{
G14s3649
Benjamin Strelitz
houserb
%}

clc;clear;

%load and organise the data
Data=importdata('housing.txt');
P=Data(:,[1:13]);T=Data(:,[14]);
p=P';t=T';
%number of centres
m=200;
%training index: choose m centres randomly
tri=randperm(500);
tri=tri(1:m);
%test index
ti=setdiff([1:500],tri);
%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);
%max dist and spread
d=max(max(dist(ptrain',ptrain)))
ss=d*sqrt(log(2))/sqrt(m);
S=linspace(ss-3,ss+3,20);
C=[];
for s=S
%form the net: exact design
net=newrb(ptrain,ttrain,1,s,m,1);
%simulate
atest=sim(net,ptest);
%assess
%r2
r2sim=rsq(atest,ttest);
C=[C; s  r2sim];
end
%find the best spread wrt r2 stat 
[mr2,i]=max(C(:,2));
best=C(i,1);

%r2=best(3);
%form the net: exact design
net=newrb(ptrain,ttrain,1,best,m,1);
%simulate
atrain=sim(net,ptrain);
atest=sim(net,ptest);


%output
disp('results for locating best spread:')
disp('   spread       r2 ')
disp(C)
disp('best spread for best r2 ')
disp(best)
disp('with resulting r2 ')
disp(mr2)

fprintf('Results after performing simulation for chosen spread of %.6f\n ',best)

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




