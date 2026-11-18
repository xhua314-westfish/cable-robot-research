
%% B5.4 E1a-B Lesson 2.4
% Six-Configuration Off-Grid Robustness Screening
%
% 研究问题：
% 六组优化配置是否仍能通过539个开发位姿？
%
% 本节只进行评价，不改变任何优化变量。
%
% 检查：
% 1. Geometry + Rank
% 2. Worst scaled sigma_min
% 3. Minimum Cable Distance
% 4. Minimum Outward Angle
% 5. Minimum Rail-End Distance

clear; clc; close all;

%% Step 1 — 加载数据

opt = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

% 读取此前已保存的539个开发位姿
dev = load( ...
    'B5_4_E1a_C4_targeted_repair.mat', ...
    'P_eval','R_eval');

folder_B53 = fullfile( ...
    fileparts(pwd),'B5_3');

rails = load(fullfile( ...
    folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

% 使用B5.4目录下已有的距离函数
assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

results = opt.results;
settings = base.settings;

P_eval = dev.P_eval;
R_eval = dev.R_eval;

N_pose = size(P_eval,1);

assert(N_pose==539);
assert(isequal(size(R_eval),[3 3 539]));

% 确认539集合前189个就是Core
assert(isequal( ...
    P_eval(1:189,:),base.P_all));

assert(isequal( ...
    R_eval(:,:,1:189),base.R_all));

fprintf('\n--- E1a-B Robustness ---\n');
fprintf('Configs: %d\n',numel(results));
fprintf('Development poses: %d\n',N_pose);

%% Step 2 — 准备结果

N_config = numel(results);

ConfigID = zeros(N_config,1);
GeometryPass = zeros(N_config,1);
RankPass = zeros(N_config,1);

WorstSigma = nan(N_config,1);
WorstKappa = nan(N_config,1);

MinAngle_deg = zeros(N_config,1);
MinDistance_mm = zeros(N_config,1);

MinRailEnd_mm = zeros(N_config,1);

WeakestCable = zeros(N_config,1);
WeakestPose = zeros(N_config,1);

% 保留每个位姿的完整结果
details = cell(N_config,1);

%% Step 3 — 评价六个配置

for c = 1:N_config

    cfg = results(c);

    ConfigID(c) = cfg.config_id;

    % 不重新优化，直接使用已保存Anchor
    A = cfg.A_optimised;
    r = cfg.r;

    % 记录当前t及固定Rail IDs
    t = cfg.t_optimised;
    rail_ids = cfg.rail_ids;

    %% 3.1 检查轨道坐标一致性

    end_distances = zeros(6,1);

    for i = 1:6

        rid = rail_ids(i);

        rail_vector = ...
            rails.rail_end(rid,:) - ...
            rails.rail_start(rid,:);

        A_check = rails.rail_start(rid,:) + ...
            t(i)*rail_vector;

        assert(norm( ...
            A(i,:)-A_check)<1e-8);

        rail_length = norm(rail_vector);

        % 到最近Rail端点的实际距离
        end_distances(i) = ...
            min(t(i),1-t(i))*rail_length;

    end

    MinRailEnd_mm(c) = ...
        min(end_distances);

    %% 3.2 评价539个位姿

    g = evaluate_robustness( ...
        A,r,P_eval,R_eval,settings);

    details{c} = g;

    GeometryPass(c) = ...
        sum(g.geometry_safe);

    RankPass(c) = sum( ...
        g.geometry_safe & g.rank_all==6);

    MinDistance_mm(c) = ...
        min(g.distances(:));

    [MinAngle_deg(c),idx] = ...
        min(g.angle_margin_deg(:));

    [pose_id,cable_id] = ind2sub( ...
        size(g.angle_margin_deg),idx);

    WeakestPose(c) = pose_id;
    WeakestCable(c) = cable_id;

    % 只有全部539姿态通过，才计算
    % 用于公平排名的worst sigma
    if GeometryPass(c)==539 && ...
            RankPass(c)==539

        WorstSigma(c) = ...
            min(g.sigma_min_all);

        WorstKappa(c) = ...
            max(g.kappa_all);

    end

    %% 3.3 显示每个Config的结果

    fprintf('\nConfig %d\n',ConfigID(c));

    fprintf('Geometry: %d / 539\n', ...
        GeometryPass(c));

    fprintf('Rank-6: %d / 539\n', ...
        RankPass(c));

    fprintf('Worst sigma: %.6f\n', ...
        WorstSigma(c));

    fprintf('Minimum angle: %.4f deg\n', ...
        MinAngle_deg(c));

    fprintf('Limiting Cable: C%d\n', ...
        WeakestCable(c));

    fprintf('Limiting Pose: %d\n', ...
        WeakestPose(c));

    fprintf('Minimum cable distance: %.4f mm\n', ...
        MinDistance_mm(c));

    fprintf('Minimum rail-end distance: %.4f mm\n', ...
        MinRailEnd_mm(c));

end

%% Step 4 — 生成对比表

T_robustness = table( ...
    ConfigID,GeometryPass,RankPass, ...
    WorstSigma,WorstKappa, ...
    MinAngle_deg,MinDistance_mm, ...
    MinRailEnd_mm, ...
    WeakestCable,WeakestPose);

fprintf('\n--- Six-Config Robustness Results ---\n');

disp(T_robustness);

%% Step 5 — 核对原始Core评价结果

for c = 1:N_config

    % 当前539数据中的前189姿态
    g = details{c};

    assert(all(g.geometry_safe(1:189)));
    assert(all(g.rank_all(1:189)==6));

    sigma_core = min( ...
        g.sigma_min_all(1:189));

    % 应复现上一节公平优化的结果
    assert(abs( ...
        sigma_core-results(c).sigma_optimised) ...
        <1e-8);

end

fprintf('\nPASS: Core 189 regression verified.\n');

%% Step 6 — 保存结果

save('B5_4_E1a_B_539pose_robustness.mat', ...
    'T_robustness','details', ...
    'P_eval','R_eval');

writetable(T_robustness, ...
    'B5_4_E1a_B_539pose_robustness.csv');

fprintf('Robustness results saved.\n');

%% ================================================
% Local Function — Unified Robustness Evaluation
%% ================================================

function g = evaluate_robustness( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);
    rank_all = zeros(N,1);

    sigma_min_all = zeros(N,1);
    kappa_all = zeros(N,1);

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

        %% Cable-Sphere check

        outward_dot = sum(S.*D,2);

        sine_margin = outward_dot./ ...
            (settings.rb*L);

        % 防止浮点误差造成asind非法
        sine_margin = max( ...
            -1,min(1,sine_margin));

        angle_margin_deg(k,:) = ...
            asind(sine_margin)';

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable check

        cable_ok = true;

        for j = 1:15

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

        if sv(end)>0
            kappa_all(k) = sv(1)/sv(end);
        else
            kappa_all(k) = inf;
        end

    end

    g.geometry_safe = geometry_safe;
    g.rank_all = rank_all;

    g.sigma_min_all = sigma_min_all;
    g.kappa_all = kappa_all;

    g.angle_margin_deg = angle_margin_deg;
    g.distances = distances;

end
