function [Res] = merge(Images,square, reference, c)
%MERGE Summary of this function goes here
%   Detailed explanation goes here
numExp = size(Images,1);
imsz = size(Images{1});
row = ceil(imsz(1) / square);
col = ceil(imsz(2) / square);
Res = zeros(imsz);
% h = waitbar(0,'HDR Plus Proc...');
% set(h,'Name','Merging in process');
for i=1:row
    left = (i - 1) * square + 1;
    right = left + square - 1;
    if right > imsz(1)
        right = imsz(1);
    end
    for j=1:col
        top = (j - 1) * square + 1;
        bottom = top + square - 1;
        if bottom > imsz(2)
            bottom = imsz(2);
        end
        for color=1:3
            T_ref = fft2(Images{reference}(left:right,top:bottom, color));
            for e=1:numExp
                im = double(Images{e}(left:right,top:bottom, color));
                T = fft2(im);
                D = T - T_ref;
                D = D .^2;
                dn = downsample(im, square / 20);
                dn = downsample(dn', square / 20);
                variance = var(dn);
                v_sz = size(variance);
                variance = sum(variance) / (v_sz(1) * v_sz(2));
                A = D ./ (D + c*variance);
                Res_temp = (1-A) .* T + A .* T_ref;
            end
            Res_temp = Res_temp / numExp;
            % threshold = variance / (1 + variance);
            % filter = Res_temp > threshold;
            % Res_temp = Res_temp .* filter;
            Res(left:right,top:bottom, color) = ifft2(Res_temp);
%             waitbar(1/row/col);
        end
    end
    % close(h);
end



