
%% B5.4 E1b Lesson 1.7
% Four-Design Nonlinear Pose Estimation Pilot
%
% Research Question:
% 在相同Cable长度噪声下，
% 不同配置是否表现出不同的位姿估计误差？
%
% Design:
% 1. E1b Config 2 Candidate 2
% 2. E1b Config 4 Candidate 1
% 3. E1b Config 8 Candidate 16
% 4. E1a Config 12
%
% 使用相同12个Core姿态
% 每个位姿20次独立噪声
% Noise SD = 0.1 mm
%
% 注意：
% 本节为仿真，不代表真实硬件精度。

clear; clc; close all;

%% Step 1 — 加载优化结果

e1b = load( ...
    'B5_4_E1b_position_reoptimisation.mat');

e1a = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

P_all = base.P_all;
R_all = base.R_all;

rb = base.settings.rb;

assert(size(P_all,1)==189);

%% Step 2 — 提取四组固定配置

designs = cell(4,1);

Design = [ ...
    "E1b C2-2";
    "E1b C4-1";
    "E1b C8-16";
    "E1a C12"];

target_pairs = [ ...
    2 2;
    4 1;
    8 16];

for d = 1:3

    id = target_pairs(d,1);
    cid = target_pairs(d,2);

    idx = find( ...
        e1b.T_optimisation.ConfigID==id & ...
        e1b.T_optimisation.CandidateID==cid);

    assert(numel(idx)==1);
    assert(e1b.T_optimisation.FinalFeasible(idx));

    cfg = e1b.optimised_candidates{idx};

    designs{d} = struct( ...
        'A',cfg.A_final, ...
        'r',cfg.r);

end

% 原E1a Config 12
idx = find([e1a.results.config_id]==12);

assert(numel(idx)==1);

cfg = e1a.results(idx);

designs{4} = struct( ...
    'A',cfg.A_optimised, ...
    'r',cfg.r);

%% Step 3 — 统一姿态与噪声

pose_ids = unique(round( ...
    linspace(1,size(P_all,1),12)));

N_pose = numel(pose_ids);

N_repeat = 20;
N_design = numel(designs);

noise_sd_mm = 0.1;

% 固定随机种子，保证可复现
rng(42);

% 事先生成噪声
% 所有配置共用这些噪声数值
noise_samples = noise_sd_mm * ...
    randn(N_pose,6,N_repeat);

assert(N_pose==12);

%% Step 4 — 统一求解器参数

solver.max_iterations = 100;

solver.residual_tol_mm = 1e-8;

solver.lambda = 1e-4;

solver.max_backtracks = 20;

solver.max_dp = 20;

solver.max_dw = deg2rad(10);

solver.scale = diag( ...
    [1 1 1 1/rb 1/rb 1/rb]);

% 所有配置都从零姿态开始
P0 = [0 0 0];
R0 = eye(3);

%% Step 5 — 初始化结果

N_total = N_design*N_pose*N_repeat;

DesignID = zeros(N_total,1);
PoseID = zeros(N_total,1);
RepeatID = zeros(N_total,1);

Converged = false(N_total,1);

PositionError_mm = nan(N_total,1);
OrientationError_deg = nan(N_total,1);

ResidualNorm_mm = nan(N_total,1);

row = 0;

fprintf('\n--- E1b Pose Estimation Pilot ---\n');
fprintf('Designs: %d\n',N_design);
fprintf('Poses per design: %d\n',N_pose);
fprintf('Repeats: %d\n',N_repeat);
fprintf('Noise SD: %.3f mm\n',noise_sd_mm);

%% Step 6 — 对四组配置执行估计

for d = 1:N_design

    A = designs{d}.A;
    r = designs{d}.r;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    fprintf('\n%s\n',Design(d));

    for p = 1:N_pose

        pose_id = pose_ids(p);

        P_true = P_all(pose_id,:);
        R_true = R_all(:,:,pose_id);

        % 真实姿态只用于生成合成长度
        L_true = predict_lengths( ...
            A,r,P_true,R_true);

        for rep = 1:N_repeat

            noise = reshape( ...
                noise_samples(p,:,rep),6,1);

            L_meas = L_true+noise;

            % 求解器不接收真实位姿
            [P_est,R_est,success,residual] = ...
                solve_pose(A,r,L_meas,P0,R0,solver);

            %% 独立计算Position误差

            pe = norm(P_est-P_true);

            %% 独立计算Rotation误差

            Rerr = R_est*R_true';

            skew_part = Rerr-Rerr';

            sin_angle = norm([ ...
                skew_part(3,2), ...
                skew_part(1,3), ...
                skew_part(2,1)])/2;

            cos_angle = (trace(Rerr)-1)/2;

            re = atan2d(sin_angle,cos_angle);

            %% 保存结果，包含求解失败

            row = row+1;

            DesignID(row) = d;
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

%% Step 7 — 生成逐次估计表

T_trials = table( ...
    DesignID,PoseID,RepeatID, ...
    Converged,PositionError_mm, ...
    OrientationError_deg,ResidualNorm_mm);

%% Step 8 — 汇总四组性能

Tests = zeros(N_design,1);
ConvergedCount = zeros(N_design,1);

PositionRMSE_mm = nan(N_design,1);
OrientationRMSE_deg = nan(N_design,1);

MaxPositionError_mm = nan(N_design,1);
MaxOrientationError_deg = nan(N_design,1);

MedianResidual_mm = nan(N_design,1);

for d = 1:N_design

    mask = DesignID==d;

    Tests(d) = sum(mask);

    ConvergedCount(d) = ...
        sum(Converged(mask));

    pe = PositionError_mm(mask);
    re = OrientationError_deg(mask);

    % 计算RMSE时包含未收敛试验
    PositionRMSE_mm(d) = ...
        sqrt(mean(pe.^2));

    OrientationRMSE_deg(d) = ...
        sqrt(mean(re.^2));

    MaxPositionError_mm(d) = max(pe);
    MaxOrientationError_deg(d) = max(re);

    MedianResidual_mm(d) = ...
        median(ResidualNorm_mm(mask));

end

ConvergenceRate = ...
    100*ConvergedCount./Tests;

T_summary = table( ...
    Design,Tests,ConvergedCount, ...
    ConvergenceRate, ...
    PositionRMSE_mm,OrientationRMSE_deg, ...
    MaxPositionError_mm, ...
    MaxOrientationError_deg, ...
    MedianResidual_mm);

fprintf('\n====================================\n');
fprintf('E1b Pose Estimation Pilot Results\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 9 — 检查实验完整性

assert(N_total==960);

assert(all(Tests==240));

assert(all(isfinite(PositionError_mm)));
assert(all(isfinite(OrientationError_deg)));

assert(all(isfinite(ResidualNorm_mm)));

fprintf('\nTotal estimation trials: %d\n', ...
    N_total);

fprintf('Total converged: %d / %d\n', ...
    sum(Converged),N_total);

%% Step 10 — 绘制结果

figure('Color','w', ...
    'Name','E1b Pose Estimation Pilot', ...
    'Position',[100 100 1150 500]);

subplot(1,2,1);

bar(PositionRMSE_mm);

xticks(1:N_design);
xticklabels(Design);
xtickangle(25);

ylabel('Position RMSE (mm)');
title('Position Estimation Error');
grid on;

subplot(1,2,2);

bar(OrientationRMSE_deg);

xticks(1:N_design);
xticklabels(Design);
xtickangle(25);

ylabel('Orientation RMSE (deg)');
title('Orientation Estimation Error');
grid on;

%% Step 11 — 保存结果

save('B5_4_E1b_pose_estimation_pilot.mat', ...
    'T_summary','T_trials', ...
    'designs','Design', ...
    'pose_ids','noise_samples', ...
    'noise_sd_mm','N_repeat','solver');

writetable(T_summary, ...
    'B5_4_E1b_pose_estimation_pilot.csv');

fprintf('\nE1b Lesson 1.7 completed.\n');

%% =========================================
% Local Function 1 — Cable Length Prediction
%% =========================================

function L = predict_lengths(A,r,P,R)

    S = (R*r')';

    B = S+P;

    L = vecnorm(A-B,2,2);

end

%% =========================================
% Local Function 2 — Measurement Jacobian
%% =========================================

function H = length_jacobian(A,r,P,R)

    S = (R*r')';

    D = A-(S+P);

    L = vecnorm(D,2,2);

    assert(all(L>1e-12));

    u = D./L;

    H = zeros(6,6);

    for i = 1:6

        H(i,:) = [ ...
            -u(i,:), ...
            cross(u(i,:),S(i,:))];

    end

end

%% =========================================
% Local Function 3 — SO(3) Rotation Update
%% =========================================

function Rd = rotation_increment(w)

    theta = norm(w);

    W = [ ...
         0    -w(3)  w(2);
         w(3)  0    -w(1);
        -w(2)  w(1)  0];

    if theta<1e-10

        Rd = eye(3)+W+0.5*(W*W);

    else

        Rd = eye(3) + ...
            sin(theta)/theta*W + ...
            (1-cos(theta))/theta^2*(W*W);

    end

end

%% =========================================
% Local Function 4 — Damped Gauss-Newton
%% =========================================

function [P,R,success,final_residual] = ...
    solve_pose(A,r,L_meas,P0,R0,solver)

    P = P0;
    R = R0;

    success = false;

    for iter = 1:solver.max_iterations

        L_pred = predict_lengths(A,r,P,R);

        e = L_meas-L_pred;

        current_residual = norm(e);

        if current_residual < solver.residual_tol_mm

            success = true;
            break;

        end

        H = length_jacobian(A,r,P,R);

        Hs = H*solver.scale;

        dy = (Hs'*Hs + ...
            solver.lambda^2*eye(6)) \ (Hs'*e);

        dq = solver.scale*dy;

        dp = dq(1:3)';
        dw = dq(4:6)';

        %% Limit update

        np = norm(dp);

        if np>solver.max_dp
            dp = dp*solver.max_dp/np;
        end

        nw = norm(dw);

        if nw>solver.max_dw
            dw = dw*solver.max_dw/nw;
        end

        %% Backtracking line search

        alpha = 1;
        accepted = false;

        for bt = 1:solver.max_backtracks

            Pt = P+alpha*dp;

            Rt = rotation_increment( ...
                alpha*dw)*R;

            trial_e = L_meas - ...
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
