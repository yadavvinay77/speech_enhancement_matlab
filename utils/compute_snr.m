function val = compute_snr(ref, test)
    ref = ref(:);
    test = test(:);
    min_len = min(length(ref), length(test));
    ref = ref(1:min_len);
    test = test(1:min_len);

    noise = ref - test;
    val = 10 * log10(sum(ref.^2) / sum(noise.^2));
end
