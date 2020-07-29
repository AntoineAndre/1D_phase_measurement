% Simple test program to demonstrate the use of the four phase measurement methods 
% applied to a one dimensionnal pattern

% Parameters definition
ncols = 1024;
periodInPixels = 32.2345;
phase =  0.45

% Creation of a single dimensionnal periodic pattern
patternRow = periodicPattern(ncols, periodInPixels, phase);


% Phase measurement methods, comment / uncomment the one needed
[phase, periodInPixels] = phaseMeasurementWithLinearRegression(patternRow, fix(periodInPixels), 'on')
% [phase, periodInPixels] = phaseMeasurement(patternRow, fix(periodInPixels), 'on')
% [phase, periodInPixels] = phaseMeasurementWithZeroPadding(patternRow, fix(periodInPixels), 4096, 'on')
% [phase, periodInPixels] = phaseMeasurementWithPeakInterpolation(patternRow, fix(periodInPixels), 'on')