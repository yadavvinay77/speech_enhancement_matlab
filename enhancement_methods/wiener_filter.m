function enhanced = wiener_filter(noisy, fs)
    frame_len = 256; 
    overlap = 128;
    win = hamming(frame_len, 'periodic');
    [S,~,~] = stft(noisy, fs, 'Window', win, 'OverlapLength', overlap);
    noise_est = mean(abs(S(:,1:5)).^2, 2);
    S_pow = abs(S).^2;
    H = S_pow ./ (S_pow + noise_est);
    S_enh = H .* S;
    enhanced = istft(S_enh, fs, 'Window', win, 'OverlapLength', overlap);
    enhanced = real(enhanced);
end
