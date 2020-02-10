function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).

c1 = -(inv(K1*R1)) * (K1*t1);
c2 = -(inv(K2*R2)) * (K2*t2);

b = norm(c1 - c2);
f = K1(1, 1);
numer = b*f;

[row, col] = size(dispM);
depthM = zeros(size(dispM));

for i = 1:row
    for j = 1:col
        if dispM(i,j) == 0
            depthM(i,j) = 0;
            continue;
        end
        depthM(i,j) = numer / dispM(i,j);
    end
end
