function [line_intersection] = lineIntersection(PA, PB, lines)
        
        point = linlinintersect(lines);
        if isnan(point)
            disp('The two line are parallel!')
        else
            [P_intersect,distances] = lineIntersect3D(PA,PB);
            [lineProjection,point2line_distance ] = point2line_projection(PA(1,:), PB(1,:), P_intersect);
            
            if point2line_distance > 10^-6
                disp('The intersection is only in 2D')
                line_intersection = point;
            else
                disp('The intersection is in 3D')
                 line_intersection = P_intersect;
            end
        end   
end

