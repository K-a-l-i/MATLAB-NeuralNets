%{
G14s3649
Benjamin Strelitz
Tegretol sim
deploying Tegretol network to find the optimal release profile (that which
is closest to Tegretol's using a weighted sum of squares error)
%}

%--------clearning workspace and terminal----------------------

clear
close all
clc

%---------------importing and organising data-----------------

%loadng Tegretol net and variales
load Tegretol.mat
%loading Tegretol release profile
tegretol=data(16:21,36);
release_profiles=t;
%loading the formulations ofther drugs
formulations=p;
%vector contaning hours when release percentages were captured
hrs=[1 2 6 10 14 22];
%string vactor containing formula variables. will be used in output
vars=["CBZCG", "CBZFG","Emcocel 90M","Emcompress","Methocel K4M","Methocel K100M","Methocel K100LV","Lactose","SLS","Mg stearate","Talc","Cabosil"]';

%---------------finding best release profile in given data-------------

%vector to contain weighted sum of squares error
lst_wss=[];

figure
hold on
%loop which finds the weighted sum of squares between Tegretol's release
%profile and those in the given data, then plots all the profiles

plot(hrs,tegretol,'r')
for i=1:size(release_profiles,2)
    %plotting release profiles
    plot(hrs,release_profiles(:,i),'b')
    %finding weighted sum of squares of errors
    wss=WSS(release_profiles(:,i));
    lst_wss=[lst_wss,wss];
end
%plotting and labelling
title(sprintf('Release Profiles of All Given Data'));
xlabel('Time (hours)');
ylabel('Release percentage');
legend('Tegretols release profle','release profiles of given data');
hold off


%finding the best release profile of given data using the minimum of the
%weighted sum of squares error
[a,BestIndx]=min(lst_wss);
best_prof=release_profiles(:,BestIndx);
best_form=formulations(:,BestIndx);

%addtional code to visualize all profiles indedpendently (no titles/labels
%etc)
% for i=1:size(release_profiles,2)
%     figure 
%     hold on
%     plot(hrs,release_profiles(:,i),'b')
%     plot(hrs,tegretol,'r')
% end

%-----------Attempt to simulate a formulation better than no.8-------------

%formulation with current best profile
init_form=p(:,BestIndx);
form=init_form;
%setting CBZ_CG to 60 initially
form(1,1)=0;
%setting CBZ_FG to 0 initially
form(2,1)=0;
%Lists storing all the weighted sum of squares errors, release profiles,
%and formulations to be simulated in for loop below
grid=[];
sim_wss=[];
Prof=[];
Form=[];
%list containing increments to alter cbzcg and cbzfg by
stps=linspace(0,60,61);

%for loop which finds 3721 different formulations for different
%combinations of cbzcg and cbzfg (each ranging from 0-60, increments of 1 and plots

fprintf('\nNow using Tegretolnet to predict release profiles on simulated data\n')
figure
hold on
for k=1:size(stps,2)
    %used to make a wss matrix for 3D plot
    row_wss=[];
    for j=1:size(stps,2)
        %cbzfg =stps
        form(2,1)=stps(1,j);
        %release profile
        prof=Tegretolnet(form);
        %weighted sum of squares of erros of Tegretol and 'prof' 19.2527 26.7470

        wss=WSS(prof);
        %updating lists
        sim_wss=[sim_wss,wss];
        row_wss=[row_wss,wss];
        Form=[Form,form];
        Prof=[Prof,prof];
        fprintf('\nCurrent formula under consideration contains:\n cbzcg %g mg and cbzfg %g mg\n\n\n\n\n',form(1,1),form(2,1));
        %plotting on same figure
        plot(hrs,prof,'b')
    end
    %form(1,1)=form(1,1)-stps(1,2)
    form(1,1)=stps(1,k);
    grid=[grid;row_wss];
end
plot(hrs,tegretol,'r')
%Graph title,labels etc
title(sprintf('Release Profiles of Tegretol and all simulated data'));
xlabel('Time (hours)');
ylabel('Release percentage');
hold off
clc;


%finding minimum weighted sum of squares of errors
[b,sim_indx]=min(sim_wss);
%finding the release profile closest to Tegretol's
best_Prof=Prof(:,sim_indx);
%finding the associated formulation
best_Form=Form(:,sim_indx);

%----------Conclusive report----------------------------------------
disp('----------------------------------------------')
disp('FINAL RESULTS');
disp('----------------------------------------------')

%correlation coefficiet R, coefficient of determination r2, p value PV
[R,PV]=corrcoef(tegretol,best_prof);
r2=R(1,2)^2;

%--given data---
disp('The best release profile from the given data was:')
disp(best_prof)
fprintf('It was given by formulation no.%g, which had the following composition:\n',BestIndx)
fprintf('value       variable\n') ;
for i = 1:size(best_prof,1)
    fprintf('%f   %s\n',best_prof(i),vars(i)) ;
end
fprintf('\nWhen compared to Tegretol, this formulation had the following results:\n r2 score:%g\n R score:%g\n p-val: %g\n weighted sum of squares:%g\n\n',r2,R(1,2),PV(1,2),a) 


%correlation coefficiet R, coefficient of determination r2, p value PV
[R,PV]=corrcoef(tegretol,best_Prof);
r2=R(1,2)^2;

%--simulated data--
disp('The best release profile from the simulated data was:')
disp(best_Prof)
fprintf('It was given by formulation no.%g, which had the following composition:\n',sim_indx)
fprintf('value       variable\n') ;
for i = 1:size(best_Prof,1)
    fprintf('%f   %s\n',best_Prof(i),vars(i)) ;
end
fprintf('\nWhen compared to Tegretol, this formulation had the following results:\n r2 score:%g\n R score:%g\n p-val: %g\n weighted sum of squares:%g\n\n',r2,R(1,2),PV(1,2),b) 


%Final printout to user
if a<b
    fprintf('\nThus after extensive testing, the release profile most closely matching that of Tegretol with respect to a weighted sum of squares criterion was:\n')
    disp(best_prof);
    fprintf('Given by Formulation no.%g from the given data and has the following composition:\n',BestIndx)
    fprintf('value       variable\n') ;
    for i = 1:size(best_prof,1)
    fprintf('%f   %s\n',best_prof(i),vars(i)) ;
    end
    fprintf('With a weighted sum of squres of %g. Looks like the best formula was there all along...\n',a)
else
    fprintf('\nThus after extensive testing, the release profile most closely matching that of Tegretol with respect to a weighted sum of squares criterion was:\n');    
    disp(best_Prof)
    fprintf('Given by Formulation no.%g from the simulated data and has the following composition:\n',sim_indx)
    fprintf('value       variable\n') ;
    for i = 1:size(best_Prof,1)
    fprintf('%f   %s\n',best_Prof(i),vars(i)) ;
    end
    fprintf('With a weighted sum of squres of %g\n',b)
end

fprintf('\nThis research was proudly brought to you by Tegretolnet.\nRemeber, all recommendations made by this system are approximations, and not expert opinions.\nPlease use the results only with the opinion a healthcare professional.\nHave a lovely day!\n')
%-------------Plotting-----------------------------------------------------
%plotting weighetd sum of squares of given data
figure 
hold on
Min=min(min(lst_wss));
plot(BestIndx,Min,'*r');
plot(1:size(release_profiles,2),lst_wss,'.b')
hold off
title(sprintf('Weighted sum of squares of errors of given formulations\nMinimum=*'))
ylabel('weighted sum of squares of errors')
xlabel('hours')

%plotting weighted sum of squares of erros of simulated data
figure 
hold on
Min=min(min(sim_wss));
plot(sim_indx,Min,'*r');
plot(1:size(sim_wss,2),sim_wss,'.b')
hold off
title(sprintf('Weighted sum of squares of errors of simulated formulations\n'))
ylabel('weighted sum of squares of errors')
xlabel('hours')

%Plotting best release profile from given data
figure 
hold on
plot(hrs,tegretol,'r')
plot(hrs,best_prof,'b')
title(sprintf('Release Profiles of Tegretol and best candidate from the given data'));
xlabel('Time (hours)');
ylabel('Release percentage');
legend('Tegretols release profle','release profile of best candidate');
hold off

%Plotting best release profile from simulated data
figure 
hold on
plot(hrs,tegretol,'r')
plot(hrs,best_Prof,'c')
title(sprintf('Release Profiles of Tegretol and best candidate from simulated simulated data'));
xlabel('Time (hours)');
ylabel('Release percentage');
legend('Tegretols release profle','release profile of best candidate');
hold off


%plotting 2 best candidates and Tegretol 
figure 
hold on
plot(hrs,tegretol,'r')
plot(hrs,best_prof,'b')
plot(hrs,best_Prof,'c')
title(sprintf('Release Profiles of Tegretol and best candidates'));
xlabel('Time (hours)');
ylabel('Release percentage');
legend('Tegretols release profle','release profile of best candidate from given data','release profile of best candidate from simulated data');
hold off


%3D-plot of the weighted sum of squares of release profiles with respect to
%cbzcg and cbzfg
figure
[X,Y]=meshgrid(stps,stps);
surf(X,Y,grid);
colormap winter
xlabel('cbzcg');
ylabel('cbzfg');
zlabel('weighted sum of square errors')
title(sprintf('Weighted sum of squares errors for simulated data (*=minimum)'));

%plotting the minimum combination of cbzcg and cbzfg as *
Min=min(min(grid));
[x,y]=find(grid==Min);
hold on
plot3(stps(1,y),stps(1,x),Min,'*r');
hold off
