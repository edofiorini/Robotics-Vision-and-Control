function [q, qd, qdd, qddd, T] = fifth_polynomials(qi, qf, dqi, dqf, ddqi, ddqf, ti, tf, Ts)
        
    deltaT = tf -ti;
    H = [ 1 0 0^2 0^3 0^4 0^5
          0  1  2*0 3*0^2  4*0^3   5*0^4
          0  0  2    6*0    12*0^2  20*0^3
          1  deltaT deltaT^2 deltaT^3    deltaT^4     deltaT^5
          0  1  2*deltaT 3*deltaT^2  4*deltaT^3   5*deltaT^4
          0  0  2    6*deltaT    12*deltaT^2  20*deltaT^3];

    Q = [qi; dqi; ddqi; qf; dqf; ddqf;];

    A = inv(H)*Q;

    a0 = A(1);
    a1 = A(2);
    a2 = A(3);
    a3 = A(4);
    a4 = A(5);
    a5 = A(6);

    T = ti:Ts:tf; 

    q = a5*(T - ti).^5 + a4*(T - ti).^4 + a3*(T-ti).^3 + a2*(T - ti).^2 + a1*(T-ti) + a0;
    qd = 5*a5*(T-ti).^4 + 4*a4*(T-ti).^3 + 3*a3*(T-ti).^2 + 2*a2*(T-ti) + a1;
    qdd = 20*a5*(T-ti).^3 + 12*a4*(T-ti).^2 + 6*a3*(T-ti) + 2*a2;
    qddd = 60*a5*(T-ti).^2 + 24*a4*(T-ti) + 6*a3;
    
end