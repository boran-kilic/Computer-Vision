function strch_img = contrast_stretching(img, c, d)
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    a = double(min(img(:))); 
    b = double(max(img(:))); 
    
    img = double(img);
    strch_img = ((img - a) / (b - a)) * (d - c) + c;
    strch_img = uint8(strch_img);
end
