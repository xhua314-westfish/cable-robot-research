clc;
clear;

%% original jacobian
J = [0.7071, -0.7809, -0.4138,  0.3417;
    0.7071,  0.6247, -0.9104, -0.9398];

%% combine cable columns
J_cs = [J(:, 1), J(:, 2), J(:, 3) + J(:, 4)];

%% reduce row echelon form
R = rref(J_cs);
% 这是matlab自动计算过程 
% 把jacobian矩阵转化为只含有f1 f2两个未知数的矩阵
% 并且将f3 f4定义为1 在满足这情况下去找f1 f2
% 将矩阵J_cs = [0.7071 -0.7809 -0.0721; 0.7071 0.6247 -1.8502]
% 变成 [1 0 x; 0 1 y];
disp('R:');
disp(R);

%% extract cable force ratios
T = R(:, end);
disp('T:');
disp(T);

%% calculate tension factor 
ratios = [T; -1];
disp('ratios:');
disp(ratios);

TF = max(ratios) / min(ratios);
fprintf('TF = %.4f\n', TF);

%% reconstruct cable tension ratios
f = [-T(1); -T(2); 1; 1];
% T只是重新分配了f1 f2
% f3 f4从事自从没有发生变化 所有还是1

%% verify force equilibrium 
w = J * f;

disp('Cable tension ratios:');
disp(f);

disp('Resultant wrench:');
disp(w);

fprintf('Equilibrium residual = %.8f\n', norm(w));

