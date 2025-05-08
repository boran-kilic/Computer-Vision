% close all
clear

img = imread("images\contrastive_strecth.png");
figure; 
tiledlayout(1,2);
nexttile
imshow(img);
nexttile
histogram(img);title('Histogram of the Grayscale Image');


pixel_values = [0 255;
                128 255;
                0 128];

for i = 1:size(pixel_values, 1)
    c = pixel_values(i, 1);
    d = pixel_values(i, 2);
    
    strch_img = contrast_stretching(img, c, d);
    
    figure; 
    tiledlayout(1, 2);
    
    nexttile;
    imshow(strch_img);
    
    nexttile;
    histogram(strch_img);
    
    sgtitle(['Contrast Stretching with c = ' num2str(c) ', d = ' num2str(d)]);
end
