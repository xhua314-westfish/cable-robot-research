clear;
clc;

% =================
% platform 
% =================

% platform = [0.5, 0.5]; 这是两列一行
P = [0.5; 0.5]; % 这是一列两行
%矩阵相乘一定得保证列数相同 

% =================
% platform 
% =================

%将0-360°一行数据变成一列数据
theta_deg = (0: 360)';
theta = deg2rad(theta_deg);

% =================
% attachment points
% =================

% attachment point in local coordinate
r = [
    -0.125, -0.125;
    0.125, -0.125;
    0.125, 0.125;
    -0.125, 0.125
    ];

% =================
% cable
% =================
% A means anchor 

A = [
    1.0, 1.0;
    1.0, 0.0;
    0.0, 0.0;
    0.0, 1.0
    ];

% =================
% platform 
% =================

B = zeros(length(theta), 4, 2);
L = zeros(length(theta), 4, 1);

% =========================
% Calculate
% =========================


% for循环计算
for i = 1:length(theta)

    % 1.rotation matrix 
    R = [cos(theta(i)), -sin(theta(i));
        sin(theta(i)), cos(theta(i))];

    % 2.Transform local -> world
    %这里需要转置矩阵 保证行数相同才能进行运算
    %矩阵乘法要求第一个矩阵的列数等于第二个矩阵的行数
    % B(i, 4, 2) = (R * r')' + P'; 这里表示第i行 第4列 第二页中的一个元素
    B (i, :, :) = (R * r')' + P'; % 这是一个三维矩阵 表示第i个角度下的坐标
    

    % 3.cable-vector、
    B_current = squeeze(B(i, :, :)); %把长度为1的维度去掉
    D = A - B_current;
    
    % 4.cable-length
    L(i, :) = sqrt(sum(D.^2, 2));
    % D.^2 dx1² dy1² dx2² dy2² ....
    % sum → dx1² + dy1²

    % =================
    % display
    % =================
    disp("the current angle is:");
    disp(theta(i));
    disp("the four cables length:");
    disp(L(i,:));
end

plot(theta_deg, L);
xlabel('Platform rotation (deg)');
ylabel('Cable length (m)');
legend('Cable 1','Cable 2','Cable 3','Cable 4');
grid on






