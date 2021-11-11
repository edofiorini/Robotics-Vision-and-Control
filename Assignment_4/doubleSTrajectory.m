function [q, qd, qdd, qddd, T]= doubleSTrajectory(ti, tf,qi, qf, dqi, dqf, dqmax, ddqmax, dddqmax,  alpha,beta, Ts)

    ddqmin = -ddqmax;
    dddqmin = -dddqmax;
    % check if the qf < qi and change the sign
    flag = 0; 
    if qf < qi
        flag = 1;
        [qi, qf, dqi, dqf] = changeSign(qi, qf, dqi, dqf);
    end
    
    a = sqrt((abs(dqf - dqi))/dddqmax);
    b = ddqmax/dddqmax;
    
    if a > b
        tjstar = b;
    else
        tjstar = a;
    end
    
    %Feasibility condition
    if tjstar < ddqmax/dddqmax
        if tjstar*(dqi + dqf) > qf-qi
            error('The trajectory is not feasible!');
        end
        
    elseif tjstar == ddqmax/dddqmax
        if (0.5)*(dqi + dqf)*(tjstar + ((abs(dqf - dqi))/dddqmax)) > qf-qi
            error('The trajectory is not feasible!');
        end
        
    end

    % case with the fixed duration DT
    if alpha > 0 && beta > 0
        
        disp("SUBCASE with alpha and beta")
        if alpha > 0.5 && beta > 0.5
            error('The conditions on alpha and beta are not ok!')
        end
        
        dt = tf - ti;  
        dq = qf - qi; 
        ta = alpha*dt;
        td = alpha*dt;
        Tj1 = beta*ta;
        Tj2 = beta*td;
        
        dqmax = dq/((1 - alpha)*dt);
        ddqmax = dq/(alpha*(1 - alpha)*(1 - beta)*(dt^2));
        dddqmax = dq/((alpha^2)*(beta)*(1 - alpha)*(1 - beta)*(dt^3));
        tv = dt - ta - td;
        %tv = (qf - qi)/dqmax - (ta/2)*(1 + (dqi/dqmax)) - (td/2)*(1 + (dqf/dqmax));
        dqlim = dqmax;
        ddqalim = ddqmax;
        ddqdlim = -ddqmax;
        dddqmin = -dddqmax;
    
    else
        
        % case 1 ----- dqlim = dqmax 
        if (dqmax - dqi)*dddqmax < ddqmax^2
            disp("SUBCASE 1")
            disp('We are in the first case and ddqmax is not reached!')
        
            Tj1 = sqrt((dqmax - dqi)/dddqmax);
            Tj2 = sqrt((dqmax - dqf)/dddqmax);
            ta = 2*Tj1;
            td = 2*Tj2;
            ddqalim = dddqmax*Tj1;
            ddqdlim = -(dddqmax*Tj2);
        
        else
            disp("SUBCASE 1")
            disp('We are in the first case and ddqmax is reached!')
        
            Tj1 = ddqmax/ dddqmax;
            Tj2 = ddqmax/ dddqmax;
            ta = Tj1 + (dqmax - dqi)/ddqmax;
            td = Tj2 + (dqmax - dqf)/ddqmax;
            ddqalim = ddqmax;
            ddqdlim = ddqmin;
        

        end
    
        tv = (qf - qi)/dqmax - (ta/2)*(1 + (dqi/dqmax)) - (td/2)*(1 + (dqf/dqmax));
    
        if tv > 0
            disp('The maximum velocity is reached')
            dqlim = dqmax;
        
        else
            disp("SUBCASE 2")
            disp('The maximum velocity is not reached! dqlim is smaller than dqmax')
            tv = 0;
    
            % case 2 --- dqlim < dqmax and max accelerations are reached in both
            % segments
            Tj = ddqmax/dddqmax;
            Tj1 = Tj;
            Tj2 = Tj;
            D = (ddqmax^4)/(dddqmax^2) + 2*(dqi^2 + dqf^2) + (ddqmax*(4*(qf - qi)-2*(ddqmax/dddqmax)*(dqi + dqf)));
            ta = (((ddqmax^2)/dddqmax) - 2*dqi + sqrt(D))/ (2*ddqmax);
            td = (((ddqmax^2)/dddqmax) - 2*dqf + sqrt(D))/ (2*ddqmax);
        
            ddqalim = dddqmax*Tj1;
            dqlim = dqi + (ta - Tj1)*ddqalim;
            ddqdlim = -(dddqmax*Tj2);
            %dqlim = dqf - (ta - Tj2)*ddqdlim;
            
            % Check  if there is ta or td
            if ta < 2*Tj && ta > 0
                error('ta < 2*Tj')
            
            
            elseif td < 2*Tj && td > 0
                error('td < 2*Tj')
        
            end
            
            % Check if ta or td is negative and reset
            if ta <= 0
                ta = 0;
                Tj1 = 0;
            end
            
            if td <= 0
                td = 0;
                Tj2 = 0;
            end
        
        end
    
    end
    
    fprintf('Tj1: %f\nTj2: %f\nta: %f\ntd %f\n',Tj1,Tj2, ta, td)
    fprintf('tv: %f\ndqmax: %f\ndqlim: %f\nddqmax: %f\n',tv,dqmax, dqlim, ddqmax)
    fprintf('ddqalim: %f\nddqdlim: %f\ndddqmax: %f\ndddqmin %f\n',ddqalim,ddqdlim, dddqmax, dddqmin)
    
    % Build the correct time-line
    Dt = ta + tv + td;
   
    t_1 = ti: Ts: ti + Tj1;
    t_2 = ti + Tj1 + Ts: Ts: ti + ta - Tj1;
    t_3 = ti + ta - Tj1 + Ts:Ts: ti + ta;
    t_4 = ti + ta + Ts:Ts: ti + ta + tv;
    t_5 = ti + Dt - td + Ts: Ts:ti + Dt - td + Tj2;
    t_6 = ti + Dt - td + Tj2 + Ts:Ts:ti+ Dt - Tj2;
    t_7 = ti + Dt - Tj2 + Ts: Ts:ti + Dt;
    
    T = [t_1, t_2,t_3,t_4,t_5,t_6,t_7];
           

    %position
    
    q_a = qi + dqi*(t_1 - ti) + dddqmax*(((t_1 - ti).^3)/6);
    q_b = qi + dqi*(t_2 - ti) + (ddqalim/6)*(3*((t_2 - ti).^2) - 3*Tj1*(t_2 - ti) + Tj1^2);
    q_c = qi + (dqlim + dqi)*(ta/2) - dqlim*(ta - (t_3 - ti)) - dddqmin*(((ta - (t_3 - ti)).^3)/6);
    q_d = qi + (dqlim + dqi)*(ta/2) + dqlim*((t_4 - ti) - ta);
    q_e = qf - (dqlim + dqf)*(td/2) + dqlim*((t_5 - ti) - Dt + td) - dddqmax*((((t_5 - ti) - Dt + td).^3)/6);
    q_f = qf - (dqlim + dqf)*(td/2) + dqlim*((t_6 - ti) - Dt + td) + (ddqdlim/6)*(3*(((t_6 - ti) - Dt + td).^2) - 3*Tj2*((t_6 - ti) - Dt + td) + Tj2^2);
    q_g = qf - dqf*(Dt - (t_7 - ti)) - dddqmax*(((Dt - (t_7 - ti)).^3)/6);
   
    q = [q_a, q_b, q_c, q_d, q_e, q_f, q_g];
    
    %velocity
    qd_a = dqi + 3*dddqmax*(((t_1 - ti).^2)/6);
    qd_b = dqi + (ddqalim/6)*(6*(t_2 - ti) - 3*Tj1);
    qd_c = dqlim - dddqmin*((-3*((t_3 - ti).^2)) -3*ta^2 + 6*ta*(t_3 - ti))/6;
    qd_d = ones(1, length(t_4))*dqlim;
    qd_e = dqlim - dddqmax*(3*(((t_5 - ti) - Dt + td).^2)/6);
    qd_f = dqlim + (ddqdlim/6)*(3*(2*(t_6 - ti) - 2*Dt + 2*td) - 3*Tj2);
    qd_g = dqf - dddqmax*((-3*((t_7 - ti).^2)) -3*Dt^2 + 6*Dt*(t_7 - ti))/6;
    
    qd = [qd_a, qd_b, qd_c, qd_d, qd_e, qd_f, qd_g];
    
    %accleration
    qdd_a = 3*dddqmax*(2*(t_1 - ti)/6);
    qdd_b = ones(1,length(t_2))*ddqalim;
    qdd_c = -dddqmin*((-3*(2*(t_3 - ti)))+ 6*ta)/6;
    qdd_d = zeros(1, length(t_4));
    qdd_e = -dddqmax*(3*(2*((t_5 - ti) - Dt + td))/6);
    qdd_f = ones(1, length(t_6))*ddqdlim;
    qdd_g = -dddqmax*((-3*(2*(t_7 - ti)))+6*Dt)/6;
    
    qdd = [qdd_a, qdd_b, qdd_c, qdd_d, qdd_e, qdd_f, qdd_g];
    
    %jerk
    qddd_a = ones(1, length(t_1))* dddqmax;
    qddd_b = zeros(1, length(t_2));
    qddd_c = ones(1, length(t_3))* dddqmin;
    qddd_d = zeros(1, length(t_4));
    qddd_e = ones(1, length(t_5))* dddqmin;
    qddd_f = zeros(1, length(t_6));
    qddd_g = ones(1, length(t_7))* dddqmax;
    
    qddd = [qddd_a, qddd_b, qddd_c, qddd_d, qddd_e, qddd_f, qddd_g];
    
    % In the case of qf < qi rechange the sign again
    if flag == 1
        [q, qd, qdd, qddd] = changeSign(q, qd, qdd, qddd);
    end
    
end