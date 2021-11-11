function [q, qd, qdd, qddd, T] = harmonicTrajectory(qi, qf, ti, tf, Ts)
 
        samples = (tf- ti)/Ts;
        T = linspace(ti, tf, samples);
        Dq = qf - qi;
        Dt = tf - ti;

        q = (Dq/2)*(1 - cos((pi*(T - ti))/Dt)) + qi;
        qd = ((pi*Dq)/(2 * Dt))*(sin((pi*(T - ti))/Dt));
        qdd = ((pi^2*Dq)/(2 * Dt^2))*(cos((pi*(T - ti))/Dt));
        qddd = (-((pi^3*Dq)/(2 * Dt^3)))*(sin((pi*(T - ti))/Dt));
 

    
end