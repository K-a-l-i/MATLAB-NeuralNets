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
p=[Data(1:43,2:5),Data(1:43,7)]'; t=Data(1:43,6)';
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
 
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.7,0.15,0.15);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);

trainfcn=string(["trainbfg",	"trainrp",	"trainscg",	"traincgf",	"traincgp","trainoss","traingdx"]);	


% besttf='trainbfg';

%network architecture
%layer sizes
S=[1:20];
%matrix to store assessments
A=[];
for i=1:size(S,2)
for k=1:size(trainfcn,2)
tf=char(trainfcn(1,k));
s1=S(i);
s2=s1;
s3=round((1/2)*s2);
s4=round((1/3)*s3+1);
%create the net
%net=newff(p,t,[s1,s2]);
net=cascadeforwardnet([s1,s2,s3,s4],tf);
%display(net)
%training
% net.trainFcn='trainscg';
%maxit
net.trainParam.epochs=500;
%set the number of epochs that the error on the validation set increses
net.trainParam.max_fail=20;

%initiate
net=init(net);
%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='MushroomBio';
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%assessing the degree of fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Arow=[s1];
Arow=[Arow,s2];
Arow=[Arow,s3];
Arow=[Arow,s4];
%train
[R,PV]=corrcoef(ttrain,atrain);
r2=R(1,2)^2;
Arow=[Arow,r2];
Arow=[Arow,R(1,2)];
fprintf('\n current number of neurons in hidden layers and training function:\n %g  %g  %g  %g  %s  \ncorr coeff: %g\n p value: %g\n r2: %g\n',s1,s2,s3,s4,tf,R(1,2),PV(1,2),r2);

% fprintf('Training:\n\n')
% fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
% disp('----------------------------------------------------------------------')
Arow=[Arow,k];
A=[A;Arow];
% if r2>max(A(:,5))
%     besttf=tf;
% end


%-------------------------------------------------------------
%test:

% [R,PV]=corrcoef(ttest,atest);
% r2=R(1,2)^2;
% fprintf('Testing:\n\n')
% fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
% disp('----------------------------------------------------------------------')

%-------------------------------------------------

end
end
[br2,i]=max(A(:,5));
best=A(i,1:4);
besttfind=A(i,7);
besttf=char(trainfcn(1,besttfind));
%net=newff(p,t,[s1,s2]);
net=cascadeforwardnet(best,besttf);
%display(net)
%training
% net.trainFcn='trainscg';
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
r2=rsq(ttrain,atrain);
[R,PV]=corrcoef(ttrain,atrain);
fprintf('Training:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
hold on
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('training: With %g samples s1=s2=%g, s3=%g, s4=%g\n',q1,best(1),best(3),best(4)))

%-------------------------------------------------------------
%test:
r2=rsq(ttest,atest);
[R,PV]=corrcoef(ttest,atest);
A(i,5)=r2;
A(i,6)=R(1,2);
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),r2)
disp('----------------------------------------------------------------------')
figure 
hold on
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing: With %g samples s1=s2=%g,s3=%g,s4=%g\n',q2,best(1),best(3),best(4)))
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