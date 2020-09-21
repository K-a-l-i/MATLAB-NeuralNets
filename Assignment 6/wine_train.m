%{
G14s3649
Benjamin Strelitz
wine_train
%}

%wine_train
clc
clear
close all

%arrange the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Data=importdata('winedata.txt');
P=Data(:,[ 2:14]);T=Data(:,[1]);
p=P';t=T';
%check:
[r,q]=size(p);[s,qt]=size(t);
if q ~=qt
    error('different batch sizes');
end

%scale down:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%scale down inputs by row
pM=max(p,[],2); %row maxima
pm=min(p,[],2);   %row minima
pf=2./(pM-pm); %factors to scale down rows
pc=-(pM+pm)./(pM-pm);       %additive terms
Dp=diag(pf);   %pf down the diagonal of Dp
pn=Dp*p+pc;       %scale down
tM=max(t,[],2) ;
tm=min(t,[],2);
tv=2./(tM-tm);
tf=tv;
tc=-(tM+tm)./(tM-tm);
Dt=diag(tf);
tn=Dt*t+tc;
%train index
%I1=randperm(floor(2*q/3));
I01=randperm(q);
I1= I01(:,randperm(floor(2*q/3)));
q1=length(I1);
%test index
%I2=setdiff([1:q],I1);
I2=I01;
I2(:,I1)=[];
q2=length(I2);
%training set:
p1=p(:,I1);t1=t(:,I1);
p1n=pn(:,I1);
t1n=tn(:,I1);
%test set:
p2=pn(:,I2);
t2=t(:,I2);
p2n=pn(:,I2);
t2n=tn(:,I2);

%network architecture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%layer sizes:
s1=9;s2=9;s3=s;
%initialise
W1=randu(-1,1,s1,r);
b1=randu(-1,1,s1,1);
W2=randu(-1,1,s2,s1);
b2=randu(-1,1,s2,1);
W3=randu(-1,1,s3,s2);
b3=randu(-1,1,s3,1);
%transfer functions
f1=@tansig;f2=@logsig;f3=@purelin;

%Training parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%learning rate
h=.05;
%epoch counter
k=1;
%Initiate error for epoch
mse=1;
%collect errors 
EEE(1)=mse;
%set tolerance
tol =1e-8;
%max iterations
maxit=800;
%train on normalised data: p1n, t1n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while mse>tol & k<maxit
    k=k+1;
    for j=1:q1
        %propagate input patterns through the net
        n1=W1*p1n(:,j)+b1;
        a1=f1(n1);
        n2=W2*a1+b2;
        a2=f2(n2);
        n3=W3*a2+b3;
        a3=f3(n3);
        an(:,j)=a3;
        %jth error vector
        e(:,j)=t1n(:,j)-an(:,j);
        %derivative matrices
        D3=eye(s3);D2=diag((1-a2).*a2);D1=diag(1-a1.^2);
        %sensitivity vectors
        S3=-2*D3*e(:,j);S2=D2*W3'*S3;S1=D1*W2'*S2;
        %update weights and biases
        W3=W3-h*S3*a2';
        b3=b3-h*S3;
        W2=W2-h*S2*a1';
        b2=b2-h*S2;
        W1=W1-h*S1*p1n(:,j)';
        b1=b1-h*S1;
    end
    %error for epoch
    mse=sum(sum(e).^2)/q1;
    %accumulate MSE into vector: 
    E(k)=mse;
end
    
    %scale up
    a=diag(1./tf)*( an-repmat(tc,1,size(t1,2)));
    for i =1:length(a)
        a(i)=round(a(i),0);
    end     
    %assessing the degree of fit
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %R^2 statistic
    r2=rsq(a,t1);
    %corrcoeff
    [R1,PV1]=corrcoef(a(1,:),t1(1,:));
    fprintf('Training:\n\n')
    fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2)
    disp('----------------------------------------------------------------------')
    
    %Plots:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t11=t1(1,:);a11=a(1,:);
    %plot error (performance function)close all
    E=E(2:end);plot(E);title('MSE')
    figure
    hold on
    plot(t11,t11)
    plot(t11,a11,'*')
    title(sprintf('Training: with %g samples\n',q))
    hold off
    
    %compare with linear model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('Compare with linear model')
    %find that w,b such that ||wp+b-t|| is a minimum
    W=t/aug(p);
    %activate using W
    y=W*aug(p);
    %linear model on training set
    L1=y(:,I1);
    for i =1:length(I1)
        L1(i)=round(L1(i),0);
    end
    figure
    hold on
    plot(t11,t11)
    plot(t11,L1(1,:),'*')
    title('linear model')
    hold off
    
    %r2 for linear model on training set
    r2L=rsq(L1,t1);
    fprintf('Training: Linear fit %5.4f\n',r2L)
    
    %save variables
    save wine_train.mat