% kyh(:,:,1) = dct2(kyh(:,:,1));
% kyh(:,:,2) = dct2(kyh(:,:,2));
% kyh(:,:,3) = dct2(kyh(:,:,3));
% kyh(200:end,300:end,:) = 0;
% kyh(:,:,1) = idct2(kyh(:,:,1));
% kyh(:,:,2) = idct2(kyh(:,:,2));
% kyh(:,:,3) = idct2(kyh(:,:,3));

% kyh = rgb2ycbcr(ysy);
% for i=2:3
%     tmp = kyh(:,:,i);
%     tmp = (1+tmp) ./ (2+tmp);
%     tmp = bfilter2(tmp);
%     kyh(:,:,i) = (2 * tmp - 1) ./ (1 - tmp);
% end
% kyh = ycbcr2rgb(kyh);    
kyhh = ysy;
imwrite(kyhh,'kyhh.jpg');
kyhh = imread('kyhh.jpg');
chart = esfrChart(kyhh);
displayChart(chart,'displayColorROIs',false,...
    'displayGrayROIs',false,'displayRegistrationPoints',false);
chTable = measureChromaticAberration(chart);
% imshow(kyh);