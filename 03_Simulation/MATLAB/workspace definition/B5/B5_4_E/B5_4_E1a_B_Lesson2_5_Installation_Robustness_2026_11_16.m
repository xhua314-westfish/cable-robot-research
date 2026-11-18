
%% B5.4 E1a-B Lesson 2.5
% Six-Configuration Installation Robustness
%
% Research Question:
% 六组优化配置对Anchor沿轨道的小位置误差有多敏感？
%
% 测试：
% 1. 每根Cable分别施加 +/-0.005 t偏差
% 2. 六根Cable共12种扰动
% 3. 六组配置共72个扰动案例
% 4. 每个合法案例评价539个开发位姿
%
% 固定：
% Rail IDs、Attachment和Pairing
%
% 注意：
% 本实验只评价，不进行优化或修复。
% +/-0.005是模拟扰动，不是真实制造公差。

clear; clc; close all;

%% Step 1 — 读取历史数据

opt = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

rob = load( ...
    'B5_4_E1a_B_539pose_robustness.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

folder_B54 = pwd;
folder_B53 = fullfile( ...
    fileparts(folder_B54),'B5_3');

rails = load(fullfile(folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

% 检查距离函数
assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

results = opt.results;
settings = base.settings;

P_eval = rob.P_eval;
R_eval = rob.R_eval;

N_config = numel(results);
N_pose = size(P_eval,1);

assert(N_config==6);
assert(N_pose==539);

%% Step 2 — 生成12个Anchor扰动

delta_t = 0.005;

perturbations = zeros(12,6);

ChangedCable = zeros(12,1);
Direction = zeros(12,1);

idx = 0;

for i = 1:6

    for sign_value = [-1 1]

        idx = idx+1;

        perturbations(idx,i) = ...
            sign_value*delta_t;

        ChangedCable(idx) = i;
        Direction(idx) = sign_value;

    end

end

assert(idx==12);

fprintf('\n--- E1a-B Installation Robustness ---\n');

fprintf('Configurations: %d\n',N_config);
fprintf('Development poses: %d\n',N_pose);
fprintf('Perturbations per Config: 12\n');
fprintf('Delta t: +/- %.4f\n',delta_t);

%% Step 3 — 初始化结果

ConfigID = [results.config_id]';

NominalPass = zeros(N_config,1);

PerturbationPass = zeros(N_config,1);
OffRailCount = zeros(N_config,1);

GeometryFailureCount = zeros(N_config,1);
ClearanceFailureCount = zeros(N_config,1);

MinPerturbedAngle_deg = nan(N_config,1);
MinPerturbedDistance_mm = nan(N_config,1);
WorstPerturbedSigma = nan(N_config,1);

perturbation_details = cell(N_config,1);

%% Step 4 — 循环六个Config

for c = 1:N_config

    cfg = results(c);

    t0 = cfg.t_optimised(:)';
    rail_ids = cfg.rail_ids(:)';

    r = cfg.r;

    % 读取上一节Nominal结果
    nominal = rob.T_robustness;

    row_id = find( ...
        nominal.ConfigID==cfg.config_id);

    assert(numel(row_id)==1);

    NominalPass(c) = ...
        nominal.GeometryPass(row_id);

    fprintf('\n============================\n');
    fprintf('Config %d\n',cfg.config_id);

    %% Step 4.1 — 创建12次扰动记录

    OffRail = false(12,1);

    GeometryPass = nan(12,1);
    RankPass = nan(12,1);

    MinAngle_deg = nan(12,1);
    MinDistance_mm = nan(12,1);
    WorstSigma = nan(12,1);

    FullPass = false(12,1);

    %% Step 4.2 — 逐个扰动评价

    for trial = 1:12

        % 基于原始优化结果施加误差
        % 不允许扰动累积
        t_trial = t0+perturbations(trial,:);

        cable_id = ChangedCable(trial);

        % 检查是否超出轨道范围
        if any(t_trial<0 | t_trial>1)

            OffRail(trial) = true;

            fprintf( ...
                'C%d %+d: OFF-RAIL\n', ...
                cable_id,Direction(trial));

            continue;

        end

        %% Step 4.3 — 重新构建Anchor坐标

        A = zeros(6,3);

        for i = 1:6

            rid = rail_ids(i);

            A(i,:) = ...
                rails.rail_start(rid,:) + ...
                t_trial(i)*( ...
                rails.rail_end(rid,:) - ...
                rails.rail_start(rid,:));

        end

        %% Step 4.4 — 评价539个位姿

        g = evaluate_perturbed_configuration( ...
            A,r,P_eval,R_eval,settings);

        GeometryPass(trial) = ...
            sum(g.geometry_safe);

        RankPass(trial) = sum( ...
            g.geometry_safe & ...
            g.rank_all==6);

        MinAngle_deg(trial) = ...
            min(g.angle_margin_deg(:));

        MinDistance_mm(trial) = ...
            min(g.distances(:));

        % 只有完整539-pose几何和Rank通过，
        % 才报告合格方案的WorstSigma
        if GeometryPass(trial)==N_pose && ...
                RankPass(trial)==N_pose

            WorstSigma(trial) = ...
                min(g.sigma_min_all);

        end

        % 同时检查上一节共同的Cable间距下限
        clearance_ok = ...
            MinDistance_mm(trial)>= ...
            opt.protocol.clearance_floor_mm-1e-8;

        FullPass(trial) = ...
            GeometryPass(trial)==N_pose && ...
            RankPass(trial)==N_pose && ...
            clearance_ok;

        fprintf([ ...
            'C%d %+d | Geometry %d/539 | ', ...
            'Angle %+8.4f deg | ', ...
            'Gap %.4f mm | FullPass %d\n'], ...
            cable_id,Direction(trial), ...
            GeometryPass(trial), ...
            MinAngle_deg(trial), ...
            MinDistance_mm(trial), ...
            FullPass(trial));

    end

    %% Step 4.5 — 汇总当前Config

    PerturbationPass(c) = sum(FullPass);

    OffRailCount(c) = sum(OffRail);

    % 仅统计合法Rail位置上的失效
    GeometryFailureCount(c) = sum( ...
        ~OffRail & ...
        GeometryPass<N_pose);

    ClearanceFailureCount(c) = sum( ...
        ~OffRail & ...
        MinDistance_mm< ...
        opt.protocol.clearance_floor_mm-1e-8);

    % 只对有计算结果的扰动取最小值
    valid = ~OffRail;

    if any(valid)

        MinPerturbedAngle_deg(c) = ...
            min(MinAngle_deg(valid));

        MinPerturbedDistance_mm(c) = ...
            min(MinDistance_mm(valid));

    end

    % 仅对完整合格的扰动报告WorstSigma
    if any(FullPass)

        WorstPerturbedSigma(c) = ...
            min(WorstSigma(FullPass));

    end

    %% Step 4.6 — 保存12次扰动的详细信息

    T_detail = table( ...
        ChangedCable,Direction, ...
        OffRail,GeometryPass,RankPass, ...
        MinAngle_deg,MinDistance_mm, ...
        WorstSigma,FullPass);

    perturbation_details{c} = T_detail;

    fprintf('\nPerturbation pass: %d / 12\n', ...
        PerturbationPass(c));

    fprintf('Off-rail count: %d / 12\n', ...
        OffRailCount(c));

    fprintf('Geometry failures: %d\n', ...
        GeometryFailureCount(c));

end

%% Step 5 — 生成六组总对比表

T_installation = table( ...
    ConfigID,NominalPass, ...
    PerturbationPass,OffRailCount, ...
    GeometryFailureCount, ...
    ClearanceFailureCount, ...
    MinPerturbedAngle_deg, ...
    MinPerturbedDistance_mm, ...
    WorstPerturbedSigma);

fprintf('\n====================================\n');
fprintf('Six-Config Installation Robustness\n');
fprintf('====================================\n');

disp(T_installation);

%% Step 6 — 输出存在问题的扰动

fprintf('\n--- Failed Perturbations ---\n');

for c = 1:N_config

    T = perturbation_details{c};

    failed = T(~T.FullPass,:);

    if ~isempty(failed)

        fprintf('\nConfig %d\n',ConfigID(c));
        disp(failed);

    end

end

%% Step 7 — 可视化

figure('Color','w', ...
    'Name','E1a-B Installation Robustness', ...
    'Position',[100 100 1100 480]);

subplot(1,2,1);

bar(ConfigID,PerturbationPass);

yline(12,'--k','Full pass');

xlabel('Configuration ID');
ylabel('Passing perturbations / 12');
title('Installation Robustness');

ylim([0 13]);
grid on;

subplot(1,2,2);

bar(ConfigID,MinPerturbedAngle_deg);

xlabel('Configuration ID');
ylabel('Minimum outward angle (deg)');
title('Worst Perturbed Outward Margin');

yline(0,'--k');
grid on;

%% Step 8 — 保存结果

save('B5_4_E1a_B_installation_robustness.mat', ...
    'T_installation', ...
    'perturbation_details', ...
    'perturbations','delta_t');

writetable(T_installation, ...
    'B5_4_E1a_B_installation_robustness.csv');

fprintf('\nInstallation robustness saved.\n');

%% ================================================
% Local Function
% 评价Anchor扰动后的539个姿态
%% ================================================

function g = evaluate_perturbed_configuration( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);
    rank_all = zeros(N,1);
    sigma_min_all = zeros(N,1);

    angle_margin_deg = zeros(N,6);
    distances = zeros(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        %% Cable geometry

        S = (R*r')';
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);

        assert(all(L>1e-9));

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_margin = outward_dot./ ...
            (settings.rb*L);

        sine_margin = max( ...
            -1,min(1,sine_margin));

        angle_margin_deg(k,:) = ...
            asind(sine_margin)';

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable

        cable_ok = true;

        for j = 1:size(pairs,1)

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

            distances(k,j) = dij;

            if dij<=settings.contact_tol

                cable_ok = false;

            end

        end

        geometry_safe(k) = ...
            sphere_ok && cable_ok;

        %% Sensing Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))];

        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        sigma_min_all(k) = sv(end);

        rank_all(k) = sum( ...
            sv>settings.rank_relative_tol*sv(1));

    end

    g.geometry_safe = geometry_safe;
    g.rank_all = rank_all;
    g.sigma_min_all = sigma_min_all;

    g.angle_margin_deg = angle_margin_deg;
    g.distances = distances;

end
