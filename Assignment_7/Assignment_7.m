%% Model-based trajectory planning - finding lambda
% We defined the trajectory based on torque constraints
% computing a lambda to respect the constraints

%clear all; close all; clc;
% Joints initialization

k = [5 5 5 5 5 5];

qk_1 = [2 2 2 2 2 2]';
qk_2 = [0 0 0 0 0 0]';
qk_3 = [3 3 3 3 3 3]';
qk_4 = [1 1 1 1 1 1]';
qk_5 = [-2 -2 -2 -2 -2 -2]';


dqi = [0 0 0 0 0 0]';
dqf = [-0.5 -0.5 -0.5 -0.5 -0.5 -0.5]';

qk = [qk_1, qk_2, qk_3, qk_4, qk_5];
tk = [0 3 6.5 9 13 ];

RVC_main
q0 = qk_1;
dotq0 = dqi;

Ts = 0.001;

DimValues = 6;

DataPositions = [];
DataVelocities = [];
DataAccelerations = [];
T = [];

for i=1:DimValues
    
    %[q, dq, ddq, T_series] = computedVelocities(qk(i,:), tk, k(1,i), dqi(i, 1), dqf(i, 1), Ts);
    [q, dq, ddq, dqk, T_series] = continuousAccelerationsThomas(qk(i,:), tk, k(1,i), dqi(i, 1), dqf(i, 1), Ts);
    DataPositions(i, :) = q;
    DataVelocities(i, :) = dq;
    DataAccelerations(i, :) = ddq; 
    T(i,:) = T_series;
end

tauNoG = [];
g = [];

for i = 1:length(DataPositions)
    g(:,i) = g_q(dh, gravity, DataPositions(:,i)); 
    tauNoG(:,i) = inv_dyn_recursive_NewtonEulero(dh, DataPositions(:,i), DataVelocities(:,i), DataAccelerations(:,i), gravity) - g(:,i);
end

tauMax = [15, 5, 5, 5, 25, 5];
lambda = findLambda(max(abs(tauNoG),[],2), tauMax);

% for i = 1:6 
%     figure(i);
%     subplot(3,1,1);
%     plot(T, DataPositions(i,:), 'LineWidth',1.5);
%     title('Position');xlabel('Time(s)'); ylabel('q (rad)');
% 
%     subplot(3,1,2);
%     plot(T, DataVelocities(i,:), 'LineWidth',1.5);
%     title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');
% 
%     subplot(3,1,3);
%     plot(T, DataAccelerations(i,:), 'LineWidth',1.5);
%     title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
%     
% end


figure(7);
for i = 1:6
 
    subplot(3,3,i);
    plot(T, tauNoG(i,:), 'LineWidth',1.5);
    title('Joint', i);xlabel('Time(s)'); ylabel('Torque');
    hold on
    yline(tauMax(i))
    yline(-tauMax(i))
    
end
suptitle("Old torque")

T = T/lambda;
DataVelocities = DataVelocities*lambda;
DataAccelerations = DataAccelerations*lambda^2;
newTau = [];
g = [];

for i = 1:length(DataPositions)
    g(:,i) = g_q(dh, gravity, DataPositions(:,i));
    newTau(:,i) = inv_dyn_recursive_NewtonEulero(dh, DataPositions(:,i), DataVelocities(:,i), DataAccelerations(:,i), gravity) - g(:,i);
end

figure(8);
for i = 1:6
 
    subplot(3,3,i);
    plot(T, newTau(i,:), 'LineWidth',1.5);
    title('Joint', i);xlabel('Time(s)'); ylabel('Torque');
    hold on
    yline(tauMax(i))
    yline(-tauMax(i))
    
end

% j = 9;
% for i = 1:6 
%     figure(j);
%     subplot(3,1,1);
%     plot(T, DataPositions(i,:), 'LineWidth',1.5);
%     title('Position');xlabel('Time(s)'); ylabel('q (rad)');
% 
%     subplot(3,1,2);
%     plot(T, DataVelocities(i,:), 'LineWidth',1.5);
%     title('Velocity');xlabel('Time(s)'); ylabel('qd (rad/s)');
% 
%     subplot(3,1,3);
%     plot(T, DataAccelerations(i,:), 'LineWidth',1.5);
%     title('Acceleration');xlabel('Time(s)'); ylabel('qdd (rad/s^2)');
%     j = j +1;
% end
suptitle("New torque")