%% Symmetric Trapezoidal Profile

clear all;  clc; close all;

% ti = 0
% You have to choose if qi > qf or qi < qf
% We assume that the value of dqi and dqf is equal to 0
% acc time = decel time = tc

% SUBCASE: 1 - Given tc and tf
%          2 - Given ddqc and tf
%          3 - Given dqc and tf
%          4 - Given dqc and ddqc

% Set the parameters
subcase = 3;
tc = 7;
dqc = 7;
ddqc = 5;

ti = 0;
tf = 5;

qf = 30;
qi = 0;


% Set the frequency related to the samples
Ts = 0.001;


% Call the function to generate the profile
[q, qd, qdd, T]= trapezoidalProfileSymmetric(tc, dqc, ddqc, ti, tf, qf, qi, Ts, subcase);


% Plot the graph
figure();

subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Symmetric Trapezoidal Profile');


%% Unsymmetric Trapezoidal Profile

clear all;  clc; close all;

% You have to choose qi > qf 
% The value of dqi and dqf can be different from 0; 
% We have non-null initial and final accelerations
% SUBCASE: 1 - Given ddqc(reach or not) and tf
%          2 - Given dqc(reach or not) and ddqc(constant given by user)



% Set the parameters
subcase = 1;
dqc = 18;
ddqc = 2.1671;

ti = 0;
tf = 5;

qf = 30;
qi = 0;
dqi = 5;
dqf = 2;

% Set the frequency related to the samples
Ts = 0.001;


% Call the function to generate the profile
[q, qd, qdd, T]= trapezoidalProfileGeneral( dqc, ddqc, ti, tf, qf, qi, dqi, dqf, Ts, subcase);

% Plot the graph
figure();

subplot(3,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(3,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Unsymmetric Trapezoidal Profile')
