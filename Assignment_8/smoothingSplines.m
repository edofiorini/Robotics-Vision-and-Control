function[Q, Qd, Qdd, dds, T] = smoothingSplines(qk, tk, k, Ts, W, lambda)
     
     C = [];
     A = [];
     Tk = [];
     dds = [];
     s = [];
     j = 1;
     % Compute all the TK = tk+1 - tk 
    for i = 1:k-1 
        
        Tk_tmp = tk(:,i+1) - tk(:,i);
        Tk = [Tk, Tk_tmp];  
    end
    
    % Build the matricies A and C
    for i = 1:k
 
        % About matrix A
        a = zeros(1, k);
        c = zeros(1, k);
        
        if i == 1
            a(1, j) = 2*Tk(:,i); 
            a(1, j+1) = Tk(:,i);
            c(1,j) = -(6/Tk(:,i));
            c(1,j+1) = (6/Tk(:,i));
            
        elseif i == k
            a(1, j) =  Tk(:,i-1);
            a(1, j+1) = 2*Tk(:,i-1); 
            c(1,j) = (6/Tk(:,i-1));
            c(1,j+1) = -(6/Tk(:,i-1));
            
        else
            a(1, j) = Tk(:,i-1);
            a(1, j+1) = 2*(Tk(:,i-1) + Tk(:, i)); 
            a(1, j+2) =  Tk(:,i);
            c(1,j) = (6/Tk(:,i-1));
            c(1,j+1) = -(6/Tk(:,i-1) + 6/Tk(:,i));
            c(1,j+2) = (6/Tk(:,i));
            j = j + 1;
        end
        
        A = [A; a];
        C = [C; c];
        
         
    end
    
    
    dds = inv(A + lambda*C*inv(W)*C')*(C*qk);
    s = qk - lambda*inv(W)*C'*dds;
    
     [Q, Qd, Qdd, T] = imposedAccelerations(s', dds', tk, k, Ts);
end