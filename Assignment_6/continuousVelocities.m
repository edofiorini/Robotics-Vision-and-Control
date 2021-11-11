function [Q, Qd, Qdd, ddqk, T] = continuousVelocities(qk, dqi, dqf, tk, k, Ts)
    
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
    for i = 1:k
        
        % About matrix C
        if i == 1
            c = 6*(((qk(i + 1) - qk(i))/Tk(i)) - dqi );
        elseif i == k
            c = 6*(dqf - ((qk(i) - qk(i - 1))/Tk(i-1)));
        else
            c = 6*(((qk(i + 1) - qk(i))/Tk(i)) - ((qk(i) - qk(i-1))/Tk(i-1)));
        end
        
        C = [C; c];
        
        
        % About matrix A
        a = zeros(1, k);
        
        if i == 1
            a(1, j) = 2*Tk(:,i); 
            a(1, j+1) = Tk(:,i);
           
            
        elseif i == k
            a(1, j) =  Tk(:,i-1);
            a(1, j+1) = 2*Tk(:,i-1); 
            
        else
            a(1, j) = Tk(:,i-1);
            a(1, j+1) = 2*(Tk(:,i-1) + Tk(:, i)); 
            a(1, j+2) =  Tk(:,i);
            
            j = j + 1;
        end
        
        A = [A; a];
        
    end
 
             
    %Find the dqk vector
    ddqk = inv(A)*C;
    
        
    [Q, Qd, Qdd, T] = imposedAccelerations(qk, ddqk', tk, k, Ts);
    
end