%% Sample color using method specified by input, and pass 
 % Method 0: use max sample
function [colorChannel] = colorSampling(Images, method, varargin)
if method == 0
    colorChannel = maxSample(Images, varargin{1});
elseif method == 1
    colorChannel = NormDistSample(Images, varargin{1}, varargin{2}, varargin{3}, varargin{4});
elseif method == 2
    colorChannel = exponentialDCTAVG(Images, varargin{1}, varargin{2}, varargin{3});
end
end

%% MaxSample
function [cChannel] = maxSample(Images, lumi)
numExposure = size(Images, 1);
Image_sz = size(Images{1});
cChannel = zeros(Image_sz);
for numexp=1:numExposure
    max_img = rgb2lab(Images{numexp});
    max_img(:,:,2) = dct2(max_img(:,:,2));
    max_img(:,:,3) = dct2(max_img(:,:,3));
    for max_row=1:Image_sz(1)
        for max_col=1:Image_sz(2)
            if max_row == 1 && max_col==1
                cChannel(1,1,2) = max_img(1,1,2) / numExposure;
                cChannel(1,1,3) = max_img(1,1,3) / numExposure;
            else
                for ch=2:3
                    if(abs(max_img(max_row, max_col, ch)) > abs(cChannel(max_row, max_col, ch)))
                        cChannel(max_row, max_col, ch) = max_img(max_row, max_col, ch);
                    end
                end
            end
        end
    end   
end

cChannel(:,:,1) = lumi / 100 * 255;
for chn=2:3
    cChannel(:,:,chn) = idct2(cChannel(:,:,chn));
end
disp(cChannel(1:10,1:10,2));
cChannel = lab2rgb(cChannel);
cChannel = rgb2lab(cChannel);
cChannel = cChannel(:,:,2:3);
end

%% Norm Distribution Sampling
function [cChannel] = NormDistSample(Images, B, mu, sigma, exponent)
cChannel = zeros(size(Images{1}));
numExposures = size(Images, 1);
colorcoef = colorCoeff(Images, B, mu, sigma, exponent);
% for i=1:numExposures
%     image_Lab_temp = rgb2lab(Images{i});
%     for j=2:3
%         image_Lab_dct = dct2(image_Lab_temp(:, :, j));
%         image_Lab(:, :, j) = image_Lab(:, :, j) + image_Lab_dct .* colorcoef{i};
%     end
% end
% for j=2:3
%     image_Lab(:, :, j) = idct2(image_Lab(:, :, j));
% end
for i=1:numExposures
    image_Lab_temp = double(rgb2lab(Images{i}));
    for j=2:3
        image_Lab_dct = dct2(image_Lab_temp(:, :, j));
        cChannel(:, :, j) = cChannel(:, :, j) + image_Lab_dct .* colorcoef{i};
    end
end
for j=2:3
    cChannel(:, :, j) = idct2(cChannel(:, :, j));
end
cChannel = cChannel(:,:,2:3);
end

function [Matrices] = colorCoeff(Images, B, mu, sigma, exponent)
Image_size = size(Images{1});
Image_size = Image_size(1:2);
norm_len = max(Image_size);
numExposures = size(Images, 1);
Matrices = cell(numExposures, 1);
B = exp(B);
B_max = max(B);
B_min = min(B);
B_len = size(B, 1);
disp(B_len);
if mod(B_len, 2) == 0
    B = [B; 99999]; % The last number will never be visited.
end
B_mid = median(B);
B_mid_pos = -1;
norm_dist = normpdf((-norm_len:1:norm_len), mu, sigma);
norm_dist = norm_dist .* double(sigma);
sum = zeros(Image_size);
for e=1:numExposures
    Matrices{e} = zeros(Image_size);
    if B(e) == B_mid && B_mid_pos == -1
        B_mid_pos = e;
        continue;
    end
    scale = ((B(e) - B_min) / (B_max - B_min)) ^ exponent;
    right_axis  = floor(scale * (Image_size(2) - 1));
    bottom_axis = floor(scale * (Image_size(1) - 1));
    norm_left  = norm_len + 1 - (right_axis - 1);
    norm_right = norm_len + 1 + (Image_size(2) - right_axis);
    for i=1:bottom_axis
        Matrices{e}(i, :) = Matrices{e}(i, :) + norm_dist(norm_left:norm_right);
    end
    norm_left  = norm_len + 1 - (bottom_axis - 1);
    norm_right = norm_len + 1 + (Image_size(1) - bottom_axis);
    for i=1:right_axis - 1
        Matrices{e}(:, i) = Matrices{e}(:, i) + (norm_dist(norm_left:norm_right))';
    end
    sum = sum + Matrices{e};
end
if B_mid_pos ~= -1
    Matrices{B_mid_pos} = ones(Image_size) - sum;
end
end

function [cChnl] = exponentialDCTAVG(Images, step, cutoff, beta)
numExposures = size(Images, 1);
imSize = size(Images{1});
cnt = ceil(imSize(1:2)/ step);
for i=1:numExposures
    Images{i} = rgb2lab(Images{i});
end
cChnl = zeros(imSize);
table = zeros(1, numExposures);
for c=2:3
    for i=1:cnt(1)
        for j=1:cnt(2)
            x = (i-1) * step + 1;
            y = (j-1) * step + 1;
            x1 = x + step;
            y1 = y + step;
            if x1 > imSize(1)
                x1 = imSize(1);
            end
            if y1 > imSize(2)
                y1 = imSize(2);
            end
            for k=1:numExposures
                % Images{k}(x:x+step, y:y+step, c) = dct2(Images{k}(x:x+step, y:y+step, c));
                temp = abs(dct2(Images{k}(x:x1, y:y1, c)));
                table(k) = length(find(temp<cutoff));
            end
            for k=1:numExposures
                [~,index]= max(table);
                alpha = beta;
                if k == 1
                    alpha = 1;
                end
                cChnl(x:x1, y:y1,c) = cChnl(x:x1, y:y1,c) * (1-alpha) + Images{index(1)}(x:x1, y:y1, c) * alpha;
                table(index(1)) = -1;
            end
        end
    end
end
cChnl = cChnl(:,:,2:3);
end

