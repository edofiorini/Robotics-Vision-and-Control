function [Q, Qd, Qdd, T] = imposedAccelerations(qk, ddqk, tk, k, Ts)
    

     % Initialize the time, positions, velocities and accelerations array
    Q = [];
    Qd = [];
    Qdd = [];
    T = [];

    
    for i = 1: k-1
        
        
        Tk = tk(:,i+1) - tk(:,i);
        t = tk(:,i):Ts:tk(:,i+1);
        
        a0 = qk(:,i);
        a1 = ((qk(:,i+1) - qk(:,i))/Tk) - (((ddqk(:,i+1) + 2*ddqk(:,i))/6)*Tk);
        a2 = ddqk(:,i)/2;
        a3 = (ddqk(:,i+1) - ddqk(:,i))/(6*Tk);
        
        q = a3*(t - tk(:,i)).^3 +   a2*(t - tk(:,i)).^2 + a1*(t - tk(:,i)) + a0;
        qd = 3*a3*(t - tk(:,i)).^2 + 2*a2*(t - tk(:,i)) + a1;
        qdd = 6*a3*(t - tk(:,i)) + 2*a2;
        
        % update the array 
        Q = [Q, q];
        Qd = [Qd, qd];
        Qdd = [Qdd, qdd];
        
        T = [T, t];
        
        
    end
    
    
end