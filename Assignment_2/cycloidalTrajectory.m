function [q, qd, qdd, qddd, T] = cycloidalTrajectory(qi, qf, ti, tf, Ts)
        

        samples = (tf- ti)/Ts;
        T = linspace(ti, tf, samples);
        Dq = qf - qi;
        Dt = tf - ti;

        q = Dq*( ((T -ti)/Dt) - 1/(2*pi)*sin(2*pi*(T - ti)/Dt) ) + qi;
        qd = (Dq/Dt)*(1 - cos((2*pi*(T - ti))/Dt));
        qdd = (2*pi*Dq/Dt^2)*(sin((2*pi*(T - ti))/Dt));
        qddd = (4*(pi^2)*Dq)/Dt^3*cos(2*pi*(T - ti)/Dt);
        
end