%{
Benjamin Strelitz
G14s3649
question 3 'gully'
%}

%gully
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
%sliding window approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
clc;
clear
close all

x=xlsread('Temperatures',1, 'd2:d1874');
%view the data

plot(x)
xlabel('time periods')
ylabel('temperature')
%delay
d=150;
[p, t]=delay(x',d);
q=size(p,2);
%size of test set
n=100;

%     q-n            n
%<---train----><----test--->
%1,2,.........q-n,q-n+1,...q

%ttest index
ti=[q-n+1:q];
%training index
tri=[1:q-n];
%test set: last n
ptest=p(:,ti);
ttest=t(:,ti);
%train set
ptrain=p(:,tri);
ttrain=t(:,tri);
%layer size
s1=10;s2=10;

%network architecture
net=feedforwardnet([s1,s2]);
%partition the data
net.dividefcn='divideind';
net.divideparam.trainind=tri;
net.divideparam.testind=ti;
net.divideparam.valind=[];
%Net training
net.TrainParam.epochs=1000;
net.trainFcn='trainscg';
%initiate the weights and biases
net=init(net);
%train the net
[net,tr]=train(net,p,t);
%rename
gullynet=net;
%activations
atrain=sim(net,ptrain);
atest=sim(net,ptest);
a=sim(net,p);

%degree of fit
%r2test=rsq(ttest,atest)
%r2train=rsq(ttrain,atrain)
r2=correlation(atest,ttest)
[R,pv]=corrcoef(ttest,atest)

plot(ttest,ttest,ttest,atest,'.')
title('test')

hold on
plot([1:length(atest)],ttest,'o')
plot([1:length(atest)],atest,'.')
hold off
title(sprintf('activation on test set'))


%myfigureposition(pos2)
plot([1:length(a)],a,[1:length(a)],t,'o')
title('activalion on all')
save gully.ma
