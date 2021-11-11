function [q, qd, qdd, qddd, qdddd, T] = seventh_polynomials(qi, qf, dqi, dqf, ddqi, ddqf, dddqi, dddqf, ti, tf, Ts)
        
    deltaT = tf -ti;
    H = [ 1  0 0^2  0^3    0^4     0^5     0^6      0^7
          0  1  2*0  3*0^2  4*0^3   5*0^4   6*0^5    7*0^6
          0  0  2     6*0    12*0^2  20*0^3  30*0^4   42*0^5
          0  0  0     6       24*0    60*0^2  120*0^3  210*0^4
          1  deltaT deltaT^2 deltaT^3     deltaT^4     deltaT^5     deltaT^6      deltaT^7
          0  1  2*deltaT 3*deltaT^2   4*deltaT^3   5*deltaT^4   6*deltaT^5    7*deltaT^6
          0  0  2    6*deltaT     12*deltaT^2  20*deltaT^3  30*deltaT^4   42*deltaT^5
          0  0  0    6        24*deltaT    60*deltaT^2  120*deltaT^3  210*deltaT^4];

    Q = [qi; dqi; ddqi; dddqi; qf; dqf; ddqf; dddqf;];

    A = inv(H)*Q;

    a0 = A(1);
    a1 = A(2);
    a2 = A(3);
    a3 = A(4);
    a4 = A(5);
    a5 = A(6);
    a6 = A(7);
    a7 = A(8);

    T = ti:Ts:tf; 

    q = a7*(T-ti).^7 + a6*(T-ti).^6 + a5*(T-ti).^5 + a4*(T-ti).^4 + a3*(T-ti).^3 + a2*(T-ti).^2 + a1*(T-ti) + a0;
    qd = 7*a7*(T-ti).^6 + 6*a6*(T-ti).^5 + 5*a5*(T-ti).^4 + 4*a4*(T-ti).^3 + 3*a3*(T-ti).^2 + 2*a2*(T-ti) + a1;
    qdd = 42*a7*(T-ti).^5 + 30*a6*(T-ti).^4 + 20*a5*(T-ti).^3 + 12*a4*(T-ti).^2 + 6*a3*(T-ti) + 2*a2;
    qddd = 210*a7*(T-ti).^4 + 120*a6*(T-ti).^3  + 60*a5*(T-ti).^2 + 24*a4*(T-ti) + 6*a3; 
    qdddd = 840*a7*(T-ti).^3 + 360*a6*(T-ti).^2 + 120*a5*(T-ti) + 24*a4;
    
end