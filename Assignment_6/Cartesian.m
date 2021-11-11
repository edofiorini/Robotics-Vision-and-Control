%% Cartesian approximation component by component
clear all; close all; clc;

P = zeros(3, 5);
P(:,1) = [0 0 0]';
P(:,2) = [1 0 0]';
P(:,3) = [2 1 0]';
P(:,4) = [2 1 2]';
P(:,5) = [2 0 3]';


tk = 1:5;
k = 5;
W = diag([1, 100, 100, 1, 1]);
mu = 1;
lambda = (1- mu)/(6*mu);
Ts = 0.001;

Q = [];
QD = [];
QDD = [];
T = [];

for i=1:3
   [q, qd, qdd, T] = smoothingSplines(P(i,:)', tk, k, Ts, W, lambda);
   Q = [Q;q];
   QD = [QD;qd];
   QDD = [QDD;qdd];
   T = [T;T];
end

plot3(Q(1,:), Q(2,:), Q(3,:));
