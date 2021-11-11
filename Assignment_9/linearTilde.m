function [Ptilde, DPtilde, DDPtilde,  T] = linearTilde(pi, pf, Ts, Ptilde, DPtilde, DDPtilde, T, ti, tf)

    % Timing law for s(t)
    [s, sd, sdd, sddd, s_tmp] = fifth_polynomials(0, norm(pf - pi), 0, 0, 0, 0, ti, tf, Ts);

      % computhe the ptilde with timing law
    p = pi + s.*((pf - pi)/(norm(pf - pi)));
    dp = sd.*((pf - pi)/(norm(pf - pi)));
    ddp = sdd.*((pf - pi)/(norm(pf - pi)));
   
    
   
    %end
    
    
    % Upload the vectors ptilde  
    Ptilde = [Ptilde, p];
    DPtilde = [DPtilde, dp];
    DDPtilde = [DDPtilde, ddp];
    T = [T, s_tmp];
    
end

