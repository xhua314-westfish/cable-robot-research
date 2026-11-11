
%% B5.4 Lesson 2.1
% Noise Sensitivity of Six-Cable Pose Estimation
%
% Research Question:
% How does identical cable-length noise affect
% pose reconstruction across six configurations?
%
% 本实验是仿真，不是硬件精度标定。
% 所有配置使用相同的随机噪声样本。
%
% Position: mm
% Rotation: rad
% Orientation error: deg

clear; clc; close all;
rng(42);

%% Step 1: Load existing configurations

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','eligibility_set', ...
    'P_all','R_all','settings');

config_ids = eligibility_set(:)';
rb = settings.rb;

assert(isequal(config_ids,[2 4 6 8 12 17]));

% 与上一节使用完全相同的12个姿态
pose_ids = unique(round( ...
    linspace(1,size(P_all,1),12)));

N_config = numel(config_ids);
N_pose = numel(pose_ids);

%% Step 2: Define simulation conditions

% 假设的长度噪声标准差（不是实测）
noise_sd_mm = 0.1;

% 每个姿态重复30次
N_repeat = 30;

% 固定随机种子，并且提前生成所有噪声
% 同一组Pose和Repeat对应同一六维噪声向量
% 不随Configuration改变
noise_samples = noise_sd_mm * ...
    randn(N_pose,6,N_repeat);

% 记录求解器设置
solver.max_iterations = 100;
solver.residual_tol_mm = 1e-8;
solver.lambda = 1e-4;
solver.max_backtracks = 20;
solver.max_dp = 20;
solver.max_dw = deg2rad(10);
solver.scale = diag([1 1 1 1/rb 1/rb 1/rb]);

%% Step 3: Prepare result arrays

N_total = N_config*N_pose*N_repeat;

ConfigID = zeros(N_total,1);
PoseID = zeros(N_total,1);
RepeatID = zeros(N_total,1);

Converged = false(N_total,1);

PositionError_mm = nan(N_total,1);
OrientationError_deg = nan(N_total,1);
ResidualNorm_mm = nan(N_total,1);

row = 0;

%% Step 4: Run Monte Carlo simulation

for c = 1:N_config

    id = config_ids(c);

    A = best_configs(id).A;
    r = best_configs(id).r;

    fprintf('\nConfig %d\n',id);

    for p = 1:N_pose

        pose_id = pose_ids(p);

        % 真实姿态仅用于生成测量和最终评估
        P_true = P_all(pose_id,:);
        R_true = R_all(:,:,pose_id);

        % 无噪声真实Cable Length
        L_true = predict_lengths(A,r,P_true,R_true);

        for rep = 1:N_repeat

            % 加入同一组随机噪声
            noise = reshape( ...
                noise_samples(p,:,rep),6,1);

            L_meas = L_true + noise;

            % 求解器不能访问真实姿态
            [P_est,R_est,success,residual] = ...
                estimate_pose(A,r,L_meas,solver);

            % 独立计算位置误差
            pe = norm(P_est-P_true);

            % 旋转误差：稳定的atan2形式
            % 避免微小角度下acos(trace)的精度问题
            Rerr = R_est*R_true';

            skew_part = Rerr-Rerr';

            sin_angle = norm([ ...
                skew_part(3,2), ...
                skew_part(1,3), ...
                skew_part(2,1) ])/2;

            cos_angle = ...
                (trace(Rerr)-1)/2;

            re = atan2d(sin_angle,cos_angle);

            % 保存所有测试，包括失败结果
            row = row+1;

            ConfigID(row) = id;
            PoseID(row) = pose_id;
            RepeatID(row) = rep;

            Converged(row) = success;
            PositionError_mm(row) = pe;
            OrientationError_deg(row) = re;
            ResidualNorm_mm(row) = residual;

        end
    end
end

assert(row==N_total);

%% Step 5: Summarise each configuration
%
% 将所有重复实验纳入统计。
% 不能只挑选成功或误差较小的试验。

PositionRMSE_mm = zeros(N_config,1);
OrientationRMSE_deg = zeros(N_config,1);

MaxPositionError_mm = zeros(N_config,1);
MaxOrientationError_deg = zeros(N_config,1);

ConvergedCount = zeros(N_config,1);
MaxResidual_mm = zeros(N_config,1);

for c = 1:N_config

    id = config_ids(c);
    mask = ConfigID==id;

    pe = PositionError_mm(mask);
    re = OrientationError_deg(mask);

    PositionRMSE_mm(c) = sqrt(mean(pe.^2));
    OrientationRMSE_deg(c) = sqrt(mean(re.^2));

    MaxPositionError_mm(c) = max(pe);
    MaxOrientationError_deg(c) = max(re);

    ConvergedCount(c) = sum(Converged(mask));
    MaxResidual_mm(c) = max(ResidualNorm_mm(mask));

end

T_noise = table( ...
    config_ids(:),ConvergedCount, ...
    PositionRMSE_mm,OrientationRMSE_deg, ...
    MaxPositionError_mm, ...
    MaxOrientationError_deg,MaxResidual_mm, ...
    'VariableNames', ...
    {'ConfigID','ConvergedCount', ...
     'PositionRMSE_mm','OrientationRMSE_deg', ...
     'MaxPositionError_mm', ...
     'MaxOrientationError_deg','MaxResidual_mm'});

disp(' ');
disp('--- B5.4 Noise Sensitivity Results ---');
disp(T_noise);

fprintf('Noise SD: %.3f mm (assumed)\n',noise_sd_mm);
fprintf('Total tests: %d\n',N_total);
fprintf('Converged: %d / %d\n',sum(Converged),N_total);

%% Step 6: Plot comparison

figure('Color','w', ...
    'Name','B5.4 Noise Sensitivity', ...
    'Position',[100 100 1200 500]);

subplot(1,2,1);

bar(config_ids,PositionRMSE_mm);
xticks(config_ids);

xlabel('Configuration ID');
ylabel('Position RMSE (mm)');
title('Position Error with Length Noise');
grid on;

subplot(1,2,2);

bar(config_ids,OrientationRMSE_deg);
xticks(config_ids);

xlabel('Configuration ID');
ylabel('Orientation RMSE (deg)');
title('Orientation Error with Length Noise');
grid on;

%% Step 7: Save results

save('B5_4_noise_sensitivity_baseline.mat', ...
    'T_noise','ConfigID','PoseID','RepeatID', ...
    'Converged','PositionError_mm', ...
    'OrientationError_deg','ResidualNorm_mm', ...
    'noise_sd_mm','noise_samples', ...
    'config_ids','pose_ids','solver');

fprintf('\nB5.4 Lesson 2.1 completed.\n');

%% =========================================
% Local function: Predict Cable Lengths
%% =========================================
function L = predict_lengths(A,r,P,R)

    S = (R*r')';
    B = S+P;
    L = vecnorm(A-B,2,2);

end

%% =========================================
% Local function: Cable Length Jacobian
%% =========================================
function H = calculate_jacobian(A,r,P,R)

    S = (R*r')';
    D = A-(S+P);
    L = vecnorm(D,2,2);

    u = D./L;

    H = zeros(6,6);

    for i = 1:6
        H(i,:) = [ ...
            -u(i,:),cross(u(i,:),S(i,:))];
    end

end

%% =========================================
% Local function: SO(3) rotation update
%% =========================================
function Rd = rotation_step(w)

    theta = norm(w);

    W = [
         0    -w(3)  w(2);
         w(3)  0    -w(1);
        -w(2)  w(1)  0
    ];

    if theta<1e-10
        Rd = eye(3)+W+0.5*W*W;
    else
        Rd = eye(3) + ...
            sin(theta)/theta*W + ...
            (1-cos(theta))/theta^2*(W*W);
    end

end

%% =========================================
% Local function: Damped Gauss-Newton
%% =========================================
function [P,R,success,final_residual] = ...
    estimate_pose(A,r,L_meas,solver)

    P = [0 0 0];
    R = eye(3);

    success = false;

    for iter = 1:solver.max_iterations

        L_pred = predict_lengths(A,r,P,R);
        e = L_meas-L_pred;

        current_residual = norm(e);

        if current_residual<solver.residual_tol_mm
            success = true;
            break;
        end

        H = calculate_jacobian(A,r,P,R);
        Hs = H*solver.scale;

        % 求解归一化增量
        dy = (Hs'*Hs + ...
            solver.lambda^2*eye(6)) \ (Hs'*e);

        dq = solver.scale*dy;

        dp = dq(1:3)';
        dw = dq(4:6)';

        % 限制步长
        np = norm(dp);
        nw = norm(dw);

        if np>solver.max_dp
            dp = dp*solver.max_dp/np;
        end

        if nw>solver.max_dw
            dw = dw*solver.max_dw/nw;
        end

        % 回溯线搜索
        alpha = 1;
        accepted = false;

        for bt = 1:solver.max_backtracks

            Pt = P+alpha*dp;
            Rt = rotation_step(alpha*dw)*R;

            trial_e = L_meas- ...
                predict_lengths(A,r,Pt,Rt);

            if norm(trial_e)<current_residual

                P = Pt;
                R = Rt;
                accepted = true;
                break;

            end

            alpha = alpha/2;

        end

        if ~accepted
            break;
        end

    end

    final_residual = norm( ...
        L_meas-predict_lengths(A,r,P,R));

    if final_residual<solver.residual_tol_mm
        success = true;
    end

end
