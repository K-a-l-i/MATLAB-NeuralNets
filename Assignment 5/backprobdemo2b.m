%{
Benjamin Strelitz
G14s3649
backpropdemo2b
%}
clc 
clear
close all
%timer initiation
tic
%generate inputs and targets
p=[0:pi/4:2*pi]';
t=3*sin(2*p)+1;
[r,q]=size(p);
[s,q1]=size(t);
%check that the number of samples are the same
if (q~=q1)
    error('different sample sizes')
end
% the number of neurons in each layer
s1=randi([1 5],1,1);s2=s;
%transfer functions
f1=@logsig;
f2=@purelin;
%learning rate
h=.1;
%initiate weights and biases
W1=-1+2*rand(s1,r);
b1=-1+2*rand(s1,1);
W2=-1+2*rand(s2,s1);
b2=-1+2*rand(s2,1);
%tolerance
tol=.001;
%counter
k=1; maxit=100;
E(1)=1;
%update loop
while abs(E)>tol & k<maxit
    k=k+1;
    %propagate through the net
    n1=W1*p+b1;
    a1=f1(n1);
    n2=W2*a1+b2;
    a2=f2(n2);
    %compute errore=t-a2;
    e=t-a2;
    sse=sum(e.^2);
    E(k)=sse;
    %derivative matrices
    D2=eye(s2);
    D1=diag(1-a1.*a1);
    %sensitivities
    S2= -2*D2*e;
    S1= D1*W2'*S2;
    %update
    W2=W2-h*S2*a1';
    b2=b2-h*S2;
    W1=W1-h*S1*p';
    b1=b1-h*S1;
end
%timer termination
toc
%remove the first error: 
E=E([2:end]);
%Displaying Errors
fprintf('EE=\n')
first3 = [E(1);E(2); E(3)];
last3 = [E(end-2);E(end-1); E(end)];
disp(first3)
fprintf('.\n.\n.\n')
disp(last3)
%Plotting
figure;
plot(E);
ylabel('E');
xlabel('iterations');
ylabel('E')
title(sprintf('Performance with tolerance = %g\n no. of neruons in layer 1 (s1)= %g\n no. of neurons in layer 2 (s2)= %g',tol,s1,s2));

%output display
disp('Thank your for using backprop1!')
    
clear
