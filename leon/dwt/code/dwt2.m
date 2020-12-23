function [img] = dwt2(img, varargin)
% dwt2(img, [times, channels]);
% perform a 2d dwt2 on img
% img: the orginal image
% times: how many times dwt will be applied to img
% channel: will apply dwt each channel, default is the first channel.
sz = size(img);
img = double(img);
times = 1;
channel = 1;
sz_vars = size(varargin, 2);
if sz_vars
    times = varargin{1};
end
if sz_vars >= 2
    channel = varargin{2};
    disp(channel);
end
for chnl=1:channel
    % apply on each row
    for i=1:sz(1)
        img(i,:, chnl) = dwt(img(i,:, chnl), times);
    end
    % apply on each column
    for i=1:sz(2)
        img(:,i, chnl) = dwt(img(:,i, chnl), times);
    end
end
end

