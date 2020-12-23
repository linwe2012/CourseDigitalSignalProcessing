% config
toBeDecoded = 'lena508_510.leon';
% config ends
N = 8;
basis = DCT2_BS(N);
fp = fopen(toBeDecoded, 'r');
original_size = fread(fp, [1,2], 'uint32');
padding = fread(fp, [1,2], 'uint8');
quan_lumi = fread(fp, [N,N], 'uint8');
quan_color = fread(fp, [N,N], 'uint8');
dict_size = fread(fp, 1, 'uint64');
comp_size = fread(fp, 1, 'uint64');
dict = cell([dict_size, 2]);
for i=1:dict_size
    dict{i, 1} = fread(fp, 1, 'bit32');
    dict_data_sz = fread(fp, 1, 'ubit8');
    dict{i,2} = fread(fp, [1,dict_data_sz], 'ubit1');
end
comp = fread(fp,[1, comp_size],  'ubit1');
fclose(fp);

% calculate picture size
% ??????
pic_size = original_size(1:2) + padding;
dc_len = pic_size(1) * pic_size(2) / 64 / 2 * 3;
disp('Huffman decode takes some time, please be patient.');
signal_decode = huffmandeco(comp, dict);
% dc_decode = [[luminous], [color1], [color2]], the same applies to
% ac_decode
dc_decode = signal_decode(1:dc_len);
ac_decode = signal_decode(dc_len+1:end);
lumi_len = dc_len / 3 * 2;
color_len = dc_len / 3 / 2;
% seperating ac & dc and obtain original signal by dpcm_decode(which actually is pcm_decode)
lumi_dc_decode = dpcm_decode(dc_decode(1:lumi_len));
color_dc_decode = cat(3, (dpcm_decode(dc_decode(lumi_len+1:lumi_len+color_len)))', (dpcm_decode(dc_decode(lumi_len+color_len+1:end)))');
% since dc&ac signal is encoded together, their rle may overlap each other,
% so the solution is keep track of how many are already decoded,
% here u is an index of the next rle code to be decodes
% and leftover is used to update how many 0s left,
% since last step may only process part of code at index u
[lumi_ac_decode, u, leftover] = rle_decode(ac_decode,[lumi_len,63]);
ac_decode = ac_decode(u:end);
ac_decode(1) = leftover;
[color1_ac_decode, u, leftover] = rle_decode(ac_decode,[color_len,63]);
ac_decode = ac_decode(u:end);
ac_decode(1) = leftover;
[color2_ac_decode, u, leftover] = rle_decode(ac_decode,[color_len,63]);
color_ac_decode = cat(3, color1_ac_decode, color2_ac_decode);
clear color1_ac_decode color2_ac_decode;


lumi_zigzag_decode = cat(2, lumi_dc_decode', lumi_ac_decode);
% color is already transposed
color_zigzag_decode = cat(2, color_dc_decode, color_ac_decode);
% my_dct_quan_zigzag_decode is also a function that does 3 jobs fist
% unzigzag, then unquantify, and finally invert dct
lumi_decode = uint8(my_dct_quan_zigzag_decode(lumi_zigzag_decode, basis, quan_lumi, pic_size));

color_decode = [];
kernel = uint8(ones(2));
for i=1:2
    color_conv_decode =  my_dct_quan_zigzag_decode(color_zigzag_decode(:,:,i), basis, quan_color, pic_size ./ 2);
    if isempty(color_decode)
        % do the invert desampling
        color_decode = my_conv2_invert(color_conv_decode, kernel, 2, pic_size);
    else
      color_decode = cat(3, color_decode, my_conv2_invert(color_conv_decode, kernel, 2,pic_size));
    end
end

color_decode = uint8(color_decode);
im_decode = cat(3, lumi_decode, color_decode);
img_decode = ycbcr2rgb(im_decode);
img_decode = img_decode(1:end-padding(1),1:end-padding(2),:);
figure;
imshow(img_decode);
%lumi_ac_decode = (ac_)