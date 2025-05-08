function dilated_img = dilation(img, se)
    [rows, cols] = size(img);
    [se_rows, se_cols] = size(se);
    pad_size = floor(se_rows/2);
    
    padded_image = padarray(img, [pad_size, pad_size], 0);
    dilated_img = zeros(size(img));
    
    for i = 1:rows
        for j = 1:cols
            neighborhood = padded_image(i:i+se_rows-1, j:j+se_cols-1);
            if any(neighborhood(se == 1), 'all')
                dilated_img(i,j) = 1;
            end
        end
    end
end