function [q, qd, qdd,T] = cubic_polynomials_DT(qi, qf, dqi, dqf, ti, tf, Ts)

    Dt = tf - ti;
    
    
    H = [ 1 0 0 0; 
      0 1 0 0; 
      1 Dt Dt^2 Dt^3; 
      0 1 2*Dt 3*Dt^2; ];

    Q = [qi; dqi; qf; dqf];

    A = inv(H)*Q;

    a0 = A(1);
    a1 = A(2);
    a2 = A(3);
    a3 = A(4);


    T = ti:Ts:tf; 

    q = a3*(T-ti).^3 + a2*(T-ti).^2 + a1*(T-ti) + a0;
    qd = 3*a3*(T-ti).^2 + 2*a2*(T-ti) + a1;
    qdd = 6*a3*(T-ti) + 2*a2;
    
end