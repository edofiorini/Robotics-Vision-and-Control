function [Q, Qd, Qdd, dqk, T] = computedVelocities(qk, tk, k, dqi, dqf, Ts)
    
    % Initialize the Vk and velocities. 
    % Impose the first value equal to zero
    
    dqk = dqi;
    Vk = 0;
    
    % Compute all the euler approximation 
    for i = 2:k
        vk = (qk(:,i) - qk(:,i-1))/(tk(:,i) - tk(:,i-1));
        Vk = [Vk, vk];
    end
    
    
    % Compute all the velocities 
    for i = 2:k-1
        
        if(sign(Vk(:,i)) == sign(Vk(:, i+1)))
            dqk = [dqk, (Vk(:,i) + Vk(:, i+1))/2];
        else
            dqk = [dqk, 0];
        end
    end
    
    dqk = [dqk, dqf];
 
    [Q, Qd, Qdd, T] = imposedVelocities(qk, dqk, tk, k, Ts);
    
    
end