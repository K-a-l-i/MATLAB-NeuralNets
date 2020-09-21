%{
Benjamin Strelitz
G14s3649
question 5 'ts5net'
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
%sliding window approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%ts5net
%m-dimensional series x

clc
clear
close all

x(1)=1;
x(2)=1;

for k=3:100
x(k)=0.76*x(k-1)+0.25*x(k-2);
end

%generating y values
y=[];
for k=1:100
y(k)= 3*x(k)^2 -x(k);
end

%layer sizes
s=[8,8];
%sequence length
m=size(y,2);

%delay size
d=6;
%size(p,2)
q=m-d;
%size of test set
n=10;

%      train                   test
%<-------------------->|<--------n------------->
%1                  m-n q-n+1                q=m-d

%initial delay
I=[1:d];
%test
R=[q-n+1:q];
%train
Q=[1:q-n];
[p,t]=delay2(x,y,d);
%net architecture
net=feedforwardnet(s);
net.divideFcn='divideind';
net.divideParam.trainind=Q;
net.divideParam.testind=R;
net.trainFcn='trainscg';
net.trainparam.goal=1e-6;
%partition data
ptrain=p(:,Q);
ptest=p(:,R);
ttrain=t(:,Q);
ttest=t(:,R);
%train
net=init(net);
[net,tr]=train(net,p,t);

%activate
atrain=net(ptrain);
atest=net(ptest);

% %evaluate
r2=correlation(atest,ttest);
[R,pv]=corrcoef(ttest,atest)
%print matrix
r=size(x,1);
M=[1:r];
M=M(:);
P=[M';r2'];
fprintf('R^2 on component %d is %5.4f\n',P)
% %plot
close all
for i=1:size(x,1)
figure(i)
plot(ttest(i,:),ttest(i,:),ttest(i,:),atest(i,:),'+')
title(sprintf('testing component %d on final seqment length %d \n',i,r))
end
