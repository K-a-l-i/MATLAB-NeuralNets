function v=randu(a,b,varargin)
%randu.m
% computes a matrix of size varargin
% true random numbers
% uniformly distributed in [a,b)
%usage: v=randu(a,b,matrixsize)
%matrix may be multidimensional

z=rand(varargin{:});
v=(b-a)*z+a;





