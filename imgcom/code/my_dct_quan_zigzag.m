function res_zigzag = my_dct_quan_zigzag(A,basis, Q)
% basis & Q must be the same size
A_size = size(A);
b_size = size(basis);
step = floor(A_size ./ b_size);
res = zeros(A_size);
res_zigzag = zeros(A_size(1) * A_size(2) / b_size(1) / b_size(2), b_size(1) * b_size(2));
cnt = 1;
x1 = 1;
for i=1:step(1)
    y1 = x1 - 1 + b_size(1);
    x2 = 1;
    for j=1:step(2)
        y2 = x2 - 1 + b_size(2);
        % x1,y1 indicates the row position of the moving window
        % x2,y2 specifies the column position
        res(x1:y1,x2:y2) = basis * A(x1:y1, x2:y2) * basis'; % dct
        res(x1:y1,x2:y2) = round(res(x1:y1, x2:y2) ./ Q); % quantify
        res_zigzag(cnt,:) = zigzag(res(x1:y1,x2:y2)); %zigzag
        cnt = cnt + 1; 
        x2 = y2 + 1;
    end
    x1 = y1 + 1;
end
% res_zigzag = uint8(res_zigzag);
end

function arr = zigzag(A)
flag = 1;
A_size = size(A);
len = A_size(1) * A_size(2);
arr = zeros(1, len);
row = 1;
col = 1;
turn = 1;
for i=1:len
    arr(i) = A(row, col);
    % if it touches border, it will prepare to turn
    if (row == 1 || row == A_size(1)) && turn
        col = col + 1;
        flag = -flag;
        turn = 0;
    elseif (col == 1 || col == A_size(2)) && turn
        row = row + 1;
        flag = -flag;
        turn = 0;
    % otherwise it will walk from left-bottom to top-right if flag = 1
    % if flag = -1, it walks other direction 
    else 
        col = col + flag;
        row = row - flag;
        turn = 1;
    end
end
end