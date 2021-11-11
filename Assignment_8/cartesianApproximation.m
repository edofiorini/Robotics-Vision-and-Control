function [Q, QD, QDD, T] = cartesianApproximation(Pg)

            % Compute component by component the 3d trajectory
            tk = 1:5;
            k = 5;
            W = diag([100, 100, 100, 100, 100]);
            mu = 1;
            lambda = (1- mu)/(6*mu);
            Ts = 0.001;

            Q = [];
            QD = [];
            QDD = [];
            T = [];

            % you can chose all the point2point or multiple point methods
            for i=1:3
                    [q, qd, qdd, t] = smoothingSplines(Pg(i,:)', tk, k, Ts, W, lambda);
                    Q = [Q;q];
                    QD = [QD;qd];
                    QDD = [QDD;qdd];
                    T = [T;T];
            end

end

