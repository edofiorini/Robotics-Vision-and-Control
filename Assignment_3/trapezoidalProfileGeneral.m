function [q, qd, qdd, T]= trapezoidalProfileGeneral( dqc, ddqc, ti, tf, qf, qi, dqi, dqf, Ts, subcase)
            

             % check if the qf < qi and change the sign
             flag = 0; 
             if qf < qi
                flag = 1;
                [qi, qf, dqi, dqf] = changeSign(qi, qf, dqi, dqf);
             end
            
            Dt = tf - ti;
            Dq = qf - qi;
            % subcase = [Dt, ddqc, dqc];
            
            % check all the cases
            if subcase == 1
                  disp("SUBCASE 1")
                  
                  if ddqc*Dq < (abs(dqi^2- dqf^2))/2
                      error('The condition about the feasibility is not ok!')
                  end
                  
                  delta = ((ddqc^2)*(Dt^2)) - 4*ddqc*Dq + 2*ddqc*(dqi+dqf)*Dt - (dqi-dqf)^2;
                  
                  
                  if delta < 0
                      error('The condition about the delta is not ok!')
                  end
                  
                  dqc = 0.5*(dqi + dqf + (ddqc*Dt) - sqrt(delta));
                  
                  delta_1 = 4*(Dq^2) - 4*Dq*(dqi + dqf)*Dt + 2*(dqi^2 + dqf^2)*Dt^2;
                  ddqc_lim = (2*Dq - (dqi + dqf)*Dt + sqrt(delta_1))/Dt^2;
                  
                  if ddqc_lim > ddqc
                      error('DDQClim is larger than DDQC!')
                  end
                  
                   if ddqc_lim == ddqc
                      disp('there is no constant velocity phase!')
                  end
                  ta = (dqc - dqi)/ddqc;
                  td = (dqc - dqf)/ddqc;
                  tf = Dt + ti;
                    
                  
                  
                  if ta < 0 || td < 0
                      error('ta or td is smaller than zero')
                  end
                
            elseif subcase == 2
                
                   disp("SUBCASE 2")
                  if ddqc*Dq < (abs(dqi^2- dqf^2))/2
                      error('The condition about the feasibility is not ok!')
                  
                  elseif ddqc*Dq > (dqc^2)-((dqi^2 + dqf^2)/2)
                      
                      disp("dqc is reached during the constant velocity phase!")
                      ta = (dqc - dqi)/ddqc;
                      td = (dqc - dqf)/ddqc;
                      Dt = Dq/dqc + (dqc/(2*ddqc)*(1 - (dqi/dqc))^2) + ((dqc/(2*ddqc))*((1 - (dqf/dqc))^2));
                      tf = ti + Dt;
                  else 
                      
                       disp("dqc is not reached during the constant velocity phase! --> Constant velocity phase is not present!")
            
                      dqc_lim = sqrt((ddqc*Dq) + (((dqi^2) + (dqf^2))/2));
                      dqc = dqc_lim;
                      ta = (dqc - dqi)/ddqc;
                      td = (dqc - dqf)/ddqc;
                      Dt = ta + td;
                      tf = ti + Dt;
                  end
                  
                  if ta < 0 || td < 0
                      error('ta or td is smaller than zero')
                  end

            end
            
           
             fprintf('dqc: %f\nddqc: %f\nti %f\n',dqc, ddqc, ti)
             fprintf('dqf: %f\ndqi: %f\n', dqf, dqi)
             fprintf('tf: %f\nqf: %f\nqi: %f\n',tf, qf, qi)
              
            %Rescaling of the samples
            
            samples_1 = ((ta)/Ts);
            samples_2 = ((tf - ti - td - ta - Ts)/Ts);
            samples_3 = ((td - Ts)/Ts);
            
            t_1 = linspace(ti, ti + ta, samples_1);
            t_2 = linspace(ti + ta + Ts , tf - td, samples_2);
            t_3 = linspace(tf - td, tf, samples_3);
            T = [t_1, t_2, t_3];
           
            % position   
             q_a = qi + (dqi*(t_1 - ti)) + (((dqc-dqi)/(2*ta))*((t_1 - ti).^2));
             q_c = qi + (dqi*(ta/2)) + (dqc*((t_2 - ti - (ta/2))));
             q_d = qf - (dqf*(tf - t_3)) - ((dqc - dqf)/(2*td)*((tf - t_3).^2));
             q = [q_a, q_c, q_d];
           
            % velocity
            qd_a = dqi + (((dqc - dqi)/ta)*(t_1 - ti));
            qd_c = ones(1,length(q_c))*dqc;
            qd_d = dqf + (((dqc - dqf)/td)*(tf - t_3));
            qd = [qd_a, qd_c, qd_d];

            % acceleration
            qdd_a = ones(1, length(qd_a))*ddqc;
            qdd_c = zeros(1, length(qd_c));
            qdd_d = ones(1, length(qd_d))*(-ddqc);
            qdd = [qdd_a, qdd_c, qdd_d];
            
            
             % In the case of qf < qi rechange the sign again
            if flag == 1
                    [q, qd, qdd, Te] = changeSign(q, qd, qdd, T);
            end
end