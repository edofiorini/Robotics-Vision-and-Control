function [projection] = point2plane_projection(normal, Pext, Pplane)

    delta_point = Pplane - Pext;
    
    t = (normal(1)*delta_point(1) + normal(2)*delta_point(2) + normal(3)*delta_point(3))/ ...
        (normal(1)^2 + normal(2)^2 + normal(3)^2);
    
    projection = [Pext(1) + normal(1)*t, Pext(2) + normal(2)*t, Pext(3) + normal(3)*t ];
        
end

