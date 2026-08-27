clc;
clear;
% step1 define platform state
% 这也是q-old
q = [0; 0; 0];

% step2 define anchor 
A1 = [0.6; 0.8];

% step3 define attachment point
r1 = [0.2; 0.1];


% step4 define platform new q
q_dot = [0.1; 0.05; 0.2];
dt = 0.1;
q_new = q + q_dot * dt;

% step5 calculate old and new length
old_length = calculate_cable_length(q, A1, r1);
new_length = calculate_cable_length(q_new, A1, r1);

numerical_length = (new_length - old_length) / dt;

disp(old_length);
disp(new_length);
disp('numerical Length Rate:');
disp(numerical_length);

% step6 calculate jacobian
[J, analytical_length_dot] = calculate_cable_jacobian(q, A1, r1, q_dot);

% step7 display the Jacobian and analytical length rate
disp('Jacobian:');
disp(J);
disp('Analytical Length Rate:');
disp(analytical_length_dot);

% step8 calculate errors
error = numerical_length - analytical_length_dot;
relative_error = abs(error) / abs(analytical_length_dot);

disp('relative error:');
disp(relative_error);



%% 长度计算函数
function L_length = calculate_cable_length(q, A1, r1)
% calculate rotation matrix
x = q(1);
y = q(2);
theta = q(3);

R = [
    cos(theta), -sin(theta);
    sin(theta), cos(theta)
    ];

% calculate attachment point 的 world position
P = [x; y] + R * r1;


% calculate cable vector
L_vector = A1 - P;

% calculate cable length
L_length = norm(L_vector);
% norm长度计算公式

end

%% jacobian 计算矩阵
function [J, L_dot] = calculate_cable_jacobian(q, A1, r1, q_dot)
    %这个函数定义两个出口一个是J, 另一个是L_dot，所以在主程序里面也要写两个接口
    %名字可以自己定义 

    x = q(1);
    y = q(2);
    theta = q(3);

    R = [
        cos(theta), -sin(theta);
        sin(theta), cos(theta)
        ];

    % 平台连接点坐标
    P_r = R * r1;
    P = [x; y] + P_r;

    L_vector = A1- P;
    L_length = norm(L_vector);

    u = L_vector / L_length;
    
    % 连接点 P 对姿态 q 的偏导矩阵 dp/dq
    % [dp/dx, dp/dy, dp/theta]
    dp_dq = [
        1, 0, -P_r(2);
      0, 1, P_r(1)  
    ];
    
    % jacobian矩阵 J = dL/dq = -u^T * (dp/dq)
    J = -u' * dp_dq;

    L_dot = J * q_dot;

end
