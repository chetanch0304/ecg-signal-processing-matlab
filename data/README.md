# ECG data

Keep input ECG files in this folder. The repository intentionally does not include patient data.

- CSV: one numeric ECG channel per row/column (configure which column is used in `src/main.m`)
- MAT: a numeric vector stored in a named variable (set `cfg.signalVariable`)
- Set the sampling frequency (`cfg.fs`) from the dataset documentation.

For public research data, see PhysioNet: https://physionet.org/
Check the dataset's license and citation requirements before redistribution.
