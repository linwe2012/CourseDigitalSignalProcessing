function [Images] = alignImages(Images, anchor, method)
numExposures = size(Images);
% Get a configuration suitable for registering images of
% different intensity.
disp('will align images, it will take a long long time');
[optimizer, metric] = imregconfig('multimodal');
anchor_gray = rgb2gray(Images{anchor});
for i=1:numExposures
    if i == anchor
        continue;
    end
    gray = rgb2gray(Images{i});
    tform = imregtform(gray, anchor_gray, method, optimizer, metric);
    Images{i} = imwarp(Images{i},tform,'OutputView',imref2d(size(Images{anchor})));
end
end

