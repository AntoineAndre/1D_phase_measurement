function [phase, periodInPixels] = phaseMeasurementWithPeakInterpolation(patternRow, approximatePeriodInPixels, displayFigures)
% Computes the phase and the period of a 1D pattern as described in: 
%   
%   Guelpa, V., Laurent, G. J., Sandoz, P., Zea, J. G., & Clévy, C. (2014). 
%   Subpixelic measurement of large 1D displacements: Principle, processing 
%   algorithms, performances and software. Sensors, 14(3), 5056-5073.
%
%   Usage
%      phase = phaseMeasurementWithPeakInterpolation(patternRow, approximatePeriodInPixels)
%      [phase, periodInPixels] = phaseMeasurementWithPeakInterpolation(patternRow, approximatePeriodInPixels, displayFigures)
%
%   Inputs   
%      patternRow: line vector of pixels
%      approximatePeriodInPixels: approximate value of the wavelength used 
%         for peak localization (in pixels)
%      displayFigures: if present some figures are displayed
%        
%   Outputs  
%      phase: measured phase of the pattern from the center of the row 
%         (in radian)
%      periodInPixels: measured value of the wavelength (in pixels)
%

    ncols = size(patternRow,2);

    %Fourier transform without the continuous component
    spectrum = fft(patternRow - mean(patternRow));
        
    %Search for the position of the frequency peak
    offsetMin = fix(ncols/approximatePeriodInPixels)-2;
    offsetMax = fix(ncols/approximatePeriodInPixels)+2;
    [~, maxPos] = max(spectrum(offsetMin:offsetMax));
    maxPos = maxPos + offsetMin - 1;
    
    refinedPos = quadraticPeakInterpolation(abs(spectrum),maxPos);
    
    periodInPixels = ncols/refinedPos;
    
    patternRowCos = 2*(periodicPattern(ncols, periodInPixels, 0.0)-0.5);
    patternRowSin = 2*(periodicPattern(ncols, periodInPixels, pi/2)-0.5);
    window = gaussianWindow(ncols);
    
    %Get the phase correspondign to the peak
    phase = atan2(sum(patternRow.*patternRowSin.*window),sum(patternRow.*patternRowCos.*window));
    
    
    if nargin>2
        figure(1);
        set(gcf, 'Position',  [200, 100, 900, 900])

        subplot(2,1,1);
        plot(patternRow, 'b', 'linewidth', 2)
        hold on
        plot(periodicPattern(ncols, periodInPixels, phase), 'r', 'linewidth', 2);
        hold off
        title('row pattern')
        xlabel('pixels')
        ylabel('mean intensity')    

        subplot(2,1,2);
        plot(abs(spectrum(1:ncols/2)), 'b', 'linewidth', 2)
        hold on
        plot([refinedPos refinedPos],[0 abs(spectrum(maxPos))], 'r', 'linewidth', 2)
        hold off
        legend('spectrum', 'peak used')
        title('spectrum abs')     

    end
end