function evaluate_dataset()
    clear; clc;

    % Setup paths
    clean_dir = fullfile('data', 'clean_speech');
    noisy_root = fullfile('data', 'noisy_speech');
    noise_types = {'babble', 'restaurant'};
    snr_levels = {'0dB', '5dB', '10dB', '15dB'};

    methods = {@spectral_subtraction, @wiener_filter, @logmmse, @subspace_method};
    method_names = {'SpectralSub', 'Wiener', 'LogMMSE', 'Subspace'};

    % Iterate methods
    for m = 1:length(methods)
        fprintf('\n=== Method: %s ===\n', method_names{m});
        for i = 1:length(noise_types)
            for j = 1:length(snr_levels)
                noise_dir = fullfile(noisy_root, noise_types{i}, snr_levels{j});
                if ~isfolder(noise_dir), continue; end
                out_dir = fullfile('output', method_names{m}, noise_types{i}, snr_levels{j});
                if ~isfolder(out_dir), mkdir(out_dir); end

                files = dir(fullfile(noise_dir, '*.wav'));
                for k = 1:length(files)
                    noisy_path = fullfile(noise_dir, files(k).name);
                    [noisy, fs] = audioread(noisy_path);

                    % Derive clean file name: "sp01_restaurant_sn10.wav" -> "sp01.wav"
                    split_name = split(files(k).name, '_');
                    clean_name = strcat(split_name{1}, '.wav');
                    clean_path = fullfile(clean_dir, clean_name);

                    if ~isfile(clean_path)
                        fprintf('[%d/%d] %s | Enhanced and saved (No clean reference)\n', k, length(files), files(k).name);
                        % Enhance and save anyway (optional)
                        enhanced = methods{m}(noisy, fs);
                        enhanced = real(enhanced);
                        audiowrite(fullfile(out_dir, files(k).name), enhanced, fs);
                        continue;
                    end

                    [clean, ~] = audioread(clean_path);

                    % Align lengths before enhancement
                    min_len_pre = min([length(clean), length(noisy)]);
                    noisy = noisy(1:min_len_pre);
                    clean = clean(1:min_len_pre);

                    % Enhance
                    enhanced = methods{m}(noisy, fs);
                    enhanced = real(enhanced);

                    % Align lengths after enhancement
                    min_len_post = min([length(clean), length(noisy), length(enhanced)]);
                    clean = clean(1:min_len_post);
                    noisy = noisy(1:min_len_post);
                    enhanced = enhanced(1:min_len_post);
                    
                    % Ensure column vectors
                    clean = clean(:);
                    noisy = noisy(:);
                    enhanced = enhanced(:);
                    
                    % Clip enhanced signal to [-1, 1] to avoid audiowrite clipping warning
                    enhanced = max(min(enhanced, 1), -1);
                    
                    % Save output
                    audiowrite(fullfile(out_dir, files(k).name), enhanced, fs);
                    
                    % Compute SNR before and after enhancement
                    snr_before = compute_snr(clean, noisy);
                    snr_after  = compute_snr(clean, enhanced);
                    fprintf('[%d/%d] %s | SNR: %.2f → %.2f dB\n', k, length(files), files(k).name, snr_before, snr_after);
                end
            end
        end
    end
end
