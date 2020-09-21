function [r2 R]=correlation(a,t,name)
%Finds the Rˆ2 statistic and correlation coefficient for
%a: activation vector
%t: target vector
%name: string with name for the plot, if required
%r2: r-squared statistic

%r: correlation coefficient
%calculating R2:
tbar=mean(t,2);
abar=mean(a,2);
tBar=repmat(tbar,1,length(t));
ss=sum((a-t).^2,2)/length(t);
sstBar=sum((tBar-t).^2,2)/length(t);
r2=1-ss./sstBar;
%r2=mean(r2v);
%calculating correlation coefficient r
et=t-repmat(tbar,1,length(t));
ea=t-repmat(abar,1,length(a));
if nargout>1
for i=1:size(et,1)
norms(i)=(norm(et(i,:)))*norm(ea(i,:));
end
norms=norms(:);
R=sum(et.*ea,2)./norms;
end
if nargin >2
for i=1:size(t,1)
figure
hold on
%plot(t(i,:),0,’o’)
plot(t(i,:),t(i,:))
plot(t(i,:),a(i,:),'*')
hold off
title(sprintf('%s component %d\n',name,i))
xlabel('targets')
ylabel('activation')
end
end