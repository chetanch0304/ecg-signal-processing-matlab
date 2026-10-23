function [ecg, fs, sourceLabel] = loadECGSignal(cfg)
%LOADECGSIGNAL Load a single-channel ECG or create a synthetic demo signal.
% cfg.inputFile: path to CSV/MAT file, or "" to use synthetic demo.
% cfg.fs: sampling frequency in Hz.
% cfg.signalVariable: variable name inside a MAT file.
% cfg.csvColumn: numeric column to use from a CSV file.

fs = cfg.fs;
sourceLabel = "Synthetic ECG-like demo (not patient data)";

if strlength(string(cfg.inputFile)) == 0
    durationSec = 10;
    t = (0:1/fs:durationSec-1/fs)';
    ecg = zeros(size(t));
    beatTimes = 0.8:0.9:(durationSec-0.5);
    for k = 1:numel(beatTimes)
        % Simple Gaussian components to mimic P, QRS and T morphology.
        ecg = ecg + 0.12*exp(-((t-(beatTimes(k)-0.20))/0.045).^2);
        ecg = ecg - 0.15*exp(-((t-(beatTimes(k)-0.035))/0.012).^2);
        ecg = ecg + 1.00*exp(-((t-beatTimes(k))/0.014).^2);
        ecg = ecg - 0.25*exp(-((t-(beatTimes(k)+0.025))/0.014).^2);
        ecg = ecg + 0.30*exp(-((t-(beatTimes(k)+0.25))/0.075).^2);
    end
    % Add modest baseline wander and noise for demonstration.
    ecg = ecg + 0.08*sin(2*pi*0.25*t) + 0.025*randn(size(t));
    return;
end

[~,~,ext] = fileparts(cfg.inputFile);
switch lower(ext)
    case '.csv'
        raw = readmatrix(cfg.inputFile);
        if isempty(raw) || size(raw,2) < cfg.csvColumn
            error('CSV file is empty or does not contain the configured column.');
        end
        ecg = raw(:,cfg.csvColumn);
        sourceLabel = "CSV: " + string(cfg.inputFile);
    case '.mat'
        loaded = load(cfg.inputFile);
        if ~isfield(loaded, cfg.signalVariable)
            error('Variable "%s" was not found in %s.', cfg.signalVariable, cfg.inputFile);
        end
        ecg = loaded.(cfg.signalVariable);
        sourceLabel = "MAT: " + string(cfg.inputFile);
    otherwise
        error('Unsupported file type "%s". Use .csv or .mat.', ext);
end

ecg = ecg(:);
ecg = ecg(isfinite(ecg));
if numel(ecg) < fs
    warning('The signal contains less than one second of valid samples.');
end
if isempty(ecg)
    error('No valid ECG samples were loaded.');
end
end
