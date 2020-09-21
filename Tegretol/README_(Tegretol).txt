-------------------------------------------------------------------
README_Tegretol
--------------------------------------------------------------------
Tegretol is the brand name for a sustained–release tablet for the treatment of epilepsy. The active ingredient,
Carbamazapinene (CBZ), is released from the tablet into the blood in such a way that there is an initial
surge of CBZ and thereafter, the concentration of CBZ in the blood is sustained.

Tegretol.m trains a neural network which can be used to simulate the relationship between formulations and
release profiles.

CBZ was used in two grades: CBZ CG (coarse grade CBZ), CBZ FG (fine grade CBZ).

Once a suitable neural network was found, the ratio of CBZ CG: CBZ FG was varied over a range
and the net simulated on each of the constructed formulations. The corresponding release profiles were
compared with that of Tegretol. In this way, a formulation which produced a release profile which matched
that of Tegretol closely was found by TegreolSim.m

Deployment:

Please run Tegretol.m first to train Tegretolnet first, followed by TegretolSim.m to simulate unique data and search for the best release profile.

TegretolSim2.m is included just to show that different (albeit far less successful) attempts were made to simulate on new data.

TegretolRBE.m trains a radial basis function network to find the relationship between cbz content and release profiles, although is far less accurate on test data than Tegretol.m on average. This is more than likely due to the small amount of data used, which makes it difficult for representative centers to be found as there is a large amount of variation in feature vectors from the given data. Depending on the randomly selected centers, the network either does incredibly well or incredibly poorly.

Note on Results:
It must be mentioned that Tegretolnet is not completely accurate. It incorrectly predicts the release profiles for the given data (can be checked by comparison when simulating data with stps). Thus it incorrectly predicts the weighted sum of the squares of the erros for the the release profile of Tregretol and the simulated profiles.. That being said, the difference in the weighted sum of squares of errors between the best from the given data and the best from the simulated data to suggest that Tegretol's prediction is still close enough, and gives a good indication of the best formulation.
Additionally, even though in the given data, cbzfg and cbzcg content seemed to have an inverse relationship, this ratio was not clear. Thus a safe approach seemed to be to simulated all possible combinations of both variables, with a given stepsize. In this case 1 was chosen as the stepsize to accomodate both efficiency and accuracy.