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
    disp(scale);
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
    disp('find mid');
    Matrices{B_mid_pos} = ones(Image_size) - sum;
end
end

