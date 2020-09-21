%{
G14s3649
Benjamin Strelitz
Tegretol
neural network trained to simulate the relationship between drug formulations and
release profiles, which are percentage of the CBZ content of the tablet released over a period of 22 hours 
%}

%-----------------Clearing workspace and terminal----------------------

clc;clear;close all

%-----------------Importing and organising dataset----------------------
%reading data
data=xlsread('TegretolData.xlsx');
%organizing appropriate data
p=data(2:13,2:34); t=data(16:21,2:34); tegretol=data(16:21,36);

%making test, training and validation sets from the data
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.7,0.15,0.15);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);


% %Additional code to be run to find an indeal training function for a
% %feedforwardnet([10,10,5,3]) with the given data. Proved to use more
% compuation than its worth

% trainfcn=string(["trainlm" ,"trainbr",	"trainbfg",	"trainrp",	"trainscg",	"traincgb",	"traincgf",	"traincgp",	"trainoss",	"traingdx",	"traingdm",	"traingd"]);
% Z=0; bestindx=1;
% 
% for i=1:size(trainfcn,2)
% net=feedforwardnet([10,10,5,3],char(trainfcn(1,i)));
% %train
% [net,netstruct]=train(net,p,t);
% atrain=sim(net,ptrain);
% [R,PV]=corrcoef(ttrain,atrain);
% r2=R(1,2)*R(1,2);
% if r2>Z
%     Z=r2;
%     bestindx=i;
% end
% end

%-----------------Finding 'Best' Network Architecture---------------------

%layer sizes of first 2 hidden layers
S=[1:50];
%matrix to store layer sizes and various assesment metrics
A=[];
%for loop which adjusts the number of neurons in the hidden layers in order
%to find the 'best' achitecture with respect to the coefficient of
%determination on the training set
for i=1:size(S,2)
    %number of neurons in hidden layers 1 and 2
    s1=S(i);s2=s1;
    %number of neurons in hidden layers 2 and 3
    s3=round((1/2)*s2);s4=round(((1/3)*s3+1));
    %storig layer sizes in A
    
    %creating the net
    net=cascadeforwardnet([s1,s2,s3,s4]);
    %training function chosen through experimentation
    net.trainFcn='trainscg';
    %max number of epochs
    net.trainParam.epochs=500;
    %The number of epochs that the error on the validation set increses
    net.trainParam.max_fail=20;

    %initiate
    net=init(net);
    %train
    [net,netstruct]=train(net,p,t);
    %name the net and structure
    net.userdata='Tegretol';
    Tegretolnet=net;
    Tegretolstruct=netstruct;


    %simulating net on training set. User can get activations on test data
    %and all data if required
    %train
    atrain=sim(Tegretolnet,ptrain); 
    %atest=sim(Tegretolnet,ptest); %test
    %a=sim(Tegretolnet,p); %all

%--assessing the degree of fit--
%train
%correlation coefficient R, p-value PV, coefficient of determination r2
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
%Storing values to be assesed later
A=[A;s1,s2,s3,s4,r2,R(1,2)];
%Output to user while selecting best model so they can be informed of the
%progress
fprintf('\nCurrent number of neurons in hidden layers and training function:\n %g  %g  %g  %g   %s  \n\nTraining Assesment Metrics:\ncorr coeff: %g\n p value: %g\n r2: %g\n\n',s1,s2,s3,s4,'trainscg',R(1,2),PV(1,2),r2);

end
clc;
%-------------fnding best architecture with respect to r2-------------
%best r2 value and index i
[br2,i]=max(A(:,5));
%best archtitecture with respect to r2
best=A(i,1:4);

%-----------------Final Network Architecture---------------------
%creating  net
net=cascadeforwardnet([best]);
%training function
net.trainFcn='trainscg';
%max number of epochs
net.trainParam.epochs=500;
%The number of epochs that the error on the validation set increses
net.trainParam.max_fail=20;

%initiate
net=init(net);
%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='Tegretol';
Tegretolnet=net;
Tegretolstruct=netstruct;
%getting test and train sets sizes
q1=size(ptrain,2);
q2=size(ptest,2);
%simulate on test and training sets
atrain=sim(Tegretolnet,ptrain); %train
atest=sim(Tegretolnet,ptest); %test
%a=sim(Tegretolnet,p); %all

%---------final output to user with results of final simulation------------

disp('RESULTS ON FINAL SIMULATION');
disp('----------------------------------------------')
fprintf('The model chosen for final simulation was a cascadenet with 4 hidden layers.\nRespective layer widths are s1=s2=%g, s3=%g, s4=%g\nTraining function is scaled conjugate gradient backpropagation (trainscg)\n',best(1),best(3),best(4));
disp('----------------------------------------------------------------------')

%training results
%correlation coefficient R, p-value PV, coefficient of determination r2
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
fprintf('Training Assessment Metrics:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
%plotting training results
figure 
hold on
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('Training Assessment Metrics:\n%g samples, hidden layer widths s1=s2=%g, s3=%g, s4=%g\n',q1,best(1),best(3),best(4)))
hold off
%further training plots
figure
hold on
plot([1:length(atrain)],ttrain,'o')
plot([1:length(atrain)],atrain,'*')
title(sprintf('activation on training set'))
hold off

%-------------------------------------------------------------
%test:
%correlation coefficient R, p-value PV, coefficient of determination r2
[R,PV]=corrcoef(ttest,atest);
r2=R(1,2)^2;
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
%plotting test results
hold on
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing:\n%g samples, hidden layer widths s1=s2=%g, s3=%g, s4=%g',q2,best(1),best(3),best(4)))
hold off
%further tetsing plots
figure
hold on
plot([1:length(atest)],ttest,'o')
plot([1:length(atest)],atest,'*')
hold off
title(sprintf('activation on test set'))

%final Output to user
fprintf('Congradulations! Tegretolnet has been successfully trained, tested and is ready for deployment!\n')

%saving network and variables
save Tegretol.mat




