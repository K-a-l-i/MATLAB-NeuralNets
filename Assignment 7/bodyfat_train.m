%{
G14s3649
Benjamin Strelitz
bodyfat_train
%}

clc
clear
close all

%arrange the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loading data from nndemos
load bodyfat_dataset.mat
%stores inputs and targets
[p,t]= bodyfat_dataset;
[r,q]=size(p);

%network architecture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%neurons in layers 1, 2
s1=16; s2=8; s3=1; 
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
net.userdata='bodayfat';
bodyfatnet=net;
bodyfatstruct=netstruct;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%batch sizes
q1=size(ptrain,2);
q2=size(ptest,2);
%simulate
atrain=sim(bodyfatnet,ptrain); %train
atest=sim(bodyfatnet,ptest);   %test
a=sim(bodyfatnet,p);           %all

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
save bodyfat_train.mat