%{
Benjamin Strelitz
G14s3649
question 2 'trainrbn2'
%}
clc;clear;close all

%inputs and targets
p =[0 0 0 0.5000 0.5000 0.5000 1.0000 1.0000 1.0000 ;0 0.5000 1.0000 0 0.5000 1.0000 0 0.5000 1.0000];
t =[-1.0000 -0.8776 -0.5403 -0.0411 0.0813 0.4185 0.6829 0.8054 1.1426];

q=size(p,2);
% nc=input('number of centres = ');
% %choose nc cenctres
% I=randperm(q);
% J=I(1:nc);
% c=p(:,J)';
% disp('initial centres')
% disp(c)

%using newrb to find optimal centers
d=dist(p,p');
dm=max(max(d));
s=dm*sqrt(log(2))/sqrt(q);
%find optimal centres with newrb
goal=1e-4;
mn=q;
df=1;
net=newrb(p,t,goal,s,mn,df);
c=net.iw{:};
disp('initial centres')
disp(c)

%RBF layer
s1=size(c,1);
d=dist(c,p);
dm=max(max(d));
s=dm*sqrt(log(2))/sqrt(q);
b=sqrt(log(2))/s;
b1=repmat(b,s1,1);
B1=repmat(b1,1,q);

%Linear Layer:
%weight matrix
s2=size(t,1);
w=randu(0,1,s2,s1);
%bias
b2=randu(0,1,s2,1);
B2=repmat(b2,1,q);

%activation through the network:
%rbf layer
n=B1.*d;
a1=radbas(n);
%linear layer
a=w*a1+B2;

%errors
e=t-a;
E=norm(e)^2;
mse=E/q;

%learning rate
lr=.1;
%set values for while loop
count=1;
tol=.001;
maxit=300;

%values for printing
CC(:,:,count)=c;
MSE(count)=mse;

%iteratively update centers
while mse>tol&count<maxit
%update to improve error
for j=1:q
%linear layer
%update bias
B2(:,j)=B2(:,j)+lr*e(:,j);
%update weight matrix w is s2 X s1
for i=1:s2
for k=1:s1
w(i,k)=w(i,k)+2*lr*e(i)*a1(k);
end
end
%rbf layer
%update bias
for k=1:s1
B1(k,j)=B1(k,j)+lr*( sum(e(:,j).*w(:,k)) )*(-2*n(k,j)*exp(-n(k,j)^2))*dist(c(k,:),p(:,j));
end
%update centres
for k=1:s1
c(k,:)=c(k,:)+lr*( sum(e(:,j).*w(:,k)) )*(B1(k,j))^2*(-2*n(k,j)*exp(-n(k,j)^2))*(c(k,:)-p(:,j)');
end
%activate
d=dist(c,p);
n=B1.*d;
a1=radbas(n);
a=w*a1+B2;
e=t-a;
E=norm(e)^2;
mse=E/q;
count=count+1;
MSE(count)=mse;
CC(:,:,count)=c;
end
end

%show centers updating
figure
for k=1:count
plot(CC(:,1,k),CC(:,2,k),'*','markersize',5)
title('centres')
pause(.05)
end
disp('final centres')
disp(c)


%input for simulation
np=101;
x=linspace(-2.5,2.5,np);
[X,Y]=meshgrid(x,x);
XX=X(:)';
YY=Y(:)';
%input patterns
P=[XX;YY];
% 
%activation
d=dist(c,P);
%choose first
pltb1=B1(:,1);
pltB1=repmat(pltb1,1,size(P,2));
pltn=pltB1.*d;
plta1=radbas(pltn);
pltb2=B2(:,1);
plta=w*plta1+pltb2;

disp('spread:')
disp(s)
disp('targets:')
disp(t)
disp('activations:')
disp(a)
disp('----------------------------------------------------------------------------------')

%reshape vector and plot
z=reshape(plta,np,np);
figure
surf(x,x,z)
title('Simulation on fine grid')

%plotting error
figure
plot(MSE)
title('Error')
xlabel('iterations')
ylabel('max error')

%%for smimulation on newp
pnew = [0.1000 0.4000 0.6000; 0.2000 0.5000 0.7000];

%RBF layer 
d=dist(c,pnew);
dm=max(max(d));
s=dm*sqrt(log(2))/sqrt(size(pnew, 2));
b=sqrt(log(2))/s;
b1=repmat(b,s1,1);
B1=repmat(b1,1,size(pnew, 2));

%Linear Layer:
%bias
B2=repmat(b2,1,size(pnew,2));

%activation through the network:
%rbf layer
n=B1.*d;
a1=radbas(n);
%linear layer
a=w*a1+B2;

%output
disp('activations on newp:')
disp(a)


