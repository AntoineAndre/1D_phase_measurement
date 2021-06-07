function [phase, periodInPixels] = phaseMeasurementWithLinearRegression(patternRow, approximatePeriodInPixels, displayFigures)
% Computes the phase and the period of a 1D pattern as described in: 
%   
%   Andre, A. N., Sandoz, P., Mauze, B., Jacquot, M., & Laurent, G. J. (2020). 
%   Sensing one nanometer over ten centimeters: A micro-encoded target for visual 
%   in-plane position measurement. IEEE/ASME Trans. Mechatronics.
%
%   Usage
%      periodInPixels = phaseMeasurementWithLinearRegression(patternRow, approximatePeriodInPixels)
%      [phase, periodInPixels] = phaseMeasurementWithLinearRegression(patternRow, approximatePeriodInPixels, displayFigures)
%
%   Inputs   
%      patternRow: line vector of pixels
%      approximatePeriodInPixels: approximate value of the wavelength used 
%         for peak localization (in pixels)
%      displayFigures: if feedback figures are to be displayed on screen
%        
%   Outputs  
%      phase: measured phase of the pattern from the center of the row 
%         (in radian)
%      periodInPixels: measured value of the wavelength (in pixels)
%

    %Fourier transform without the continuous component
    spectrum = fftshift(fft(patternRow - mean(patternRow)));
    
    length_tot = size(spectrum,2);
    length_window = size(spectrum,2)/2;

    %Search for the position of the frequency peak
    offsetMin = fix(length_tot/(approximatePeriodInPixels+2));
    offsetMax = fix(length_tot/(approximatePeriodInPixels-2));
    [maxVal, maxPos] = max(spectrum(length_tot/2+offsetMin:length_tot/2+offsetMax));

    col = 1:size(spectrum,2);
    col = (col - maxPos - offsetMin - length_tot/2 + 1)/length_tot;
    sigmaPercent = 0.002;

    hyperGaussianFilter = exp(-power(col/sigmaPercent, 2));

    %Filter the inverse Fourier transform angle with the hyperGaussian
    %filter
    wrappedPhase = double(angle(ifft(fftshift(spectrum.*hyperGaussianFilter))));

    %unwrap from the center point
    unwrappedPhase = wrappedPhase(length_window/2 + 1:3*length_window/2);
    unwrappedPhase(length_window/2:length_window) = unwrap(unwrappedPhase(length_window/2:length_window));
    unwrappedPhase(length_window/2:-1:1) = unwrap(unwrappedPhase(length_window/2:-1:1));

    x = -length_window/2+0.5:length_window/2-0.5;

    %Least squares method to fit the unwrapped phase
    m = (length_window*sum(x.*unwrappedPhase) - sum(x)*sum(unwrappedPhase))/(length_window*sum(x.*x) - sum(x)^2);
    phase = (sum(unwrappedPhase) - m*sum(x))/length_window;
    
    %Period of the pattern is directly given by the slope of the regression
    %line
    periodInPixels = 2*pi/m;
    
    %r^2 indicator of fit quality
    r2 = 1 - sum((unwrappedPhase - m.*x).^2)/sum((unwrappedPhase - mean(unwrappedPhase)).^2);

    if nargin>2
        figure(1);
        set(gcf, 'Position',  [200, 100, 900, 900])

        subplot(2,2,1);
        plot(patternRow, 'b', 'linewidth', 2)
        hold on
        plot(periodicPattern(size(patternRow,2), periodInPixels, phase), 'r', 'linewidth', 2);
        hold off
        title('row pattern')
        xlabel('pixels')
        ylabel('mean intensity')    

        subplot(2,2,2);
        plot(abs(spectrum), 'b', 'linewidth', 2)
        hold on
        plot(hyperGaussianFilter*abs(maxVal), 'r', 'linewidth', 2)
        hold off
        legend('spectrum', 'gaussian filter')
        title('spectrum abs')    

        subplot(2,2,3);
        plot(wrappedPhase, 'b', 'linewidth', 2)
        title('wrapped phase')
        xlabel('pixels')
        ylabel('rad.')    

        subplot(2,2,4);
        plot(x, unwrappedPhase, 'b', 'linewidth', 2)
        hold on
        plot(x, m.*x + phase, 'r--', 'linewidth', 2)
        hold off
        text(x(end)/2 + 15, 10, num2str(r2))
        legend('unwrapped phase', 'LSQ fit')
        title('unwrapped phase')
        xlabel('pixels')
        ylabel('rad.')
    end
end