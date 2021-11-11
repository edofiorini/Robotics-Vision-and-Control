function [q, qd, qdd, T]= trapezoidalProfileSymmetric(tc, dqc, ddqc, ti, tf, qf, qi, Ts, subcase)

    
   % check if the qf < qi and change the sign
    flag = 0; 
    if qf < qi
         flag = 1;
         [qi, qf, dqi, dqf] = changeSign(qi, qf, 0, 0);
    end
    
   % check all the 4 cases
         
    if subcase == 4
            
            disp("SUBCASE 4")
            tc = dqc / ddqc;
            tf = ti + (dqc^2 + ddqc*(qf - qi)) / (dqc*ddqc);
           
    %1th case         
    elseif subcase == 1
            
            disp("SUBCASE 1")
            ddqc = (qf - qi)/ ((tc*(tf - ti)) - tc^2);
           

            dqc= ddqc*tc;
            alpha = tc/tf;
     
            if 0 > alpha && alpha > 0.5
                error('The condition about alpha are not ok!')
            end
    
     %2th case
    elseif subcase == 2
            
            disp("SUBCASE 2")
            delta = (((tf - ti)^2)*ddqc - 4*(qf - qi))/ddqc;
            
            if delta < 0
                error('The condition about delta are not ok!')
            else
                tc = ((tf - ti)/2) - ((1/2)*sqrt(delta));
            end
             dqc = ddqc*tc;
     %3th case
    elseif subcase == 3
            
            disp("SUBCASE 3")
            tc = (qi - qf + (dqc*(tf - ti)))/ dqc;
            ddqc = (dqc^2)/(qi - qf + (dqc*(tf -ti)));
            
            if(tc < 0 || tc > (tf - ti)/2)
                error('The condition about tc are not ok!');
            end
         
            
    end
    
    
    % Check if tc is ok for a symmetric profile and compute the profile
    if tc > (tf - ti)/2
        	error('The first condition about tc are not ok!')
    end
    
    
    fprintf('tc: %f\ndqc: %f\nddqc: %f\nti %f\n',tc,dqc, ddqc, ti)
    fprintf('tf: %f\nqf: %f\nqi: %f\n',tf, qf, qi)
    
    
    % Build the correct time-line
    samples = round((tf - ti)/Ts);     
    t_1 = linspace(ti, tc + ti, samples);
    t_2 = linspace(tc + ti, tf - tc, samples);
    t_3 = linspace(tf - tc, tf, samples);
    T = [t_1, t_2, t_3];
           
    % position
    q_a = qi + ((dqc/(2*tc))*((t_1 - ti).^2));
    q_c = qi + ((dqc)*(t_2 - ti - (tc/2)));
    q_d = qf - ((dqc/(2*tc))*(tf - t_3).^2);
    q = [q_a, q_c, q_d];
            
    % velocity
    qd_a = (dqc/tc)*(t_1-ti);
    qd_c = ones(1,samples)*dqc;
    qd_d = (dqc/tc)*(tf -t_3);
    qd = [qd_a, qd_c, qd_d];

    % acceleration
    qdd_a = ones(1,samples)*(dqc/tc);
    qdd_c = zeros(1, samples);
    qdd_d = ones(1,samples)* (- (dqc/tc));
    qdd = [qdd_a, qdd_c, qdd_d];
    
    % In the case of qf < qi rechange the sign again
    if flag == 1
       [q, qd, qdd, Te] = changeSign(q, qd, qdd, T);
    end
    
end