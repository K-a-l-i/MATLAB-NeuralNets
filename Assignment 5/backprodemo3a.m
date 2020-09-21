%{
Benjamin Strelitz
G14s3649
backpropdemo3a
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
s1=3;s2=2;s3=s;
%transfer functions
f1=@logsig;
f2=@tansig;
f3=@purelin;
%learning rate
h=.1;
%initiate weights and biases
W1=-1+2*rand(s1,r);
b1=-1+2*rand(s1,1);
W2=-1+2*rand(s2,s1);
b2=-1+2*rand(s2,1);
W3=-1+2*rand(s3,s2);
b3=-1+2*rand(s3,1);
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
    n3=W3*a2+b3;
    a3=f3(n3);
    %compute errore=t-a2;
    e=t-a3;
    sse=sum(e.^2);
    E(k)=sse;
    %derivative matrices
    D3=eye(s3);
    D2=diag(1-a2.^2);
    D1=diag((1-a1).*a1);
    %sensitivities
    S3= -2*D3*e;
    S2= D2*W3'*S3;
    S1= D1*W2'*S2;
    %update
    W3=W3-h*S3*a2';
    b3=b3-h*S3;
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
title(sprintf('Performance with tolerance = %g\n',tol));

%simulate on another input of the same size
yesno = input('Would you like to simulate on another 9x1 input pattern P?\n 1==yes, 0==no\n');
newact = [];
while yesno ==1

u=input('9x1 input: P =')
u=u(:);
%produce activation
a1=f1(n1);
n2=W2*a1+b2;
a2=f2(n2);
n3=W3*a2+b3;
v=f3(n3);
w=2*sin(3*v)+1;
%compare with function
x=linspace(0,2*pi,101);y=3*sin(2*x)+1;
%compare:
disp('new activation and function value')
[v w(:)]
figure
plot(p,t,'o')
hold on
plot(u,v,'*')
plot(x,y)
h = legend('discrete targets','activations', 'continuous target function');
set(h,'Interpreter','none')
hold off
title(sprintf('new activation and targets \n'))
yesno = input('Would you like to simulate on another 9x1 input pattern P?\n 1==yes, 0==no\n');
end
%output display
disp('Thank your for using backprop1!')
clear
close all
