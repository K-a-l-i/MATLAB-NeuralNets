%{
G14s3649
Benjamin Strelitz
deploying ugradnet - question 6a
%}

%ugrad_sim
%deploys ugradnet to investigate trends
clear all
close all
clc

load ugrad_train.mat

%vary Swedish points
x(1,:)=linspace(24,46,91);
%varyy school quality
x(2,:)=linspace(1,10,91);
%fixed test results of 50
x(3,:)=repmat(50,1,91);
%deploy the net
y=ugradnet(x);
%plots
figure
plot(x(2,:),y(1,:))
title('semester 1 vs school quality')
figure
plot(x(2,:),y(2,:))
title('semester 2 vs school quality')
figure
plot(x(1,:),y(1,:))
title('semester 1 vs Swedish points')
figure
plot(x(1,:),y(2,:))
title('semester 2 vs Swedish points')