function [Q, Qd, Qdd, dqk, T] = continuousAccelerationsThomas(qk, tk, k, dqi, dqf, Ts)

    Tk = [];
    D  = [];
     % Compute the vectors A,B,C
    B = zeros(1, k-2);
    A = zeros(1, k-2);
    C = zeros(1, k-2);
    
    
    % Compute all the TK = tk+1 - tk 
    for i = 1:k-1 
        
        Tk_tmp = tk(:,i+1) - tk(:,i);
        Tk = [Tk, Tk_tmp];
        
    end
    
    % Compute the vector D
    for i = 1:k-2
        
        D(i) = 3*(Tk(:,i+1)/Tk(:,i))*(qk(:,i+1) - qk(:,i)) + 3*(Tk(:,i)/Tk(:,i+1))*(qk(:,i+2) - qk(:,i+1));
       
        
        if i == 1
            D(i) = D(i) - Tk(:,i+1)*dqi;
        end
        
        if i == k-2
            D(i) = D(i) - Tk(:,i)*dqf;
        end
        
        %D = [D; d];
        
    
    
   
    
        
        B(:,i) = 2*(Tk(:,i) + Tk(:, i+1)); 
        
        
        if i ~= 1 
            A(:,i) = Tk(:,i+1);
            
        end
        
        if i ~= k-2
            C(:,i) = Tk(:,i);
        end
         
        % Forward elimination
         if i > 1
            m = A(:,i)/B(:, i-1);
            B(:,i) = B(:,i) - m*C(:,i-1); 
            D(:,i) = D(:,i) - m*D(:,i-1); 
        end
    
     end
    
    
    
    
    
    X = zeros(1, k-2);
    X(:, k-2) = D(:, k-2)/B(:, k-2);
    
    % Backward substitution
    for i = k-3:-1:1
        X(:, i) = (D(:,i) - C(:,i)*X(:,i+1))/B(:,i);
    end
    
    % Build the final vector dqk
    dqk = [dqi, X, dqf];
        
    [Q, Qd, Qdd, T] = imposedVelocities(qk, dqk, tk, k, Ts);
    
end