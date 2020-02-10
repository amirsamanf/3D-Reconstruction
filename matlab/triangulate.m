function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%

n = size(pts1,1);
pts3d = zeros(n,4);
for i = 1:size(pts1,1)
    x = pts1(i,1);
    y = pts1(i,2);
    X = pts2(i,1);
    Y = pts2(i,2);
    
    A = [y*P1(3,:) - P1(2,:); P1(1,:) - x*P1(3,:); Y*P2(3,:) - P2(2,:); P2(1,:) - X*P2(3,:)];
  
    [~,~,v] = svd(A);
    
    pts3d(i,:) = v(:,4)';
    pts3d(i,:) = pts3d(i,:) ./ pts3d(i,4);

end

pts3d = pts3d(:, 1:3);

