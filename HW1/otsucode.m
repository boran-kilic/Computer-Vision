% close all
clear
img = imread("images\otsu_1.png");
disp("First Image")
binary_img = otsu_threshold(img);
figure;
subplot(1,2,1); imshow(img); title("Original Image 1");
subplot(1,2,2); imshow(binary_img); title("Seperated Image 1");

figure;
histogram(img);title('Histogram of the Grayscale Image 1');

clear
img = imread("images\otsu_2.jpg");
disp("Second Image")
binary_img = otsu_threshold(img);
figure;
subplot(1,2,1); imshow(img); title("Original Image 2");
subplot(1,2,2); imshow(binary_img); title("Seperated Image 2");

figure;
histogram(img);title('Histogram of the Grayscale Image 2');

