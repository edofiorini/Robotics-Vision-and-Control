%% Double S trajectory

clear all;  clc;

% You have to choose if qi > qf or qi < qf
% We assume that the value of dqi and dqf is equal to 0

% 1- if you set alpha and beta different from zero,  there is a trajectory with fixed duration that you have to choose 
% 2 - set dqmax, ddqmax and dddqmax:
%       --> first check is with the assumption that dqmax=dqlim
%       --> compute all the parameters, check if tv > 0 it is ok 
%       otherwise --> dqlim=dqmax and compute all the parameters
%     check if or not you reach the dqmax/ddqmax(in each case)


% Set the parameters
dqmax = 5;
ddqmax = 10;
dddqmax = 30;


ti = 0;
tf = 5;

qi = 0;
qf = 10;

dqi = 0;
dqf = 0;

alpha = 0;
beta = 0;

% Set the frequency related to the samples
Ts = 0.001;


% Call the function to generate the profile
[q, qd, qdd, qddd, T]= doubleSTrajectory(ti, tf, qi, qf, dqi, dqf, dqmax, ddqmax, dddqmax, alpha, beta, Ts);


% Plot the graph
figure();

subplot(4,1,1);
plot(T, q, 'LineWidth',1.5);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(4,1,2);
plot(T, qd, 'LineWidth',1.5);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(4,1,3);
plot(T,qdd, 'LineWidth',1.5);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');

subplot(4,1,4);
plot(T,qddd, 'LineWidth',1.5);
title('Jerk');xlabel('Time(s)'); ylabel('qddd (rad/s^3)');
suptitle('Double S trajectory');