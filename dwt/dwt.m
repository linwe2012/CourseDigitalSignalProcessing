function [arr] = dwt(arr, varargin)
% perform dwt on arr,
% the times is dtermined by varargin{1}
% by default will perform until one average left
sz = size(arr);
cnt = max(sz);
times = -1;
if size(varargin)
    times = varargin{1};
end
while cnt >= 2 && times ~= 0
    % perform dwt at average part of dwt
    % the average part ranges from 1 to cnt
    arr(1:cnt) = dwt_once(arr(1:cnt));
    cnt = floor(cnt / 2);
    if times > 0
        times = times - 1;
    end
end
end

function [r] = dwt_once(arr)
% perform dwt once
sz = size(arr);
cnt = floor(max(sz) / 2);
next = cnt;
r = zeros(sz);
for i=1:cnt
    x1 = arr((i-1) * 2 + 1);
    x2 = arr(2*i);
    r(i) = (x1 + x2) / 2; % average
    r(next + i) = (x1 - x2) / 2; % detail
end
end