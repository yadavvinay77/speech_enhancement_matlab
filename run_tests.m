% run_tests.m
try
    evaluate_dataset(); % or any test functions you want to run
    exit(0); % success
catch ME
    disp(getReport(ME));
    exit(1); % failure
end
