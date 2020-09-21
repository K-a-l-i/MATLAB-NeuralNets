%{
G14s3649
Benjamin Strelitz
Tegretol sim
deploying Tegretol network to find the optimal release profiles
%}
clear
close all
clc
load Tegretol.mat

%all previous formulation values for cbzcg and cbzfg, including the
%means. Will be used in the creation of a new data set.
cbzcg=[0,mean(p(1,:)),60,19.5,24.7500, 49.5000,40,9.9,36.5,38.9,38, 50,48.54, 48.55,10.7,6.1,7.5];
cbzfg=[0,mean(p(2,:)),49.5,30,24.75,40,39.6,49,59,38.8,43.4,42];

%size of new data set(number of observation for each new value of  and
%cbzfg
s=600;

%empty lists for later evaluation
y=[];
Y=[];


for i=1:size(cbzfg,2)
%creating new data matrix, varying cbzcg between 0-60 and taking previous
%values of cbzfg, including the mean
meanP=[repmat(mean(p(1,:)),1,s);repmat(cbzfg(i),1,s);repmat(mean(p(3,:)),1,s);repmat(mean(p(5,:)),1,s);repmat(mean(p(5,:)),1,s);repmat(mean(p(6,:)),1,s)
repmat(mean(p(7,:)),1,s);repmat(mean(p(8,:)),1,s);repmat(mean(p(9,:)),1,s);repmat(mean(p(10,:)),1,s);repmat(mean(p(11,:)),1,s);repmat(mean(p(12,:)),1,s)];
newP=meanP;
newP(1,:)=linspace(0,60,s);
%simulate on all p
y=[y;Tegretolnet(newP)];

end

for i=1:size(cbzcg,2)
%creating new data matrix, varying cbzfg between 0-60 and taking previous
%values of cbzcg, including the mean
meanp=[repmat(cbzcg(i),1,s);repmat(0,1,s);repmat(mean(p(3,:)),1,s);repmat(mean(p(5,:)),1,s);repmat(mean(p(5,:)),1,s);repmat(mean(p(6,:)),1,s)
repmat(mean(p(7,:)),1,s);repmat(mean(p(8,:)),1,s);repmat(mean(p(9,:)),1,s);repmat(mean(p(10,:)),1,s);repmat(mean(p(11,:)),1,s);repmat(mean(p(12,:)),1,s)];
newp=meanp;
newp(2,:)=linspace(0,60,s);
%simulate on all p
Y=[Y;Tegretolnet(newp)];
end

 %plottig cbzcg 0-60
 S=[6,12,18,24,30,36,42,48,54,60,66,72];
for k=S
figure
hold on
for i=1:300
plot([1 2 6 10 14 22],y(k-5:k,i)','b')
end
plot([1 2 6 10 14 22], tegretol','r')
hold off
xlabel('time (hours)');
ylabel('percentage release');
title(sprintf('cbzcg:0-60 (blue), tegretol (red), cbzfg at %g',string(cbzfg(k/6))))
end
% 
% %plottig cbzfg 0-60
S2=[6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96,102];
for k=S2
figure
hold on
for i=1:300
plot([1 2 6 10 14 22],Y(k-5:k,i)','g')
end
plot([1 2 6 10 14 22], tegretol','r')
hold off
xlabel('time (hours)');
ylabel('percentage release');
title(sprintf('cbzfg:0-60 (green), tegretol (red), cbzfg at %g',string(cbzcg(k/6))))
end

%checking for release profile that most closely matches tegretol (minimum weighted sum of squares): cbzcg
%varying beween 0-60
weightvec=[8,4,2,1,1,1];
c=norm(weightvec);
weights=(1/c)*weightvec;
WSS=[];
for k=S
    wss=[];
    for i=1:300
        vals=[];
        for j=1:6
            vec=[y(k-5:k,i)];
            val=weights(j)*(vec(j,:)-tegretol(j,:))^2;
            vals=[vals;val];
        end
        wss=[wss,sum(vals)];
    end
    WSS=[WSS;wss];
end
%finding formlation that produced a minimum weighted sum of squares
minMatrix = min(WSS(:));
[row,col] = find(WSS==minMatrix);

%checking for release profile that most closely matches tegretol(minimum weighted sum of squares): cbzfg
%varying beween 0-60
WSS2=[];
for k=S2
    wss2=[];
    for i=1:300
        vals=[];
        for j=1:6
            vec=[Y(k-5:k,i)];
            val=weights(j)*(vec(j,:)-tegretol(j,:))^2;
            vals=[vals;val];
        end
        wss2=[wss2,sum(vals)];
    end
    WSS2=[WSS2;wss2];
end
minMatrix2 = min(WSS2(:));
[row2,col2] = find(WSS2==minMatrix2);

%plot of final 2 formulations
figure 
hold on
plot([1 2 6 10 14 22],y(55:60,300)','b')
plot([1 2 6 10 14 22],tegretol','r')
plot([1 2 6 10 14 22],Y(19:24,300)','g')
xlabel('time (hours)')
ylabel('percentage release')
title(sprintf('final formulations most similar to tegretol (weighted some of squares):\n tegretol(red), cbzcg 60 cbzfg 59(blue),cbzcg 60 cbfg 60 (green)'))
hold off

disp('after much testing, the 2 formulations that provided an initial release profile most similar to Tegretol was Formulation1 -cbzcg:60 cbzfg:59 - and Formulation 2-cbzcg:60 cbzfg:60')