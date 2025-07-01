function enhanced = spectral_subtraction(noisy, fs)
    frame_len = 256; 
    overlap = 128;
    win = hamming(frame_len, 'periodic');
    [S,~,~] = stft(noisy, fs, 'Window', win, 'OverlapLength', overlap);
    noise_est = mean(abs(S(:,1:5)), 2);
    S_enh = max(abs(S) - noise_est, 0.01) .* exp(1j * angle(S));
    enhanced = istft(S_enh, fs, 'Window', win, 'OverlapLength', overlap);
    enhanced = real(enhanced);
end
