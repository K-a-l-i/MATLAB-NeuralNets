%{
Benjamin Strelitz
G14s3649
question 4 'ugrad rbf'
%}

%schoolrbf
clc;clear;close all

Data=importdata('ugraddata.txt');
p=Data(:,[1 2 3]);
t=Data(:,[4 5]);
%arrange as rows
p=p';
t=t';

%test index
m=size(p,2);
I=randperm(m);
ti=I(1:floor(m/5));
%training index
tri=setdiff([1:m],ti);
%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);
d=dist(p',p);
dm=max(max(d));
fprintf('max distance between inputs = %4.2f\n',dm)
%sr=input(’spread range = [min, max] =  ’);
sr=[0.1,6];
%use this procedure to find the best spread:
%matrix for storing spread and r
R=[];
i=1;
for s=linspace(sr(1),sr(2),300)   
%train on training set
net=newrbe(ptrain,ttrain,s);
%simulate on test set
a=sim(net,ptest);
[r2, r]=correlation(a,ttest);
R=[R; [[s;s] r2 r]];
fprintf('finding spread: iteration %1.f\n',i)
i=i+1;
end

disp('  spread      r2          r')
disp(R(1:10,:))
fprintf(' . \n . \n . \n')
disp(R(290:300,:))

%semester 1 reslts
sem1=R(1:2:end,:);
%semester 2 reslts
sem2=R(2:2:end,:);

%find the best spread wrt r2 stat (sem1)
[mr2,i]=max(sem1(:,2));
sem1_bs2=R(i,1);
%find the best spread wrt r: correlation coeff (sem1)
[mr1,j]=max(sem1(:,3));
sem1_bs=sem1(j,1);
%simulate with best spread wrt r2 stat
net1_2=newrbe(ptrain,ttrain(1,:),sem1_bs2);
atest1_2=sim(net1_2,ptest);
[r2_12, r_12]=correlation(atest1_2,ttest(1,:));
fprintf('For semster 1, the best spread with respect to r2 stat is %.6f, giving an r statof %.6f, and an r2 stat of %.6f\n',sem1_bs2, r_12(1), r2_12(1));
%%simulate with best spread wrt r stat
net1=newrbe(ptrain,ttrain(1,:),sem1_bs);
atest1=sim(net1,ptest);
[r2_11, r_11]=correlation(atest1,ttest(1,:));
fprintf('For semster 1, the best spread with respect to r stat is %.6f, giving an r stat of %.6f, and an r2 stat of %.6f\n',sem1_bs, r_11(1), r2_11(1));

%find the best spread wrt r2 stat (sem2)
[mr2_2,i]=max(sem2(:,2));
sem2_bs2=sem2(i,1);
%find the best spread wrt r: correlation coeff (sem1)
[mr1_2,j]=max(sem2(:,3));
sem2_bs=sem2(j,1);
%simulate with best spread wrt r2 stat
net2_2=newrbe(ptrain,ttrain(2,:),sem2_bs2);
atest2_2=sim(net2_2,ptest);
[r2_22, r_22]=correlation(atest2_2,ttest(2,:));
fprintf('For semster 2, the best spread with respect to r2 stat is %.6f, giving an r statof %.6f, and an r2 stat of %.6f\n',sem2_bs2, r_22(1), r2_22(1));
%%simulate with best spread wrt r stat
net2=newrbe(ptrain,ttrain(2,:),sem2_bs);
atest2=sim(net2,ptest);
[r2_21, r_21]=correlation(atest2,ttest(2,:));
fprintf('For semster 2, the best spread with respect to r stat is %.6f, giving an r stat of %.6f, and an r2 stat of %.6f\n',sem2_bs, r_21(1), r2_21(1));



t2=ttest(2,:);
t1=ttest(1,:);
a1=atest1;
a1_2=atest1_2;
a2=atest2;
a2_2=atest2_2;

%plot
figure
hold on
plot(t1,t1)
plot(t1,a1,'*')
hold off
title(sprintf('Semester 1 with spread %4.2f, max wrt to r \n',sem1_bs))
xlabel('targets')
ylabel('activation')
%plot
figure
hold on
plot(t1,t1)
plot(t1,a1_2,'*')
hold off
title(sprintf('Semester 1 with spread %4.2f, max wrt to r2 \n',sem1_bs2))
xlabel('targets')
ylabel('activation')
%plot
figure
hold on
plot(t2,t2)
plot(t2,a2,'*')
hold off
title(sprintf('Semester 2 with spread %4.2f, max wrt to r \n',sem2_bs))
xlabel('targets')
ylabel('activation')
%plot
figure
hold on
plot(t2,t2)
plot(t2,a2_2,'*')
hold off
title(sprintf('Semester 2 with spread %4.2f, max wrt to r2 \n',sem2_bs2))
xlabel('targets')
ylabel('activation')
