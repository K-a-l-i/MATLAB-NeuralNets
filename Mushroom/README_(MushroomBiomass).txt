----------------------------------------------------------------
README_(MushroomBiomass).txt
----------------------------------------------------------------

King Tuber Oyster mushrooms were grown under various conditions. The original data for this study contained multiple incorrect entries and outliers. The cleaned data can be found in the file MushDataBio.xlsx 

The training and deployment of the MushroomBio scripts are done with the purpose of find conditions which produce maximum mushroom biomass. The conditions which were varied were:
• yeast extract (grams per litre)
• glucose (grams per litre)
• pH
• temperature (degrees Celsius)
Optimal growing conditions for each of these objectives was then discovered by the network.

1 Deployment:

Please run MushroomBio.m  to train the network followed by MushBioSim.m to deploy the net and obtain optimal growing conditions. 

The other scripts included are MushroomBio2.m and MushroomBio3.m These are additional training scripts which use different methods for finding the 'best' netwrok architecture, however, were not as successful as MushroomBio.m. 

MushroomBioRBE.m is a radial basis function network designed to do the same as MushroomBio.m, but does so with less consistency. This is likely due to the small amount of data. Results for this network are near perfect for training, because it uses all training examples as centers. However, its ability to generalize to test data is varied becuase data points are distinct enough for some test examples to not be represented by the choice of centers. Test performance is thus determined by the random selection of centers, and would be far more consistent if representative centers were specifically chosen.

2 Simulation:

2.1) The biggest consideration for the deployment of the network was the range of growing conditions:

2.2) The range impacts the 'accuracy' of the networks prediction by allowing for more or less discrete data to be simulated on. While the best case would be to have as many data points as possible for the variables, this hampers training time significantly. While this is always the case (more data -> longer training), this is particulary true when considering the algorithm used in MushBioSim to generate data, which takes every combination of each value for each variable with every other. This was done for 'completeness'.

2.3) Another consideration for the range of values is needing to plot combinations of them in 3 dimenstions, and so the same number of data points for each variable need to be collected. Given the scale of the variables is different, this is not always trivial as it means data points will not always increment in simple values (1, 0.1,0.5 etc). These incrementations are given in the matrix stps. The values a,b,c,d are the number of increments for each linspace vector to be used (i.e stps_temp=linspace(20,45, a)), to give rounder increments. More importantly, using a,b,c,d will allow for conditions yeast=4, glucose=40, ph=7, temp=35 to be simulated. These are the conditions that yield the most biomass from the given data, stored in the variable best_cond.
NB: Note that whenever adjusting the number of increments for each linspace stps vector, if these vectors are not the same length 3D plots will not generate (as is the case when using a,b,c,d)
 
2.4) best_cond is important for the final results comparison, but also gives a very real indication of how accurate/inaccurate the network's simulations are. The biomass produced by these conditions is given as 0.257000000000000. However, when stps is defined using no. of inrements a,b,c,d, the predicted biomass for these same conditions is approximately 0.054320913412808. This gives an indication of the networks inaccuracy, and that its recommendations serve more as a general guideline



