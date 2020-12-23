function [Images, B] = readImages(root, name, file_cnt, postfix)
Images = cell(file_cnt, 1);
B = zeros(file_cnt, 1);
file = constructFileName(root, name, 0, postfix);
info = imfinfo(file);
hasExposure = 1;
h = waitbar(0,'HDR Process Ongoing(1/5)');
set(h,'Name','readImages');
if ~exist('info.DigitalCamera', 'var')
    disp('readImages::fails to find exposure info. Will estimate exposure');
    hasExposure = 0;
end
for i=1:file_cnt
    file = constructFileName(root, name, i-1, postfix);%[root name midname postfix];
    disp(['loaded: ' file]);
    Images{i} = imread(file);
    if hasExposure
        info = imfinfo(file);
        B(i) = info.DigitalCamera.ExposureTime;
    else
        B(i) = getExposure(Images{i});
    end
    waitbar(i/file_cnt);
end
if ~hasExposure
    % adjust exposure
    Bmax = max(B);
    Bmin = min(B);
    B = (B - Bmin) / (Bmax - Bmin); % normalize it
    B = B .^ 1.75; % make B dense in around origin
    B = B + 1 / 5;
    B = B * (Bmax / Bmin * 0.7);
    disp('Here is the estimated exposure: after sorted.');
    disp(B);
end
im = Images;
b = B;
%sort images by exposures from max to small
for i = 1:file_cnt
    [~,index]= max(b);
    B(i) = b(index(1));
    Images{i} = im{index};
    b(index) = -1000;
end
close(h);
end

%% This Functin recieve digit i.e. 2, it will return Picture02.png
function [file] = constructFileName(root, name, digit, postfix)
    midname = int2str(digit);
    if digit < 10
        midname = ['0' midname];
    end
    file = [root name midname postfix];
end

%% This function just give a relative estimate of exposure
function [b] = getExposure(Image)
% To speed up dct
step = ceil(max(size(Image)) / 100);
Image = downsample(permute((downsample(Image, step)), [2,1,3]),step);
Image = rgb2lab(Image);
Image = dct2(Image(:,:,1));
b = Image(1,1,1);
end