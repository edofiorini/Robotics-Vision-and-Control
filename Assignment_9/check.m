function out  = check(Pg, p0, r)
        
        if( (Pg(1,1)- p0(1))^2 + (Pg(2,1)-p0(2))^2 + (Pg(3,1)-p0(3))^2 == r^2)
            out = true;
        else
            out = false
        end
end

