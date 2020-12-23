function [hdr] = hdrMap(Images, g, w, B)
% lnE = sum(wij(z)*(g(z) - lnt)) / sum(wij)
% hdr = sum(wij   *(g(z) - B(exp)) / sum(wij)
Image_size = size(Images{1});
exposures = size(Images, 1);
hdr     = zeros(Image_size);
temp    = zeros(Image_size);
sum_wij = zeros(Image_size);
cutoff = ones(256,1);
cutoff(253:256) = 0;
for i=1: exposures
    img = Images{i} + 1;
    % Assuming exposure is placed from long to short
    % if a pixel is saturated, all pics with longer exposure
    % at this place is unreliable
    saturated = cutoff(img);
    saturated(:,:,1) = saturated(:,:,1) & saturated(:,:,2) & saturated(:,:,3);
    saturated(:,:,2) = saturated(:,:,1);
    saturated(:,:,3) = saturated(:,:,1);
    hdr = hdr .* saturated;
    sum_wij = sum_wij .* saturated;
    
    wij = w(img);
    sum_wij = sum_wij + wij;
    % apply to each channel
    for chnl=1:3
        temp(:,:,chnl) = g{chnl}(img(:,:,chnl)) - B(i);
    end
    
    hdr = hdr + wij .* temp;
end
hdr = hdr ./ sum_wij;
hdr = exp(hdr);
end

