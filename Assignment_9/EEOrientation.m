function [Otilde, DOtilde, DDOtilde, TO] = EEOrientation(PHI_i, PHI_f, Ts,  Otilde, DOtilde, DDOtilde, TO, ti, tf, pi, pf)

       % Timing law for s(t)
    [s, sd, sdd, sddd, s_tmp] = fifth_polynomials(0, norm(PHI_f - PHI_i), 0, 0, 0, 0, ti, tf, Ts);

      % computhe the ptilde with timing law
    o = PHI_i +  s.*((PHI_f - PHI_i)/(norm(PHI_f - PHI_i)));
    do = sd.*((PHI_f - PHI_i)/(norm(PHI_f - PHI_i)));
    ddo = sdd.*((PHI_f - PHI_i)/(norm(PHI_f - PHI_i)));
   
    % Upload the vectors ptilde  
    Otilde = [Otilde, o];
    DOtilde = [DOtilde, do];
    DDOtilde = [DDOtilde, ddo];
    TO = [TO, s_tmp];
   
end

