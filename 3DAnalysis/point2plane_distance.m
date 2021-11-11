function [distance] = point2plane_distance(a,b,c,d,P)

    %Point-to-Plane 3D distance computation 
    x=P(1); y=P(2); z=P(3);
    distance = (abs(a*x + b*y + c*z + d)) / (sqrt( a^2 + b^2 + c^2));
    
end

