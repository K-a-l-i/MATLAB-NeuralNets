%{
G14s3649
Benjamin Strelitz
mayflyrbn
%}

clc;clear;close all

%load and organise the data
Data=importdata('bupa.txt');
P=Data(:,[ 1:6]);T=Data(:,[7]);
p=P';t=T';
for i=1:size(t,2)
    if t(i)==2
        t(i)=0;
    end
end
%number of centres
m=150;
%training index: choose m centres randomly
Tri=randperm(345);
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
d=max(max(dist(ptrain',ptrain)))
ss=d*sqrt(log(2))/sqrt(m)
S=linspace(ss-1.5,ss+1.5,20);
C=[];
for s=S
%form the net: exact design
net=newrb(ptrain,ttrain,0.05,s,m,1);
%simulate
atest=round(sim(net,ptest));
%assess
%correct classifications on test set
c=sum(atest-ttest==0);
%percentage correct
pc=c/(345-m)*100;
C=[C; s c pc];
end
[pc,i]=max(C(:,3));
best=C(i,1);


%r2=best(3);
%form the net: exact design
net=newrb(ptrain,ttrain,0.05,best,m,1);
%simulate
atrain=round(sim(net,ptrain));
atest=round(sim(net,ptest));

%Dealing with train activations not 0 or 1
for i=1:size(atrain,2)
    if atrain(i)>=2
        atrain(i)=1;
    end
    if atrain(i)<=-1
        atrain(i)=0;
    end
end

%Dealing with test activations not 0 or 1
for i=1:size(atest,2)
    if atest(i)>=2
        atest(i)=1;
    end
    if atest(i)<=-1
        atest(i)=0;
    end
end

%output
disp(' spread      correct    %correct')
disp(C)
fprintf('best percent correct on spread simulation was %.6f, resuting from a spread of %.6f\n', pc, best(1,1))

%Training assesment
%correct classifications:
cc=sum(atrain-ttrain==0);
%percentage correct
pc=cc/(m)*100;
%R^2 statistic
 r2=rsq(atrain,ttrain);
 %corrcoeff
 [R1,PV1]=corrcoef(atrain,ttrain);
 fprintf('Training: \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2)
 fprintf('percentage correct = %4.2f\n',pc)
 disp('----------------------------------------------------------------------')
 %assess Testing
 %correct classifications:
 ccc=sum(atest-ttest==0);
%percentage correct
 pc=ccc/(345-m)*100;
 %R^2 statistic
 r2=rsq(atest,ttest);
 %corrcoeff
 [R1,PV1]=corrcoef(atest,ttest);
 fprintf('Testing: \n\n')
 fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2)
 fprintf('percentage correct = %4.2f\n',pc)
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
    
    %Plotting Confusion Matrices
    figure
    hold on
    plotconfusion(atest,ttest,'Test Set')
    hold off
    figure
    hold on
    plotconfusion(atrain,ttrain, 'Training Set')
    hold off

