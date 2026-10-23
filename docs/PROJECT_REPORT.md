# ECG Signal Processing & R-Peak Detection Using MATLAB

## Abstract
An electrocardiogram (ECG) represents the electrical activity of the heart over time. This project studies a MATLAB workflow for loading an ECG signal, examining its time- and frequency-domain characteristics, filtering noise, detecting candidate R-peaks, and estimating heart rate from R-R intervals. Experimental results and numerical performance claims should be added only after running the implementation on a documented dataset.

## 1. Introduction
ECG signals contain characteristic P waves, QRS complexes, and T waves. R-peaks provide useful timing markers for measuring the intervals between heartbeats. Real recordings can contain baseline wander, power-line interference, muscle noise, and motion artifacts, which can complicate peak detection.

## 2. Problem statement
Develop a MATLAB-based signal-processing pipeline that reduces common ECG noise, detects candidate R-peaks, and estimates heart rate from detected beat locations.

## 3. Objectives
- Load and visualize a sampled ECG.
- Analyze the signal using FFT.
- Apply digital filtering.
- Detect candidate R-peaks.
- Calculate R-R intervals and estimated heart rate.
- Save plots and summary files for evaluation.

## 4. Methodology
1. Load ECG samples and the documented sampling frequency.
2. Plot the raw ECG waveform.
3. Calculate and display the single-sided FFT magnitude spectrum.
4. Apply a Butterworth band-pass filter.
5. Detect candidate peaks using prominence and minimum-distance constraints.
6. Convert peak indices into time values.
7. Calculate R-R intervals and estimate BPM.
8. Save plots and CSV summaries.

## 5. Theory
For sampling frequency `Fs`, sample index `n` corresponds approximately to time `t = (n-1)/Fs` in MATLAB indexing. Given an R-R interval in seconds, heart rate can be estimated as `HR = 60/RR`. A band-pass filter can attenuate low-frequency baseline drift and high-frequency noise, but cutoffs must be selected based on the data and sampling frequency.

## 6. Expected outputs
The code is intended to generate raw ECG, FFT, filtered ECG, and R-peak detection plots, along with CSV files containing peak locations and R-R intervals. Outputs depend on the input signal and parameters.

## 7. Evaluation
If annotated reference beats are available, compare detections against annotations. Report true positives (TP), false positives (FP), and false negatives (FN). Sensitivity is `TP/(TP+FN)` and positive predictive value is `TP/(TP+FP)`. Do not report accuracy values until measured.

## 8. Limitations
The current detector uses a simple peak-prominence rule and is not a clinically validated QRS detector. It may fail for noisy signals, unusual ECG morphology, or inappropriate filter settings. The synthetic fallback is only for software demonstration.

## 9. Future scope
- Implement the Pan–Tompkins algorithm.
- Evaluate on annotated PhysioNet data.
- Compare FIR and IIR filters.
- Add sensitivity, positive predictive value, and F1-score calculations.
- Build a real-time or App Designer interface.

## 10. Conclusion
This project demonstrates core DSP concepts on ECG data: sampling, FFT analysis, digital filtering, peak detection, and heart-rate estimation. Results should be validated using real, documented ECG recordings before making performance claims.

## References
1. J. Pan and W. J. Tompkins, “A Real-Time QRS Detection Algorithm,” *IEEE Transactions on Biomedical Engineering*, 1985.
2. MathWorks, Signal Processing Toolbox documentation: https://www.mathworks.com/help/signal/
3. PhysioNet: https://physionet.org/
4. Rangaraj M. Rangayyan, *Biomedical Signal Analysis: A Case-Study Approach*.
