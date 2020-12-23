function res = rle_encode(varargin)
dump = size(varargin);
cnt = dump(2);
res = [];
zero_cnt = 0;
for i=1:cnt
    A = varargin{i};
    A_size = size(A);
    for j=1:A_size(1)
        for k=1:A_size(2)
            if A(j, k) == 0
                zero_cnt = zero_cnt + 1;
            else
                res = [res, zero_cnt, A(j, k)];
                zero_cnt = 0;
            end
        end
    end
end
res = [res, zero_cnt, 0];
end

