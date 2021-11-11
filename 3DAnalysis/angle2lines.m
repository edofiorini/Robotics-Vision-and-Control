function [Theta] = angle2lines(line_intersection,L1, L2)
        
        % angle beetwen 2 lines
        S1 = L1 - line_intersection;
        S2 = L2 - line_intersection;
        Theta = atan2(norm(cross(S1, S2)), dot(S1, S2));
        
end

