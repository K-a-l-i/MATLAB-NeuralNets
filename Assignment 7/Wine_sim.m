%{
G14s3649
Benjamin Strelitz
Wine_sim
%}

load Wine_train.mat


%getting inputs
P=importdata('winedata.txt');
p=P';
t=p(1,:);
p(1,:)=[];
%simulate on all pnew
y=round(Winenet(p));

%output
fprintf('   predicted wines for the given data are:\n')
disp('   -----------------------------------------------------------------------------')
disp('activation      target')
M=[y ;t];
fprintf('%4.1f\t\t\t%4.1f\n',M)

[R,pv]=corrcoef(ttest,atest)
r2=rsq(t,y);

%targets for  confusion matrix
TM=zeros(3,size(t,2));
for i =1:3
for j =1:size(t,2)
    if t(:,j)==i
    TM(i,j)=1;
    else 
    TM(i,j)=0;    
    end
end
end

%activations for  confusion matrix
AM=zeros(3,size(y,2));
for i =1:3
for j =1:size(y,2)
    if y(:,j)==i
    AM(i,j)=1;
    else 
    AM(i,j)=0;    
    end
end
end

%plotting cofusion matrix
plotconfusion(TM,AM,'New Data')


%plotting
figure
plot(t,t,t,y,'*')
title(sprintf('All: With %g samples \n',q))
disp('all')
fprintf('\nDegree o fit was assesed using r2 indicator, which gave a value of %f:\n',r2)