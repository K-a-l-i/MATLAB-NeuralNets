--------------------------------
README_(Ionosphere)
---------------------------------
The value: foF2 is the ordinary penetration frequency of the F2 layer of the ionosphere. The F2 layer is
the highest layer of the ionosphere. The ionosphere reflects all radio waves below a certain frequency (the
penetration frequency foF2), frequencies above that characteristic frequency pass through without being
reflected. This frequency is very simply related to the electron density of the ionosphere. Two “echos” of
the transmitted wave are received. This due to the differing ways in which circularly polarized radiation is
refracted by the ionosphere. The first echo is called the ordinary echo. The second is called the extraordinary
echo. So, in summary, the foF2 reading is the maximum ordinary frequency that is reflected by the F2 layer
of the ionosphere.

The file: fof2data.txt contains this data

Ionospher.m attempts to predict foF2 levels in the ionosphere as a function of: day
number (a number between 1 and 365), sunspot number (a number which indicates the level of sunspot
activity) and magnetic activity. Before training, the 'day number' variable was replaced with 2 cyclic time variables dnc and dns, which are both functions of the day number.

Deploy:

Ionospher.m is the only script that needs to be run.

ionosphere_rbe was included to show an attempt using radial basis function networks, but the performance on training data was terrible. This could be due to the massive amoount of data. Since centers are chosen randomly, it makes it incredibly likely that the centers chosen will not represent the underlying relationship between variables. Because the data is so large, choosing enough centers to accomplish this would require too much computation. It would be worthwhile to investigate selecting representative centers intentionally to see if this increases test performance 