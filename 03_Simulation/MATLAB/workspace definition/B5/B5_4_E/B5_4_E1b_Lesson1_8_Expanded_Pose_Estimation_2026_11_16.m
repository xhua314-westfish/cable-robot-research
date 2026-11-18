
%% B5.4 E1b Lesson 1.8
% Expanded Pose Estimation Comparison
%
% Research Question:
% C2-2在12个Core姿态中的估计优势，
% 能否在更广泛的开发位姿中继续保持？
%
% Designs:
% 1. E1b C2-2
% 2. E1b C4-1
% 3. E1b C8-16
% 4. E1a C12
%
% Test:
% 12 Core + 12 Off-grid A + 12 Off-grid B
% 每个位姿20次噪声重复
% Noise SD = 0.1 mm
%
% 本节不进行任何配置优化。
% 测试数据仍然属于Development，不是Holdout。

clear; clc; close all;

%% Step 1 — 加载现有数据

e1b = load( ...
    'B5_4_E1b_position_reoptimisation.mat');

e1a = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

dev = load( ...
    'B5_4_E1b_539pose_robustness.mat', ...
    'P_eval','R_eval');

P_all = dev.P_eval;
R_all = dev.R_eval;

rb = base.settings.rb;

assert(size(P_all,1)==539);
assert(isequal(size(R_all),[3 3 539]));

%% Step 2 — 提取四个对照设计

Design = [ ...
    "E1b C2-2";
    "E1b C4-1";
    "E1b C8-16";
    "E1a C12"];

N_design = numel(Design);

designs = cell(N_design,1);

target_pairs = [ ...
    2 2;
    4 1;
    8 16];

for d = 1:3

    config_id = target_pairs(d,1);
    candidate_id = target_pairs(d,2);

    idx = find( ...
        e1b.T_optimisation.ConfigID==config_id & ...
        e1b.T_optimisation.CandidateID==candidate_id);

    assert(numel(idx)==1);

    cfg = e1b.optimised_candidates{idx};

    designs{d} = struct( ...
        'A',cfg.A_final, ...
        'r',cfg.r);

end

% 添加原E1a Config 12
idx = find( ...
    [e1a.results.config_id]==12);

assert(numel(idx)==1);

cfg = e1a.results(idx);

designs{4} = struct( ...
    'A',cfg.A_optimised, ...
    'r',cfg.r);

%% Step 3 — 分层选择36个开发位姿

% Core:       1 - 189
% Off-grid A: 190 - 339
% Off-grid B: 340 - 539

core_ids = unique(round( ...
    linspace(1,189,12)));

offgrid_A_ids = unique(round( ...
    linspace(190,339,12)));

offgrid_B_ids = unique(round( ...
    linspace(340,539,12)));

pose_ids = [ ...
    core_ids, ...
    offgrid_A_ids, ...
    offgrid_B_ids];

assert(numel(core_ids)==12);
assert(numel(offgrid_A_ids)==12);
assert(numel(offgrid_B_ids)==12);

assert(numel(pose_ids)==36);

N_pose = numel(pose_ids);

%% Step 4 — 定义统一噪声

N_repeat = 20;
noise_sd_mm = 0.1;

rng(42);

% 同一个pose、repeat下，
% 四个Config共用相同的六维噪声。
noise_samples = noise_sd_mm* ...
    randn(N_pose,6,N_repeat);

%% Step 5 — 定义统一求解器

solver.max_iterations = 100;

solver.residual_tol_mm = 1e-8;

solver.lambda = 1e-4;

solver.max_backtracks = 20;

solver.max_dp = 20;

solver.max_dw = deg2rad(10);

solver.scale = diag( ...
    [1 1 1 1/rb 1/rb 1/rb]);

P0 = [0 0 0];
R0 = eye(3);

%% Step 6 — 初始化结果

N_total = N_design*N_pose*N_repeat;

DesignID = zeros(N_total,1);
PoseID = zeros(N_total,1);
RepeatID = zeros(N_total,1);

Converged = false(N_total,1);

PositionError_mm = nan(N_total,1);
OrientationError_deg = nan(N_total,1);
ResidualNorm_mm = nan(N_total,1);

row = 0;

fprintf('\n--- E1b Expanded Pose Estimation ---\n');

fprintf('Designs: %d\n',N_design);
fprintf('Pose samples: %d\n',N_pose);
fprintf('Repeats per pose: %d\n',N_repeat);
fprintf('Noise SD: %.3f mm\n',noise_sd_mm);

%% Step 7 — 执行全部估计

for d = 1:N_design

    A = designs{d}.A;
    r = designs{d}.r;

    fprintf('\n%s\n',Design(d));

    for p = 1:N_pose

        pose_id = pose_ids(p);

        P_true = P_all(pose_id,:);
        R_true = R_all(:,:,pose_id);

        % Ground truth只用于生成模拟测量
        L_true = predict_lengths( ...
            A,r,P_true,R_true);

        for rep = 1:N_repeat

            noise = reshape( ...
                noise_samples(p,:,rep),6,1);

            L_meas = L_true+noise;

            [P_est,R_est,success,residual] = ...
                solve_pose( ...
                A,r,L_meas,P0,R0,solver);

            % 独立计算Position误差
            pe = norm(P_est-P_true);

            % 独立计算Rotation误差
            Rerr = R_est*R_true';

            skew_part = Rerr-Rerr';

            sin_angle = norm([ ...
                skew_part(3,2), ...
                skew_part(1,3), ...
                skew_part(2,1)])/2;

            cos_angle = (trace(Rerr)-1)/2;

            re = atan2d(sin_angle,cos_angle);

            % 不因求解失败而删除试验
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

%% Step 8 — 保存逐次误差

T_trials = table( ...
    DesignID,PoseID,RepeatID, ...
    Converged, ...
    PositionError_mm, ...
    OrientationError_deg, ...
    ResidualNorm_mm);

%% Step 9 — 计算每组统计量

Tests = zeros(N_design,1);
ConvergedCount = zeros(N_design,1);

PositionRMSE_mm = nan(N_design,1);
OrientationRMSE_deg = nan(N_design,1);

P95Position_mm = nan(N_design,1);
P95Orientation_deg = nan(N_design,1);

MaxPosition_mm = nan(N_design,1);
MaxOrientation_deg = nan(N_design,1);

MedianResidual_mm = nan(N_design,1);

for d = 1:N_design

    mask = DesignID==d;

    pe = PositionError_mm(mask);
    re = OrientationError_deg(mask);

    Tests(d) = numel(pe);

    ConvergedCount(d) = sum(Converged(mask));

    % 所有试验都计入RMSE
    PositionRMSE_mm(d) = ...
        sqrt(mean(pe.^2));

    OrientationRMSE_deg(d) = ...
        sqrt(mean(re.^2));

    % 通过排序计算经验95百分位
    pe_sorted = sort(pe);
    re_sorted = sort(re);

    percentile_index = ceil(0.95*numel(pe));

    P95Position_mm(d) = ...
        pe_sorted(percentile_index);

    P95Orientation_deg(d) = ...
        re_sorted(percentile_index);

    MaxPosition_mm(d) = max(pe);
    MaxOrientation_deg(d) = max(re);

    MedianResidual_mm(d) = ...
        median(ResidualNorm_mm(mask));

end

ConvergenceRate = ...
    100*ConvergedCount./Tests;

T_summary = table( ...
    Design,Tests,ConvergedCount, ...
    ConvergenceRate, ...
    PositionRMSE_mm, ...
    OrientationRMSE_deg, ...
    P95Position_mm, ...
    P95Orientation_deg, ...
    MaxPosition_mm, ...
    MaxOrientation_deg, ...
    MedianResidual_mm);

fprintf('\n====================================\n');
fprintf('E1b Expanded Estimation Results\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 10 — 对三个姿态子集分别比较

Subset = strings(3*N_design,1);
SubsetDesign = strings(3*N_design,1);

SubsetPositionRMSE = nan(3*N_design,1);
SubsetOrientationRMSE = nan(3*N_design,1);

subset_names = [ ...
    "Core";
    "Off-grid A";
    "Off-grid B"];

subset_ids = { ...
    core_ids, ...
    offgrid_A_ids, ...
    offgrid_B_ids};

row_subset = 0;

for d = 1:N_design

    for s = 1:3

        mask = ...
            DesignID==d & ...
            ismember(PoseID,subset_ids{s});

        pe = PositionError_mm(mask);
        re = OrientationError_deg(mask);

        assert(numel(pe)==12*N_repeat);

        row_subset = row_subset+1;

        Subset(row_subset) = subset_names(s);
        SubsetDesign(row_subset) = Design(d);

        SubsetPositionRMSE(row_subset) = ...
            sqrt(mean(pe.^2));

        SubsetOrientationRMSE(row_subset) = ...
            sqrt(mean(re.^2));

    end
end

T_subsets = table( ...
    SubsetDesign,Subset, ...
    SubsetPositionRMSE, ...
    SubsetOrientationRMSE);

fprintf('\n--- Results by Pose Subset ---\n');

disp(T_subsets);

%% Step 11 — 检查实验完整性

assert(N_total==2880);
assert(all(Tests==720));

assert(all(isfinite(PositionError_mm)));
assert(all(isfinite(OrientationError_deg)));
assert(all(isfinite(ResidualNorm_mm)));

fprintf('\nTotal trials: %d\n',N_total);

fprintf('Total converged: %d / %d\n', ...
    sum(Converged),N_total);

fprintf('All estimation records verified.\n');

%% Step 12 — 可视化

figure('Color','w', ...
    'Name','E1b Expanded Pose Estimation', ...
    'Position',[100 100 1150 480]);

subplot(1,2,1);

bar(PositionRMSE_mm);

xticks(1:N_design);
xticklabels(Design);
xtickangle(25);

ylabel('Position RMSE (mm)');
title('Expanded Position RMSE');
grid on;

subplot(1,2,2);

bar(OrientationRMSE_deg);

xticks(1:N_design);
xticklabels(Design);
xtickangle(25);

ylabel('Orientation RMSE (deg)');
title('Expanded Orientation RMSE');
grid on;

%% Step 13 — 保存

save( ...
    'B5_4_E1b_expanded_pose_estimation.mat', ...
    'T_summary','T_subsets', ...
    'T_trials','Design','designs', ...
    'pose_ids','subset_ids', ...
    'noise_samples','noise_sd_mm', ...
    'solver','N_repeat');

writetable(T_summary, ...
    'B5_4_E1b_expanded_pose_estimation.csv');

writetable(T_subsets, ...
    'B5_4_E1b_estimation_subsets.csv');

fprintf('\nE1b Lesson 1.8 completed.\n');

%% ======================================
% Local Function 1 — Cable length model
%% ======================================

function L = predict_lengths(A,r,P,R)

    S = (R*r')';
    B = S+P;

    L = vecnorm(A-B,2,2);

end

%% ======================================
% Local Function 2 — Jacobian
%% ======================================

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

%% ======================================
% Local Function 3 — Rotation increment
%% ======================================

function Rd = rotation_increment(w)

    theta = norm(w);

    W = [ ...
        0 -w(3) w(2);
        w(3) 0 -w(1);
        -w(2) w(1) 0];

    if theta<1e-10

        Rd = eye(3)+W+0.5*(W*W);

    else

        Rd = eye(3) + ...
            sin(theta)/theta*W + ...
            (1-cos(theta))/theta^2*(W*W);

    end

end

%% ======================================
% Local Function 4 — Pose estimation
%% ======================================

function [P,R,success,final_residual] = ...
    solve_pose(A,r,L_meas,P0,R0,solver)

    P = P0;
    R = R0;

    success = false;

    for iter = 1:solver.max_iterations

        L_pred = predict_lengths(A,r,P,R);

        e = L_meas-L_pred;

        current_residual = norm(e);

        if current_residual<solver.residual_tol_mm

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

        %% Limit step

        np = norm(dp);
        nw = norm(dw);

        if np>solver.max_dp

            dp = dp*solver.max_dp/np;

        end

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

            trial_error = ...
                L_meas-predict_lengths(A,r,Pt,Rt);

            if norm(trial_error)<current_residual

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
