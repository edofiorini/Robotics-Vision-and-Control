%% Interpolating polynomials with computed velocities at path points and imposed velocities at /initial/final points
%Computation based on position and velocity

clear all;close all; clc;

% Set the positions 
k = 6;
qk = [5 20 -25 6 -5 10];

%Set the initial and final velocity 
dqi = 0;
dqf = 0;

% Set the time and Ts
tk = [0 2 8 12 15 20];
Ts = 0.001;

[q, qd, qdd, dqk, T] = computedVelocities(qk, tk, k, dqi, dqf, Ts);


figure();


subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');
hold on
drawPoints(tk,qk);

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');
hold on
drawPoints(tk,dqk);

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Computed velocities at path points');

%% Interpolating polynomials with continuous accelerations at path points and imposed velocity at /initial/final points
% Computation based on position and velocity


clear all; clc;

% Set the positions 
k = 6;
qk = [5 20 -25 6 -5 10];
dqi = -5 ;
dqf = 10;

% Set the time and Ts
tk = [0 2 8 12 15 20];
Ts = 0.001;

[q, qd, qdd, T,dqk] = continuousAccelerations(qk, tk, k, dqi, dqf, Ts);

figure();


subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
hold on
drawPoints(tk,qk);

title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
hold on
 drawPoints(tk,dqk);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Continuous accelerations at path points');

%% %% Interpolating polynomials with continuous accelerations and Thomas algorithm at path points and impose velocity at /initial/final points
%Computation based on position and velocity

clear all; clc;

% Set the positions 
k = 6;
qk = [5 20 -25 10 -5 10];
dqi = -5;
dqf = 10;

% Set the time and Ts
tk = [0 2 8 12 15 20];
Ts = 0.001;

[q, qd, qdd, dqk, T] = continuousAccelerationsThomas(qk, tk, k, dqi, dqf, Ts);

figure();


subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');
hold on
drawPoints(tk,qk);

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');
hold on
drawPoints(tk,dqk);

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Continuous accelerations at path points with Thomas');