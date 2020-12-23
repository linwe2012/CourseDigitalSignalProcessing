function res = my_conv2(A, kernel, step)
res_size = floor((size(A) - size(kernel) + 1) ./ step) + 1;
k_size = size(kernel);
res = zeros(res_size(1:2));
cnt = res_size; %floor(res_size(1:2) ./ step);
%disp(cnt);
x1 = 1;
y1 = x1 + k_size(1) - 1;
for i=1:cnt(1)
    x2 = 1;
    y2 = x2 + k_size(2) - 1;
    %disp(size(A(x1:y1,x2:y2)));
    %disp(size(sum(A(x1:y1,x2:y2) .* kernel)));
    for j=1:cnt(2)
        res(i, j) = sum((sum(A(x1:y1,x2:y2) .* kernel)), 2); 
        x2 = x2 + step;
        y2 = x2 + k_size(2) - 1;
    end
    x1 = x1 + step;
    y1 = x1 + k_size(1) - 1;
end
end

