%{
G14s3649
Benjamin Strelitz
fertility_train
%}
% y=regexp(x, ',', 'split');
% y= vertcat(y{:});
% cellfun( @str2double, y(1:2) )

clc
clear
close all

%arrange the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Importing data
P=importdata('fertility_Diagnosis.txt');
%getting inputs and targets from data
newP=[];
T=[];
t=[];
for i=1:size(P,1)
y=regexp(P(i,:), ',', 'split');
y= vertcat(y{:});
T(i)=cell2mat(y(10));
newP=[newP;cellfun( @str2double, y)];
end
newP(:,10)=[];
p=newP';
for i=1:size(T,2)
newvect=T(:,i);
if newvect==78
   t(i)=1;
end
if newvect==79
   t(i)=0;
end
end
%creatting new data set with t and p in order to shuffle for training. Net
%did porrly previously because participants were oredered by their answers
Data=[p;t];
Data=Data(:,randperm(size(Data,2)));
p=Data([1:9],:);
t=Data(10,:);
%stores inputs and targets
[r,q]=size(p);

%network architecture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%neurons in layers 1, 2
s1=10; s2=8; s3=1; 
%create the net
net=feedforwardnet([s1, s2]);
display(net)
%training function
net.trainFcn='trainscg';
%maxit
net.trainParam.epochs=100;
%set the number of epochs that the error on the validation set increses
net.trainParam.max_fail=20;

%We can also set ratio using:
[ptrain,pval,ptest,trainInd,valInd,testInd] = dividerand(p,0.6,0.2,0.2);
[ttrain,tval,ttest] = divideind(t,trainInd,valInd,testInd);

%initiate
net=init(net);

%train
[net,netstruct]=train(net,p,t);
%name the net and structure
net.userdata='fertility';
Fertnet=net;
Fertstruct=netstruct;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%batch sizes
q1=size(ptrain,2);
q2=size(ptest,2);
%simulate
atrain=round(sim(Fertnet,ptrain)); %train
atest=round(sim(Fertnet,ptest));   %test
a=round(sim(Fertnet,p));           %all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%assessing the degree of fit
trainr2=rsq(ttrain,atrain);
[R,PV]=corrcoef(ttrain,atrain);
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),trainr2)
disp('----------------------------------------------------------------------')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figures
figure
plot(ttrain,ttrain,ttrain,atrain,'*')
title(sprintf('Training: With %g samples \n',q))
disp('train')
disp('activation      target')
M=[atrain ;ttrain];
fprintf('%4.1f\t\t\t%4.1f\n',M)
%-------------------------------------------------------------

%test:
testr2=rsq(ttest,atest);
[R,PV]=corrcoef(ttest,atest);
fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),testr2)
disp('----------------------------------------------------------------------')
figure
plot(ttest,ttest,ttest,atest,'*')
title(sprintf('Testing: With %g samples \n',q))
disp('test')
disp('activation      target')
M=[atest ;ttest];
fprintf('%4.1f\t\t\t%4.1f\n',M)
%-------------------------------------------------

%all
allr2=rsq(t,a);
[R,PV]=corrcoef(t,a);fprintf('Testing:\n\n')
fprintf(' corr coeff: %g\n p value: %g\n r2: %g\n',R(1,2),PV(1,2),allr2)
disp('----------------------------------------------------------------------')
figure
plot(t,t,t,a,'*')
title(sprintf('All: With %g samples \n',q))
disp('all')
disp('activation      target')
M=[a ;t];
fprintf('%4.1f\t\t\t%4.1f\n',M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%MATLAB post regression functions
r=postreg(a,t);
rtest=postreg(atest,ttest);
rtrain=postreg(atrain,ttrain);
disp('MATLAB postregression')
disp('-----------------------')
fprintf('train r=%g\n',rtrain)
fprintf('test r=%g\n',rtest)
fprintf('all r=%g\n',r)

%confusion matrix plots

plotconfusion(ttest, atest, 'Test Set',ttrain, atrain, 'Training Set')


%plot errors on a histogram
e=t-a;
figure
hist(e)
title('all errors')
xlabel('errors')
ylabel('instances')

%MATLAB regression plotting functions:
figure
plotregression(ttest,atest)
title('test')
figure
plotregression(t,a)
title('train')
figure
plotregression(t,a)
title('all')

%MATLAB performance plots
plotperform(netstruct)

%save all variables
save fertility_train.mat