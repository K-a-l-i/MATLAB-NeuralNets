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

%number of centres
m=200;
%training index: choose m centres randomly
Tri=randperm(500);
tri=Tri(1:m);
%test index
ti=Tri;
ti(:,tri)=[];
%training and test sets:
ptrain=p(:,tri);
ttrain=t(:,tri);
ptest=p(:,ti);
ttest=t(:,ti);
%max dist and spread
d=max(max(dist(ptrain',ptrain)));
fprintf('max distance between inputs = %4.2f\n',d)
%defining spread range;
ss=d*sqrt(log(2))/sqrt(m);
S=linspace(ss-2,ss+2,10);
%use this procedure to find the best spread:
%matrix for storing spread and r
R=[];
for s=S
%form the net: exact design
net=newrb(ptrain,ttrain,0.01,s,m,1);
%simulate
a=sim(net,ptest);
%assess
[r2, r]=correlation(a,ttest);
R=[R; [[s;s] r2 r]];
end
disp('  spread      r2          r')
disp(R(1:10,:))
fprintf(' . \n . \n . \n')
%disp(R(90:100,:))

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
net1_2=newrb(ptrain,ttrain(1,:),0.01,sem1_bs2,m,1);
atest1_2=sim(net1_2,ptest);
[r2_12, r_12]=correlation(atest1_2,ttest(1,:));

%%simulate with best spread wrt r stat
net1=newrb(ptrain,ttrain(1,:),0.01,sem1_bs,m,1);
atest1=sim(net1,ptest);
[r2_11, r_11]=correlation(atest1,ttest(1,:));

%find the best spread wrt r2 stat (sem2)
[mr2_2,i]=max(sem2(:,2));
sem2_bs2=sem2(i,1);
%find the best spread wrt r: correlation coeff (sem1)
[mr1_2,j]=max(sem2(:,3));
sem2_bs=sem2(j,1);

%simulate with best spread wrt r2 stat
net2_2=newrb(ptrain,ttrain(2,:),0.01,sem2_bs2,m,1);
atest2_2=sim(net2_2,ptest);
[r2_22, r_22]=correlation(atest2_2,ttest(2,:));

%%simulate with best spread wrt r stat
net2=newrb(ptrain,ttrain(2,:),0.01,sem2_bs,m,1);
atest2=sim(net2,ptest);
[r2_21, r_21]=correlation(atest2,ttest(2,:));

%output
fprintf('\nmax distance between inputs = %4.2f\n',d)
fprintf('\nfor training and testing on the ugrad data set with %1.f centers, the results were as follows:\n',m)
fprintf('------------------------------------------------------------------------------------------------------------------------------\n')
fprintf('\nFor semster 1, the best spread with respect to r2 stat is %.6f, giving an r statof %.6f, and an r2 stat of %.6f\n',sem1_bs2, r_12(1), r2_12(1));
fprintf('\nFor semster 1, the best spread with respect to r stat is %.6f, giving an r stat of %.6f, and an r2 stat of %.6f\n',sem1_bs, r_11(1), r2_11(1));
fprintf('\nFor semster 2, the best spread with respect to r2 stat is %.6f, giving an r statof %.6f, and an r2 stat of %.6f\n',sem2_bs2, r_22(1), r2_22(1));
fprintf('\nFor semster 2, the best spread with respect to r stat is %.6f, giving an r stat of %.6f, and an r2 stat of %.6f\n',sem2_bs, r_21(1), r2_21(1));
fprintf('\n------------------------------------------------------------------------------------------------------------------------------\n');


%importing pnew
Data2=importdata('ugradpnew.txt');
pnew=Data2';


%simulating on ugradpnew:
%using best spread for semester 1 wrt r2
atestpnew1_2=sim(net1_2,pnew)';
%best spread for semester 1 wrt r
atestpnew1=sim(net1,pnew)';
%best spread for semester 2 wrt r2
atestpnew2_2=sim(net2_2,pnew)';
%best spread for semester 2 wrt r
atestpnew2=sim(net2,pnew)';

%output for predictions on pnew
disp('The following are predictions for semester 1 and 2 given the data in ugradpnew:')
disp('   best s wrt r:       best s wrt r2:')
disp('   sem1      sem2      sem1      sem2')
disp([atestpnew1 atestpnew2 atestpnew1_2 atestpnew2_2 ])






%re-assigning variables for ease of use
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
