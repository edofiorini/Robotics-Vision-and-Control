function [line] = printLine(bestFit)
        
        %dir1 = (bestFit(1,:) - bestFit(2,:)) / norm(bestFit(1,:) - bestFit(2,:) );
        
        nx = bestFit(1,1) - bestFit(2,1);
        ny = bestFit(1,2) - bestFit(2,2);;
        nz = bestFit(1,3) - bestFit(2,3);;
        len = 1000;
        xx = [bestFit(1,1) - len*nx, bestFit(2,1) + len*nx];
        yy = [bestFit(1,2) - len*ny, bestFit(2,2) + len*ny];
        zz = [bestFit(1,3) - len*nz, bestFit(2,3) + len*nz];
        
        line = [xx ; yy; zz;];
end

