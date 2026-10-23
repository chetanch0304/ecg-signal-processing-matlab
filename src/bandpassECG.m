function filtered = bandpassECG(ecg, fs, lowCutHz, highCutHz, filterOrder)
%BANDPASSECG Apply a zero-phase Butterworth band-pass filter to ECG data.
% Cutoffs must satisfy 0 < lowCutHz < highCutHz < fs/2.

if lowCutHz <= 0 || highCutHz <= lowCutHz || highCutHz >= fs/2
    error('Require 0 < lowCutHz < highCutHz < fs/2. Check fs and cutoff values.');
end
[b,a] = butter(filterOrder, [lowCutHz highCutHz]/(fs/2), 'bandpass');
filtered = filtfilt(b,a,double(ecg(:)));
end
