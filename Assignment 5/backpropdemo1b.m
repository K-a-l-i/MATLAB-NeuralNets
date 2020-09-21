%{
Benjamin Strelitz
G14s3649
backpropdemo1a
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
s1=s;
%transfer functions
f1=@purelin;
%learning rate
h=.001;
%initiate weights and biases
W1=-1+2*rand(s1,r);
b1=-1+2*rand(s1,1);
%tolerance
tol=.001;
%counter
k=1; maxit=100;
E(1)=1;
%update loop
while abs(E)>tol & k<maxit
    k=k+1;
    %propagate through the nets
    n1=W1*p+b1;
    a1=f1(n1);
    %compute errore=t-a2;
    e=t-a1;
    sse=sum(e.^2);
    E(k)=sse;
    %derivative matrices
    D1=eye(s);
    %sensitivities
    S1= -2*D1*e;
    %update
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
title(sprintf('Performance with tolerance = %g\n no. of neruons in layer 1 (s1)= %g\n',tol,s1));

%output display
disp('please note, given that this network only has 1 layer, it is unable to vary the number of neurons in that layer. This is because the number of neurons in the final layer needs to be the same as the number of rows in the target vector')
disp('Thank your for using backprop1!')

clear

