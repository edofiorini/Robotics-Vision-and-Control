function [a,b,c,d] = findParameters(radius, p0)
        
        a = -p0(1)*2;
        b = -p0(2)*2;
        c = -p0(3)*2;
        
        d = ((radius/0.5)^2 - (a^2 + b^2 + c^2))/(-4); 
end

