% close all
clear

figure;
img1 = imread("images\hist1.jpg");
subplot(1,2,1); imshow(img1);title('Grayscale Image 1');

subplot(1,2,2); histogram(img1);
title('Histogram of Grayscale Image 1');

figure;
img2 = imread("images\hist2.jpg");
subplot(1,2,1); imshow(img2); title('Grayscale Image 2');

subplot(1,2,2); histogram(img2);
title('Histogram of Grayscale Image 2');


