%{
G14s3649
Benjamin Strelitz
BMI function
%}

function BMI(P)

load bodyfat_train.mat

%isolating weight and height variables, where w=weight, h=height
w =P(2,:); 
h= P(3,:);

%creating new inputs as BMI
bmi =[];
for i=1:size(w,2)
    bmi(i)= w(i)/(h(i)^2);
end

%constructing network with bmi varying and all else constant.
P(1,:)=repmat(mean(P(1,:)),1,size(P,2));

for i=4:size(P,1)
P(i,:)=repmat(mean(P(i,:)),1,size(P,2));
end

%simulating on new bodyfat data
y=bodyfatnet(P);

%printout
fprintf('   predicted bodyfat percentages for the given data are:\n')
disp('   -----------------------------------------------------------------------------')
disp('activations')
M=[y];
fprintf('%4.1f\t\n',M);


%sort on row (feature) 6
[c,i]=sort(bmi);
%corresponding activations
v=y(i);
%plot 1 in 10
close all
x=c([1:10:end]);
y=v([1:10:end]);
%list
[x(:) y(:)];
%linear regression
X=[x(:) ones(length(x),1)];
%coefficients
C=X\y(:);
a=C(1);
b=C(2);
t=linspace(x(1),x(end),100);
z=a*t+b;
figure
hold on
plot(x,y,'.')
plot(t,z)
hold off
xlabel('BMI')
ylabel('body fat')

end

