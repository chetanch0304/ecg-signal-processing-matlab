# Results

The PNG files in this folder are screenshots of the MATLAB figures captured during the project's demonstration run:

1. `01_raw_ecg.png` — raw synthetic ECG-like signal
2. `02_fft_spectrum.png` — single-sided FFT magnitude spectrum
3. `03_filtered_ecg.png` — Butterworth band-pass filtered signal
4. `04_rpeak_detection.png` — filtered signal with detected candidate R-peaks

Run `src/main.m` to generate fresh figures and CSV summaries (`rpeak_summary.csv` and, when available, `rr_intervals.csv`). The screenshots are from the synthetic demonstration signal, not a real patient recording. Numerical results should be taken from the MATLAB Command Window and generated CSV files after execution.
