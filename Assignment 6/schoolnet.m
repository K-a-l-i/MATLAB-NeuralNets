%{
G14s3649
Benjamin Strelitz
schoolnet function
%}

function y=schoolnet(x)
load school_train.mat
if size(x,1) ~=r
    error('x incorrect size');
end
%normalise x
xn=Dp*x+repmat(pc,1,size(x,2));
for j=1:size(x,2)
    n1=W1*xn(:,j)+b1;
    a1=f1(n1);
    yn(:,j)=a1;
end
%rescale
y=diag(1/tf)*( yn-repmat(tc,1,size(yn,2)))  ;