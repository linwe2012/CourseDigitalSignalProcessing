% Author: leon
% Github: Linwe2012@163.com
% Following open source, tutorials or paper have inspired me:
% - Paul Debevec's SIGGRAPH'97 paper "Recovering High Dynamic Range
%   Radiance Maps from Photographs"
% - Mathias Eitz, Claudia Stripf:
%   http://cybertron.cg.tu-berlin.de/eitz/hdr/ 
% - https://github.com/cbod/cs766-hdr/
% This script generate hdr image from a series of different exposure
% images. It is important that it contains exposure info.
% Check exposure info: Right Click->Properties->Details->Camera

%% Configure:
 % Files must be named as abc00.jpg, abc01.jpg... 
 % They should be the same size
path_root = 'img/';
path_filename = 'Royal_Palace_in_Madrid/';
path_img_cnt = 7;
path_format = '.jpg';
lambda = 20; % how smooth g should be
lumiStrength = 0.6; % change luminance
% Luminance reconstruct method:
% % 1: using simple x/(1+x) to map
% % 2: use ACES
Luminance_reconstruct = 1; 
weights = zeros(256, 1);
weights(1:128) = 1:128;
weights(129:256) = 128:-1:1;
% align config: {ifalign, anchor(all imgs align to anchor), align method}
% see imregconfig for detail
% this is a experimetal feature, which doesn't work perfectly
% NEVER use it unless absolute necessay, cuz it takes too much time
align = {0, 1, 'similarity'};

%% HDR Procedure
[Images, B] = readImages(path_root, path_filename, path_img_cnt, path_format);
if align{1}
    Images = alignImages(Images, align{2}, align{3});
end
SampleMatrices = imagesToMatrix(Images);

B = log(B);

g = cell(3, 1);
lE = cell(3, 1);
for i=1:3
    [g{i}, lE{i}] = gsolve(SampleMatrices{i}, B, lambda, weights);
end
disp("gsolved");
hdrmap = hdrMap(Images, g, weights, B);
disp("hdr map generated");

Image_size = size(Images{1});
delta = 0.00001; % prevent log0
luminance = 0.2125 * hdrmap(:,:,1) + 0.7154 * hdrmap(:,:,2) + 0.0721 * hdrmap(:,:,3);
luminanceKey = exp((1/(Image_size(1) * Image_size(2)))*(sum(sum(log(luminance + delta))))); % Geometric Mean 
luminance = luminance * lumiStrength / luminanceKey;
    
if Luminance_reconstruct == 1
    luminance = luminance ./ (1 + luminance);
else
% Academy Color Encoding System(ACES)
    A_h = 2.51; B_h = 0.03; C_h = 2.43; D_h = 0.59; E_h = 0.14; % Magic
    luminance = (luminance .* (A_h * luminance + B_h)) ./ (luminance .* (C_h * luminance + D_h) + E_h);
end
luminance = luminance * 100;

image_Lab = zeros(size(Images{1}));
image_Lab(:,:,1) = luminance;

% Color sampling with max sample
image_Lab(:,:,2:3) = colorSampling(Images, 0, luminance);
% % Color sampling with norm distribution
% image_Lab(:,:,2:3) = colorSampling(Images, 1, B, 0, 10, 3);
% % Color sampling with exponential average
% image_Lab(:,:,2:3) = colorSampling(Images, 2, 8, 1, 0.8);
disp("Color Sampled, ready to reconstruct Image.");
h = waitbar(0,'HDR Process Ongoing(5/5)');
set(h,'Name','sample image and rearrange as matrix');
image_hdr = lab2rgb(image_Lab);
saturation = (tanh(luminance / 100 * 10 - 5) + 1) / 10 + 1;
image_hdr = rgb2hsv(image_hdr);
image_hdr(:,:,2) = image_hdr(:,:,2) .* saturation;
image_hdr = hsv2rgb(image_hdr);
close(h);
imwrite(image_hdr, 'result.jpg');
figure;
imshow(image_hdr);


figure;
imshow(Images{1});
title('Orignal image');
