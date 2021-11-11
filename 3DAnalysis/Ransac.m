function [bestFit, outliers, inliers] = Ransac(data, k, t,d)

        iterations = 0;
        bestFit = realmin;
        bestErr =  realmax;
        
        while iterations < k
     
            one = 0; two = 0;
            while one == two 
                    one = randi([1 size(data,1)]);
                    two = randi([1 size(data,1)]);
                   maybeInliers = [data(one,:); data(two,:)];
            end
                
            maybeModel = maybeInliers;
            alsoInliers = [];
            maybeoutliers = []; 
            distance = [];
            for i=1: size(data,1)
                
                if i == one || i == two
                    continue 
                end
                
               
                [lineProjection,point2line_distance ] = point2line_projection(maybeModel(1,:), maybeModel(2,:), data(i,:));
                if point2line_distance < t
                    alsoInliers = [alsoInliers; data(i,:)];
                    distance = [distance, point2line_distance];
                else
                    maybeoutliers = [maybeoutliers; data(i,:) ];
                end
            end
            
            thisErr = mean(distance);
            
            if size(alsoInliers, 1) > d
                betterModel = maybeInliers;
                
                if thisErr < bestErr
                    bestFit = betterModel;
                    BestErr = thisErr;
                    outliers = maybeoutliers;
                    inliers = [maybeInliers; alsoInliers];
                end
            end
            iterations = iterations + 1;
        end
        
end

