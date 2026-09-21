% lesson 3.6
% planar dynamics + cable length simulation
%
% this simulation includes:
% 1. platform rigid-body dynamics
% 2. cable force and moments
% 3. platform position and velocity
% 4. cable lengths
% 5. cable Jacobian
% 6. cable velocity
% 7. time-varying jacobian
% 8. cable acceleration
% 9. numerical verification

clc;
clear;
close all;

%% ===========
%1. system parameters 
% =======================

m = 2;   % platform mass [kg]
Iz = 0.5; % platform moment of inertia [kg*m^2]

% mass matrix
M = [m 0 0;
    0 m 0;
    0 0 Iz];

%% ======================== 
% 2. cable wrench and external wrench
% =============

% cable wrench acting on platform
% Fx Fy Tz
w_cable = [0; 4; 1]; % N,N,N*m

%external wrench 
w_ext = [0; -2; 0]; % N,N,N*m

% net wrench
w_net = w_cable + w_ext;

%% =============
% 3. platform acceleration
% ============

% dynamic equation:
% M * q_ddot = w_net 
% therefore:
% q_ddot = M^(-1) * w_net
q_ddot = M \ w_net;

%% ====================
% 4. initial conditions
% ===========

% initial platform position
% q = [x; y; θ]
q = [0; 0; 0];

% initial platform velocity
% q_dot = [x_dot; y_dot; theta_dot]
q_dot = [0; 0; 0];

%% ================
% 5. simulation settings
% ============

dt = 0.01; % time steps [s]
t = 0:dt:2; % simulation time [s]
N = length(t); 

%% =====================
% 6. cable geometry
% ================

% fixed anchor positions 
% each column represents one anchor:
% A(:,1) → A1
% A(:,2) → A2
% A(:,3) → A3
% A(:,4) → A4
A = [-2 2 2 -2;
    3 3 -1 -1];

% platform attachment points relative to platform center 
% each column represents one attachment point:
% r(:,1) → r1
% r(:,2) → r2
% r(:,3) → r3
% r(:,4) → r4
r = [-0.5 0.5 0.5 -0.5;
    0.5 0.5 -0.5 -0.5
    ];

n_cables = size(A,2);

%% ==================
% 7. Pre-allocation 
% ======================

% platform state
q_history = zeros (3, N);
q_dot_history = zeros(3, N);
q_ddot_history = zeros(3, N);

% cable length
L_history = zeros(n_cables, N);

% cable velocity
L_dot_history = zeros(n_cables, N);
L_dot_numerical_history = zeros(n_cables, N);

% cable acceleration
L_ddot_history = zeros(n_cables, N);
L_ddot_numerical_history = zeros(n_cables, N);

% jacobian
J_history = zeros(3, n_cables, N);
% jacobian is 3x4 in each time step
% use 3D matrix to recording all jacobian in different time step
J_dot_history = zeros(3, n_cables, N);



%% ==============
% 8. dynamics simulation loop
% ================

for k = 1 : N
    % --------
    % 8.1 store platform state
    % --------
    
    q_history (:, k) = q;
    q_dot_history(:, k) = q_dot;
    q_ddot_history(:, k) = q_ddot;

    % -----------
    % 8.2 platform position and rotation
    % ----------

    % platform center
    P = q(1:2);

    % platform orientation
    theta = q(3);

    % rotation matrix 
    R = [cos(theta) -sin(theta);
        sin(theta) cos(theta)];

    % -----------
    % 8.3 Calculate world-frame attachment points
    % ----------
    
    % r, attachment point in platform frame
    % world-frame attachment points
    B = P + R * r;
    
    % -----------
    % 8.4 calculate cable vectors
    % ----------

    % cable vector from the attachment point to anchor
    D = A - B; 

    % --------
    % 8.5 calculate cable lengths
    % ---------

    % each column of D represents one cable vector
    % L_i = sqrt(dx_i^2 + dy_i^2)
    % D.^2 每个元素单独求平方
    % sum(D.^2, 1), 按列向下相加
    % L is 1×4, L_history(:,k) needs 4×1
    % therefore transpose L
    L = sqrt(sum(D.^2, 1))';
    
    % store cable lengths
    L_history(:, k) = L;

    % -----------
    % 8.6 calculate jacobian and J_dot
    % ----------


    % unit vector from attachment point to anchor 
    % D is 2×4, L is 4×1
    % therefore, L is automatically extended to 2×4 
    % L (cable1 cable1; ......; cable4 cable4)
    % 点除需要列数相等 所以这里又进行了转置
    u =  D ./ L';

    J = zeros(3, n_cables);
    
    % 计算 jacobian每一行每一列数据 3行四列
    for i = 1: n_cables
        
        % cable direction 
        % there are four columns 
        ui = u(:, i);

        % Attachment point relative to platform center
        ri = r(:,i);

        % transition contribution
        % dL/dx and dL/dy
        J(1, i) = -ui(1);
        J(2, i) = -ui(2);

        % rotation contribution
        % d(R*r)/dtheta
        dri_dtheta = [-sin(theta) -cos(theta);
            cos(theta) -sin(theta)] * ri;

        % dL/dtheta
        J(3, i) = -ui' * dri_dtheta;   
    end
    
    % store jacobian 
    J_history(:, :, k) = J;

    % calculate j_dot
    if k == 1
        J_dot = zeros(3, 4);
    else
        J_dot = (J - J_history(:, :, k - 1)) / dt;
    end
    J_dot_history(:, :, k) = J_dot;
    
    % -----------
    % 8.6 calculate cable velocity and acceleration
    % ----------

    % calculate cable velocity
    % J = 3×4
    % q_dot = 3×1
    L_dot = J' * q_dot;

    % store cable velocity
    L_dot_history(:, k) = L_dot;
    
    % calculate cable acceleration 
    L_ddot = J' * q_ddot + J_dot' * q_dot;

    % store cable acceleration
    L_ddot_history(:,k) = L_ddot;
    
    % ------------
    % 8.7 update platform velocity and position
    % ---------

    % do not update after the final time point
    if k < N
        
        % velocity integration
        % q_dot_new = q_dot_old + q_ddot * dt
        q_dot = q_dot + q_ddot * dt;

        % position integration
        % q_new = q_old + q_dot * dt
        q = q + q_dot *dt;

    end 

    % calculate cable velocity using numerical differentiation
    if k == 1 
        L_dot_numeric = zeros(4,1);
    else
        L_dot_numeric = (L_history(:, k) - L_history(:, k-1))/ dt;
    end 
    
    % store numerical cable velocity
    L_dot_numerical_history (:, k) = L_dot_numeric;

    % calculate cable acceleration using numerical differentiation
    if k == 1 
        L_ddot_numeric = zeros(4,1);
    else
        L_ddot_numeric = (L_dot_history(:, k) - L_dot_history(:, k-1))/ dt;
    end 

    % store numerical cable acceleration
    L_ddot_numerical_history (:, k) = L_ddot_numeric;

end 

%% =========
% 9. plot platform velocity 
% =======

figure;

% (1, :)提起第一行中所以的列数据，就是所有x方向的速度
plot(t, q_dot_history(1, :), 'LineWidth', 2);
hold on;

plot(t, q_dot_history(2, :), "LineWidth", 2);

xlabel('time (s)');
ylabel('velocity (m/s)');

legend('x velocity', 'y velocity');
title('platform velocity');

grid on;

%% ===========
% 10. plot platform position
% ========

figure;

plot(t, q_history(1, :), LineWidth=2);
hold on;

plot(t, q_history(2, :), LineWidth=2);

xlabel('time (s)');
ylabel('position (m)');

legend('x position', 'y position');
title('platform position');

grid on;

%% ===========
% 11. plot cable length
% ========

figure;

plot(t, L_history(1, :), LineWidth=2);
hold on;

plot(t, L_history(2, :), LineWidth=2);
plot(t, L_history(3, :), LineWidth=2);
plot(t, L_history(4, :), LineWidth=2);

xlabel('time (s)');
ylabel('cable length (m)');

legend('cable 1', 'cable 2', 'cable 3', 'cable 4' );
title('cable length');

grid on;

%% ===========
% 11. plot cable velocity
% ========

figure;

plot(t, L_dot_history(1,:), 'LineWidth', 2);
hold on;

plot(t, L_dot_history(2,:), 'LineWidth', 2);
plot(t, L_dot_history(3,:), 'LineWidth', 2);
plot(t, L_dot_history(4,:), 'LineWidth', 2);

xlabel('time (s)');
ylabel('cable velocity (m/s)');
legend('cable 1', 'cable 2', 'cable 3', 'cable 4');
title('cable velocity');
grid on;

%% ===========
% 12. compare cable velocity
% ========

figure;

plot(t, L_dot_history(1, :), 'LineWidth', 2);
hold on;

plot(t, L_dot_numerical_history(1, :), '--', 'LineWidth', 2);
xlabel('time (s)');
ylabel('cable 1 velocity (m/s)');
legend('jacobian', 'numerical difference');
title('Cable 1 velocity comparison');
grid on;

%% ===========
% 12. compare cable acceleration
% ========

figure;

plot(t, L_ddot_history(1, :), 'LineWidth', 2);
hold on;

plot(t, L_ddot_numerical_history(1, :), '--', 'LineWidth', 2);
xlabel('time (s)');
ylabel('cable 1 acceleration (m/s²)');
legend('jacobian', 'numerical difference');
title('Cable 1 acceleration comparison');
grid on;
