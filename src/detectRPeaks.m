function [peakLocs, peakAmps] = detectRPeaks(filteredECG, fs)
%DETECTRPEAKS Detect candidate R-peaks using peak prominence and spacing.
% This is a simple educational detector, not a validated clinical algorithm.

x = double(filteredECG(:));

% For detection only, flip signal if the dominant QRS direction is negative.
if abs(min(x)) > abs(max(x))
    xDetect = -x;
else
    xDetect = x;
end

% Robust amplitude-based starting threshold.
signalRange = max(xDetect) - min(xDetect);
minProminence = max(0.15 * signalRange, eps);
minDistanceSamples = round(0.25 * fs); % allows up to about 240 BPM

[peakAmps, peakLocs] = findpeaks(xDetect, ...
    'MinPeakProminence', minProminence, ...
    'MinPeakDistance', minDistanceSamples);

% Convert amplitudes back to original signal polarity for reporting.
if abs(min(x)) > abs(max(x))
    peakAmps = -peakAmps;
end
end
