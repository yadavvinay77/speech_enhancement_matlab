# Speech Enhancement MATLAB Project

This repository contains a MATLAB-based speech enhancement system implementing multiple enhancement algorithms with evaluation metrics.

## Project Structure

  speech_enhancement_matlab/
  ├── evaluate_dataset.m % Main script to run enhancements and evaluate
  ├── enhancement_methods/ % Enhancement algorithm implementations
  │ ├── spectral_subtraction.m
  │ ├── wiener_filter.m
  │ ├── logmmse.m
  │ └── subspace_method.m
  ├── utils/ % Utility functions for metrics computation
  │ ├── compute_snr.m
  │ ├── compute_pesq.m % (optional, requires VOICEBOX/ITU PESQ)
  │ └── compute_stoi.m % (optional)
  ├── data/ % Input audio data
  │ ├── clean_speech/
  │ └── noisy_speech/
  │ ├── babble/
  │ └── restaurant/
  ├── output/ % Output directory for enhanced audio results
  ├── .gitignore
  └── README.md


## Features

- Implements four speech enhancement methods:
  - Spectral Subtraction
  - Wiener Filter
  - LogMMSE (placeholder implementation)
  - Subspace Method

- Evaluates and compares enhancement performance using:
  - Signal-to-Noise Ratio (SNR)
  - PESQ and STOI (optional with VOICEBOX)

- Processes multiple noise types and SNR levels

## Usage

1. Organize your audio data in the `data/clean_speech` and `data/noisy_speech` folders.
2. Run the main script in MATLAB:

```matlab
evaluate_dataset;

3. Enhanced audio files and evaluation results will be saved in the output/ folder.

Requirements
MATLAB R2019b or later

Optional: VOICEBOX toolbox for PESQ and STOI computations

License
MIT License

