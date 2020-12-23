%config
toBeEncoded = 'lena508_510.bmp';
export = 'lena508_510.leon';
% config ends
N = 8;
basis = DCT2_BS(N);
quan_lumi = [16  11  10  16  24  40  51  61;
12 12  14  19  26  58  60  55;
14 13  16  24  40  57  69  56;
14  17  22  29  51  87  80  62;
18  22  37  56  68  109  103  77;
24  35  55  64  81  104  113  92;
49  64  78  87  103  121  120  101;
72  92  95  98  112  100  103  99;];
quan_color = [17 18 24 47 99 99 99 99;
18 21 26 66 99 99 99 99;
24 26 56 99 99 99 99 99;
47 66 99 99 99 99 99 99;
99 99 99 99 99 99 99 99;
99 99 99 99 99 99 99 99;
99 99 99 99 99 99 99 99;
99 99 99 99 99 99 99 99;];


img = imread(toBeEncoded);
original_size = size(img);
% padding the image, 2*N(8)to ensure that after down-sampling
% image size still a multiple of 8
padding = 2 * N - mod(original_size, 2 * N);
padding = padding(1:2);
im = padarray(img, padding,'replicate', 'post');
im = rgb2ycbcr(im);

conv_k = ones(2, 2, 'uint8');
% downsampling the image
color1 = my_conv2(im(:, :, 2),conv_k, 2) ./ 4;
color2 = my_conv2(im(:, :, 3),conv_k, 2) ./ 4;

% my_dct_quan_zigzag put three functions(dct, quantify, zigzag) into one
% first column of the result matrix is dc signal
% and the rest column is ac signal in accordance with dc
% ??????dct?????????????????????????dc??,
% ????63????ac????????dc????
im_dct_quan_zigzag = my_dct_quan_zigzag(double(im(:, :, 1)), basis, quan_lumi);
color_zigzag = cat(3, my_dct_quan_zigzag(color1, basis, quan_color), my_dct_quan_zigzag(color2, basis, quan_color));
% dc signal use dpcm(which is actually pcm, because they have little 
% influence on the final file size)
% dc???dpcm????????????pcm???pcm?dpcm?????????????
dc = cat(2, dpcm_encode(im_dct_quan_zigzag(:,1)), dpcm_encode(color_zigzag(:,1, 1)), dpcm_encode(color_zigzag(:,1, 2)));
% ac signal use rle, which encodes the luminous matrix & color matrices
% altogether
% ac????????, ??????????
ac = rle_encode(im_dct_quan_zigzag(:,2:end), color_zigzag(:,2:end,1), color_zigzag(:,2:end,2));
signal = cat(2, dc, ac);

% use getprob to get symbol table & its probability by traversing all
% elements
% getprob ?????????symbol???????
[sym, prob] = getprob(signal);
dict = huffmandict(sym, prob);
comp = huffmanenco(signal, dict);
header = uint32(original_size(1:2));
% header: image size, padding size
% table: luminous quantifier, color quantifier
% detail: dictionary size , data size
% dictionary: [symbol, dict_size, dict_data]
% data: huffman encoded data
fp = fopen(export, 'w');
fwrite(fp, header, 'uint32');
fclose(fp);
fp = fopen(export, 'a');
header = uint8(padding(1:2));
fwrite(fp, header, 'uint8');
fwrite(fp, uint8(quan_lumi), 'uint8');
fwrite(fp, uint8(quan_color), 'uint8');
dict_size = size(sym);
comp_size = size(comp);
fwrite(fp, uint32(dict_size(2)), 'uint64');
fwrite(fp, uint32(comp_size(2)), 'uint64');
bit_cnt = 0;
for i=1:dict_size(2)
    dict_data = dict{i,2}; % dict is a cell
    dict_data_size = size(dict_data);
    fwrite(fp, int32(sym(i)), 'bit32');
    fwrite(fp, uint8(dict_data_size(2)), 'ubit8');
    fwrite(fp, dict_data, 'ubit1');
    bit_cnt = bit_cnt + 40 + dict_data_size(2);
end
add = 8 - mod(bit_cnt+comp_size(2), 8);
% note that we are using bits to write file, but the final file size is 
% multiple of bytes, here is trying to align bits to bytes
% ?????bit??, ????????bytes ????, ???????????????
% ???
comp = [comp, ones(1,add)];
fwrite(fp, comp, 'ubit1');
fclose(fp);
comp__preserve = comp;
imshow(img);
