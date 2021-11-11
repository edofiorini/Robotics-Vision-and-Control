%clear  all; close all; clc;

% Compute the trajectory from home position to 3 different points 
% p(t) = p(u)u(t)

RVC_main

% Set the parameters of the trajectory
Ts = 0.001;

Ptilde = []; P = [];
DPtilde = []; DP = [];
DDPtilde = []; DDP = [];
DDDP = [];
T = [];

O_EE_t = [];
O_EE_n = [];
O_EE_b = [];

Otilde = [];
DOtilde = [];
DDOtilde = [];
TO = [];
    
% Set the parameters of the sphere 

p0 = [2,2,2];

radius = 2;

[a,b,c,d] = findParameters(radius, p0);
% Set the points on the sphere

p1 = [2;0;2];
p2 = [2;2;4];
p3 = [4;2;2];
Pg = [p1, p2, p3];

% Check if the points are on the sphere
for i = 1: size(Pg)
     out = check(Pg(:,i), p0, radius);
     if(out == false)
         error('One of the points does not belongs on the sphere!')
     end
end


Pg = [x0(1:3), p1, p2, p3];

% Compute the path p(u)
 [P, DP, DDP, DDDP, T, p, dp, ddp] = linearMotion(x0(1:3), p1, Ts, P, DP, DDP, DDDP, T);
 [Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b] = FrenetFrame(p, dp, ddp,0, 20,x0(1:3), p1, Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b , Ts);
 [P, DP, DDP, DDDP, T,  p, dp, ddp] = circularMotion(p1, p2, Ts, p0', P, DP, DDP,DDDP, T, false);
 [Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b] = FrenetFrame(p, dp, ddp,20, 30, p1, p2, Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b , Ts);
 [P, DP, DDP, DDDP, T, p, dp, ddp] = circularMotion(p2, p3, Ts, p0', P, DP, DDP, DDDP, T, false);
 [Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b] = FrenetFrame(p, dp, ddp,30, 40, p2, p3, Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b , Ts);
 [P, DP, DDP, DDDP, T, p, dp, ddp] = circularMotion(p3, p1, Ts, p0', P, DP, DDP, DDDP, T, false);
 [Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b] = FrenetFrame(p, dp, ddp,40, 60, p3, p1, Otilde, DOtilde, DDOtilde, TO, O_EE_t, O_EE_n, O_EE_b , Ts);
% Compute the ptilde(t)-- Only EE position--- You have to choose the TIME

% home--->P1
[Ptilde, DPtilde, DDPtilde,  T] = linearTilde(x0(1:3), p1, Ts, Ptilde, DPtilde, DDPtilde, T, 0, 20);
%[Ptilde, DPtilde, DDPtilde,  T] = linearTilde(x0(1:3), p1, Ts, Ptilde, DPtilde, DDPtilde, T, 0, 20);

%P1--->P2
[Ptilde, DPtilde, DDPtilde, T] = circularTilde(p1, p2, Ts, p0', Ptilde, DPtilde, DDPtilde, T, flag, 20, 30);

%%P2--->P3
[Ptilde, DPtilde, DDPtilde, T] = circularTilde(p2, p3, Ts, p0', Ptilde, DPtilde, DDPtilde, T, flag, 30, 40);

%%P3--->P1
[Ptilde, DPtilde, DDPtilde, T] = circularTilde(p3, p1, Ts, p0', Ptilde, DPtilde, DDPtilde, T, flag, 40, 60);

% SIMULINK - SCRIPT

DimValues = 6;
  
DataPositions =  [Ptilde; Otilde];
DataVelocities = [ DPtilde; DOtilde];
    


% xd.time=T;
% xd.signals.values=DataPositions;
% xd.signals.dimensions=DimValues;
% 
% dotxd.time=T;
% dotxd.signals.values=DataVelocities;
% dotxd.signals.dimensions=DimValues;



% Plot the sphere and the trajectory
%TRAJECTORY
p = plot3(Ptilde(1,:), Ptilde(2,:), Ptilde(3,:));
p.LineWidth = 5;
title('Position');xlabel('x');ylabel('y');zlabel('z');
grid on
hold on;
plot3(Pg(1,:), Pg(2,:), Pg(3,:),'o', 'MarkerSize',15);
hold on;
plot3(p0(1), p0(2), p0(3),'*', 'MarkerSize',15);
hold on;
quiver3(P(1,1:200:end), P(2,1:200:end), P(3,1:200:end), ...
 O_EE_t(1,1:200:end), O_EE_t(2,1:200:end), O_EE_t(3,1:200:end));
hold on;
quiver3(P(1,1:200:end), P(2,1:200:end), P(3,1:200:end), ...
  O_EE_b(1,1:200:end), O_EE_b(2,1:200:end), O_EE_b(3,1:200:end));
hold on;
quiver3(P(1,1:200:end), P(2,1:200:end), P(3,1:200:end), ...
  O_EE_n(1,1:200:end), O_EE_n(2,1:200:end), O_EE_n(3,1:200:end));

%SPHERE
hold on
[X,Y,Z] = sphere; 
X = X * radius; 
Y = Y * radius; 
Z = Z * radius; 
axis equal; 
surf(X+p0(1), Y+ p0(2), Z+ p0(3), 'FaceAlpha', 0.1);

legend('Trajectory', 'Points',  'Centre');
suptitle('3D Trajectory');
