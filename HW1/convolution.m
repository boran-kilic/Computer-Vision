function conv_img = convolution(img, filter)
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    [img_height, img_width] = size(img);
    [filter_height, filter_width] = size(filter);
    
    pad_height = floor(filter_height / 2);
    pad_width = floor(filter_width / 2);
    
    padded_img = padarray(img, [pad_height, pad_width], 0, 'both');
    
    conv_img = zeros(img_height, img_width);
    
    for i = 1:img_height
        for j = 1:img_width
            region = padded_img(i:i + filter_height - 1, j:j + filter_width - 1);
            conv_img(i, j) = sum(sum(region .* filter));
        end
    end
end
