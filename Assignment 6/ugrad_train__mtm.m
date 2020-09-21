%{
G14s3649
Benjamin Strelitz
ugrad_train with momentum
%}

clc
clear
close all

%arrange the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Data=importdata('ugraddata.txt');
P=Data(:,[1 2 3 4]);T=Data(:,5);
p=P';t=T';

%test index
[r,m]=size(p);
I=randperm(m);
ti=I(1:floor(m/3));


%training index
tri=setdiff([1:m],ti);
m1=size(tri,2);

%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);

%network architecture
s1=4;
s2=4;
s3=size(t,1);

%         W1(4X2)          W2(4X4)          W3(1X4)         
%  p(2Xm)---------->a1 ------------->a2----------->----->a3(1Xm) 
%         b1(4X1)          b2(4X1)          b3(1X1)                 
%  
%                   tansig          logsig          purelin

%epoch counter
k=1;

%initialise
W1=randu(-1,1,s1,r);
b1=randu(-1,1,s1,1);
W2=randu(-1,1,s2,s1);
b2=randu(-1,1,s2,1);
W3=randu(-1,1,s3,s2);
b3=randu(-1,1,s3,1);



%learning rate
r=.005;

%momentum
q=.95;

%transfer functions
f1=@tansig;
f2=@logsig;
f3=@purelin;

%primitive normalisation
%normalising
pmx=max(max(p));
tmx=max(max(t));

%normalised data for training
pn=ptrain/pmx;
tn=ttrain/tmx;

%obtain error on first epoch
for j=1:m1
    n1=W1*pn(:,j)+b1;
    a1=f1(n1);
    n2=W2*a1+b2;
    a2=f2(n2);
    n3=W3*a2+b3;
    a3=f3(n3);
    e(:,j)=(tn(:,j)-a3);
end

%error from first epoch
mse=sum(e.^2)/m1;
E(k)=mse;

%derivative matrices
D3=eye(size(a3,1));
D2=diag((1-a2).*a2);
D1=diag(1-a1.^2);

%sensitivities
s3=-2*D3*e(:,j);
s2=D2*W3'*s3;
s1=D1*W2'*s2;

%first update 
%we need two sets of weights before updating in the while loop:
%old new
%W,  WW 
%b,  bb

WW3=W3-r*s3*a2';
bb3=b3-r*s3;

WW2=W2-r*s2*a1';
bb2=b2-r*s2;

WW1=W1-r*s1*pn(:,j)';
bb1=b1-r*s1;


%set tolerance
tol =1e-4;

%k=2;
while mse>tol & k<500
    k=k+1;
    %run the batch
    for j=1:m1
        n1=WW1*pn(:,j)+bb1;
        a1=f1(n1);
        n2=WW2*a1+bb2;
        a2=f2(n2);
        n3=WW3*a2+b3;
        a3=f3(n3);
        an(j)=a3;

        %error for j th pattern 
        e(:,j)=(tn(:,j)-a3);

        D3=eye(size(a3,1));
        D2=diag((1-a2).*a2);
        D1=diag(1-a1.^2);


        s3=-2*D3*e(:,j);
        s2=D2*WW3'*s3;
        s1=D1*WW2'*s2;

        %update 
       %W<--WW
       %b<--bb
        W1=WW1;
        b1=bb1;
        W2=WW2;
        b2=bb2;
        W3=WW3;
        b3=bb3;
        
        %new WW, bb
        WW3=WW3-r*s3*a2'+q*(WW3-W3);
        bb3=bb3-r*s3+q*(bb3-b3);

        WW2=WW2-r*s2*a1'+q*(WW2-W2);
        bb2=bb2-r*s2+q*(bb2-b2);

        WW1=WW1-r*s1*pn(:,j)'+q*(WW1-W1);
        bb1=bb1-r*s1+q*(bb1-b1);
    end

    %error from epoch
    mse=sum(e.^2)/m1;
    E(k)=mse;   
end

%scale up
atrain=tmx*an;
%disp('activation/target');
[atrain;ttrain];

%rsq
r2=rsq(atrain, ttrain);
fprintf('r2 is: %.4f\n',r2);

%plot error (performance function)
close all
plot(E)
xlabel('epochs')
ylabel('error')

title(sprintf('Performance with \n LR=%5.4f and Momentum=%5.4f\n epochs = %d',r,q,k))




%save all variables
save school_mtm2.mat;