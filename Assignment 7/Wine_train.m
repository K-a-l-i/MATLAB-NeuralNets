%{
G14s3649
Benjamin Strelitz
Wine_train
%}

clc
clear
close all

%arrange the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loading data from nndemos
load wine_dataset.mat

%stores inputs and targets
[p,T]= wine_dataset;
[r,q]=size(p);
t=[];
for i=1:size(T,2)
   newvect=T(:,i);
   if newvect(1,:)==1
        t(i)=1;
   end
   if newvect(2,:)==1
        t(i)=2;
   end
   if newvect(3,:)==1
        t(i)=3;
   end
end
%network architecture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%neurons in layers 1, 2
s1=4; s2=2; s3=1; 
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
net.userdata='Wine';
Winenet=net;
Winestruct=netstruct;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%batch sizes
q1=size(ptrain,2);
q2=size(ptest,2);
%simulate
atrain=round(sim(Winenet,ptrain)); %train
atest=round(sim(Winenet,ptest));   %test
a=round(sim(Winenet,p));           %all

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
[R,pv]=corrcoef(ttest,atest)


%targets for train batch confusion matrix
TMtrain=zeros(3,size(ttrain,2));
for i =1:3
for j =1:size(ttrain,2)
    if ttrain(:,j)==i
    TMtrain(i,j)=1;
    else 
    TMtrain(i,j)=0;    
    end
end
end

%activations for test batch confusion matrix
AMtrain=zeros(3,size(atrain,2));
for i =1:3
for j =1:size(atrain,2)
    if atrain(:,j)==i
    AMtrain(i,j)=1;
    else 
    AMtrain(i,j)=0;    
    end
end
end


%targets for test batch confusion matrix
TMtest=zeros(3,size(ttest,2));
for i =1:3
for j =1:size(ttest,2)
    if ttest(:,j)==i
    TMtest(i,j)=1;
    else 
    TMtest(i,j)=0;    
    end
end
end

%activations for test batch confusion matrix
AMtest=zeros(3,size(atest,2));
for i =1:3
for j =1:size(atest,2)
    if atest(:,j)==i
    AMtest(i,j)=1;
    else 
    AMtest(i,j)=0;    
    end
end
end

%plotting cofusion matrix
plotconfusion(TMtest,AMtest,'Test Set',TMtrain,AMtrain,'Training Set')

%save all variables
save Wine_train.mat