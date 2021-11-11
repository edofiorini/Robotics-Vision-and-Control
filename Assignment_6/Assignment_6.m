%% Interpolating polynomials based on the accelerations at path points and imposed velocities at /initial/final points

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

[q, qd, qdd, ddqk, T] = continuousVelocities(qk, dqi, dqf, tk, k, Ts);


figure();


subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');
hold on
drawPoints(tk,qk);

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
hold on
drawPoints(tk,ddqk');
suptitle('Accelerations at path points');

%% %% Interpolating polynomials based on the accelerations at path points and imposed velocities at /initial/final points 
% Thomas Algorithm

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

[q, qd, qdd, ddqk, T] = continuousVelocitiesThomas(qk, tk, k, dqi, dqf, Ts);


figure();


subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');
hold on
drawPoints(tk,qk);

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
hold on
drawPoints(tk,ddqk);
suptitle('Accelerations at path points with Thomas');

%% %% Smoothing cubic splines

clear all;close all; clc;

% Set the positions 
k = 6;
qk = [4 -5 10 7 5 10]';
W = diag([1,100 , 100, 1, 1, 1]);
mu = 0.1;
lambda = (1- mu)/(6*mu);

% Set the time and Ts
tk = [0 5.5 15 18 20 25];
Ts = 0.001;

[q, qd, qdd, dds, T] = smoothingSplines(qk, tk, k, Ts, W, lambda);


figure();

subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');
hold on
drawPoints(tk,qk');

 
subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
hold on
drawPoints(tk,dds');
suptitle('Smoothing cubic splines');