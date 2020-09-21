%{
Benjamin Strelitz
G14s3649
ts2a
%}

%ts2a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
%sliding window approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%

clc
clear
close all
load ts1seq.mat

[p, t]=delay(x,2);
q=size(p,2);

%layer sizes
s1=2;s2=2;
%network architecture
net=feedforwardnet([s1,s2]);

%training index, test index

%    training indx               test indx
%<------q-n--------->    <----------n------------>


%size of test set: the last n
n=10;
%test index
ti=[q-n:q];

%training index
tri=[1:q-n-1];
%val index
vi=[];
net.divideFcn='divideind';
net.divideParam.trainInd=tri;
net.divideParam.testInd=ti;
net.divideParam.valInd=[];
%net.trainFcn=’trainscg’;
%set goal>0 since there is no validation set
net.trainParam.goal=1e-8;
%initiate the weights and biases
net=init(net);
%train the net
[net,tr]=train(net,p,t);
%evaluate performance
%training set
ptrain=p(:,tri);
atrain=net(ptrain);
ttrain=t(:,tri);
%compare on training set
[atrain(:) ttrain(:)];
%evaluate with our own function: correlation
[r2 r]=correlation(atrain,ttrain,'train');
%test set
ptest=p(:,ti);
atest=net(ptest);
ttest=t(:,ti);
disp('atest       ttest');
fprintf('%8.4f\t%-8.4f\n',atest(:), ttest(:))
[r2 r]=correlation(atest,ttest,'test')
%rename
ts1net=net;
save ts1.mat