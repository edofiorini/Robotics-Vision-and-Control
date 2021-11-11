function [Ptilde, DPtilde, DDPtilde, T] = circularTilde(pi, pf, Ts, c, Ptilde, DPtilde, DDPtilde, T, flag, ti, tf)
            
    % check if there is points on the same line
    if flag == true
        
        userResponse = input('Enter another P. Write the numbers separated by ,\n', 's')
	
        userResponse = strrep(userResponse, ',', ' ');
	
        p_new = sscanf(userResponse, '%f')
        
        [Ptilde, DPtilde, DDPtilde, T] = circularTilde(pi, p_new, Ts, c, P, DP, DDP, T, false, ti, tf/2);
        [Ptilde, DPtilde, DDPtilde, T] = circularTilde(p_new, pf, Ts, c, P, DP, DDP, T, false, tf/2, tf);
    
    else
   
        %s = 0: Ts: norm(pf - pi);

        %r = cross(c - pf, c - pi);
        %rho = norm(pi - c);
    
        rho = norm(pi-c);
        r = cross(c-pf, c-pi); 
        arc_angle = vecangle(c-pf, c-pi, r); 
        plength = rho*arc_angle;
        
        % Timing law for s(t)
         [s, sd, sdd, sddd, s_tmp] = fifth_polynomials(0, plength, 0, 0, 0, 0, ti, tf, Ts);
       
    
        p_prime = [rho*cos((s/rho));rho*sin((s/rho));zeros(1,length(s))];
    
        % R matrix to find the versors
        x_prime = (pi - c)/rho;
        z_prime = r/norm(r);
        y_prime = cross(x_prime, z_prime);
         R = [x_prime y_prime z_prime];
    
        % computhe the ptilde with timing law
        p = c + R*p_prime;
        dp = R*[    -sd.*sin(s/rho);
                        sd.*cos(s/rho);
                        zeros(1,length(s))                      ];
           
        ddp = R*[   -sd.^2*(1/rho).*cos(s/rho) - sdd.*sin(s/rho) ;
                        -sd.^2*(1/rho).*sin(s/rho) + sdd.*sin(s/rho);
                        zeros(1,length(s))                      ];
            
        % Upload the vectors ptilde  
        Ptilde = [Ptilde, p];
        DPtilde = [DPtilde, dp];
        DDPtilde = [DDPtilde, ddp];
        T = [T, s_tmp];
        


    end   
end

