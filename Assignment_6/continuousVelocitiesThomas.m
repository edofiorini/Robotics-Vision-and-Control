function [Q, Qd, Qdd, X, T] = continuousVelocitiesThomas(qk, tk, k, dqi, dqf, Ts)

    Tk = [];
    D  = [];
     % Compute the vectors A,B,C
    B = zeros(1, k);
    A = zeros(1, k);
    C = zeros(1, k);
    
    
    % Compute all the TK = tk+1 - tk 
    for i = 1:k-1 
        
        Tk_tmp = tk(:,i+1) - tk(:,i);
        Tk = [Tk, Tk_tmp];
        
    end
    
    % Compute the vector D
    for i = 1:k
        
       % About matrix C
        if i == 1
            d = 6*(((qk(i + 1) - qk(i))/Tk(i)) - dqi );
        elseif i == k
            d = 6*(dqf - ((qk(i) - qk(i - 1))/Tk(i-1)));
        else
            d = 6*(((qk(i + 1) - qk(i))/Tk(i)) - ((qk(i) - qk(i-1))/Tk(i-1)));
        end
        
        D = [D, d];
        
        if i == 1 
            B(i) = 2*Tk(i);
        elseif i == 2
            B(i) = 2*(Tk(i) + Tk(i-1));
        elseif i == k
            B(i) = 2*(Tk(i-1));
        elseif i == k-1
            B(:,i) = 2*(Tk(i-1) + Tk(i));
        else
            B(:,i) = 2*(Tk(:,i) + Tk(:, i-1)); 
        end
        
        if i ~= 1 
            A(:,i) = Tk(:,i-1);
        end
        
        if i ~= k
            C(:,i) = Tk(:,i);
        end
         
        % Forward elimination
         if i > 1
            m = A(:,i)/B(:, i-1);
            B(:,i) = B(:,i) - m*C(:,i-1); 
            D(:,i) = D(:,i) - m*D(:,i-1); 
         end
        
     end

    X = zeros(1, k);
    X(:, k) = D(:, k)/B(:, k);
    
    % Backward substitution
    for i = k-1:-1:1
        X(:, i) = (D(:,i) - C(:,i)*X(:,i+1))/B(:,i);
    end
   
        
    [Q, Qd, Qdd, T] = imposedAccelerations(qk,X, tk, k, Ts);
    
end