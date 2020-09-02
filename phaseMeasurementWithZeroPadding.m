function [phase, periodInPixels] = phaseMeasurementWithZeroPadding(patternRow, approximatePeriodInPixels, n, displayFigures)
% Computes the phase and the period of a 1D pattern directly from the angle of the peak
% with a zero padded pattern
%
%   Usage
%      phase = phaseMeasurementWithZeroPadding(patternRow, approximatePeriodInPixels)
%      [phase, periodInPixels] = phaseMeasurementWithZeroPadding(patternRow, approximatePeriodInPixels, displayFigures)
%
%   Inputs   
%      patternRow: line vector of pixels
%      approximatePeriodInPixels: approximate value of the wavelength used 
%         for peak localization (in pixels)
%      n: patternRow is padded with zeros if it has less than n 
%         points and truncated if it has more.
%      displayFigures: if present some figures are displayed
%        
%   Outputs  
%      phase: measured phase of the pattern from the center of the row 
%         (in radian)
%      periodInPixels: measured value of the wavelength (in pixels)
%
    
    ncols = size(patternRow,2);
    ext = (n-ncols)/2;
    extendedPatternRow = [zeros(1,ext) hann(ncols)'.*(patternRow - mean(patternRow)) zeros(1,ext)];
   
    %Fourier transform without the continuous component
    spectrum = fft(extendedPatternRow);
        
    %Search for the position of the frequency peak
    offsetMin = fix(n/approximatePeriodInPixels)-10;
    offsetMax = fix(n/approximatePeriodInPixels)+10;
    [~, maxPos] = max(spectrum(offsetMin:offsetMax));
    maxPos = maxPos + offsetMin - 1;

    %Get the period in pixel
    periodInPixels = n/maxPos;
    
    %Get the phase correspondign to the peak
    phase = mod(angle(spectrum(maxPos))-2*pi*n/2/periodInPixels,2*pi)-pi;
    
    if nargin>3
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
        plot([maxPos maxPos],[0 abs(spectrum(maxPos))], 'r', 'linewidth', 2)
        hold off
        legend('spectrum', 'peak used')
        title('spectrum abs')    

    end
end