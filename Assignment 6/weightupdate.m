%weight update scheme for momentum
%without using books
clear
clc

%counter
k=1;

%first weight
u(k)=1;
%adjustment
a(k)=1/k;
%second weight
v(k)=u(k)+a(k);

for k=2:50
    %adjustment
    %for example:
    a(k)=1/k
    
    %change in weights dw
    %second weight - first weight
    d(k)=v(k-1)-u(k-1)
    
    %new first weight<---old second weight
    u(k)=v(k-1)
    
    %new second weight<-----old second weight+adjustment
    v(k)=v(k-1)+a(k)*d(k)  
end

