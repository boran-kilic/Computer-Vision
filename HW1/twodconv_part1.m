% close all
clear

img = imread("images\convolution_spatial_domain.jpg");
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = double(img); 

% sobel
sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = [-1 -2 -1;0 0 0; 1 2 1];

edge_sobel_x = convolution(img, sobel_x).^2;
edge_sobel_y = convolution(img, sobel_y).^2;
edge_sobel = sqrt(edge_sobel_x + edge_sobel_y);

figure;
subplot(1,2,1); imshow(edge_sobel_x, []); title('Sobel Horizontal');
subplot(1,2,2); imshow(edge_sobel_y, []); title('Sobel Vertical');
figure; imshow(edge_sobel, []); title('Sobel Edge Detection');

% prewitt
prewitt_x = [-1 0 1; -1 0 1; -1 0 1];
prewitt_y = [-1 -1 -1; 0 0 0; 1 1 1];

edge_prewitt_x = convolution(img, prewitt_x).^2;
edge_prewitt_y = convolution(img, prewitt_y).^2;
edge_prewitt = sqrt(edge_prewitt_x + edge_prewitt_y);

figure;
subplot(1,2,1); imshow(edge_prewitt_x, []); title('Prewitt Horizontal');
subplot(1,2,2); imshow(edge_prewitt_y, []); title('Prewitt Vertical');
figure; imshow(edge_prewitt, []); title('Prewitt Edge Detection');

