function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

w = floor(windowSize/2);

im1 = im2double(im1);
im2 = im2double(im2);

[row , col] = size(im1);
dispM = zeros(row,col);

for i = w+1:row-w
    for j = w+1:col-w-maxDisp
        score = intmax;
        disp = 0;

        im1Template = im1(i-w:i+w,j-w:j+w);
        for d = 1:maxDisp
            im2Patch = im2(i-w:i+w,j+d-w:j+d+w);

            %%SSD%%
            SSD = (im2Patch - im1Template)^2;
            sumSSD = sum(SSD(:));        

            if (score > sumSSD)                
                score = sumSSD;
                disp = d;
            end
        end
        dispM(i,j) = disp;
    end
end
