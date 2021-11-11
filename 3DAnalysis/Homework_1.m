clear all; close all; clc;

% Load the image
depth = int32(imread('04972/depth/0001841-000061399420.png'));
%rgb = int32(imread('00003/rgb/0000001-000000000000.jpg'));

% Set the parameter (from database)
[row, column] = size(depth);
% fu = fKu
fu = 525;
% fv = fkv
fv = 525;
uo = 319.5;
vo = 239.5;

figure(9);
imshow(depth,[min(depth,[],'all'),max(depth,[],'all')]);
colormap jet;
colorbar;
colormap;

% Design the 3d cloud of points
cloudPoints = [];
colors = [];
counter = 1;

x_im = zeros(size(depth));
y_im = zeros(size(depth));

for u = 1:row
    for v = 1:column
        z = depth(u,v);
        
        if z > 850 || z == 0
            continue
        end
        
        if counter < 5 
            counter = counter + 1;
            continue
        end
        
        x_im = -((depth(u,v)*(u - uo))/fu);
        y_im = -((depth(u,v)*(v - vo))/fv);
        
        cloudPoints = [cloudPoints; [x_im y_im z]];
        counter = 1;
        %colors = [colors; rgb(u,v)];
    end
end

figure(1);
%pcshow(cloudPoints)
plot3(cloudPoints(:,1), cloudPoints(:,2), cloudPoints(:,3), 'or');
title('Cloud of Points')

 % 3D plane model
cloudPoint = pointCloud(double(cloudPoints)); 
plane = pcfitplane(cloudPoint, 5); 

a = plane.Parameters(1);
b = plane.Parameters(2);
c = plane.Parameters(3);
d = plane.Parameters(4);

 planePoints3D = [];
 for xi=cloudPoint.XLimits(1):10:cloudPoint.XLimits(2)
     for yi=cloudPoint.YLimits(1):10:cloudPoint.YLimits(2)
            zi = -d/c - b/c*yi - a/c*xi;
            planePoints3D = [planePoints3D; [xi, yi, zi]];
      end
end
%[a, b, c, d, planePoints3D, cloudPoint, plane ] = planeModel(cloudPoints);

% Normal computation
normal = plane.Normal;

% Find the clean plane from cloud of points
[cloudPoints_fitted, outlier] = planeFitting(cloudPoints, a,b, c,d);

figure(2);
plot3(cloudPoints_fitted(:,1), cloudPoints_fitted(:,2), cloudPoints_fitted(:,3), 'or');
hold on
plot3(outlier(:,1), outlier(:,2), outlier(:,3), 'ob');
title(' Inlier and outlier')
legend('Inliers', 'Outliers')

% Plane plotting
figure(3);
% pcshow(cloudPoints, (ones(length(cloudPoints),3)))
plot3(cloudPoints_fitted(:,1), cloudPoints_fitted(:,2), cloudPoints_fitted(:,3), 'or');
hold on;
% pcshow(planePoints3D);
% pcshow(normal_line3D);
plot3(planePoints3D(:,1), planePoints3D(:,2), planePoints3D(:,3), 'ob');
title('Plane fitting vs Mathematical plane');

%Point-to-Plane 3D projection 
Pplane = planePoints3D(100,:); 
P1 = double(outlier(50,:)); 
[projection] = point2plane_projection(normal, P1, Pplane);

figure(4);
plot3(planePoints3D(:,1), planePoints3D(:,2), planePoints3D(:,3), 'or');
hold on;
quiver3(projection(1), projection(2), projection(3), ...
normal(1)*50, normal(2)*50, normal(3)*50, 'g');
hold on;
plot3(projection(:,1), projection(:,2), projection(:,3), 'ob');
hold on;
plot3(P1(:,1), P1(:,2), P1(:,3), 'ob');
hold on;
plot3(cloudPoints_fitted(:,1), cloudPoints_fitted(:,2), cloudPoints_fitted(:,3), 'og');
title('Point-to-Plane 3D projection');

%disp("Point: " + num2str(P3(1)) + " " + num2str(P3(2)) + " " + num2str(P3(3))); 
%disp("Projection: " + num2str(P3_proj(1)) + " " + num2str(P3_proj(2)) + " " + num2str(P3_proj(3)));

% Find the bound of the model 
boundIndex = (boundary(cloudPoints_fitted(:,1), cloudPoints_fitted(:,2), 1));
boundPoints = cloudPoints_fitted(boundIndex,:);
figure(5);
plot3(cloudPoints_fitted(:,1), cloudPoints_fitted(:,2), cloudPoints_fitted(:,3), 'ob');
hold on;
plot3(boundPoints(:,1), boundPoints(:,2), boundPoints(:,3), 'og', 'MarkerFaceColor', '#50F050');
title('Boundary of the plane');

[centroids] = computeCentroids(cloudPoints_fitted);
        
% Lines intersection
PA = [planePoints3D(1,:); planePoints3D(30,:);];
PB = [planePoints3D(4,:); (planePoints3D(6,:) + planePoints3D(4,:))/2;];
lines = [planePoints3D(1,1:2); planePoints3D(2,1:2);planePoints3D(26,1:2); planePoints3D(52,1:2);];
[line_intersection] = lineIntersection(PA, PB, lines);

% Angle between 2 lines
L1 = planePoints3D(1,:);
L2 = planePoints3D(30,:);
[Theta] = angle2lines(line_intersection,L1, L2);

% Ransac

[bestFit1, outliers1,  inliers1] = Ransac(boundPoints, 3000, 4 ,30);
[bestFit2, outliers2, inliers2] = Ransac(outliers1, 2000, 8 ,30);
[bestFit3, outliers3, inliers3] = Ransac(outliers2, 2000, 8 ,30);
[bestFit4, outliers4, inliers4] = Ransac(outliers3, 2000, 10 ,30);
 
[line1] = printLine(bestFit1);
[line2] = printLine(bestFit2);
[line3] = printLine(bestFit3);
[line4] = printLine(bestFit4);

[vertices] = findLineIntersection(bestFit1, bestFit2, bestFit3, bestFit4);

figure(6);
plot3(cloudPoints_fitted(:,1), cloudPoints_fitted(:,2), cloudPoints_fitted(:,3), 'ob');
% hold on;
% plot3(boundPoints(:,1), boundPoints(:,2), boundPoints(:,3), 'og', 'MarkerFaceColor', '#50F050');

hold on
 plot3(inliers1(:,1), inliers1(:,2), inliers1(:,3),  'o', 'MarkerFaceColor', '#50F050');
hold on
 plot3(inliers2(:,1), inliers2(:,2), inliers2(:,3),  'o', 'MarkerFaceColor', '#ff9b00');
hold on
 plot3(inliers3(:,1), inliers3(:,2), inliers3(:,3),  'o', 'MarkerFaceColor', '#007301');
 hold on
 plot3(inliers4(:,1), inliers4(:,2), inliers4(:,3),  'o', 'MarkerFaceColor', '#94ecdd');
 
hold on;
 H1 = plot3(line1(1,:), line1(2,:), line1(3,:));
 set(H1, 'XLimInclude', 'off', 'YLimInclude', 'off', 'ZLimInclude', 'off', 'Color', 'red');
H2 = plot3(line2(1,:), line2(2,:), line2(3,:));
set(H2, 'XLimInclude', 'off', 'YLimInclude', 'off', 'ZLimInclude', 'off', 'Color', 'red');
hold on;
H3 = plot3(line3(1,:), line3(2,:), line3(3,:));
set(H3, 'XLimInclude', 'off', 'YLimInclude', 'off', 'ZLimInclude', 'off', 'Color', 'red');
hold on;
H4 = plot3(line4(1,:), line4(2,:), line4(3,:));
set(H4, 'XLimInclude', 'off', 'YLimInclude', 'off', 'ZLimInclude', 'off', 'Color', 'red');

hold on;
plot3(vertices(:,1), vertices(:,2), vertices(:,3), '*r');
hold on;
plot3(centroids(1), centroids(2), centroids(3), 'or');

legend('data', 'inliers1', 'inliers2', 'inliers3', 'inliers4', 'line1', 'line2', 'line3', 'line4', 'intersection','centroid')
