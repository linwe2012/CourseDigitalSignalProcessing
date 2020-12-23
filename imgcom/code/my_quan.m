function res = my_quan(A,Q)
A_size = size(A);
Q_size = size(Q);
step = floor(A_size ./ Q_size);
res = zeros(A_size);
x1 = 1;
for i=1:step(1)
    y1 = x1 - 1 + Q_size(1);
    x2 = 1;
    for j=1:step(2)
        y2 = x2 - 1 + b_size(2);
        res(x1:y1,x2:y2) = A(x1:y1, x2:y2) ./ Q;
        x2 = y2 + 1;
    end
    x1 = y1 + 1;
end
end

