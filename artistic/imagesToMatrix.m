function [Matrices] = imagesToMatrix(Images)
numExposures = size(Images, 1);
Image_size   = size(Images{1});
Image_pixels = Image_size(1) * Image_size(2);
Image_width  = Image_size(2);
% We need N(P-1) > (Zmax - Zmin)
% number of samples for each image each channel
numSamples = ceil(2 * 255 / (numExposures - 1));

zRed   = zeros(numSamples, numExposures);
zGreen = zeros(numSamples, numExposures);
zBlue  = zeros(numSamples, numExposures);

step   = floor(Image_pixels / numSamples);

for i=1:numExposures
    img = Images{i};
    samplePoint = 1;
    for j=1:numSamples
        row = floor(samplePoint / Image_width) + 1;
        col = mod(samplePoint, Image_width);
        if col == 0
            col = Image_width;
        end
        % disp([row, col]);
        zRed(j, i)   = img(row, col, 1);
        zGreen(j, i) = img(row, col, 2);
        zBlue(j, i)  = img(row, col, 3);
        samplePoint = samplePoint + step;
    end 
end
Matrices = {zRed, zGreen, zBlue};
end

