function [lineProjection,point2line_distance ] = point2line_projection(B, C, Pext)
        
        d = (C -B) /norm(C - B);
        v = Pext - B;
        t = v*d';
        lineProjection = B + t*d;
        
        point2line_distance = norm(lineProjection - Pext);
end

