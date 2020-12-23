% lena508_510
im = imread('lena508_510.bmp');
im_ycbcr = double(rgb2ycbcr(im));
m = max(im_ycbcr(:,:,1),[], 1);
m = max(m, [], 2);
m_log = log(m+1);
mmin = min(im_ycbcr(:,:,1),[], 1);
mmin = min(mmin, [], 2);
im_ycbcr(:,:,1) = log(im_ycbcr(:,:,1) + 1) / m_log * m ;

im_res = ycbcr2rgb(uint8(im_ycbcr));
max_ycbcr = max(im_res(:,:,1), [], 1);
max_ycbcr = max(max_ycbcr, [], 2);
min_ycbcr = min(im_res(:,:,1), [], 1);
min_ycbcr = min(min_ycbcr, [], 2);

im_res(:,:,2) = im_res(:,:,1);
im_res(:,:,3) = im_res(:,:,1);
imshow(im_res);
