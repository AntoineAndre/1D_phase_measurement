function [refinedPosition,height]=quadraticPeakInterpolation(X,peakIndex)
% gives the refined position of a peak using quadratic interpolation around
%   the given index.
%
%   Usage
%      refinedPosition=quadraticPeakInterpolation(X)
%      refinedPosition=quadraticPeakInterpolation(X,peakIndex)
%      [refinedPosition,height]=quadraticPeakInterpolation(X,peakIndex)
%
%   Inputs
%      X (vector): data
%      peakIndex (optional scalar): index of the peak in X
%         default value = position of the largest element in X
%
%   Outputs
%      refinedPosition (scalar): refined position of the peak
%      height (optional scalar): value of the parabola at the
%         refined position
%
%   Remarks
%      Input values must respect 1 < peakIndex < length(X)
%
% This file is part of the Vernier Library.
% Copyright (c) 2015 FEMTO-ST, ENSMM, UFC, CNRS.

if nargin<2
    [m,peakIndex]=max(X);
end

numerator =   ( X(peakIndex-1) - X(peakIndex+1) );
denominator = ( X(peakIndex) - X(peakIndex+1) ) + ( X(peakIndex) - X(peakIndex-1) );

if denominator ~= 0
    refinedPosition = peakIndex - numerator/(2*denominator);
    
    if nargout==2    
        height = X(peakIndex) + (2*X(peakIndex) - X(peakIndex-1) - X(peakIndex+1))/2 * (peakIndex-refinedPosition)^2;
    end
else
    refinedPosition = peakIndex;
    height=X(peakIndex);

end


end