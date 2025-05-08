clear; 

figure;tiledlayout(1,3);
video_no = 1;
template_path = sprintf('dataset/cropped/crop%d.jpg', video_no);
initial_frame = double(rgb2gray(imread(template_path)));
corner_points = harris_corner_detection(initial_frame);
nexttile
imshow(initial_frame,[]); hold on
plot(corner_points(:, 1), corner_points(:, 2), 'r.', 'MarkerSize', 10);
hold off;
title('Harris Corner Detection');

video_no = 2;
template_path = sprintf('dataset/cropped/crop%d.jpg', video_no);
initial_frame = double(rgb2gray(imread(template_path)));
corner_points = harris_corner_detection(initial_frame);
nexttile
imshow(initial_frame,[]); hold on
plot(corner_points(:, 1), corner_points(:, 2), 'r.', 'MarkerSize', 10);
hold off;
title('Harris Corner Detection');

video_no = 3;
template_path = sprintf('dataset/cropped/crop%d.jpg', video_no);
initial_frame = double(rgb2gray(imread(template_path)));
corner_points = harris_corner_detection(initial_frame);
nexttile
imshow(initial_frame,[]); hold on
plot(corner_points(:, 1), corner_points(:, 2), 'r.', 'MarkerSize', 10);
hold off;
title('Harris Corner Detection');

video_no = 1;
template_path = sprintf('dataset/videos/%d/frame07.png',video_no);
initial_frame = double(rgb2gray(imread(template_path)));
corner_points = harris_corner_detection(initial_frame);
figure;
imshow(initial_frame,[]); hold on
plot(corner_points(:, 1), corner_points(:, 2), 'r.', 'MarkerSize', 10);
hold off;
title('Harris Corner Detection');

video_no = 2;
template_path = sprintf('dataset/videos/%d/frame07.png',video_no);
initial_frame = double(rgb2gray(imread(template_path)));
corner_points = harris_corner_detection(initial_frame);
figure;
imshow(initial_frame,[]); hold on
plot(corner_points(:, 1), corner_points(:, 2), 'r.', 'MarkerSize', 10);
hold off;
title('Harris Corner Detection');

video_no = 3;
template_path = sprintf('dataset/videos/%d/1.png',video_no);
initial_frame = double(rgb2gray(imread(template_path)));
corner_points = harris_corner_detection(initial_frame);
figure;
imshow(initial_frame,[]); hold on
plot(corner_points(:, 1), corner_points(:, 2), 'r.', 'MarkerSize', 10);
hold off;
title('Harris Corner Detection');
function corners = harris_corner_detection(image)
    image = double(histeq(uint8(image)));
    
    window_size = 4;
    k = 0.02; 
    N = 250; 

    Sx = [-1 0 1; -2 0 2; -1 0 1];
    Sy = [-1 -2 -1; 0 0 0; 1 2 1];
    Ix = imfilter(image, Sx, 'replicate');
    Iy = imfilter(image, Sy, 'replicate');

    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix .* Iy;

    gaussian_filter = fspecial('gaussian', [window_size, window_size], 1);
    Sx2 = imfilter(Ix2, gaussian_filter, 'replicate');
    Sy2 = imfilter(Iy2, gaussian_filter, 'replicate');
    Sxy = imfilter(Ixy, gaussian_filter, 'replicate');

    R = (Sx2 .* Sy2 - Sxy.^2) - k * (Sx2 + Sy2).^2;
    threshold = 0.001 * max(R(:));
    R = (R > threshold) .* R; 
    local_max = imdilate(R, strel('square', window_size));
    corners_response = (R == local_max) & (R > 0);

    [rows, cols] = find(corners_response);
    corner_responses = R(corners_response);
    
    [~, sorted_indices] = sort(corner_responses, 'descend');
    strongest_indices = sorted_indices(1:min(N, length(sorted_indices)));
    rows = rows(strongest_indices);
    cols = cols(strongest_indices);
    corners = [cols, rows];

    margin = 1;
    valid_idx = (cols > margin & cols < size(image, 2) - margin & ...
                 rows > margin & rows < size(image, 1) - margin);
    corners = corners(valid_idx, :);
end
