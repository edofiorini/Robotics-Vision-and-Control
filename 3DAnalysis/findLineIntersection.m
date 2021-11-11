function [vertices] = findLineIntersection(bestFit1, bestFit2, bestFit3, bestFit4)
            
        
            vert1 = lineIntersect3D([bestFit1(1,:); bestFit2(1,:)], [bestFit1(2,:); bestFit2(2,:)]);
            angle1 = angle2lines(vert1, bestFit1(1,:), bestFit2(1,:));

            if angle1 <= pi/6
                % First and Second lines are (almost) parallel
                vert1 = lineIntersect3D([bestFit1(1,:); bestFit3(1,:)], [bestFit1(2,:); bestFit3(2,:)]);
                vert2 = lineIntersect3D([bestFit1(1,:); bestFit4(1,:)], [bestFit1(2,:); bestFit4(2,:)]);
                vert3 = lineIntersect3D([bestFit2(1,:); bestFit4(1,:)], [bestFit2(2,:); bestFit4(2,:)]);
                vert4 = lineIntersect3D([bestFit2(1,:); bestFit3(1,:)], [bestFit2(2,:); bestFit3(2,:)]);
            else
                % First and Second lines have an intersection (at least in 2D space)
                vert2 = lineIntersect3D([bestFit1(1,:); bestFit3(1,:)], [bestFit1(2,:); bestFit3(2,:)]);
                angle2 = angle2lines(vert2, bestFit1(1,:), bestFit3(1,:));
                
                if angle2 <= pi/6
                    % First and Third lines are (almost) parallel
                    vert2 = lineIntersect3D([bestFit1(1,:); bestFit4(1,:)], [bestFit1(2,:); bestFit4(2,:)]);
                    vert3 = lineIntersect3D([bestFit3(1,:); bestFit4(1,:)], [bestFit3(2,:); bestFit4(2,:)]);
                    vert4 = lineIntersect3D([bestFit2(1,:); bestFit3(1,:)], [bestFit2(2,:); bestFit3(2,:)]);
                else
                    % First and Third lines have an intersection (at least in 2D space)
                    vert3 = lineIntersect3D([bestFit3(1,:); bestFit4(1,:)], [bestFit3(2,:); bestFit4(2,:)]);
                    vert4 = lineIntersect3D([bestFit2(1,:); bestFit4(1,:)], [bestFit2(2,:); bestFit4(2,:)]);
                end
            end
            vertices = [vert1; vert2; vert3; vert4];
end

