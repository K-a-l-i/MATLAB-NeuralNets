function r2=rsq(t,a)
%Finds the r^2 statistic and correlation coefficient for 
%a: sxq activation matrix
%t: sxq target matrix
%r2: r-squared statistic



%arrange t, a with s rows (features) and q columns (observations)
[s,q]=size(t);
if s>q
    t=t';
    a=a';
end

%calculating r2:
%means of the feature rows
mt=repmat(mean(t,2),1,size(t,2));

%sum of squares error between activations and targets
sse=sum((a-t).^2,2);

%sum of squares error between mean of targets and targets
sst=sum((mt-t).^2,2);

%column vector of the r2 stats of the rows
r2=1-sse./sst;

