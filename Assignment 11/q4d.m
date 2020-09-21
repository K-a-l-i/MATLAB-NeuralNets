%{
Benjamin Strelitz
G14s3649
question 4d) '4d'
investigating the effect of other variales on concrete stength
%}
clc;clear;close all

%loading net
load Concretenet.mat

%Importing dataset
Data=xlsread('Concrete_Data.xls');
D=Data(:,[ 1:8]);T=Data(:,[9]);
p=D';t=T';
varnames = ["cement";"blast furnace";"fly ash"; "water"; "superplasticizer"; "coarse aggregate";"fine aggregate";"age"];
 

%number of input patterns
q=size(p,2);

for i=2:7
    x=[540;140;100;150;15;1000;750;100];
    x=repmat(x,1,q);
    x(i,:)=p(i,:);
    y=Concretenet(x);
    [c,j]=sort(x(i,:));
    Y=y(j);
    X=c;
    figure
    hold on
    plot(X,Y,'.')
    title(sprintf('Effect of %s on concrete',varnames(i)))
    xlabel(sprintf('%s',varnames(i)))
    ylabel(sprintf('compressive strength'))
    pause(1)
    hold off    

end


