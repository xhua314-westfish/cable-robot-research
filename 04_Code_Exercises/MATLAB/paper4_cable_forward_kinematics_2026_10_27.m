
%% A4 - Lesson 3.1
% Noiseless 6-DOF Forward Kinematics
% Gauss-Newton with world-frame rotation updates

clc;
clear;
close all;

%% 1. Fixed anchor points
% Paper 4 Table 1
% Original unit: cm

A_cm = [ 71.5   71.5  -71.5  -71.5   71.5   71.5  -71.5  -71.5;
    38    -38    -38     38     38    -38    -38     38;
    93     93     93     93      0      0      0      0];

% Convert cm to m
A = A_cm / 100;

%% 2. Local attachment points
% Paper 4 Table 1
% Original unit: cm

r_cm = [ 3.75   3.75  -3.75  -3.75   3.75   3.75  -3.75  -3.75;
    7.5   -7.5   -7.5    7.5    3.75  -3.75  -3.75   3.75;
    -3.75  -3.75  -3.75  -3.75   3.75   3.75   3.75   3.75];

% Convert cm to m
r = r_cm / 100;

%% 3. Platform pose
% Initial conditions from Section 5

P = [0.15; 0.15; 0.465];

R = eye(3);

%% 4. Define the true platform pose
P_true = P;
R_true = eye(3);

% Generate exact cable lengths
D_true = P_true + R_true*r - A;
L_true = vecnorm(D_true,2,1)';

%% 5. Define an initial pose estimate
% Translation starts 10 mm away from the true pose
P_est = P_true + [0.01; -0.01; 0.01];

% Initial orientation error: 2 degrees about X
theta0 = deg2rad(2);

R_est = [1 0 0;
    0 cos(theta0) -sin(theta0);
    0 sin(theta0)  cos(theta0)];
% 这里的P_est和R_est均为估计值estimation
% 后面通过迭代计算使得预测值接近于实际值 
% 通过残差控制迭代次数 


%% 6. Solver settings
% noise settings
rng(42);
% 假随机数42 为了论文能复现 
% 而且会使后面的randn生成一样的矩阵 

N_MC = 100;

sigma_L = 0.001;            % 1 mm standard deviation

% iter settings

max_iter = 20;
tol = 1e-10;

% storage 
residual_history = zeros(max_iter,1);

position_errors = zeros(3,N_MC);
rotation_errors = zeros(3,N_MC);

final_residuals = zeros(N_MC,1);
iteration_counts = zeros(N_MC,1);

%% 7. Monte Carlo loop
for n = 1 : N_MC
    %% Generate independent measurement noise
    noise = sigma_L * randn(8,1);

    L_meas = L_true + noise;


    %% Reset initial pose for every trial
    P_est = P_true + [0.01; -0.01; 0.01];

    theta0 = deg2rad(2);

    R_est = [1 0 0;
        0 cos(theta0) -sin(theta0);
        0 sin(theta0) cos(theta0)];

    %% a. Gauss-Newton iteration
    for k = 1: max_iter
        % World-frame attachment vectors
        r_world = R_est*r;

        % Current predicted cable vectors
        D_current = P_est + r_world - A;

        % Predicted cable lengths
        L_pred = vecnorm(D_current,2,1)';

        % Measurement residual: measured minus predicted
        residual = L_meas - L_pred;

        % Unit cable directions
        e = D_current ./ vecnorm(D_current,2,1);

        % Current 8x6 measurement Jacobian
        H_current = [e', cross(r_world,e,1)'];

        % Check local observability
        assert(rank(H_current)==6, ...
            'Measurement Jacobian is rank deficient.');

        % Least-squares pose increment
        delta_q = H_current \ residual;
        % 得到的 Delta q 是一个 6 × 1 的向量：
        % 前 3 个分量是平移增量，后 3 个分量是世界坐标系下的微小旋转向量 delta \omega。

        % Update translation
        P_est = P_est + delta_q(1:3);

        % Extract world-frame rotation increment
        delta_w = delta_q(4:6);

        angle = norm(delta_w);

        % Update rotation using Rodrigues formula
        if angle > 0

            axis_vector = delta_w / angle;

            K = [0 -axis_vector(3) axis_vector(2);
                axis_vector(3) 0 -axis_vector(1);
                -axis_vector(2) axis_vector(1) 0];

            R_delta = eye(3) ...
                + sin(angle)*K ...
                + (1-cos(angle))*(K*K);

            R_est = R_delta*R_est;

        end

        % Record pre-update residual
        residual_history(k) = norm(residual);

        fprintf('Iteration %d: residual = %.3e m\n', ...
            k,residual_history(k));

        % Stop when the pose increment is small
        if norm(delta_q) < tol
            break;
        end
    end

    %% store position erros
    position_errors(:,n) = P_est - P_true;

    %% Store small rotation error vector
    % R_true = eye(3) in this experiment
    R_diff = R_est*R_true';
    % R_est = R_diff * R_true 
 
    c = (trace(R_diff)-1)/2;
    % c是旋转角 alpha
    % 任何旋转矩阵 R 的迹-trace（主对角线元素之和）与等效旋转角 $\alpha$ 
    % 满足以下定理：trace(R_diff) = 1 + 2cos(alpha)
    c = max(-1,min(1,c));

    alpha = acos(c);
    %对余弦值 c 取反余弦函数arccos

    vee_part = [R_diff(3,2)-R_diff(2,3);
        R_diff(1,3)-R_diff(3,1);
        R_diff(2,1)-R_diff(1,2)];

    if alpha < 1e-7
        rot_error_vec = 0.5*vee_part;
    else
        rot_error_vec = alpha/(2*sin(alpha))*vee_part;
    end

    rotation_errors(:,n) = rot_error_vec;

    % 把一个抽象的姿态矩阵变化，拆解并输出为
    % rotation_errors = [X轴偏转角, Y轴偏转角, Z轴偏转角]

    %% Final residual after updating pose

    L_final = vecnorm(P_est + R_est*r - A,2,1)';

    final_residuals(n) = norm(L_meas - L_final);

    iteration_counts(n) = k;

end

%% 8. Compute final estimation errors

% position estimation error 
position_error_mm = norm(P_est-P_true)*1000;

% Rotation estimation error
R_error = R_est*R_true';
cos_angle = (trace(R_error)-1)/2;
cos_angle = max(-1,min(1,cos_angle));
rotation_error_deg = rad2deg(acos(cos_angle));

% final predicted cable length 
D_final = P_est + R_est*r - A;
L_final = vecnorm(D_final,2,1)';

% Residual relative to measured lengths
final_residual = L_meas-L_final;
residual_norm_mm = norm(final_residual)*1000;


%% 6. Display results

disp('True position (m):');
disp(P_true);

disp('Estimated position (m):');
disp(P_est);

fprintf('Position error = %.6f mm\n', ...
    position_error_mm);

fprintf('Rotation error = %.6f deg\n', ...
    rotation_error_deg);

fprintf('Final cable length residual = %.3e mm\n', ...
    residual_norm_mm);

fprintf('Iterations completed = %d\n',k);

%% A4 - Lesson 4.1
% Pose Estimation Covariance

%% 1. Measurement noise covariance
sigma_L = 0.001; % 1mm
V = sigma_L^2 * eye(8);
% 表明系统中共有 8 个独立的测量通道，
% 每个通道的测量方差均相同（为 sigma_L^2 = 10^{-6} m^2）

%% 2. Pose covariance
% Use the Jacobian at the current reference pose
H_cov = H_current;

% Information matrix
F = H_cov' * (V \ H_cov);
% 计算费雪信息矩阵（Fisher Information Matrix, F），
% 数学公式为 F = H^T V^{-1} H。

% Covariance matrix
P_cov = F \ eye(6);

%% 3. Standard deviations
std_pose = sqrt(diag(P_cov));
% 取 P_cov 主对角线上的 6 个方差值开平方根，
% 提取出 6 个姿态参数的标准差 sigma。

% Position uncertainty in mm
std_position_mm = std_pose(1:3)*1000;
% 截取前 3 个位置标准差（$x, y, z$），
% 乘以 1000 从米（m）转换为毫米（mm）。

% Rotation uncertainty in degrees
std_rotation_deg = rad2deg(std_pose(4:6));
%截取后 3 个姿态角标准差（姿态角），
% 调用 rad2deg 函数从弧度（rad）转换为角度（deg）。

%% 4. Calculate empirical standard deviations

std_position_MC = std(position_errors,0,2)*1000;

std_rotation_MC = rad2deg(std(rotation_errors,0,2));

%% 5. Covariance predictions from Lesson 4.1

std_position_pred = sqrt(diag(P_cov(1:3,1:3)))*1000;

std_rotation_pred = ...
    rad2deg(sqrt(diag(P_cov(4:6,4:6))));

%% 6. Display comparison

disp('Predicted position std (mm):');
disp(std_position_pred);

disp('Monte Carlo position std (mm):');
disp(std_position_MC);

disp('Predicted rotation std (deg):');
disp(std_rotation_pred);

disp('Monte Carlo rotation std (deg):');
disp(std_rotation_MC);

fprintf('Mean final residual = %.4f mm\n', ...
    mean(final_residuals)*1000);

fprintf('Mean iteration count = %.2f\n', ...
    mean(iteration_counts));


%% A4 - Lesson 4.2 Visualization
% Predicted vs Monte Carlo position uncertainty

figure;

values = [std_position_pred, std_position_MC];

bar(values);

set(gca,'XTickLabel',{'X','Y','Z'});

ylabel('Position Standard Deviation (mm)');

legend('Analytical Prediction','Monte Carlo', ...
    'Location','best');

title('Pose Estimation Uncertainty Validation');

grid on;


%% A4 - Lesson 4.3
% RMSE, Bias and 3-sigma coverage

%% 1. Position errors in mm

E_pos = position_errors * 1000;

%% 2. Rotation errors in degrees

E_rot = rad2deg(rotation_errors);

%% 3. Calculate Bias

bias_pos = mean(E_pos,2);
bias_rot = mean(E_rot,2);

%% 4. Calculate RMSE for each component

rmse_pos = sqrt(mean(E_pos.^2,2));
rmse_rot = sqrt(mean(E_rot.^2,2));

%% 5. Predicted three-sigma bounds

bound_pos = 3*std_position_pred;
bound_rot = 3*std_rotation_pred;

%% 6. Empirical three-sigma coverage
% Each row corresponds to one pose component

coverage_pos = mean(abs(E_pos) <= bound_pos,2)*100;
coverage_rot = mean(abs(E_rot) <= bound_rot,2)*100;

%% 7. Display comparison

PositionResults = table( ...
    ["X";"Y";"Z"], ...
    bias_pos, rmse_pos, ...
    std_position_pred, std_position_MC, ...
    bound_pos, coverage_pos, ...
    'VariableNames', ...
    {'Axis','Bias_mm','RMSE_mm', ...
    'PredStd_mm','MCStd_mm', ...
    'Bound3Sigma_mm','Coverage_pct'});

RotationResults = table( ...
    ["RotX";"RotY";"RotZ"], ...
    bias_rot, rmse_rot, ...
    std_rotation_pred, std_rotation_MC, ...
    bound_rot, coverage_rot, ...
    'VariableNames', ...
    {'Axis','Bias_deg','RMSE_deg', ...
    'PredStd_deg','MCStd_deg', ...
    'Bound3Sigma_deg','Coverage_pct'});

disp('Position error statistics:');
disp(PositionResults);

disp('Rotation error statistics:');
disp(RotationResults);



%% A4 - Lesson 4.4
% Normalized Estimation Error Squared (NEES)

%% 1. Combine six-dimensional estimation errors

E_pose = [position_errors; rotation_errors];

N_MC = size(E_pose,2);

%% 2. Compute NEES for each trial

NEES = zeros(N_MC,1);

for n = 1:N_MC

    e_q = E_pose(:,n);

    NEES(n) = e_q' * (P_cov \ e_q);

end

%% 3. Average NEES

ANEES = mean(NEES);

fprintf('Average NEES = %.4f\n',ANEES);

fprintf('Theoretical expected NEES = 6\n');


%% A4 - Lesson 4.4B
% Understand histogram bins and frequencies

figure;

h = histogram(NEES,15);

xline(6,'r--','Expected mean = 6');

xlabel('NEES');
ylabel('Frequency');
title('NEES Histogram - 15 Bins');
grid on;

%% Extract bin information

bin_edges = h.BinEdges;
bin_counts = h.Values;

%% Display frequencies

BinStart = bin_edges(1:end-1)';
BinEnd = bin_edges(2:end)';
Frequency = bin_counts';

BinTable = table(BinStart,BinEnd,Frequency);

disp('NEES histogram bin statistics:');
disp(BinTable);

%% Check sample count

fprintf('Number of bins = %d\n',numel(bin_counts));
fprintf('Total observations = %d\n',sum(bin_counts));
fprintf('Number of Monte Carlo trials = %d\n',numel(NEES));


%% A4 - Lesson 4.5
% ANEES statistical consistency test
% 对蒙特卡洛仿真结果进行 ANEES（Average Normalized Estimation Error Squared，平均归一化估计误差平方）一致性检验，
% 用卡方分布（$\chi^2$ 分布）来严格判定：算法算出的理论协方差 $P_{\text{cov}}$ 是否真实反映了实际的估计误差。

%% 1. Parameters

N = length(NEES);
n_dof = 6;

alpha = 0.05;

%% 2. Chi-square confidence bounds
% Requires Statistics and Machine Learning Toolbox

lower_bound = chi2inv(alpha/2, n_dof*N) / N;

upper_bound = chi2inv(1-alpha/2, n_dof*N) / N;

%% 3. Average NEES

ANEES = mean(NEES);

%% 4. Consistency decision

is_consistent = ...
    (ANEES >= lower_bound) && ...
    (ANEES <= upper_bound);

%% 5. Display results

fprintf('Number of trials = %d\n',N);
fprintf('Expected ANEES = %d\n',n_dof);

fprintf('Actual ANEES = %.4f\n',ANEES);

fprintf('95%% lower bound = %.4f\n',lower_bound);
fprintf('95%% upper bound = %.4f\n',upper_bound);

fprintf('Consistency test passed = %d\n',is_consistent);
