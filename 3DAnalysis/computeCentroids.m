function [centroids] = computeCentroids(cloudPoints_fitted)
        
        centroids = mean(cloudPoints_fitted);
end

