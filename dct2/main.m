N = 8;
% basis is the same as 1d dct's basis
basis = DCT2_BS(N);
x = rand(N);

%dct 2d: 
% basis * x get each column a dct
% (basis * x) * x' apply dct on each row of (basis * x)
% thus, we have a 2d dct
x_dct = basis * x * basis';
x_sysdct = dct2(x);

% using my own compare function
% last parameter is accurracy
if misequal(x_dct, x_sysdct, 10e-10)
    disp('Correct!');
else
    disp('Wrong!');
end

%read in image with noise
im_n = imread('lena512_noise.bmp');

imshow(im_n);
im_n_dct2 = dct2(im_n);
row = 200;
col = 200;

% mask makes everything 0 except top left corner
% the area that will be left untouched is defined by row & col
mask = zeros(512);
for i=1:row
    for j=1:col
        if i+j<row
            mask(i, j) = 1;
        end
    end
end
im_dn_dct2 = im_n_dct2 .* mask;
% figure2: dct image after mask
set(figure(), 'name','DCT image');
imshow(uint8(im_dn_dct2));
im_new = idct2(im_dn_dct2);
% figure2: dct image after dct denoise
set(figure(), 'name','DCT denoised image');
imshow(uint8(im_new));

im = imread('lena512.bmp');
noise = 20 * randn(512);
im_n1 = double(im) + noise;
set(figure(), 'name','My image with noise');
imshow(uint8(im_n1));
im_n1_dct2 = dct2(im_n1);
set(figure(), 'name','DCT image with noise');
imshow(uint8(im_n1_dct2));
row = 100;
col = 100;
mask(:,:) = 0; 
for i=1:row
    for j=1:col
        if i+j<row
            mask(i, j) = 1;
        end
    end
end

im_dn1_dct2 = im_n1_dct2 .* mask;
set(figure(), 'name','DCT of My image afetr denoise');
imshow(uint8(im_dn1_dct2));
set(figure(), 'name','DCT denoised my image');
imshow(uint8(idct2(im_dn1_dct2)));
            

        