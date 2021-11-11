function [qi, qf, dqi, dqf] = changeSign(qi, qf, dqi, dqf)
            
        % Change the sign of the value to compute the correct trajectory
        qi = -qi;
        qf = -qf;
        dqi = -dqi;
        dqf = -dqf;
    
end