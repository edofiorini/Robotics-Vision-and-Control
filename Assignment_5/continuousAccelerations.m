function [Q, Qd, Qdd, T, dqk] = continuousAccelerations(qk, tk, k, dqi, dqf, Ts)

    % Inizialization of all the vectors
    Tk = [];
    A = [];  
    C = [];
    j = 1;
    
    % Build the Tk vector
    
    for i = 1:k-1
        
        Tk_tmp = tk(:,i+1) - tk(:,i);
        Tk = [Tk, Tk_tmp];
        
    end
    
    % Build the matricies A and C
    for i = 1:k-2
        
        % About matrix C
        c = 3*(Tk(:,i+1)/Tk(:,i))*(qk(:,i+1) - qk(:,i)) + 3*(Tk(:,i)/Tk(:,i+1))*(qk(:,i+2) - qk(:,i+1));
        

        
        C = [C; c];
        
        
        % About matrix A
        a = zeros(1, k-2);
        
        if i == 1
            a(1, j) = 2*(Tk(:,i) + Tk(:, i+1)); 
            if k > 3
                a(1, j+1) = Tk(:,i);
            end
            
        elseif i == k-2
            a(1, j) =  Tk(:,i+1);
            a(1, j+1) = 2*(Tk(:,i+1) + Tk(:, i)); 
            
        else
            a(1, j) = Tk(:,i+1);
            a(1, j+1) = 2*(Tk(:,i) + Tk(:, i+1)); 
            a(1, j+2) =  Tk(:,i);
            
            j = j + 1;
        end
        
        A = [A; a];
        
    end
    
          
     C(1) = C(1) - Tk(:,2)*dqi;
     C(end) = C(end) - Tk(:,k-2)*dqf;
       
        
    %Find the dqk vector
    dqk_temp = inv(A)*C;
    dqk = [dqi, dqk_temp', dqf];
        
    [Q, Qd, Qdd, T] = imposedVelocities(qk, dqk, tk, k, Ts);
    
end