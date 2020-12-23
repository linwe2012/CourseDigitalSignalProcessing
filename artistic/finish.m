function [Res] = finish(Image,filtersz, factor)
% filtersz:15, factor:1.4
%FINISH Summary of this function goes here
%   Detailed explanation goes here
% Image = rgb2ycbcr(Image);
% kyhh = finish(ysy, 5, 1.4);
% imshow(kyhh);
% Res = Image;
Res = rgb2ycbcr(Image);
Res(:,:,1) = Res(:,:,1) * 0.7;
Res = ycbcr2rgb(Res);
blur = imgaussfilt(Image, 3,'FilterSize', [filtersz, filtersz]);
% blur = imgaussfilt(blur, 'FilterSize', [filtersz, filtersz]);
blur = blur(:,:,1:2);
somthn = abs(blur) ./ abs(Image(:,:,1:2));
index = find(somthn < factor);
mirror = Image(:,:,1:2);
Image = mirror;
Image(index) = blur(index) * 0.7; % mirror(index) * 0.3 + blur(index) * 0.7;

blur = imgaussfilt(Res, 10, 'FilterSize', [101, 101]);
blur = blur(:,:,1:2);
somthn = abs(blur) ./ abs(Image(:,:,1:2));
index = find(somthn < factor);
Image(index) = blur(index) .* 0.9;
blur = imgaussfilt(Res, 1, 'FilterSize', [301, 301]);
Image(:,:,1) = blur(:,:,1);
blur = imgaussfilt(Res, 1, 'FilterSize', [201, 201]);
Image(:,:,2) = blur(:,:,2);
blur = imgaussfilt(blur, 10, 'FilterSize', [filtersz, filtersz]);
blur = blur(:,:,1:2);
somthn = abs(blur) ./ abs(Image(:,:,1:2));
index = find(somthn < factor);
mirror = Image(:,:,1:2);
Image = mirror;
Image(index) = blur(index) .* 0.65;
Res(:,:,1:2) = Image;
% for i=2:3
%     filter = Res(:,:,i) > 0;
%     Res(:,:,i) = Res(:,:,i) .* filter;
%     filter = Res(:,:,i) <= 1;
%     Res(:,:,i) = Res(:,:,i) .* filter;
% end
% Res(:,:,2) = bfilter2(Res(:,:,2), 15);
% Res(:,:,3) = bfilter2(Res(:,:,3), 15);
% Res = ycbcr2rgb(Res);
% Res(:,:,1) = Res(:,:,1) * 0.7;
% Res = ycbcr2rgb(Res);
% imsz = size(Image);
% mask = zeros(imsz(1:2));
% mask(1:400,1:600) = 1;
% for i=1:2
%     Res(:,:,i) = dct2(Image(:,:,i));
%     Res(:,:,i) = Res(:,:,i) .* mask;
%     Res(:,:,i) = idct2(Res(:,:,i));
% end
imshow(Res);
end

