% Scripts to reproduce the figures of the report
% This work in progress has sadly not been finished in time
% it has forced us to write a parametrable, reproducible code
% instead of changing it for each test

% Length
testBlurDeblur(1, 0, 60,  0, 3)
% Lucy
testBlurDeblur(1, 1, 60, 30, 2, 100)
testBlurDeblur(1, 1, 60, 30, 3, 100)
testBlurDeblur(1, 5, 60, 30, 2, 100)
testBlurDeblur(1, 5, 60, 30, 3, 100)
testBlurDeblur(1, 6, 60, 30, 2, 100)
testBlurDeblur(1, 6, 60, 30, 3, 100)

% Foreground
testCam(0,0,1,2,0)