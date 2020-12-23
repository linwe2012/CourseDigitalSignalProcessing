function [arr] = idwt(arr, varargin)
% perform idwt on image
% idwt(arr [, times])
% times: how many times required to restore
sz = size(arr);
len = max(sz);
done = 1;
cnt = 1;
if size(varargin)
    times = varargin{1};
    div = 2 ^ times;
    cnt = floor(len / div);
    done = cnt;
end
% perform idwt until reaches whole length of array
% done means how many are already retored to be average
while done < len
    % x stores all the avarage signals
    x = arr(1:cnt);
    for i=1:cnt
        d = arr(done + i);
        xx = x(i);
        arr(2*i - 1) = xx + d;
        arr(2 * i) = xx - d;
    end
    done = done * 2;
    cnt = cnt * 2;
end
end
