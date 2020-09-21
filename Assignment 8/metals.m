%{
Benjamin Strelitz
G14s3649
question 4 'metals'
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
%sliding window approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%

%metals
clc
clear
%cd('L:\profile\MATLAB')% put your own path to the file here.
%read from metals.xlsx %or data.xlsx

%aluminium
M(:,1)=xlsread('metals',1,'C8:C910');
%copper
M(:,2)=xlsread('metals',1,'I8:I910');
%nickel
M(:,3)=xlsread('metals',1,'O8:O910');
%lead
M(:,4)=xlsread('metals',1,'U8:U910');
%tin
M(:,5)=xlsread('metals',1,'Z8:Z910');
%zinc
M(:,6)=xlsread('metals',1,'AE8:AE910');
%Al alloy
M(:,7)=xlsread('metals',1,'AK8:AK910');
%see the data
close all
names={'aluminum','copper','nickel','lead','tin','zinc','aluminium alloy'};
for j=1:7
    figure(j)
    plot(M(:,j))
    title(sprintf('%s',names{j}))
end

%organnise
x=M';
%layer sizes
s=[20,20,20];
%sequence length
m=size(x,2);
%delay size : number of working days in the year
d=265;
%size(p,2)
q=m-d;
%size of test set
n=30;

%      train                   test
%<-------------------->|<--------n-------------->
%1                  q-n q-n+1                   q=m-d

%initial delay
I=[1:d];
%test
R=[q-n+1:q];
%train
Q=[1:q-n];
[p,t]=delay(x,d);
%net architecture
net=feedforwardnet(s);
net.divideFcn='divideind';
net.divideParam.trainind=Q;
net.divideParam.testind=R;
net.trainFcn='trainscg';
net.trainparam.goal=1e-6;
%partition data
ptrain=p(:,Q);
ttrain=t(:,Q);
%train
net=init(net);
[net,tr]=train(net,p,t);

%activate and compare
atrain=net(ptrain);
ptest=p(:,R);
ttest=t(:,R);
atest=net(ptest);

%evaluate
%r2=rsq(ttest,atest);
r2=[];
for i=1:7
    r2(i)=correlation(atest,ttest);
end

[R,pv]=corrcoef(ttest,atest)

%print matrix
m=size(x,1);
M=[1:m];
M=M(:);
P=[M';r2];
fprintf('R^2 on component %d is %5.4f\n',P)

% %plot
for i=1:size(x,1)
    figure
    plot(ttest,ttest,ttest(:,i),atest(:,i),'+')
    title(sprintf('testing component %d on final seqment length %d \n',i,n))
end
for i=1:size(x,1)
figure
plot(ttest(:,i),'o')
hold on
plot(atest(:,i),'*')
hold off
title(sprintf('%s',names{i}))
end