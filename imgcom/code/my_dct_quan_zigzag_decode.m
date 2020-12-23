function res = my_dct_quan_zigzag_decode(A,basis, Q, dims)
b_size = size(basis);
step = floor(dims ./ b_size);
res = zeros(dims);
cnt = 1;
x1 = 1;
for i=1:step(1)
    y1 = x1 - 1 + b_size(1);
    x2 = 1;
    for j=1:step(2)
        y2 = x2 - 1 + b_size(2);
        mat = unzigzag(A(cnt, :));
        res(x1:y1,x2:y2) = idct2((mat .* Q));
        cnt = cnt + 1;
        x2 = y2 + 1;
    end
    x1 = y1 + 1;
end
% res = uint8(res);
end

function A = unzigzag(arr)
flag = 1;
A = zeros(8);
bound = 8;
len = 64;
row = 1;
col = 1;
turn = 1;
for i=1:len
    A(row, col) = arr(i);
    
    if (row == 1 || row == bound) && turn
        col = col + 1;
        flag = -flag;
        turn = 0;
    elseif (col == 1 || col == bound) && turn
        row = row + 1;
        flag = -flag;
        turn = 0;
    else 
        col = col + flag;
        row = row - flag;
        turn = 1;
    end
end
end

