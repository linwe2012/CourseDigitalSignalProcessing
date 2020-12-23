function res = my_conv2_invert(A, kernel, step, dims)
res_size = dims;
k_size = size(kernel);
res = zeros(res_size(1:2));
cnt = size(A);%floor(res_size(1:2) ./ step);
x1 = 1;
y1 = x1 + k_size(1) - 1;
for i=1:cnt(1)
    x2 = 1;
    y2 = x2 + k_size(2) - 1;
    for j=1:cnt(2)
        res(x1:y1, x2:y2) = kernel .* A(i,j); 
        x2 = x2 + step;
        y2 = x2 + k_size(2) - 1;
    end
    x1 = x1 + step;
    y1 = x1 + k_size(1) - 1;
end
end

