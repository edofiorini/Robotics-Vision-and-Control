function [q, qd, qdd, qddd, T] = fifth_polynomials(qi, qf, dqi, dqf, ddqi, ddqf, ti, tf, Ts)
        
    H = [ 1 ti ti^2 ti^3 ti^4 ti^5
          0  1  2*ti 3*ti^2  4*ti^3   5*ti^4
          0  0  2    6*ti    12*ti^2  20*ti^3
          1  tf tf^2 tf^3    tf^4     tf^5
          0  1  2*tf 3*tf^2  4*tf^3   5*tf^4
          0  0  2    6*tf    12*tf^2  20*tf^3];

    Q = [qi; dqi; ddqi; qf; dqf; ddqf;];

    A = inv(H)*Q;

    a0 = A(1);
    a1 = A(2);
    a2 = A(3);
    a3 = A(4);
    a4 = A(5);
    a5 = A(6);

    T = ti:Ts:tf; 

    q = a5*T.^5 + a4*T.^4 + a3*T.^3 + a2*T.^2 + a1*T + a0;
    qd = 5*a5*T.^4 + 4*a4*T.^3 + 3*a3*T.^2 + 2*a2*T + a1;
    qdd = 20*a5*T.^3 + 12*a4*T.^2 + 6*a3*T + 2*a2;
    qddd = 60*a5*T.^2 + 24*a4*T + 6*a3;
    
end