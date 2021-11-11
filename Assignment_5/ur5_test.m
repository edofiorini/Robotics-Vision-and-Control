

% Joints initialization

k = [5 5 5 5 5 5];

qk_1 = [0 0 0 0 0 0]';
qk_2 = [10 10 10 10 10 10]';
qk_3 = [25 25 25 25 25 25]';
qk_4 = [15 15 15 15 15 15]';
qk_5 = [50 50 50 50 50 50]';


dqi = [0 0 0 0 0 0]';
dqf = [0 0 0 0 0 0]';

qk = [qk_1, qk_2, qk_3, qk_4, qk_5];
tk = [1 2.5 4 5 8];

q0 = qk_1;
dotq0 = dqi;

Ts = 0.001;

DimValues = 6;

DataPositions = [];
DataVelocities = [];

for i=1:DimValues
    
    [q, dq, Qdd, T] = computedVelocities(qk(i,:), tk, k(1,i), dqi(i, 1), dqf(i, 1), Ts);
    DataPositions(i, :) = q;
    DataVelocities(i, :) = dq;
    
    
    
end



qd.time=T;
qd.signals.values=DataPositions';
qd.signals.dimensions=DimValues;

dotqd.time=T;
dotqd.signals.values=DataVelocities';
dotqd.signals.dimensions=DimValues;
