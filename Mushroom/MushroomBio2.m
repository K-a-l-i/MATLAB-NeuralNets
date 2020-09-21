%{
G14s3649
Benjamin Strelitz
MushroomBio
Neural network designed to simulate the association between growing
conditions and Biomass
%}
clear
close all
clc


%load and organise the data
Data=xlsread('data.xlsx');
p=[Data(2:43,2:5),Data(2:43,7)]'; t=Data(2:43,6)';
%removing outliers and input errors

 p(:,3)=[];  t(:,3)=[];
 p(:,11)=[];  t(:,11)=[];
 p(:,31)=[];  t(:,31)=[];
 p(:,32)=[];  t(:,32)=[];
 p(:,33)=[];  t(:,33)=[];
 p(:,33)=[];  t(:,33)=[];
 p(:,33)=[];  t(:,33)=[];
 p(:,30)=[];  t(:,30)=[];
  p(:,31)=[];  t(:,31)=[];


[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.6,0.2,0.2);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);

trainfcn=string(["trainlm" ,"trainbr",	"trainbfg",	"trainrp",	"trainscg",	"traincgb",	"traincgf",	"traincgp",	"trainoss",	"traingdx",	"traingdm",	"traingd"]);
besttf=[];
[r,q]=size(p);

%network architecture

%matrix to store assessments
A=[];
for j=0:10
for i=j+1:10
for k=1:size(trainfcn,2)
s1=i;   
s2=j;
disp('current number of neurons in each layer')
tf=char(trainfcn(1,k));
s=[s1,s2,trainfcn(1,k)]
%create the net
if s2==0
    net=feedforwardnet(s1,tf);
else
    net=feedforwardnet([s1,s2],tf);
end

net.trainParam.epochs=500;
%set the number of epochs that the error on the validation set increses
net.trainParam.max_fail=20;
% %initiate
net=init(net);

%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='Mushroom';
mushnet=net;
mushstruct=netstruct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%simulate
atrain=sim(mushnet,ptrain); %train
atest=sim(mushnet,ptest); %test
%a=sim(mushnet,p); %all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%assessing the degree of fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Arow=[s1];
Arow=[Arow,s2];

%r2=rsq(ttrain,atrain);
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
Arow=[Arow,r2];
Arow=[Arow,R(1,2)];
fprintf('Training:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')


%-------------------------------------------------------------
%test
[R,PV]=corrcoef(ttest,atest);
r2=R(1,2)^2;
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')

%-------------------------------------------------
A=[A;Arow];
if r2>max(A(:,3))
    besttf=tf;
end
end
end
end




[br2,ind]=max(A(:,3));
best=[A(ind,1),A(ind,2)];

if best(1,2)==0
    best=best(1,1);
    net=feedforwardnet(best,besttf);
    best=[best,0];
else
    net=feedforwardnet(best,besttf);
end

%net=newff(p,t,[s1,s2]);
%display(net)
%training
net.trainFcn='trainscg';
%maxit
net.trainParam.epochs=500;
%set the number of epochs that the error on the validation set increses
net.trainParam.max_fail=20;
%initiate
net=init(net);
%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='MushroomBiomass';
mushbnet=net;
mushbstruct=netstruct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1=size(ptrain,2);
%using our own hand-made net:
q2=size(ptest,2);
%simulate
atrain=sim(mushbnet,ptrain); %train
atest=sim(mushbnet,ptest); %test
a=sim(mushbnet,p); %all

%output
disp('RESULTS ON FINAL SIMULATION');
disp('----------------------------------------------------------------------');

%train
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
fprintf('Training:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
hold on
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('training: With %g samples s1=%g, s2=%g, trainfcn=%s\n',q1,best(1),best(2),besttf))

%-------------------------------------------------------------
%test:
[R,PV]=corrcoef(ttest,atest);
r2=R(1,2)^2;
A(i,5)=r2;
A(i,6)=R(1,2);
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
hold on
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing: With %g samples s1=%g,s2=%g, trainfc=%s\n',q2,best(1),best(2),besttf))
hold off

figure
hold on
plot([1:length(atrain)],ttrain,'o')
plot([1:length(atrain)],atrain,'*')
title(sprintf('activation on training set'))
hold off

figure
hold on
plot([1:length(atest)],ttest,'o')
plot([1:length(atest)],atest,'*')
hold off
title(sprintf('activation on test set'))

save MushroomBio.mat