function [Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b] = FrenetFrame(p, dp, ddp,ti, tf, pi, pf, Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b, Ts )

    o_EE_t = zeros(3, size(p,2));
    o_EE_n = zeros(3, size(p,2));
    o_EE_b = zeros(3, size(p,2));

    for i = 1: size(p,2)
               
             o_EE_t(:,i )= dp(:,i);
             o_EE_n(:,i) =  ddp(:,i)/norm(ddp(:,i));
             o_EE_b(:,i) = cross(o_EE_t(:,i), o_EE_n(:,i));
  
    end

    % Eulers Angles
    %for i = 1: size(p,2)
    
        R = [o_EE_t(:,1), o_EE_b(:,1), o_EE_n(:,1)];
        PHI_i = [atan2(sqrt(R(1,3)^2 + R(2,3)^2), R(3,3));
                     atan2(R(2,3), R(1,3));
                     atan2(R(3,2), -R(3,1));                        ];                          
        
        R = [o_EE_t(:,end), o_EE_b(:,end), o_EE_n(:,end)];
        PHI_f = [atan2(sqrt(R(1,3)^2 + R(2,3)^2), R(3,3));
                     atan2(R(2,3), R(1,3));
                     atan2(R(3,2), -R(3,1));  ];  

        O_EE_t  =  [O_EE_t, o_EE_t ];
        O_EE_n = [O_EE_n, o_EE_n ];
        O_EE_b = [O_EE_b, o_EE_b ];
       
        [Otilde, DOtilde, DDOtilde, TO] = EEOrientation(PHI_i, PHI_f, Ts,  Otilde, DOtilde, DDOtilde, TO,  ti, tf, pi, pf);
        
end

