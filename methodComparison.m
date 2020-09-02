nCols = 1024;
nTests = 1000;

phaseValues=zeros(1,nTests);
periodValues=zeros(1,nTests);

phaseErrors=zeros(1,nTests);
periodErrors=zeros(1,nTests);

phaseErrorsWithZeroPadding=zeros(1,nTests);
periodErrorsWithZeroPadding=zeros(1,nTests);

phaseErrorsWithPeakInterpolation=zeros(1,nTests);
periodErrorsWithPeakInterpolation=zeros(1,nTests);

phaseErrorsWithLinearRegression=zeros(1,nTests);
periodErrorsWithLinearRegression=zeros(1,nTests);

for i=1:nTests
    
    period = 15+50*rand;
    phase =  2*pi*rand-pi;
    phaseValues(i) = phase;
    periodValues(i) = period; 
    patternRow = periodicPattern(nCols, period, phase);

    [estimatedPhase, estimatedPeriod] = phaseMeasurement(patternRow, fix(period));
    phaseErrors(i) = abs(angdiff(estimatedPhase,phase));
    periodErrors(i) = abs(estimatedPeriod-period);
    
    [estimatedPhase, estimatedPeriod] = phaseMeasurementWithZeroPadding(patternRow, fix(period), 2048);
    phaseErrorsWithZeroPadding(i) =abs(angdiff(estimatedPhase,phase));
    periodErrorsWithZeroPadding(i) = abs(estimatedPeriod-period);
    
    [estimatedPhase, estimatedPeriod] = phaseMeasurementWithPeakInterpolation(patternRow, fix(period));
    phaseErrorsWithPeakInterpolation(i) = abs(angdiff(estimatedPhase,phase));
    periodErrorsWithPeakInterpolation(i) = abs(estimatedPeriod-period);
    
    [estimatedPhase, estimatedPeriod] = phaseMeasurementWithLinearRegression(patternRow, fix(period));
    phaseErrorsWithLinearRegression(i) = abs(angdiff(estimatedPhase,phase));
    periodErrorsWithLinearRegression(i) = abs(estimatedPeriod-period);
    
end

figure(1);

subplot(2,1,1);
plot(periodValues,phaseErrors,'+b');
hold on;
plot(periodValues,phaseErrorsWithZeroPadding,'+c');
plot(periodValues,phaseErrorsWithPeakInterpolation,'+r');
plot(periodValues,phaseErrorsWithLinearRegression,'+g');
xlabel('Period (pixels)');
ylabel('Phase estimation error (rad)');
legend('phaseMeasurement','phaseMeasurementWithZeroPadding','phaseMeasurementWithPeakInterpolation','phaseMeasurementWithLinearRegression');
hold off;

subplot(2,1,2);
plot(periodValues,periodErrors,'+b');
hold on;
plot(periodValues,periodErrorsWithZeroPadding,'+c');
plot(periodValues,periodErrorsWithPeakInterpolation,'+r');
plot(periodValues,periodErrorsWithLinearRegression,'+g');
xlabel('Period (pixels)');
ylabel('Period estimation error (pixels)');
legend('phaseMeasurement','phaseMeasurementWithZeroPadding','phaseMeasurementWithPeakInterpolation','phaseMeasurementWithLinearRegression');
hold off;

