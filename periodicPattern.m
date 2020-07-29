function patternRow = periodicPattern(ncols, periodInPixels, phase)
% Generates a 1D periodic pattern
%

patternRow = 0.5+0.5*cos (phase+2*pi*([1:ncols]-ncols/2-0.5)/periodInPixels);

