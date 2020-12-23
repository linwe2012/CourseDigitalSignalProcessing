function [res, u, leftover] = rle_decode(A,dims)
res = zeros(dims);
u = 1;
v = 2;
current = A(u:v);
for i=1:dims(1)
    for j=1:dims(2)
        if current(1) == 0
            res(i,j) = current(2);
            u = u + 2;
            v = v + 2;
            current = A(u:v);
        else
            res(i,j) = 0;
            current(1) = current(1) - 1;
        end
    end
end
leftover = current(1);
end

