%% cubic polynomials 3rd-(cubic)
%Implement in Matlab 3rd– (cubic), 5th–, 7th–order polynomials for qi> qf and qi < qf,
%and in both formulations

clear all; close all; clc;

% You have to choose if qi > qf or qi < qf
qi = 0;
dqi = 0;
qf = 10;
dqf = 0;
ti = 0;
tf = 8;
Ts = 0.001;

[q, qd, qdd, T] = cubic_polynomials(qi, qf, dqi, dqf, ti, tf, Ts);

figure();

subplot(3,1,1);
plot(T,q);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(3,1,2);
plot(T,qd);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Cubic polynomials');


%% cubic polynomials 3rd-(cubic) - second version Dt

clear all; close all; clc;

% You have to choose if qi > qf or qi < qf

qi = 10;
dqi = 10;
qf = 0;
dqf = 1;
ti = 10;
tf = 30;
Ts = 0.001;

[q, qd, qdd,T] = cubic_polynomials_DT(qi, qf, dqi, dqf, ti, tf, Ts);

figure();

subplot(3,1,1);
plot(T,q);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(3,1,2);
plot(T,qd);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(3,1,3);
plot(T,qdd);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
suptitle('Cubic polynomials');

%% 5th-Order Polynomials

clear all; close all; clc;

% You have to choose if qi > qf or qi < qf
qi = 0;
dqi = 0;
ddqi = 0;
qf = 10;
dqf = 0;
ddqf = 0;
ti = 1;
tf = 8;
Ts = 0.001;

[q, qd, qdd, qddd, T] = fifth_polynomials(qi, qf, dqi, dqf, ddqi, ddqf, ti, tf, Ts);

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
suptitle('Fifth polynomials');

%% 7th-Order Polynomials

clear all; close all; clc;

% You have to choose if qi > qf or qi < qf
qi = 0;
dqi = 2;
ddqi = 1;
dddqi = 0;
qf = 0;
dqf = 30;
ddqf = 0;
dddqf = 0;
ti = 1;
tf = 18;
Ts = 0.001;

[q, qd, qdd, qddd, qdddd, T] = seventh_polynomials(qi, qf, dqi, dqf, ddqi, ddqf, dddqi, dddqf, ti, tf, Ts);

figure();

subplot(5,1,1);
plot(T,q);
title('Position');xlabel('Time(s)'); ylabel('q (rad)');

subplot(5,1,2);
plot(T,qd);
title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');

subplot(5,1,3);
plot(T,qdd);
title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');

subplot(5,1,4);
plot(T,qddd);
title('Jerk');xlabel('Time(s)'); ylabel('qddd (rad/s^3)');

subplot(5,1,5);
plot(T,qdddd);
title('Snap');xlabel('Time(s)'); ylabel('qdddd (rad/s^4)');
suptitle('Seventh polynomials');