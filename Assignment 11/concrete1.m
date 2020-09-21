%{
Benjamin Strelitz
G14s3649
question 4a) 'concrete1'
%}
clc;clear;close all

%Importing dataset
Data=xlsread('Concrete_Data.xls');
P=Data(:,[ 1:8]);T=Data(:,[9]);
p=P';t=T';

%network architecture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%neurons in layers 1, 2
s1=8; s2=6; s3=4; s4=3;s5=1; 
%create the net
net=feedforwardnet([s1, s2,s3,s4]);
%training function
net.trainFcn='trainbr';
%maxit
net.trainParam.epochs=300;
%set the number of epochs that the error on the validation set increases
net.trainParam.max_fail=20;

%set ratio using:
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.6,0.2,0.2);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);

%initiate
net=init(net);

%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='concrete';
Concretenet=net;
Concretestruct=netstruct;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%batch sizes
q1=size(ptrain,2);
q2=size(ptest,2);
%simulate
atrain=sim(Concretenet,ptrain); %train
atest=sim(Concretenet,ptest);   %test
a=sim(Concretenet,p);           %all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assessing the degree of fit
trainr2=rsq(ttrain,atrain);
[R,PV]=corrcoef(ttrain,atrain);
fprintf('Training:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),trainr2)
disp('----------------------------------------------------------------------')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figures
%training
figure
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('Training: With %g samples \n',q1))
% disp('train')
% disp('activation      target')
% M=[atrain ;ttrain];
% fprintf('%4.1f\t\t\t%4.1f\n',M)
%-------------------------------------------------------------

%test:
testr2=rsq(ttest,atest);
[R,PV]=corrcoef(ttest,atest);
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),testr2)
disp('----------------------------------------------------------------------')
figure
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing: With %g samples \n',q2))
% disp('test')
% disp('activation      target')
% M=[atest ;ttest];
% fprintf('%4.1f\t\t\t%4.1f\n',M)
%-------------------------------------------------

%all
allr2=rsq(t,a);
[R,PV]=corrcoef(t,a);fprintf('All:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),allr2)
disp('----------------------------------------------------------------------')
figure
plot(t,t,t,a,'*')
title(sprintf('All: With %g samples \n',q1+q2))
% disp('all')
% disp('activation      target')
% M=[a ;t];
% fprintf('%4.1f\t\t\t%4.1f\n',M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%MATLAB performance plots
plotperform(netstruct)
[R,pv]=corrcoef(ttest,atest)

save Concretenet.mat