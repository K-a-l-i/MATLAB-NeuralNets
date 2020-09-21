%143649
%Benjamin Strelitz
%MushroomBio Sim
%Finding conditions which produce maximum mushroom EPS Yield
%-------------------------------------------------------------------------

%--------------Clearing Workspace and Importing data----------------------
clear;clc;close all
format short
load MushroomEPS.mat

%---------------------Variable Setup--------------------------------------
%string vector to be used for graph titles
titles=string({"effect on EPS yield with varying yeast","effect on EPS yield with varying glucose","effect on EPS yield with varying pH","effect on EPS yield with varying temperature"});
%string vector containing xlabels for graphs
xlabs=string(["yeast","gluscose", "pH","temperature"]);
%variable finding the maximum biomass in the given data
Max_eps=max(t);
%finding the index of the max
max_indxs=find(t==Max_eps);
%finding the conditions that produced the maximum EPS
best_cond=p(:,max_indxs(1));

%setting up a matrix stps which stores possible values for each condition
%to be varied
%see 2.3) in README_(MushroomBiomass).txt for using a,b,c,d if
%required.
stps_temp=linspace(20,45,8);  %a) 6
stps_ph=linspace(4.5,10,8)    %b) 12
stps_glucose=linspace(0,45,8);%c) 10
stps_yeast=linspace(0.5,6,8); %d) 12
stps={stps_yeast; stps_glucose;stps_ph;stps_temp};

%initialising a condition vector to be altered using the data in stps
sim_cond=[0.5;0;4.5;25];
%matrix to store all simulated conditions
conds=[];
%vector to store all the resulting biomass yiels
bms=[];

%-----------------------Simulation-----------------------------------
%for loop designed to find every combination of conditions contained in
%stps. 
for l=2:size(stps_temp,2)
for i=2:size(stps_ph,2)
for j=2:size(stps_glucose,2)
for k=2:size(stps_yeast,2)
    sim_cond(1)=stps_yeast(k);
    %using mushnet to predict biomass
    BM=mushepsnet(sim_cond);
    conds=[conds,sim_cond];
    bms=[bms,BM];
    %output to user, allowing them to track simulation progress
    disp('Current condiontions under simulation:')
    fprintf("\nyeast: %g\nglucose: %g\nph: %g\ntemperature: %g\n\n",sim_cond(1),sim_cond(2),sim_cond(3),sim_cond(4))
    
end
sim_cond(2)=stps_glucose(j);
end
sim_cond(3)=stps_ph(i);
end
sim_cond(4)=stps_temp(l);
end
%finding the max biomass from simulation and its index
[sim_max,sim_indx]=max(bms);
%finding the conditions that produced the max biomass
Best_cond=conds(:,sim_indx);
%finding the percentage increase between the max predicted biomass and the
%max biomass from the given data
diff=((sim_max-Max_eps)/Max_eps)*100;

%-------------------------Results-------------------------------------------
clc;
disp('----------------------------------------------')
disp('FINAL RESULTS');
disp('----------------------------------------------')
%results for given data
disp('Best conditions for the given data were:')
fprintf("yeast: %g\nglucose: %g\nph: %g\ntemperature: %g\n\n\n",best_cond(1),best_cond(2),best_cond(3),best_cond(4))
disp('Giving an EPS yield of:')
disp(Max_eps)
%results for simulated data
disp('Best conditions for simulated data were:')
fprintf("yeast: %g\nglucose: %g\nph: %g\ntemperature: %g\n\n\n", Best_cond(1),Best_cond(2),Best_cond(3),Best_cond(4))
disp('Giving a predicted EPS yield of:')
disp(sim_max)

%Final output
fprintf("\nFor the limited search range of growing condition parameters, the findings of this study suggest \nthat for the best Biomass yield, growing conditions should be:\n ")
disp('-------------------------------------------------------------------------------------------------------------------------------------------')
if sim_max>Max_eps
    fprintf("yeast: %g\nglucose: %g\nph: %g\ntemperature: %g\n\n",Best_cond(1),Best_cond(2),Best_cond(3),Best_cond(4))
    disp('Giving a predicted EPS yield of:')
    disp(sim_max)
    fprintf("This is an increase of %g percent EPS over the best case for the given data.\nThe results of this study wer proudly brought to you by mushepsnet.\nHave a lovely day!\n", diff)
else
    fprintf("yeast: %g\nglucose: %g\nph: %g\ntemperature: %g\n\n",best_cond(1),best_cond(2),best_cond(3),best_cond(4))
    disp('Giving an EPS yield of:')
    disp(Max_eps)
    fprintf("The results of this study wer proudly brought to you by mushepsnet.\nHave a lovely day!\n")
end 

%---------------------Plotting-----------------------------------------
%Plotting biomass yield with respect to a single variable
for i=1:4
    %starts with the best condition 
    newcond=repmat(best_cond,1,cellfun('length',stps(i)));
for j=1:cellfun('length',stps(i))
    %updates the j'th condition
    newcond(i,j)=stps{i,1}(1,j);
end 
%simulates on the new data provided by the j'th update
y=mushepsnet(newcond);
x=newcond(i,:);
%plots result
figure
hold on
plot(x,y,'*')
title(sprintf('%s',titles(1,i)))
xlabel(sprintf('%s',xlabs(1,i)))
ylabel('EPS yield')
hold off
end


%plotting 3D surfaces. ALL THE STP VECTORS MUST BE THE SAME
%LENGTH! see 2.3) in README_(MushroomBiomass).txt for more detail
 %creates 4 choose 2 = 6 different plots, or the effect of 2 variables on
 %biomass yield
for i=1:3
    newcond=repmat(best_cond,1,cellfun('length',stps(i)));
    newcond(i,:)=stps{i,1}(1,:);
    for k=i+1:4
        grid=[];
        newcond(k,:)=stps{k,1}(1,:);

        for h=1:cellfun('length',stps(k))
            bio_row=[];
            for p=1:cellfun('length',stps(k))
                newcond2=best_cond;
                newcond2(i)=newcond(i,h);
                newcond2(k)=newcond(k,p);
                bio_row=[bio_row,mushepsnet(newcond2)];
            end
            grid=[grid;bio_row];    
        end
        %plotting graph
        figure
        [X,Y]=meshgrid(stps{i,1}(1,:),stps{k,1}(1,:));
        surf(X,Y,grid)
        view(3)
        xlabel(xlabs(i));
        ylabel(xlabs(k));
        zlabel('EPS');
        title(sprintf('EPS with respect to %s and %s : (*=maximum)',xlabs(i),xlabs(k)));
        %plotting max as *
        Max=max(max(grid));
        [x,y]=find(grid==Max);
        hold on
        plot3(stps{i,1}(1,y),stps{k,1}(1,x),Max,'*r');
        hold off
        
        
    end
end


