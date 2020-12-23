function res = misequal( A, B , accuracy)
sz = size(A);
if isequal(sz, size(B))
    for i=1:sz(1)
        for j=1:sz(2)
            if A(i,j)-B(i,j) > accuracy
                res = 0;
                return;
            end;
        end;
    end;
    res = 1;
else
    res = 0;
end
end
