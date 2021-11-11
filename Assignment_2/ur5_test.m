clear all;close all;clc;

% Joints initialization
qi = [0.2 -0.5 0.3 -2 2.5 3]';
qf = [-0.2 -1.9 0.3 1 1.5 -1.2]';
q0 = qi;
dotq0 = qdi;
ti = 0;
tf = 10;
Ts = 0.01;
samples = (tf- ti)/Ts;
T = linspace(ti, tf, samples);

%[ti:Ts:tf] is the same of linespace
n = (tf-ti)/Ts;
TimeValues = linspace(ti,tf,n);
DimValues = 6;

DataPositions = [];
DataVelocities = [];

for i=1:DimValues
    Dq = qf(i) - qi(i);
    Dt = tf - ti;
    
    [q,dq] = cycloidalTrajectory(qi(i),qf(i), ti,tf, T, Dq, Dt);
    DataPositions(i, :) = q;
    DataVelocities(i, :) = dq;
end

qd.time=TimeValues;
qd.signals.values=DataPositions';
qd.signals.dimensions=DimValues;

dotqd.time=TimeValues;
dotqd.signals.values=DataVelocities';
dotqd.signals.dimensions=DimValues;

% 
% % Compute the p(t)
% %t = 0:Ts:2;
% s = [];
% v=10;
% 
% s(1) = 0;
% i = 1;
% while s(i) <= length(P)*Ts
%     
%     i = i + 1;
%     s(i) = s(i-1)+Ts*v;
%     
% 
% end
% 
% s = s(1:length(s)-1);
% t = 0:Ts:length(s)*Ts - Ts;
% newP = zeros(3,length(t));
% newP(:,1) = P(:,1);
% 
% for i = 2:length(t)
%    
%     newP(:,i) = P(:,round(s(i)/Ts));
% end
