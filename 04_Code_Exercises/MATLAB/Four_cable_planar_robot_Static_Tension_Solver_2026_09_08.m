clc;
clear;

%% define parameters
% platform state
q = [0; 0; 0];
%如果q = [3, 5, 2]就找不到解 

% define anchor 
anchor = [
    1, 0;
    1, 1;
    0, -1;
    -1, -1
    ];

% define attachment point
r = [0.5, 0.5;
    -0.5, 0.5;
    -0.5, -0.5;
    0.5, -0.5
    ];

% define external wrench
%w_ext = [0; 5; 0; 1];
T_test = [5; 5; 5; 5];

% define number of cables
num_cables = size(r, 1);

% define tension limit
%T_min = [2; 2; 2; 2];
%T_max = [30; 30; 30; 30];
T_min = 2 * ones(num_cables,1);
T_max = 20 * ones(num_cables,1);

%% calculate length, jacobian and a_matrix
[cable_length, jacobian_matrix, a_matrix] = calculate(q, anchor, r);

%% display result
disp('cable length:');
disp(cable_length);
disp('jacobian_matrix:');
disp(jacobian_matrix);
disp('a_matrix:');
disp(a_matrix);

%% check A = - J ^ T
A_error = a_matrix + jacobian_matrix';

disp('A + J^T:');
disp(A_error);

%% calculate optimal tension
% objective: minimize total tension 
f = ones(num_cables,1);
%f 矩阵的作用就是给每一个未知数Ti赋予一个"权重"

% solve liner programming problem
w_ext = -a_matrix * T_test;
b = -w_ext;
[T, fval, exitflag] = linprog(f, [], [], a_matrix, b, T_min, T_max);
%在满足一系列线性约束的条件下，寻找一个向量 $x$，使得线性目标函数 $f^\top x$ 的值最小（即 $\min_x f^\top x$）
%fval（Function Value，目标函数的最终最小值）
%它是一个整数状态码，用来告诉程序求解器为什么停止运行，即判断算出来的答案是否有效、可靠。

if exitflag == 1

    disp('Optimal cable tensions:');
    disp(T);

    equilibrium_error = a_matrix * T - b;

    disp('Equilibrium error:');
    disp(equilibrium_error);

    total_tension = sum(T);

    disp('Total tension:');
    disp(total_tension);

else

    disp('No feasible tension solution exists.');

end

%% calculate length, jacobian and A_matrix
function [L_length, J_jacobian, A_matrix] = calculate(q, anchor, r)

% Pre-allocated vector space 4*1
num_cables = size(r,1);
L_length = zeros(num_cables, 1);
J_jacobian = zeros(num_cables, 3);
A_matrix = zeros(3, num_cables);

% calculate rotation matrix
x = q(1);
y = q(2);
theta = q(3);

R = [cos(theta), -sin(theta);
    sin(theta),  cos(theta)];

for i = 1:num_cables

    % calculate lengths of cables
    P = [x; y] + R * r(i, :)';
    L_vector = anchor(i, :)' - P;
    L_length(i) = norm(L_vector);
    
    % calculate jacobian
    u = L_vector / L_length(i);
    P_r = R * r(i, :)';
    % 连接点 P 对姿态 q 的偏导矩阵 dp/dq
    % [dp/dx, dp/dy, dp/theta]
    dp_dq = [
        1, 0, -P_r(2);
        0, 1, P_r(1)  
        ];

    J_jacobian(i, :) = -u' * dp_dq;

    % calculate structure matrix A
    % 二维力矩计算公式 P_rx * u_y - P_ry * u_x
    torque_z = P_r(1) * u(2) - P_r(2) * u(1);
    A_matrix(:, i) = [u(1), u(2), torque_z]; 

end
end 


