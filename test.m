% Simple test program to demonstrate the use of the four phase measurement methods 
% applied to a one dimensionnal pattern

% Parameters definition
ncols = 1024;
periodInPixels = 35.2345;
phase =  0.45

% Creation of a single dimensionnal periodic pattern
patternRow = periodicPattern(ncols, periodInPixels, phase);


% Phase measurement methods, comment / uncomment the one needed
[phase_reg, periodInPixels_reg] = phaseMeasurementWithLinearRegression(patternRow, fix(periodInPixels), 'on')
% [phase_peak, periodInPixels_peak] = phaseMeasurement(patternRow, fix(periodInPixels), 'on')
% [phase_zeros, periodInPixels_zeros] = phaseMeasurementWithZeroPadding(patternRow, fix(periodInPixels), 4096, 'on')
% [phase_interp, periodInPixels_interp] = phaseMeasurementWithPeakInterpolation(patternRow, fix(periodInPixels), 'on')