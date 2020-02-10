function E = essentialMatrix(F, K1, K2)

E = transpose(K2) * F * K1;

