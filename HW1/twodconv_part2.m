% close all
clear

img = imread("images\convolution_freq_domain.jpg");
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = double(img);

img_freq = fftshift(fft2(ifftshift(img)));

% figure;imshow(log(1 + abs(img_freq)), []);
% title('Magnitude Spectrum of the Original Image');

[m, n] = size(img);
[u, v] = meshgrid(-floor(n/2):floor((n-1)/2), -floor(m/2):floor((m-1)/2)); 

rho = 10;
H = exp(-(u.^2 + v.^2) / (2 * (rho^2))); 

figure;imshow(log(1 + abs(H)), []);
title('Magnitude Spectrum of the Gaussian Filter');

filtered_freq = img_freq .* H;

filtered_img = fftshift(ifft2(ifftshift(filtered_freq)));

figure;
subplot(1, 2, 1);
imshow(uint8(img));
title('Original Image');

subplot(1, 2, 2);
imshow(uint8(filtered_img));
title('Filtered Image with Gaussian Low-Pass');
