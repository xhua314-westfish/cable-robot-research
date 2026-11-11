
%% B5.4 Lesson 2
% Minimal Nonlinear Six-DOF Pose Estimator
%
% Research Question:
% Can six cable lengths recover an unknown rigid-body pose?
%
% Objectives:
% 1. Test all six Core-eligible configurations
% 2. Generate noise-free synthetic length measurements
% 3. Estimate pose without accessing ground truth
% 4. Use damped Gauss-Newton with line search
% 5. Validate position and orientation errors
% 6. Record convergence and residuals
%
% IMPORTANT:
% This is an IDEAL, NOISE-FREE algorithm test.
% No real sensor accuracy is claimed.
%
% Units:
% Position: mm
% Rotation increments: rad
% Reported orientation errors: degrees

clear; clc; close all;

%% Step 1: Load verified B5.4 baseline

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','eligibility_set', ...
    'P_all','R_all','settings');

rb = settings.rb;

config_ids = eligibility_set(:)';
N_config = numel(config_ids);

assert(N_config==6);
assert(isequal(config_ids,[2 4 6 8 12 17]));

N_core = size(P_all,1);
assert(N_core==189);

fprintf('\n--- B5.4 Lesson 2 ---\n');
fprintf('Configurations: %d\n',N_config);
fprintf('Core poses available: %d\n',N_core);

%% Step 2: Select validation poses
%
% 从已保存的189个Core姿态中
% 选择12个分布在不同索引位置的样本。
%
% 本节先验证估计器的基本工作能力。
% 后续再扩展到全部189姿态。

pose_ids = unique(round(linspace(1,N_core,12)));

N_test = numel(pose_ids);

assert(N_test==12);

fprintf('Selected test poses: %d\n',N_test);
disp(pose_ids);

%% Step 3: Define common estimator settings
%
% 所有六组配置使用相同初值、
% 迭代次数、阻尼和停止条件。
%
% 这里的参数是数值求解器设置，
% 不是系统硬件性能要求。

solver = struct();

solver.max_iterations = 100;

% 长度残差停止阈值，mm
solver.residual_tol_mm = 1e-8;

% 归一化参数步长停止阈值
solver.step_tol = 1e-9;

% Damped Gauss-Newton正则化
solver.lambda = 1e-4;

% Backtracking line search
solver.max_backtracks = 20;

% 每次迭代的最大位移更新，mm
solver.max_translation_step_mm = 20;

% 每次迭代最大旋转向量更新，rad
solver.max_rotation_step_rad = deg2rad(10);

% 与B4一致的Jacobian缩放
solver.scale = diag( ...
    [1 1 1 1/rb 1/rb 1/rb]);

%% Step 4: Prepare result storage

N_total = N_config*N_test;

ConfigID = zeros(N_total,1);
PoseID = zeros(N_total,1);

Converged = false(N_total,1);
Iterations = zeros(N_total,1);

PositionError_mm = nan(N_total,1);
OrientationError_deg = nan(N_total,1);
ResidualNorm_mm = nan(N_total,1);

% 保存全部估计结果，供后续诊断
estimated_poses = cell(N_total,1);

row_id = 0;

%% Step 5: Evaluate six configurations

for c = 1:N_config

    config_id = config_ids(c);

    cfg = best_configs(config_id);

    A = cfg.A;
    r = cfg.r;

    fprintf('\n====================================\n');
    fprintf('Configuration %d\n',config_id);
    fprintf('====================================\n');

    for k = 1:N_test

        pose_id = pose_ids(k);

        %% 5.1 True pose - used only for simulation

        P_true = P_all(pose_id,:);
        R_true = R_all(:,:,pose_id);

        % 真实姿态仅用于生成合成Cable长度
        L_meas = cable_lengths( ...
            A,r,P_true,R_true);

        % 无噪声实验
        % 这里不加入任何随机数
        assert(all(isfinite(L_meas)));

        %% 5.2 Initial guess
        %
        % 估计器从同一个零姿态出发。
        %
        % 不允许使用真实Pose作为初值。

        P0 = [0 0 0];
        R0 = eye(3);

        %% 5.3 Estimate unknown pose

        result = solve_pose_from_lengths( ...
            A,r,L_meas,P0,R0,solver);

        %% 5.4 Independent error calculation
        %
        % 求解完成之后，才使用真实姿态计算误差。
        %
        % 这些Ground Truth值没有传给求解器。

        p_error = norm(result.P-P_true);

        R_relative = result.R*R_true';

        cos_angle = ...
            (trace(R_relative)-1)/2;

        % 防止浮点数超过[-1,1]
        cos_angle = max(-1,min(1,cos_angle));

        R_error = acosd(cos_angle);

        %% 5.5 Save single test result

        row_id = row_id+1;

        ConfigID(row_id) = config_id;
        PoseID(row_id) = pose_id;

        Converged(row_id) = result.converged;
        Iterations(row_id) = result.iterations;

        PositionError_mm(row_id) = p_error;

        OrientationError_deg(row_id) = R_error;

        ResidualNorm_mm(row_id) = result.residual_norm;

        estimated_poses{row_id} = result;

    end

end

assert(row_id==N_total);

%% Step 6: Create per-pose result table

T_pose = table( ...
    ConfigID,PoseID,Converged,Iterations, ...
    PositionError_mm,OrientationError_deg, ...
    ResidualNorm_mm);

disp(' ');
disp('--- Individual Pose Estimation Results ---');
disp(T_pose);

%% Step 7: Summarise estimation performance
%
% 平均误差只是一种统计方式。
% 同时报告最大误差与收敛数量，
% 防止少数失败案例被平均值掩盖。

SummaryConfigID = config_ids(:);

ConvergedCount = zeros(N_config,1);
PositionRMSE_mm = nan(N_config,1);
OrientationRMSE_deg = nan(N_config,1);

MaxPositionError_mm = nan(N_config,1);
MaxOrientationError_deg = nan(N_config,1);

MedianIterations = nan(N_config,1);

for c = 1:N_config

    mask = ConfigID==config_ids(c);

    p_errors = PositionError_mm(mask);
    r_errors = OrientationError_deg(mask);

    ConvergedCount(c) = sum(Converged(mask));

    % 对全部测试姿态计算RMSE
    % 即使某次没有收敛也不能将其删除
    PositionRMSE_mm(c) = ...
        sqrt(mean(p_errors.^2));

    OrientationRMSE_deg(c) = ...
        sqrt(mean(r_errors.^2));

    MaxPositionError_mm(c) = max(p_errors);

    MaxOrientationError_deg(c) = max(r_errors);

    MedianIterations(c) = ...
        median(Iterations(mask));

end

T_summary = table( ...
    SummaryConfigID,ConvergedCount, ...
    PositionRMSE_mm,OrientationRMSE_deg, ...
    MaxPositionError_mm, ...
    MaxOrientationError_deg, ...
    MedianIterations);

disp(' ');
disp('--- Pose Estimation Summary ---');
disp(T_summary);

%% Step 8: Basic numerical checks
%
% 这里只检查计算结果的有效性，
% 不预先假设所有配置一定成功收敛。
%
% 如果某配置失败，
% 必须保留并进一步分析其原因。

assert(all(isfinite(PositionError_mm)));
assert(all(isfinite(OrientationError_deg)));
assert(all(isfinite(ResidualNorm_mm)));

assert(all(PositionError_mm>=0));
assert(all(OrientationError_deg>=0));

assert(all(ConvergedCount<=N_test));

fprintf('\n--- Solver Verification ---\n');

fprintf('Total tests: %d\n',N_total);

fprintf('Converged: %d / %d\n', ...
    sum(Converged),N_total);

fprintf('Maximum position error: %.6e mm\n', ...
    max(PositionError_mm));

fprintf('Maximum orientation error: %.6e deg\n', ...
    max(OrientationError_deg));

%% Step 9: Visualise estimated pose errors

figure('Color','w', ...
    'Name','B5.4 Noise-Free Pose Estimation', ...
    'Position',[100 100 1200 500]);

subplot(1,2,1);

bar(SummaryConfigID,PositionRMSE_mm);

xlabel('Configuration ID');
ylabel('Position RMSE (mm)');

title('Noise-Free Position Reconstruction');

xticks(SummaryConfigID);
grid on;

subplot(1,2,2);

bar(SummaryConfigID,OrientationRMSE_deg);

xlabel('Configuration ID');
ylabel('Orientation RMSE (deg)');

title('Noise-Free Orientation Reconstruction');

xticks(SummaryConfigID);
grid on;

%% Step 10: Save estimator validation

save('B5_4_pose_estimator_baseline.mat', ...
    'T_pose','T_summary', ...
    'estimated_poses', ...
    'config_ids','pose_ids', ...
    'solver','rb');

fprintf('\nB5.4 Lesson 2 completed.\n');

fprintf('Saved: B5_4_pose_estimator_baseline.mat\n');

%% ==================================================
% Local Function 1: Predict six cable lengths
%% ==================================================
function L = cable_lengths(A,r,P,R)

    % 六个Attachment从Body Frame到World Frame
    S = (R*r')';

    % Attachment世界坐标
    B = S+P;

    % Cable长度
    L = vecnorm(A-B,2,2);

end

%% ==================================================
% Local Function 2: Compute length Jacobian
%% ==================================================
function H = cable_length_jacobian(A,r,P,R)

    S = (R*r')';

    B = S+P;

    D = A-B;

    L = vecnorm(D,2,2);

    assert(all(L>1e-12));

    u = D./L;

    H = zeros(6,6);

    for i = 1:6

        % 与B4相同的空间角速度/左乘旋转约定
        H(i,:) = [ ...
            -u(i,:), ...
            cross(u(i,:),S(i,:)) ...
        ];

    end

end

%% ==================================================
% Local Function 3: Rotation increment
%% ==================================================
function R_delta = rotation_increment(omega)

    theta = norm(omega);

    wx = [
         0        -omega(3)  omega(2);
         omega(3)  0        -omega(1);
        -omega(2)  omega(1)  0
    ];

    if theta<1e-10

        % 小角度展开，提高数值稳定性
        R_delta = eye(3)+wx+0.5*(wx*wx);

    else

        % Rodrigues公式
        R_delta = eye(3) + ...
            (sin(theta)/theta)*wx + ...
            ((1-cos(theta))/theta^2)*(wx*wx);

    end

end

%% ==================================================
% Local Function 4: Damped Gauss-Newton estimator
%% ==================================================
function result = solve_pose_from_lengths( ...
    A,r,L_meas,P0,R0,solver)

    % 估计器只接收：
    % A、r、L_meas、初始姿态和求解器参数。
    %
    % 注意：这里完全没有P_true或R_true。

    P = P0;
    R = R0;

    converged = false;
    iter_used = 0;

    for iter = 1:solver.max_iterations

        iter_used = iter;

        %% Current predicted measurement

        L_pred = cable_lengths(A,r,P,R);

        e = L_meas-L_pred;

        residual_norm = norm(e);

        if residual_norm < solver.residual_tol_mm

            converged = true;
            break;

        end

        %% Linearised measurement model

        H = cable_length_jacobian(A,r,P,R);

        Hs = H*solver.scale;

        % Damped Gauss-Newton step
        % 使用缩放变量避免位置和旋转单位差异
        lambda = solver.lambda;

        dy = (Hs'*Hs + lambda^2*eye(6)) \ ...
            (Hs'*e);

        % 恢复实际位姿增量
        dq = solver.scale*dy;

        dp = dq(1:3)';
        domega = dq(4:6)';

        %% Limit excessive update

        dp_norm = norm(dp);

        if dp_norm > solver.max_translation_step_mm

            dp = dp * ...
                solver.max_translation_step_mm/dp_norm;

        end

        w_norm = norm(domega);

        if w_norm > solver.max_rotation_step_rad

            domega = domega * ...
                solver.max_rotation_step_rad/w_norm;

        end

        %% Backtracking line search

        accepted = false;

        alpha = 1;

        for bt = 1:solver.max_backtracks

            P_trial = P+alpha*dp;

            R_trial = ...
                rotation_increment(alpha*domega)*R;

            L_trial = cable_lengths( ...
                A,r,P_trial,R_trial);

            trial_norm = norm(L_meas-L_trial);

            if trial_norm < residual_norm

                P = P_trial;
                R = R_trial;

                accepted = true;
                break;

            end

            alpha = alpha/2;

        end

        if ~accepted
            break;
        end
    end

    %% Final residual

    L_final = cable_lengths(A,r,P,R);

    final_residual = norm(L_meas-L_final);

    if final_residual < solver.residual_tol_mm
        converged = true;
    end

    %% Return result

    result = struct();

    result.P = P;
    result.R = R;

    result.converged = converged;
    result.iterations = iter_used;

    result.residual_norm = final_residual;

end
