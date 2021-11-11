function [q, qd, qdd, T] = cubic_polynomials(qi, qf, dqi, dqf, ti, tf, Ts)
        
    H = [ 1 ti ti^2 ti^3 
          0 1  2*ti 3*ti^2 
          1 tf tf^2 tf^3 
          0 1 2*tf 3*tf^2];

    Q = [qi; dqi; qf; dqf];

    A = inv(H)*Q;
    
    a0 = A(1);
    a1 = A(2);
    a2 = A(3);
    a3 = A(4);
        
    T = ti:Ts:tf; 

    q = a3*T.^3 + a2*T.^2 + a1*T + a0;
    qd = 3*a3*T.^2 + 2*a2*T + a1;
    qdd = 6*a3*T + 2*a2;

    
end