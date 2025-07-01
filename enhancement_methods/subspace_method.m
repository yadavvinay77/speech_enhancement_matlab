function enhanced = subspace_method(noisy, fs)
    % Simple SVD-based noise reduction
    L = 256;
    X = buffer(noisy, L, L-1, 'nodelay');
    R = cov(X');
    [V, D] = eig(R);
    thresh = mean(diag(D));  % threshold eigenvalues
    V_denoise = V(:, diag(D) > thresh);
    Y = V_denoise * (V_denoise' * X);
    enhanced = real(overlap_add(Y));
end

function sig = overlap_add(X)
    [L, N] = size(X);
    sig = zeros(1, L + N - 1);
    for n = 1:N
        sig(n:n+L-1) = sig(n:n+L-1) + X(:,n)';
    end
end
