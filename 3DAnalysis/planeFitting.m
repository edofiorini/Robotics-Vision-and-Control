function [cloudPoints_fitted, outlier] = planeFitting(cloudPoints, a,b, c,d)
        
    outlier = [];
    cloudPoints_fitted= [];
    
    for i =1:size(cloudPoints,1)
        distance = point2plane_distance(a,b,c,d,cloudPoints(i,:));
        if distance > 7
            outlier = [outlier;cloudPoints(i,:)];
        else
            cloudPoints_fitted = [cloudPoints_fitted;cloudPoints(i,:) ];
        end
    end

    cloudPoints_fitted = double(cloudPoints_fitted);
end

