%% Configuration
% img will be devided into 4 ^ times part
times = 3;
% color channel
channels = 3;
% original image path
img_path = 'bird.jpg';
% set all abs dwt value less than cutoff to 0
cutoff = 5;

%% Task1: do dwt
A = [64, 2, 3, 61, 60, 6, 7, 57];
B = dwt(A);
disp(B);
C = idwt(B);
disp(C);

%% Task 2: img compression
im = imread(img_path);

% pad image
cell_cnt = (2 ^ times);
imsize = size(im);
padding = mod(cell_cnt - mod(imsize, cell_cnt), cell_cnt);
padding(3) = 0;
img = zeros(imsize + padding);
img(1:imsize(1), 1:imsize(2), :) = im;

% perform dwt
img_dwt = dwt2(img, times, channels);
figure('Name', 'Image after dwt');
imshow(uint8(img_dwt));

% Calculate filter according to imge
filter = (abs(img_dwt) > cutoff);
w = size(img, 1) / cell_cnt;
h = size(img, 2) / cell_cnt;
% make sure the most important part stays untouched.
filter(1:w,1:h,:) = 1;
img_dwt = img_dwt .* filter; % filter image

% perform idwt and unpad
img_idwt = idwt2(img_dwt, times, channels);
img_idwt = img_idwt(1:imsize(1), 1:imsize(2), :);

figure('Name', 'Original Image');
imshow(im);
figure('Name', 'Image after compression');
imshow(uint8(img_idwt));
