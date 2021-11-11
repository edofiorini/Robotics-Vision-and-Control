clear all; close all;clc;

depth = int32(imread('00003/depth/0000001-000000000000.png'));
rgb = int32(imread('00003/rgb/0000001-000000000000.jpg'));


[row, column] = size(depth);
% fu = fKu
fu = 525;
% fv = fkv
fv = 525;
uo = 319.5;
vo = 239.5;

figure(1);
imshow(depth,[min(depth,[],'all'),max(depth,[],'all')]);
colormap jet;
colorbar;
colormap;

indexmap = zeros(row, column);
pointCloud = [];
colors = [];
index = 1;

x_im = zeros(size(depth));
y_im = zeros(size(depth));

for u = 1:row
    for v = 1:column
        z = depth(u,v);
        if z == 0
            continue
        end
        x_im = -((depth(u,v)*(u - uo))/fu);
        y_im = -((depth(u,v)*(v - vo))/fv);
        
        pointCloud = [pointCloud; [x_im y_im -z]];
        colors = [colors; rgb(u,v)];
        
        indexmap(u, v) = index;
        index = index +1;
        
    end
end

faces = [];
t = 7;

for u = 1:row - 1
    for v = 1: column - 1
        z = depth(u,v);
        if z == 0
            continue
        end
        
       v_or = v + 1;
       u_ver = u + 1;
       in_diag_u = u_ver;
       in_diag_v = v_or;
        A = indexmap(u,v);
        B = indexmap(u_ver,v);
        C = indexmap(u, v_or);
        D = indexmap(in_diag_u, in_diag_v);
        
        if B == 0 || C == 0 
            continue
        end
        
        if D == 0
            seg1 = point2point_distance(double(pointCloud(A,:)), double(pointCloud(B,:)));
            seg2 = point2point_distance(double(pointCloud(A,:)), double(pointCloud(C,:)));
            seg5 = point2point_distance(double(pointCloud(B,:)), double(pointCloud(C,:)));
            
            if seg1 < t || seg2< t || seg5 < t
                faces = [faces; [A B C]];
            end
            
        else
            
           
            seg1 = point2point_distance(double(pointCloud(A,:)), double(pointCloud(B,:)));
            seg2 = point2point_distance(double(pointCloud(A,:)), double(pointCloud(C,:)));
            seg3 = point2point_distance(double(pointCloud(B,:)), double(pointCloud(D,:)));
            seg4 = point2point_distance(double(pointCloud(C,:)), double(pointCloud(D,:)));
            seg5 = point2point_distance(double(pointCloud(B,:)), double(pointCloud(C,:)));
        
            if seg1 < t || seg2< t || seg5 < t
                faces = [faces; [A B C]];
            elseif seg3 < t || seg4< t || seg5 < t
                faces = [faces; [B C D]];
            end
        end
        
    end
    
end

figure(2)
%pcshow(pointCloud)
 plot3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3),'r.');

exportMeshToPly(pointCloud, faces , colors, 'es3');

