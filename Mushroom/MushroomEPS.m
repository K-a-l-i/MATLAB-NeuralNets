%{
G14s3649
Benjamin Strelitz
MushroomBio
Neural network designed to simulate the association between growing
conditions and Biomass
%}
%-------------------------------------------------------------------------

%--------------Clearing Workspace and Importing Data----------------------
clear
close all
clc
%load and organise the data
Data=xlsread('MushDatabEPS.xlsx');

%---------------------Organizing Data-----------------------------------
%creating variables of correct dimensions
p=[Data(1:33,2:5)]'; t=Data(1:33,7)';
%removing further outliers
p(:,3)=[];t(:,3)=[];
p(:,30)=[];t(:,30)=[];
%organising data into test and training sets
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.7,0.15,0.15);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);

%--------------------Finding Best Network architecture---------------------
%layer sizes
S=[1:60];
%matrix to store assessment metrics and layer widths
A=[];
%for loop to find best layer sizes with respect to the coefficient of
%determination on training. Layer numbers and size ratios were found by
%experimentation
for i=1:size(S,2)
%si=width of layer i
s1=S(i);
s2=s1;
s3=round((1/2)*s2);
s4=round((1/3)*s3+1);
%create the net (cascadeforwardnet worked better than feedforwardnet on
%experimentation. 'trainscg' was also found through trial and error
mushepsnet=cascadeforwardnet([s1,s2,s3,s4],'trainscg');
%max number of epochs
mushepsnet.trainParam.epochs=500;
%The number of epochs that the error on the validation set increses
mushepsnet.trainParam.max_fail=20;
%initiate net
mushepsnet=init(mushepsnet);
%train
[mushepsnet,netstruct]=train(mushepsnet,p,t);
%name the net and structure
mushepsnet.userdata='MushroomEPS';
mushbstruct=netstruct;

%--simulating--
%train
%the user is free to get activations on test and all data but we only need
%the training results for choice of architecture
atrain=sim(mushepsnet,ptrain); 
% %test
% atest=sim(mushnet,ptest); 
% %all
% a=sim(mushnet,p); 
%--assessing the degree of fit--

%performance metrics on training data
%coefficient of correlation R, P value PV, coefficient of determination r2
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
%storing results in A
A=[A;[s1,s2,s3,4,r2,R(1,2)]];
%Output to user while selecting best model so they can be informed of the
%progress
fprintf('\nCurrent number of neurons in hidden layers and training function:\n %g  %g  %g  %g   %s  \n\nTraining Assesment Metrics:\ncorr coeff: %g\n p value: %g\n r2: %g\n',s1,s2,s3,s4,'trainscg',R(1,2),PV(1,2),r2);


end
clc;
%findind the highest coefficient of determination r2 and its index i
[br2,i]=max(A(:,5));
%finding the layer widths resulting in the best r2 
best=A(i,1:4);

%-----------------Building Best Network----------------------------------
%instantiate net
mushepsnet=cascadeforwardnet(best,'trainscg');
%max number of epochs
mushepsnet.trainParam.epochs=500;
%The number of epochs that the error on the validation set increses
mushepsnet.trainParam.max_fail=20;

%initiate net
mushepsnet=init(mushepsnet);
%train
[mushepsnet,netstruct]=train(mushepsnet,p,t);
%name the net and structure
mushepsnet.userdata='MushroomEPS';
mushstructeps=netstruct;
%getting size of train and test sets for output
q1=size(ptrain,2);
q2=size(ptest,2);
%simulating
%train
atrain=sim(mushepsnet,ptrain);
%test
atest=sim(mushepsnet,ptest); 
%all
a=sim(mushepsnet,p);

%--------------------- Output to User--------------------------------------
disp('----------------------------------------------------------------------');
disp('               - RESULTS ON FINAL SIMULATION -                        ');
disp('----------------------------------------------------------------------');
fprintf('The model chosen for final simulation was a cascadenet with 4 hidden layers.\nRespective layer widths are s1=s2=%g, s3=%g, s4=%g\nTraining function is scaled conjugate gradient backpropagation (trainscg)\n',best(1),best(3),best(4));
disp('----------------------------------------------------------------------')
%training metrics
%coefficient of correlation R, P value PV, coefficient of determination r2
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
%printing results
fprintf('\nTraining Assesment Metrics:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
%plotting training targets and activations
figure 
hold on
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('Training Assesment Metrics:\n%g samples, layer widths s1=s2=%g, s3=%g, s4=%g\n',q1,best(1),best(3),best(4)))
legend('training targets','training network activations')
hold off

figure
hold on
plot([1:length(atrain)],ttrain,'o')
plot([1:length(atrain)],atrain,'*')
title(sprintf('activation on training set'))
legend('training targets','training network activations')
hold off

%test metrics:
%coefficient of correlation R, P value PV, coefficient of determination r2
[R,PV]=corrcoef(ttest,atest);
r2=R(1,2)^2;
%printing results
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
%plotting test targets and activations
figure 
hold on
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing:\n%g samples, layer widths s1=s2=%g, s3=%g, s4=%g\n',q2,best(1),best(3),best(4)))
legend('test targets','test network activations')
hold off

figure
hold on
plot([1:length(atest)],ttest,'o')
plot([1:length(atest)],atest,'*')
hold off
title(sprintf('Activations on test set'))
legend('test targets','test network activations')


%plotting activations on all data
figure
hold on
plot([1:length(a)],t,'o')
plot([1:length(a)],a,'*')
title(sprintf('Activations on all data'))
legend('targets','network activations')
hold off

%final print to user
fprintf('Congradulations! mushepsnet has been successfully trained, tested and is ready for deployment!\n')
%saving net and variables
save MushroomEPS.mat


