% close all
clear
src_img = imread('images\morphological_operations.png');
src_img = rgb2gray(src_img);
figure();
tiledlayout(1,2);
nexttile;
imshow(src_img); title('source image');
se=[0 0 0 0 1 0 0 0 0
    0 0 1 1 1 1 1 0 0
    0 1 1 1 1 1 1 1 0
    0 1 1 1 1 1 1 1 0
    1 1 1 1 1 1 1 1 1
    0 1 1 1 1 1 1 1 0
    0 1 1 1 1 1 1 1 0
    0 0 1 1 1 1 1 0 0
    0 0 0 0 1 0 0 0 0];

output_img = n_erosion(src_img,se,10);
output_img = n_dilation(output_img,se,10);

nexttile;
imshow(output_img); title('morphological operations output');

function [output_img] = n_erosion(input_img,se,n)
output_img = input_img;
for i = 1:n
    output_img = erosion(output_img,se);
end
end 

function [output_img] = n_dilation(input_img,se,n)
output_img = input_img;
for i = 1:n
    output_img = dilation(output_img,se);
end
end



