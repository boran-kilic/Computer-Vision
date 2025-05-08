function binary_img = otsu_threshold(img)
    [counts, gray_levels] = imhist(img);
    total_pixels = sum(counts);
    probabilities = counts / total_pixels;
    max_variance = 0;
    threshold = 0;
    
    for t = 1:256
        prob1 = sum(probabilities(1:t));
        prob2 = sum(probabilities(t+1:end));
        
        if prob1 == 0 || prob2 == 0
            continue;
        end
        
        mean1 = sum(gray_levels(1:t) .* probabilities(1:t)) / prob1;
        mean2 = sum(gray_levels(t+1:end) .* probabilities(t+1:end)) / prob2;
        variance = prob1 * prob2 * (mean1 - mean2)^2;
        
        if variance > max_variance
            max_variance = variance;
            threshold = t;
        end
    end
    fprintf("Otsu threshold found as: %d\n",threshold);
    
    binary_img = img >= threshold;
end
