function [phase, periodInPixels] = phaseMeasurement(patternRow, approximatePeriodInPixels, displayFigures)
% Computes the phase of a 1D pattern directly from the angle of the peak
%
%   Usage
%      phase = phaseMeasurement(patternRow, approximatePeriodInPixels)
%      [phase, periodInPixels] = phaseMeasurement(patternRow, approximatePeriodInPixels, displayFigures)
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
    spectrum = fft(hann(size(patternRow,2))'.*(patternRow - mean(patternRow)));
        
    %Search for the position of the frequency peak
    offsetMin = fix(ncols/approximatePeriodInPixels)-2;
    offsetMax = fix(ncols/approximatePeriodInPixels)+2;
    [~, maxPos] = max(spectrum(offsetMin:offsetMax));
    maxPos = maxPos + offsetMin - 1;

    %Get the period in pixel
    periodInPixels = ncols/maxPos;
    
    %Get the phase correspondign to the peak
    phase = mod(angle(spectrum(maxPos))-2*pi*ncols/2/periodInPixels-pi,2*pi);
    
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
        plot([maxPos maxPos],[0 abs(spectrum(maxPos))], 'r', 'linewidth', 2)
        hold off
        legend('spectrum', 'peak used')
        title('spectrum abs')    

    end
end