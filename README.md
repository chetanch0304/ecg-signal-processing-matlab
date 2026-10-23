# ECG Signal Processing & R-Peak Detection Using MATLAB

A MATLAB project starter for ECG preprocessing, frequency-domain analysis, R-peak detection, and heart-rate estimation.

> **Important:** This repository is an educational DSP project, not a medical diagnostic tool. Validate results against annotated ECG data before reporting detector accuracy. The included fallback signal is synthetic and must not be described as a real patient recording.

## Features
- Load ECG data from a `.mat` or `.csv` file, or generate a synthetic demo signal
- Plot raw ECG in the time domain
- Inspect the frequency spectrum using the FFT
- Apply a Butterworth band-pass filter
- Detect candidate R-peaks using peak prominence and minimum separation
- Calculate R-R intervals and average heart rate (BPM)
- Save figures and numerical results to `results/`

## Requirements
- MATLAB (R2019b or later recommended)
- Signal Processing Toolbox for `butter`, `filtfilt`, and `findpeaks`

## Quick start
1. Download or clone this repository.
2. Open MATLAB and set the current folder to the repository root.
3. Run:

   ```matlab
   run('src/main.m')
   ```

4. If no input data is configured, the script creates a synthetic ECG-like signal for a pipeline demonstration.
5. Review figures and output files in `results/`.

## Using your own ECG data
### Option A: CSV
Place a CSV file in `data/` with one ECG column. If it contains a header row, MATLAB's `readmatrix` usually handles it. Set `cfg.inputFile` in `src/main.m` to the file path and set `cfg.fs` to the correct sampling frequency.

### Option B: MAT
Place a `.mat` file in `data/` containing a numeric vector. Set `cfg.inputFile` and `cfg.signalVariable` in `src/main.m` to the file path and variable name.

**Use the dataset's documented sampling frequency. Do not guess `fs`.** The script assumes one ECG channel. If your file contains multiple columns, select the ECG column before processing.

## Project workflow
1. Acquire/load ECG samples and sampling frequency.
2. Visualize the raw signal.
3. Inspect the one-sided FFT magnitude spectrum.
4. Filter the signal to reduce baseline drift and high-frequency noise.
5. Detect candidate R-peaks.
6. Calculate R-R intervals and estimate heart rate.
7. Save plots and a CSV summary.

## Repository structure
```text
ecg-signal-processing-matlab/
├── README.md
├── LICENSE
├── .gitignore
├── src/
│   ├── main.m
│   ├── loadECGSignal.m
│   ├── bandpassECG.m
│   └── detectRPeaks.m
├── data/
│   └── README.md
├── results/
│   └── README.md
└── docs/
    └── PROJECT_REPORT.md
```

## Outputs
The script saves:
- `results/01_raw_ecg.png`
- `results/02_fft_spectrum.png`
- `results/03_filtered_ecg.png`
- `results/04_rpeak_detection.png`
- `results/rpeak_summary.csv`

These are generated only after running the MATLAB script.

## Limitations
- Simple threshold/prominence-based detection may fail on noisy, inverted, or unusual ECG morphologies.
- Filter cutoffs should be selected with respect to sampling frequency and the dataset.
- No clinical claims should be made from this educational implementation.
- For formal performance evaluation, compare detections against reference annotations and report sensitivity and positive predictive value.

## Suggested future improvements
- Implement the Pan–Tompkins QRS detection algorithm
- Evaluate on an annotated PhysioNet dataset
- Add sensitivity, positive predictive value, and F1-score calculations
- Compare FIR and IIR filters
- Add a MATLAB App Designer interface

## References
- MathWorks, *Signal Processing Toolbox Documentation*: https://www.mathworks.com/help/signal/
- PhysioNet, physiological signal databases: https://physionet.org/
- J. Pan and W. J. Tompkins, “A Real-Time QRS Detection Algorithm,” *IEEE Transactions on Biomedical Engineering*, 1985.
