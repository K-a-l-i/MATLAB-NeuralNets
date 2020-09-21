function [p t]=delay(x,d)
%produces a moving window of length d from the sequence x
%from x1 x2 x3 .......
%produces
%There are n-d input patterns p_{dX1} and targets t_{1X1}
n=size(x,2);
for k=1:n-d
    p(:,k)=x([k:k+d-1]);
    t(k)=x(k+d);
end