clear;

epsilon1 = 1e-1;
epsilon2 = 1e-3;
epsilon3 = 1e-3;

max_iter_1 = 50;
max_iter_2 = 200;
max_iter_3 = 250;

lucas_kanade(1, 1e-1, max_iter_1);
lucas_kanade(1, 1e-3, max_iter_1);
lucas_kanade(1, 1e-6, max_iter_1);

lucas_kanade(1, epsilon1, 20);
lucas_kanade(1, epsilon1, 50);
lucas_kanade(1, epsilon1, 100);

lucas_kanade(2, 1e-1, max_iter_2);
lucas_kanade(2, 1e-3, max_iter_2);
lucas_kanade(2, 1e-6, max_iter_2);

lucas_kanade(2, epsilon2, 50);
lucas_kanade(2, epsilon2, 100);
lucas_kanade(2, epsilon2, 200);

lucas_kanade(3, 1e-1, max_iter_3);
lucas_kanade(3, 1e-3, max_iter_3);
lucas_kanade(3, 1e-6, max_iter_3);

lucas_kanade(3, epsilon3, 100);
lucas_kanade(3, epsilon3, 200);
lucas_kanade(3, epsilon3, 250);

% lucas_kanade(1, epsilon1, max_iter_1);
% lucas_kanade(2, epsilon2, max_iter_2);
% lucas_kanade(3, epsilon3, max_iter_3);

function lucas_kanade(video_no, epsilon, max_iter)
    video_path = sprintf('dataset/videos/%d', video_no);
    frame_list = {dir(fullfile(video_path, '*.png')).name};
    frame_list = sort(frame_list);
    
%     frame_info = dir(fullfile(video_path, '*.png'));  
%     frame_names = {frame_info.name};                 
%     frame_numbers = regexp(frame_names, '\d+', 'match'); 
%     
%     frame_numbers = cellfun(@(k) str2double(k{1}), frame_numbers); 
%     [~, sorted_indices] = sort(frame_numbers);                    
%     frame_list = frame_names(sorted_indices);                     

    template_path = sprintf('dataset/cropped/crop%d.jpg', video_no);
    target = double(rgb2gray(imread(template_path)));

    init_pos_all = [265 140 100 240
                    170 35 40 30
                    45 210 40 25];

    init_pos = init_pos_all(video_no, :);
     
    x = init_pos(1);
    y = init_pos(2);
    w = init_pos(3);
    h = init_pos(4);
    
    % Sobel filters
    Sx = [-1 0 1; -2 0 2; -1 0 1]; 
    Sy = [-1 -2 -1; 0 0 0; 1 2 1]; 

    Ix = imfilter(target, Sx, 'replicate');
    Iy = imfilter(target, Sy, 'replicate');
    J = [Ix(:), Iy(:)]; 
    H = J' * J;

    p = [0; 0]; 

    num_frames = length(frame_list);
    figure;
    tiledlayout(ceil(num_frames / 4),4,'TileSpacing', 'none', 'Padding', 'compact');
    
    for i = 1:num_frames
        frame_rgb = imread(fullfile(video_path, frame_list{i}));
        frame_gray = double(rgb2gray(frame_rgb));
        delta_p = [inf; inf];
        for iter = 1:max_iter
           if norm(delta_p) > epsilon
                x_p = x + round(p(1));
                y_p = y + round(p(2));
                candidate = frame_gray(y_p:y_p+h-1, x_p:x_p+w-1);
                error = target - candidate;
                b = J' * error(:);
                delta_p = H \ b;
                p = p + delta_p;
           else
               break
           end
        end

        x = x + round(p(1));
        y = y + round(p(2));
        target = candidate;

        nexttile;
        imshow(frame_rgb, []);
        hold on;
        rectangle('Position', [x, y, w, h], 'EdgeColor', 'r', 'LineWidth', 1.5);
        hold off;
        title(sprintf('Frame %d', i),'FontSize', 6);
%         pause(0.2)
    end
    sgtitle(sprintf('Tracked Template Across Frames $\\epsilon = 10^{%d}$, max iteration = %d', ...
            log10(epsilon), max_iter), 'Interpreter', 'latex');

end

