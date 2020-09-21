%{
G14s3649
Benjamin Strelitz
ugrad1a using logsig instead of purelin
%}

%ugrad_train
clc
clear
close all

%arrange the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Data=importdata('ugraddata.txt');
P=Data(:,[1 2 3]);T=Data(:,[4 5]);
p=P';t=T';
t=t(:,[1:6]);
p=p(:,[1:6]);
%check:
[r,q]=size(p);[s,qt]=size(t);
if q ~=qt
    error('different batch sizes');
end

%scale down:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%scale down inputs by row
%row maxima
pM=max(p,[],2);
%row minima
pm=min(p,[],2);   
%factors to scale down rows
pf=2./(pM-pm);  
%additive terms
pc=-(pM+pm)./(pM-pm);      
%pf down the diagonal of Dp
Dp=diag(pf);   
%scale down
pn=Dp*p+pc;           %repmat(pc,1,size(p,2));       
%scale down targets similarly
tM=max(t,[],2) ;
tm=min(t,[],2);
tf=2./(tM-tm);
tc=-(tM+tm)./(tM-tm);
Dt=diag(tf);
tn=Dt*t+tc;          %repmat(tc,1,size(t,2));
%train index
I1=randperm(floor(2*q/3));
q1=length(I1);
%test index
I2=setdiff([1:q],I1);
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
s1=s;
%initialise
W1=-1+2*rand(s1,r);
b1=-1+2*rand(s1,1);
%transfer functions
f1=@logsig;

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
        an(:,j)=a1;
        %jth error vector
        e(:,j)=t1n(:,j)-an(:,j);
        %derivative matrices
        D1=diag((1-a1).*a1);
        %sensitivity vectors
        S1=-2*D1*e(:,j);
        %update weights and biases
        W1=W1-h*S1*p1n(:,j)';
        b1=b1-h*S1;
    end
    %error for epoch
    mse=sum(sum(e).^2)/q1;
    %accumulate MSE into vector: EE
    E(k)=mse;  
end
    %scale up
    a=diag(1./tf)'*( an-repmat(tc,1,size(t1,2)));
    
    %assessing the degree of fit
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %R^2 statistic
    r2sem1=rsq(a,t1(1,:)); %semester 1
    r2sem2=rsq(a,t1(2,:)); %semester 2
    
    %corrcoeff
    [R1,PV1]=corrcoef(a(1,:),t1(1,:));
    fprintf('Training: Semester 1:\n\n')
    fprintf('corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2sem1(1))
    disp('----------------------------------------------------------------------')
    [R2,PV2]=corrcoef(a(2,:),t1(2,:));fprintf('Training: Semester 2\n\n')
    fprintf('corr coeff: %g\n p value: %g\n r2: %g\n\n',R2(1,2),PV2(1,2),r2sem2(1))
    disp('----------------------------------------------------------------------')
    
    %Plots:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t11=t1(1,:);a11=a(1,:);t12=t1(2,:);a12=a(2,:);
    %plot error (performance function)close all
    E=E(2:end);plot(E);title('MSE')
    figure
    hold on
    plot(t11,t11)
    plot(t11,a11,'*')
    title(sprintf('Training: Semester 1 with %g samples\n',q))
    hold off
    figure
    hold on
    plot(t12,t12)
    plot(t12,a12,'*')
    hold off
    title(sprintf('Training: Semester 2 with %g samples\n',q))
    
    %compare with linear model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('Compare with linear model')
    %find that w,b such that ||wp+b-t|| is a minimum
    W=t/aug(p);
    %activate using W
    y=W*aug(p);
    %linear model on training set
    L1=y(:,I1);
    figure
    hold on
    plot(t11,t11)
    plot(t11,L1(1,:),'*')
    title('linear model: first semester')
    hold off
    figure
    hold on
    plot(t12,t12)
    plot(t12,L1(2,:),'*')
    title('linear model: second semester')
    %r2 for linear model on training set
    r2sem1L=rsq(L1,t1(1,:));
    r2sem2L=rsq(L1,t1(2,:));
    
    fprintf('Training: Linear fit Semester 1 %5.4f\n',r2sem1L(1))
    fprintf('Training: Linear fit Semester 2 %5.4f\n',r2sem2L(1))
    %save variables
    save ugrad_train.mat