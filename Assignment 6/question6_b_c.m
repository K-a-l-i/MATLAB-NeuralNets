%{
G14s3649
Benjamin Strelitz
deploying ugradnet - question 6b and 6c
%}


%deploys ugradnet to investigate trends
clear all
close all
clc

load ugrad_train.mat

%fix Swedish points at 30
x(1,:)=repmat(30,1,91);
%vary school quality
x(2,:)=linspace(1,10,91);
%vary test results 
x(3,:)=linspace(10,100,91);
%deploy the net
y=ugradnet(x);

%6c
%student from school of quality 6 and has Swedish point score of 25:


%Swedish points at 25 and school quality of 6
k=[25;6];

%test results
t=linspace(1,100,100);
z1=[];z2=[];
for i=1:size(t,2)
    k(3,:,1)=t(i);
    sem=ugradnet(k);
    z1(i)=sem(1,:);
    z2(i)=sem(2,:);
end
SemMarks=[z1;z2];
m=[];
for i =1:size(SemMarks,2)
if SemMarks(1,i)>50 
    if SemMarks(2,i)>50
        m=[i,SemMarks(1,i),SemMarks(2,i)];
        break
    end
end
end

%print result for minimum test mark
fprintf('The minimum test mark the new student requires to pass (>50 percent) both semesters is: %0.f percent\n\nThis will give them semester 1 and 2 marks of approximately %0.f and %0.f percent respectively\n',m(1),m(2),m(3));

%plots
figure
plot(x(3,:),y(1,:))
title('semester 1 vs test mark')
figure
plot(x(3,:),y(2,:))
title('semester 2 vs test mark')
figure
plot(x(2,:),y(1,:))
title('semester 1 vs school quality')
figure
plot(x(2,:),y(2,:))
title('semester 2 vs school quality')