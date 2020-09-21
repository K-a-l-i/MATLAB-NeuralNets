%{
G14s3649
Benjamin Strelitz
MushroomEPS
Neural network designed to simulate the association between growing conditions and EPS
%}
clear
close all
cclc


%load and organise the data
Data=xlsread('data.xlsx');
p=Data(1:43,2:6)'; t=Data(1:43,7)';
%removing outliers and input errors
 p(:,15)=[];  p(:,12)=[];
 t(:,15)=[];  t(:,12)=[];

%load Ionosphere.mat
[r,q]=size(p);
%network architecture
%matrix to store assessments
A=[];

%We can also set using:
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.6,0.2,0.2);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);

trainfcn=string(["trainlm" ,"trainbr",	"trainbfg",	"trainrp",	"trainscg",	"traincgb",	"traincgf",	"traincgp",	"trainoss",	"traingdx",	"traingdm",	"traingd"]);
Z=0; bestindx=1;

for i=1:size(trainfcn,2)
net=feedforwardnet([10,10],char(trainfcn(1,i)));
%train
[net,netstruct]=train(net,p,t);
atrain=sim(net,ptrain);
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)*R(1,2);
if r2>Z
    Z=r2;
    bestindx=i;
end
end


for j=0:10
for i=j+1:20

s1=i;   
s2=j;

% s3=round((1/2)*s2);
% s4=round((1/3)*s3+1);
disp('current number of neurons in each layer')
s=[s1,s2]

%create the net
if s2==0
        net=feedforwardnet(s1);
else
    net=feedforwardnet([s1,s2]);
end
%display(net)
%training
net.trainFcn=char(trainfcn(1,bestindx));
%maxit
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
a=sim(mushnet,p); %all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%assessing the degree of fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Arow=[s1];
Arow=[Arow,s2];
% A(i,3)=s3;
% A(i,4)=s4;
%train
%r2=rsq(ttrain,atrain);
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)*R(1,2);
Arow=[Arow,r2];
Arow=[Arow,R(1,2)];
fprintf('Training:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')


%-------------------------------------------------------------
%test:
r2=rsq(ttest,atest);
[R,PV]=corrcoef(ttest,atest);

fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')

%-------------------------------------------------
A=[A;Arow];
end
end




[br2,ind]=max(A(:,3));
best=[A(ind,1),A(ind,2)];

if best(1,2)==0
    best=best(1,1);
end




%display(net)
%training
net=feedforwardnet(best,char(trainfcn(1,bestindx)));
%maxit
net.trainParam.epochs=500;
%set the number of epochs that the error on the validation set increses
net.trainParam.max_fail=20;
%test train sets
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.6,0.2,0.2);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);
%initiate
net=init(net);
%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='Mushroom';
mushnet=net;
mushstruct=netstruct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1=size(ptrain,2);
%using our own hand-made net:
q2=size(ptest,2);
%simulate
atrain=sim(mushnet,ptrain); %train
atest=sim(mushnet,ptest); %test
a=sim(mushnet,p); %all

%output
disp('RESULTS ON FINAL SIMULATION');
disp('----------------------------------------------------------------------');

%train
%r2=rsq(ttrain,atrain);
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)*R(1,2);
fprintf('Training:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
hold on
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('training: With %g samples s1=%g\n',q1,best(1)))

%-------------------------------------------------------------
%test:
%r2=rsq(ttest,atest);
[R,PV]=corrcoef(ttest,atest);
r2=R(1,2)*R(1,2);
A(i,5)=r2;
A(i,6)=R(1,2);
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
hold on
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing: With %g samples s1=%g\n',q2,best(1)))
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

save MushroomEPS.mat





trainfcn=string(["trainlm" ,"trainbr",	"trainbfg",	"trainrp",	"trainscg",	"traincgb",	"traincgf",	"traincgp",	"trainoss",	"traingdx",	"traingdm",	"traingd"]);