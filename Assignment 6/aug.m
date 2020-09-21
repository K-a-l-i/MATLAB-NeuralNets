%{
Benjamin Strelitz
G14s3649
aug
accepts a matrix ,P, and augments the last row with a row of ones
%}
function Pa = aug(P)
    Pa = [P; ones([1, size(P,2)])];
end
