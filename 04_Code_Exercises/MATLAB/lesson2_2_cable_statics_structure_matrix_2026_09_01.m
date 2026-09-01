clc;
clear;

% step1 define platform state
% 这也是q-old
q = [0; 0; 0];

% step2 define anchor 
Anchor = [
    0.0, 0.6; 
    0.6, 0.6;
    0.6, 0.0;
    0.0, 0.0 ];

% step3 define attachment point
r = [
    0.2, 0.1;
    0.1, 0.3;
    0.0, 0.1;
    0.3, 0.3];

disp('r矩阵行数为：')
disp(size(r, 1));

% step4 define platform new q
q_dot = [0.1; 0.05; 0.2];
dt = 0.001;
q_new = q + q_dot * dt;

% step5 calculate old and new length
old_length = calculate_cable_length(q, Anchor, r);
new_length = calculate_cable_length(q_new, Anchor, r);

numerical_length = (new_length - old_length) / dt;

disp('old_length:');
disp(old_length);
disp('new_length:');
disp(new_length);
disp('numerical Length Rate:');
disp(numerical_length);

% step6 calculate jacobian and a_direct
[J, analytical_length_dot, a_direct] = calculate_cable_jacobian(q, Anchor, r, q_dot);

% step7 display the Jacobian and analytical length rate
disp('Jacobian (4×3):');
disp(J);
disp('Analytical Length Rate:');
disp(analytical_length_dot);

% step8 calculate errors
error = numerical_length - analytical_length_dot;
relative_error = abs(error) ./ abs(analytical_length_dot);
%点除表示矩阵内的元素逐一相除

disp('relative error:');
disp(relative_error);
%这里结果会显示 1.0e-03* 表示所有结果都得乘以10e-3

%step9 calculate structure matrix a
A = - J';
disp('strucutre matrix A (3×4):');
disp(A);

%step10 verify A and A_direct
disp('A_direct:');
A_direct = a_direct';
disp(A_direct);

error_a = A - A_direct;
disp('A - A_direct:');
disp(error_a);

disp('Maximum absolute error:');
disp(max(abs(error_a(:))));


%% 长度计算函数
function L_length = calculate_cable_length(q, Anchor, r)
%预分配向量空间 4*1
num_cables = size(r, 1);
L_length = zeros(num_cables, 1);

% calculate rotation matrix
x = q(1);
y = q(2);
theta = q(3);

R = [
    cos(theta), -sin(theta);
    sin(theta), cos(theta)
    ];

% calculate attachment point 的 world position
% 矩阵维度不一致 需要用for循环一个个计算
for i = 1 : num_cables

   P = [x; y] + R * r(i ,:)';

   % calculate cable vector
   % Anchor(i, :)' 转置为列向量，避免维度不一致
   L_vector = Anchor(i, :)' - P;

   % calculate cable length
   L_length(i) = norm(L_vector);
   % norm长度计算公式
end
end

%% jacobian 计算矩阵
function [J, L_dot, a_direct] = calculate_cable_jacobian(q, Anchor, r, q_dot)
    %这个函数定义两个出口一个是J, 另一个是L_dot，所以在主程序里面也要写两个接口
    %名字可以自己定义 
    
    %预分配向量空间 4*1
    num_cables = size(r, 1);
    J = zeros(num_cables, 3); % 预分配 4x3 雅可比矩阵空间
    a_direct = zeros(num_cables, 3);

    x = q(1);
    y = q(2);
    theta = q(3);

    R = [
        cos(theta), -sin(theta);
        sin(theta), cos(theta)
        ];

    %因为矩阵维度不一样 使用for循环计算
    for i = 1 : num_cables

        % 平台连接点坐标
        P_r = R * r(i, :)';
        P = [x; y] + P_r;

        L_vector = Anchor(i, :)' - P;
        L_length = norm(L_vector);
        u = L_vector / L_length;

        % 连接点 P 对姿态 q 的偏导矩阵 dp/dq
        % [dp/dx, dp/dy, dp/theta]
        dp_dq = [
            1, 0, -P_r(2);
            0, 1, P_r(1)  
            ];

        % jacobian矩阵 J = dL/dq = -u^T * (dp/dq)
        J(i, :) = -u' * dp_dq;

    
        % calculate a_direct
        % 二维力矩计算公式 P_rx * u_y - P_ry * u_x
        torque_z = P_r(1) * u(2) - P_r(2) * u(1);
        a_direct(i, :) = [u(1), u(2), torque_z]; 

    end
    % 循环结束后统一计算所有绳索的长度变化率 (4x1)
    L_dot = J * q_dot;


end
