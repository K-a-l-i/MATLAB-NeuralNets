%Functio to check the weighted sum of squares error between tegretol's release
%profile and that of a different chemical formulation 'p'
function W=WSS(p)

%vector of values to be used in weighting
v=[8, 4, 2, 1, 1, 1];
c=norm(v);

%Vector of weights to be applied to sum of squares
weights=(1/c)*v';

%tegreto's release profile
tegretol=[15.7793567437954;28.3613302425898;42.4749917535373;56.2372188679933;67.1583991452967;78.3197984396481];

%weighted sum of squares error
W=sum(weights.*(tegretol-p).^2);
end
