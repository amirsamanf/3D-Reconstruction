clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2);
[nR, nC] = size(rectIL);

i1 = rectIL(:, nC/2+1:end);
i2 = rectIR(:, 1:nC/2);

maxDisp = 30; 
windowSize = 5;
dispM = get_disparity(i1, i2, maxDisp, windowSize);

% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);


% --------------------  Display

figure; imagesc(dispM.*(i1>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(i1>40)); colormap(gray); axis image;
