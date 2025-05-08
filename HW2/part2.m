clear 
close all

for n = 1:10
    filename = sprintf('part2/%d.jpg', n);
    image = imread(filename);  
    [L,N] = superpixels(image,120,"Method","slic", 'Compactness',25);
    BW = boundarymask(L);
    
    outputImage = zeros(size(image),'like',image);
    idx = label2idx(L);
    numRows = size(image,1);
    numCols = size(image,2);
    for labelVal = 1:N
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+numRows*numCols;
        blueIdx = idx{labelVal}+2*numRows*numCols;
        outputImage(redIdx) = mean(image(redIdx));
        outputImage(greenIdx) = mean(image(greenIdx));
        outputImage(blueIdx) = mean(image(blueIdx));
    end

    figure
    set(gcf, 'Position', [0, 0, 1000, 700]);
    subplot(1,2,1);
    imshow(image,[]);title('Original Image')
    subplot(1,2,2);
    imshow(imoverlay(outputImage,BW,'red'));title('Oversegmented Image')
%part3

% grayImg = rgb2gray(outputImage);
grayImg = rgb2gray(image);
% figure; imshow(grayImg)

[EO, BP] = gaborconvolve(grayImg, 4, 4, 3, 1.7, 0.65, 1.3, 0, 0);

gaborFeatures = zeros(N, 16);

orient = [0 pi/4 pi/2 3*pi/4];
scale = [0.25 0.5 0.75 1.0];

for i = 1:N
    % Find the pixels belonging to the current superpixel
    superpixelPixels = find(L == i);
    
    % Extract the Gabor filter responses for these pixels
    responses = zeros(length(superpixelPixels), 16);  % 4 scales * 4 orientations = 16
    
    for s = 1:length(scale)  
        for o = 1:length(orient)  
            index = (s-1)*4 + o;  
            responses(:, index) = abs(EO{s, o}(superpixelPixels));
        end
    end
    
    gaborFeatures(i, :) = mean(responses, 1);  
end


    %  K-means 
    numClusters = 4;  
    
    [clusterLabels, clusterCenters] = kmeans(gaborFeatures, numClusters);
    
    clusterImage = zeros(size(L));  
    
    for i = 1:N 
        superpixelPixels = find(L == i);
        clusterImage(superpixelPixels) = clusterLabels(i);
    end
    
    colors = lines(numClusters); 
    pseudoColorImage = zeros([size(clusterImage), 3]);
    
    
    for i = 1:numClusters
    
        clusterPixels = (clusterImage == i); 
        pseudoColorImage(repmat(clusterPixels, [1, 1, 3])) = repmat(colors(i, :), sum(clusterPixels(:)), 1);
    end
    
    figure;
    imshow(pseudoColorImage);
    title('Pseudo-Color Clustering Result');

end







