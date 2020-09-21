%{
G14s3649
Benjamin Strelitz
ionospherrbe
%}

clc;clear;

%load and organise the data
%load and organise the data
Data=importdata('f0f2data.txt');
P=Data(:,[1:3]);T=Data(:,4);
p=P';t=T';

%creating cyclic time variables
y=[cos(2*pi*p(1,:)/365); sin(2*pi*p(1,:)/365)];

%new data matrix
p=[y;p(2,:);p(3,:)];

q=size(p,2);
%number of centres
m=400;
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


for i=1:10
S=linspace(ss-2/(i),ss+2/(i),20);
C=[];

for s=S
%form the net: exact design
net=newrbe(ptrain,ttrain,s);
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
fprintf('Now performing simulation for chosen spread of %.6f\n\n ',best(1,1))
ss=best;

end




%form the net: exact design
net=newrbe(ptrain,ttrain,best);
%simulate
atrain=sim(net,ptrain);
atest=sim(net,ptest);

%assess Training
%R^2 statistic
 r2=rsq(atrain,ttrain);
 %corrcoeff
 [R1,PV1]=corrcoef(atrain,ttrain);
 fprintf('Training: expecting 100 percent accuracy as we are simulating on all centres \n\n')
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
    hold off
    title(sprintf('activation on test set'))

