function window = gaussianWindow(ncols)
% Generates a 1D gaussian window
%

window = exp(-( ([1:ncols]-ncols/2-0.5) / (ncols/20) ).^2 );