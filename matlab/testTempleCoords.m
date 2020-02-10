% A test script using templeCoords.mat
%
% Write your code here
%

% Script for 3.1.5

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
load('../data/someCorresp.mat');

F = eightpoint(pts1, pts2, M);

% epipolarMatchGUI(img1, img2, F);

coords = load('../data/templeCoords.mat');

pts2 = epipolarCorrespondence(img1, img2, F, coords.pts1);

intrinsics = load('../data/intrinsics.mat');

E = essentialMatrix(F, intrinsics.K1, intrinsics.K2);

M2s = camera2(E);

R2 = M2s(:, 1:3, 3);
t2 = M2s(:, 4, 3);
NewM2 = [R2  t2];
P2 = intrinsics.K2 * NewM2;

R1 = eye(3);
t1 = zeros(3,1);
P1 = intrinsics.K1 * [R1 t1];

pts3 = triangulate(P1, coords.pts1, P2, pts2);

% Calculate Errors after reprojection
d1 = zeros(1, size(pts3, 1));
d2 = zeros(1, size(pts3, 1));
for i = 1:size(pts3, 1)
    pt = [pts3(i, :) 1];
    
    pt1 = P1 * pt';
    pt2 = P2 * pt';
    
    % Positive Depth Test (will only pass for the right )
    if (pt1(3) < 0) || (pt2(3) < 0)
       error('Some coordinates not in front of camera. Change projection matrix and try again!') 
    end
    
    pt1 = pt1 ./ pt1(3);
    pt2 = pt2 ./ pt2(3);
    
    d1(i) = sqrt((pt1(1) - coords.pts1(i, 1))^2 + (pt1(2) - coords.pts1(i, 2))^2);
    d2(i) = sqrt((pt2(1) - pts2(i, 1))^2 + (pt2(2) - pts2(i, 2))^2);
end

err1 = mean(d1);
err2 = mean(d2);

% Plot 3D points
plot3(pts3(:,1), pts3(:,2), pts3(:,3), '.', 'MarkerSize', 8)

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
