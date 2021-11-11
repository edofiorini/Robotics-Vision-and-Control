%% Harmonic Trajectory 

clear all; close all; clc;

% You have to choose if qi, qf, ti, tf
qi = 0;
qf = 10;
ti = 0;
tf = 8;


Ts = 0.001;

[q, qd, qdd, qddd, T] = harmonicTrajectory(qi, qf, ti, tf, Ts);


figure();

subplot(4,1,1);
plot(T,q);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(4,1,2);
plot(T,qd);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(4,1,3);
plot(T,qdd);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');

subplot(4,1,4);
plot(T,qddd);
title('Jerk');xlabel('Time(s)'); ylabel('qddd (rad/s^3)');
suptitle('Harmonic Trajectory');

%% Cycloidal Trajectory

clear all; close all; clc;

% You have to choose if qi, qf, ti, tf
qi = 0;
qf = 10;
ti = 0;
tf = 8;


Ts = 0.001;

        
[q, qd, qdd, qddd, T] = cycloidalTrajectory(qi, qf, ti, tf, Ts);

figure();

subplot(4,1,1);
plot(T,q);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(4,1,2);
plot(T,qd);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(4,1,3);
plot(T,qdd);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');

subplot(4,1,4);
plot(T,qddd);
title('Jerk');xlabel('Time(s)'); ylabel('qddd (rad/s^3)');
suptitle('Cycloidal Trajectory');
