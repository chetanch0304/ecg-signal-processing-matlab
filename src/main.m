%% ECG Signal Processing & R-Peak Detection Using MATLAB
% Educational project. Not for clinical diagnosis.
clear; clc; close all;

%% Configuration
projectRoot = fileparts(fileparts(mfilename('fullpath')));
resultsDir = fullfile(projectRoot, 'results');
if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

cfg.inputFile = ""; % Example: fullfile(projectRoot,'data','ecg.csv')
cfg.signalVariable = "ecg"; % Variable name for MAT files
cfg.csvColumn = 1;          % ECG column number for CSV files
cfg.fs = 250;               % Hz; replace with dataset's documented sampling rate
cfg.lowCutHz = 5;            % Hz
cfg.highCutHz = 18;           % Hz
cfg.filterOrder = 4;

rng(7); % Repeatable synthetic demo noise

%% Load ECG
[ecg, fs, sourceLabel] = loadECGSignal(cfg);
ecg = double(ecg(:));
t = (0:numel(ecg)-1)'/fs;

fprintf('Source: %s\n', sourceLabel);
fprintf('Samples: %d | Sampling frequency: %.2f Hz | Duration: %.2f s\n', ...
    numel(ecg), fs, numel(ecg)/fs);

%% Plot raw ECG
fig = figure('Name','Raw ECG','Color','w');
plot(t, ecg, 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Raw ECG Signal'); grid on;
saveas(fig, fullfile(resultsDir,'01_raw_ecg.png'));

%% FFT spectrum
n = numel(ecg);
xCentered = ecg - mean(ecg);
Y = fft(xCentered);
P2 = abs(Y/n);
P1 = P2(1:floor(n/2)+1);
if numel(P1) > 2
    P1(2:end-1) = 2*P1(2:end-1);
end
f = fs*(0:floor(n/2))/n;

fig = figure('Name','ECG FFT','Color','w');
plot(f, P1, 'LineWidth', 1);
xlim([0 min(60,fs/2)]);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Single-Sided FFT Magnitude Spectrum'); grid on;
saveas(fig, fullfile(resultsDir,'02_fft_spectrum.png'));

%% Filter signal
filteredECG = bandpassECG(ecg, fs, cfg.lowCutHz, cfg.highCutHz, cfg.filterOrder);

fig = figure('Name','Filtered ECG','Color','w');
plot(t, filteredECG, 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title(sprintf('Filtered ECG (%.1f–%.1f Hz Butterworth Band-Pass)', ...
    cfg.lowCutHz, cfg.highCutHz)); grid on;
saveas(fig, fullfile(resultsDir,'03_filtered_ecg.png'));

%% Detect R-peaks
[peakLocs, peakAmps] = detectRPeaks(filteredECG, fs);
peakTimes = (peakLocs-1)/fs;

fig = figure('Name','R-Peak Detection','Color','w');
plot(t, filteredECG, 'b-', 'LineWidth', 1); hold on;
plot(peakTimes, filteredECG(peakLocs), 'rv', ...
    'MarkerFaceColor','r','MarkerSize',6);
xlabel('Time (s)'); ylabel('Amplitude');
title('Filtered ECG with Detected Candidate R-Peaks');
legend('Filtered ECG','Detected candidate peaks','Location','best');
grid on;
saveas(fig, fullfile(resultsDir,'04_rpeak_detection.png'));

%% Heart-rate estimation
if numel(peakLocs) >= 2
    rrIntervals = diff(peakTimes);
    validRR = rrIntervals > 0.25 & rrIntervals < 2.0; % broad 30–240 BPM sanity range
    validRRIntervals = rrIntervals(validRR);
    if ~isempty(validRRIntervals)
        heartRates = 60 ./ validRRIntervals;
        averageHR = mean(heartRates);
    else
        heartRates = [];
        averageHR = NaN;
        warning('No R-R intervals passed the broad sanity check.');
    end
else
    rrIntervals = [];
    validRRIntervals = [];
    heartRates = [];
    averageHR = NaN;
    warning('Fewer than two peaks detected; heart rate cannot be estimated.');
end

fprintf('Candidate R-peaks detected: %d\n', numel(peakLocs));
if isfinite(averageHR)
    fprintf('Estimated average heart rate: %.1f BPM\n', averageHR);
else
    fprintf('Estimated average heart rate: unavailable\n');
end

%% Save detection summary
if isempty(peakLocs)
    summary = table([], [], 'VariableNames', {'PeakTime_s','PeakAmplitude'});
else
    summary = table(peakTimes(:), peakAmps(:), ...
        'VariableNames', {'PeakTime_s','PeakAmplitude'});
end
writetable(summary, fullfile(resultsDir,'rpeak_summary.csv'));

if numel(peakLocs) >= 2
    rrTable = table((1:numel(rrIntervals))', rrIntervals(:), ...
        'VariableNames', {'IntervalIndex','RRInterval_s'});
    writetable(rrTable, fullfile(resultsDir,'rr_intervals.csv'));
end

fprintf('Plots and summaries saved to: %s\n', resultsDir);
