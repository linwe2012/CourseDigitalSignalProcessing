toBeEncoded = 'lena508_510.bmp';
style_path = 'vang_starsky.jpg';
img = imread(toBeEncoded);
im = rgb2ycbcr(img);
% vang_starsky
% dvin_monalisa da vinci mona lisa
% dali_memory.jpg

style_orgin = imread(style_path);
style_info = imfinfo(style_path);
% style_exposure = style_info.DigitalCamera.ExposureTime;
style = rgb2ycbcr(style_orgin);
im_size = size(im);
im_dct = zeros(size(im));
style_dct = zeros(size(im));
im_res = zeros(size(im));
for i=1:3
     im_dct(:,:,i)= dct2(im(:,:,i));
     style_dct(:,:,i) = dct2(style(1:im_size(1), 1:im_size(2), i));
    % = temp(1:im_size(1), 1:im_size(2), i);
    % im_dct(100:end,100:end, i) = style_dct(100:end,100:end,i);
    style_coeff = (style_dct(:,:,i) + 1 ) / 10 ;
    if i == 1
        a = 90;
        % im_dct(90:400,90:400, i) = style_dct(90:400,90:400,i)*0.2 + im_dct(90:400,90:400, i)* 0.4 + im_dct(90:400,90:400, i) .* style_coeff(90:400,90:400, i) * 0.4;
        % im_dct(a:end,a:end, i) = style_dct(a:end,a:end,i)*0.2 + im_dct(a:end,a:end, i)* 0.4 + im_dct(a:end,a:end, i) .* style_coeff(a:end,a:end, i) * 0.4;
        im_dct(a:end,a:end, i) = style_dct(a:end,a:end,i)*0.2 + im_dct(a:end,a:end, i)* 0.4 + im_dct(a:end,a:end, i) .* style_coeff(a:end,a:end, i) * 0.4;
        im_dct(1:2,1:2, i) = style_dct(1:2,1:2,i)*0.09 + im_dct(1:2,1:2, i)* 0.9 + im_dct(1:2,1:2, i) .* style_coeff(1:2,1:2, i) / 100 * 0.01;
    end
    if i ~= 1
        im_dct(:,:, i) = style_dct(:,:,i)*0.15 + im_dct(:,:, i)* 0.85;
        % im_dct(400:end,400:end, i) = style_dct(400:end,400:end,i);
        im_dct(1:2,1:2, i) = style_dct(1:2,1:2,i)* 0.7 + im_dct(1:2,1:2, i) * 0.3;
        im_dct(400:end,400:end, i) = style_dct(400:end,400:end,i);
    end
    im_res(:,:,i) = idct2(im_dct(:,:,i));
end

img_res = ycbcr2rgb(uint8(im_res));

imshow(img_res);
imwrite(img_res, 'D:\Matlab\artistic\ysy.jpg');
% disp(img_res(1:5, 1:5,:));
% disp('break');
% disp(img(1:5, 1:5,:));
% figure;
% imshow(style_orgin);