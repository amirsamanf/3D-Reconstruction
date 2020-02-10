function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)

[rows,cols,~]= size(im2);

pts1 = round(pts1);

bestCandids = zeros(size(pts1, 1), 2);
for i=1:size(pts1, 1)
    p(1) = pts1(i, 1);
    p(2) = pts1(i, 2);
    p(3) = 1;
   
    l = F * p';
   
    s = sqrt(l(1)^2+l(2)^2);

    if s==0
        error('Zero line vector');
    end
    
    l = l/s;    
    
    candidatePoints = zeros(cols, 2);
    candidatePoints(:,1) = (1:cols);
    for x = 1:cols        
        y = -(l(1) * x + l(3))/l(2);
        candidatePoints(x,2) = round(y);
    end
%     onesCol = ones(cols,1);
%     candidatePoints = [candidatePoints onesCol];
   
    %%%%%%%%WINDOW
    %Zero pad image
    padding = 5;
    paddedImage1 = padarray(im1, [padding padding], 'both');   
    paddedImage2 = padarray(im2, [padding padding], 'both');    
    
    im1Point = [p(2)/p(3),p(1)/p(3)];
    dist = double(zeros(size(candidatePoints, 1), 1));
    for k = padding+1:size(candidatePoints, 1) - padding
        squaredDist = 0;
        for kRow = -padding:1:padding
            for kCol = -padding:1:padding
                squaredDist = squaredDist + double((double(paddedImage2(candidatePoints(k,2)+kRow, candidatePoints(k,1)+kCol)) - double(paddedImage1(im1Point(1)+kRow,im1Point(2)+kCol))))^2;
            end
        end
        dist(k) = sqrt(squaredDist);
    end

    dist = dist(padding+1:end-(padding+1));
    
    [~, ind] = min(dist);
    ind = ind + padding + 1;
    
    bestCandids(i,1) = candidatePoints(ind,1);
    bestCandids(i,2) = candidatePoints(ind,2);
    
end
    
pts2 = bestCandids;    



