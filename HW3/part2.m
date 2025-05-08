clear;

epsilon1 = 1e-3;
epsilon2 = 1e-3;
epsilon3 = 1e-3;

max_iter_1 = 75;
max_iter_2 = 300;
max_iter_3 = 250;

klt_tracker(1, 1e-1, max_iter_1);
klt_tracker(1, 1e-3, max_iter_1);
klt_tracker(1, 1e-6, max_iter_1);

klt_tracker(1, epsilon1, 75);
klt_tracker(1, epsilon1, 100);
klt_tracker(1, epsilon1, 150);

klt_tracker(2, 1e-1, max_iter_2);
klt_tracker(2, 1e-3, max_iter_2);
klt_tracker(2, 1e-6, max_iter_2);

klt_tracker(2, epsilon2, 75);
klt_tracker(2, epsilon2, 100);
klt_tracker(2, epsilon2, 300);

klt_tracker(3, 1e-1, max_iter_3);
klt_tracker(3, 1e-3, max_iter_3);
klt_tracker(3, 1e-6, max_iter_3);

klt_tracker(3, epsilon3, 100);
klt_tracker(3, epsilon3, 200);
klt_tracker(3, epsilon3, 250);


% video_no = 4;
% 
% if video_no == 1
%     klt_tracker(1, epsilon1, max_iter_1);
% elseif video_no == 2
%     klt_tracker(2, epsilon2, max_iter_2);
% elseif video_no == 3
%     klt_tracker(3, epsilon3, max_iter_3);
% elseif video_no == 4
%     klt_tracker(1, epsilon1, max_iter_1);
%     klt_tracker(2, epsilon2, max_iter_2);
%     klt_tracker(3, epsilon3, max_iter_3);    
% end

function klt_tracker(video_no, epsilon, max_iter)
    % Path to video
    video_path = sprintf('dataset/videos/%d', video_no);
    frame_list = {dir(fullfile(video_path, '*.png')).name};

%     frame_info = dir(fullfile(video_path, '*.png'));  
%     frame_names = {frame_info.name};                 
%     frame_numbers = regexp(frame_names, '\d+', 'match'); 
%     
%     frame_numbers = cellfun(@(k) str2double(k{1}), frame_numbers); 
%     [~, sorted_indices] = sort(frame_numbers);                    
%     frame_list = frame_names(sorted_indices);   

    init_pos_all = [265 140 100 240;  
                    170 35 40 30;     
                    45 210 40 25];    
    init_pos = init_pos_all(video_no, :);
    x = init_pos(1);
    y = init_pos(2);
    w = init_pos(3);
    h = init_pos(4);

    initial_frame = double(rgb2gray(imread(fullfile(video_path, frame_list{1}))));
    corner_points = harris_corner_detection(initial_frame);
    corner_points = corner_points(corner_points(:, 1) >= x & corner_points(:, 1) <= x+w & ...
                                   corner_points(:, 2) >= y & corner_points(:, 2) <= y+h, :);
    corner_points = corner_points(1:min(75, size(corner_points, 1)), :); 

    Sx = [-1 0 1; -2 0 2; -1 0 1];
    Sy = [-1 -2 -1; 0 0 0; 1 2 1];

    num_frames = length(frame_list);
    figure;
    tiledlayout(ceil(num_frames / 4), 4, 'TileSpacing', 'none', 'Padding', 'compact');

    for frame_idx = 1:num_frames
        frame_rgb = imread(fullfile(video_path, frame_list{frame_idx}));
        frame_gray = double(rgb2gray(frame_rgb));
        updated_corners = zeros(size(corner_points));
        total_displacement = zeros(size(corner_points));

        for corner_idx = 1:size(corner_points, 1)
            p = [0; 0];  
            delta_p = [inf; inf];

            x_c = corner_points(corner_idx, 1);
            y_c = corner_points(corner_idx, 2);
            [X, Y] = meshgrid(x_c-1:x_c+1, y_c-1:y_c+1);
            template = interp2(initial_frame(round(y):round(y+h-1), round(x):round(x+w-1)), ...
                   X-x+1, Y-y+1, 'linear', 0);
            for iter = 1:max_iter
                if norm(delta_p) > epsilon
                    [X_warp, Y_warp] = meshgrid(x_c-1+p(1):x_c+1+p(1), y_c-1+p(2):y_c+1+p(2));
                    warped_window = interp2(frame_gray, X_warp, Y_warp, 'linear', 0);

                    error_image = template - warped_window;

                    Ix = imfilter(frame_gray, Sx, 'replicate');
                    Iy = imfilter(frame_gray, Sy, 'replicate');
                    Ix_warped = interp2(Ix, X_warp, Y_warp, 'linear', 0);
                    Iy_warped = interp2(Iy, X_warp, Y_warp, 'linear', 0);

                    J = [Ix_warped(:), Iy_warped(:)];
                    H = J' * J;

                    b = J' * error_image(:);
                    delta_p = H \ b;

                    p = p + delta_p;
                else
                    break;
                end
            end

            updated_corners(corner_idx, :) = corner_points(corner_idx, :) + round(p');
            total_displacement(corner_idx, :) = round(p');  
        end

        corner_points = updated_corners;

        avg_displacement = mean(total_displacement, 1)* 2;
        x = x + avg_displacement(1);
        y = y + avg_displacement(2);
        frame_height = size(frame_gray, 1);
        frame_width = size(frame_gray, 2);
        
        x = max(1, min(x, frame_width - w));
        y = max(1, min(y, frame_height - h));
        nexttile;
        imshow(frame_rgb, []); hold on;
        rectangle('Position', [x, y, w, h], 'EdgeColor', 'r', 'LineWidth', 2);  % Bounding box
        plot(updated_corners(:, 1), updated_corners(:, 2), 'g.', 'MarkerSize', 8);  % Tracked corners
        hold off;
        title(sprintf('Frame %d', frame_idx), 'FontSize', 6);
        fprintf('Frame %d: Avg Displacement = [%.2f, %.2f]\n', frame_idx, avg_displacement(1), avg_displacement(2));
    end

    sgtitle(sprintf('KLT Tracker with Bounding Box: $\\epsilon = 10^{%d}$, max iteration = %d', ...
        log10(epsilon), max_iter), 'Interpreter', 'latex');
end



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

