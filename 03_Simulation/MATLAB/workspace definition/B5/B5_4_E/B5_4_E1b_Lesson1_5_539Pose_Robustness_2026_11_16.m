
%% B5.4 E1b Lesson 1.5
% 539-Pose Robustness Screening
%
% Research Question:
% 22个Core合格的E1b配置能否通过539个开发位姿？
%
% 固定：
% Rail IDs、Rail Positions、Attachment、Pairing
%
% 本节不进行优化或修复。
% 使用此前保存的539个Development Poses。

clear; clc; close all;

%% Step 1 — 加载E1b优化结果

e1b = load( ...
    'B5_4_E1b_position_reoptimisation.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

% 加载之前使用过的539位姿集合
dev = load( ...
    'B5_4_E1a_C4_targeted_repair.mat', ...
    'P_eval','R_eval');

folder_B53 = fullfile( ...
    fileparts(pwd),'B5_3');

rails = load(fullfile(folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

settings = base.settings;

P_eval = dev.P_eval;
R_eval = dev.R_eval;

N_pose = size(P_eval,1);
assert(N_pose==539);

% 检查前189个与Core一致
assert(isequal( ...
    P_eval(1:189,:),base.P_all));

assert(isequal( ...
    R_eval(:,:,1:189),base.R_all));

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 选择Core合格候选

T_opt = e1b.T_optimisation;

selected_rows = find(T_opt.FinalFeasible);

N = numel(selected_rows);

assert(N==22);

fprintf('\n--- E1b 539-Pose Screening ---\n');
fprintf('Core-qualified candidates: %d\n',N);
fprintf('Development poses: %d\n',N_pose);

%% Step 3 — 初始化结果

ConfigID = zeros(N,1);
CandidateID = zeros(N,1);

GeometryPass = zeros(N,1);
RankPass = zeros(N,1);

WorstSigma = nan(N,1);
WorstKappa = nan(N,1);

MinAngle_deg = nan(N,1);
MinDistance_mm = nan(N,1);
MinRailEnd_mm = nan(N,1);

WeakestPose = zeros(N,1);
WeakestCable = zeros(N,1);

% 保存完整姿态评价记录
details = cell(N,1);

%% Step 4 — 评价全部22个候选

for j = 1:N

    row_id = selected_rows(j);

    cfg = e1b.optimised_candidates{row_id};

    ConfigID(j) = cfg.config_id;
    CandidateID(j) = cfg.candidate_id;

    A = cfg.A_final;
    r = cfg.r;

    rho = cfg.rail_ids(:)';
    t = cfg.t_final(:)';

    %% 4.1 检查Anchor仍在目标Rail上

    end_distance = zeros(6,1);

    for i = 1:6

        rid = rho(i);

        v = rails.rail_end(rid,:) - ...
            rails.rail_start(rid,:);

        expected_A = ...
            rails.rail_start(rid,:) + t(i)*v;

        assert(norm( ...
            A(i,:)-expected_A)<1e-8);

        % 计算距离最近Rail端点的距离
        end_distance(i) = ...
            min(t(i),1-t(i))*norm(v);

    end

    MinRailEnd_mm(j) = min(end_distance);

    %% 4.2 计算539个姿态

    g = evaluate_e1b_539( ...
        A,r,P_eval,R_eval,settings);

    details{j} = g;

    GeometryPass(j) = sum(g.geometry_safe);

    RankPass(j) = sum( ...
        g.geometry_safe & g.rank_all==6);

    % Minimum outward angle
    [MinAngle_deg(j),idx] = ...
        min(g.angle_margin_deg(:));

    [pose_id,cable_id] = ind2sub( ...
        size(g.angle_margin_deg),idx);

    WeakestPose(j) = pose_id;
    WeakestCable(j) = cable_id;

    MinDistance_mm(j) = ...
        min(g.distances(:));

    %% 4.3 Core回归检查

    assert(all(g.geometry_safe(1:189)));

    assert(all(g.rank_all(1:189)==6));

    sigma_core = min( ...
        g.sigma_min_all(1:189));

    assert(abs( ...
        sigma_core-cfg.final.sigma)<1e-8);

    %% 4.4 只有全部539通过，才排名Sensing

    if GeometryPass(j)==N_pose && ...
            RankPass(j)==N_pose

        WorstSigma(j) = ...
            min(g.sigma_min_all);

        WorstKappa(j) = ...
            max(g.kappa_all);

    end

    %% 4.5 显示当前候选结果

    fprintf('\nConfig %d | Candidate %d\n', ...
        ConfigID(j),CandidateID(j));

    fprintf('Geometry: %d / 539\n', ...
        GeometryPass(j));

    fprintf('Rank: %d / 539\n', ...
        RankPass(j));

    fprintf('Worst Sigma: %.6f\n', ...
        WorstSigma(j));

    fprintf('Minimum Angle: %.4f deg\n', ...
        MinAngle_deg(j));

    fprintf('Limiting Cable: C%d\n', ...
        WeakestCable(j));

    fprintf('Limiting Pose: %d\n', ...
        WeakestPose(j));

    fprintf('Minimum Distance: %.4f mm\n', ...
        MinDistance_mm(j));

    fprintf('Rail-End Distance: %.4f mm\n', ...
        MinRailEnd_mm(j));

end

%% Step 5 — 创建完整结果表

DevEligible = ...
    GeometryPass==N_pose & ...
    RankPass==N_pose;

T_robustness = table( ...
    ConfigID,CandidateID, ...
    GeometryPass,RankPass,DevEligible, ...
    WorstSigma,WorstKappa, ...
    MinAngle_deg,MinDistance_mm, ...
    MinRailEnd_mm, ...
    WeakestCable,WeakestPose);

fprintf('\n============================\n');
fprintf('E1b 539-Pose Robustness Results\n');
fprintf('============================\n');

disp(T_robustness);

%% Step 6 — 每个Config统计通过数量

IDs = unique(ConfigID,'stable');

N_family = numel(IDs);

CandidateCount = zeros(N_family,1);
DevPassCount = zeros(N_family,1);

BestCandidateID = nan(N_family,1);
BestSigma = nan(N_family,1);

for k = 1:N_family

    id = IDs(k);

    mask = ConfigID==id;

    CandidateCount(k) = sum(mask);

    DevPassCount(k) = sum( ...
        mask & DevEligible);

    % 只在539/539合格候选中选最高Sigma
    qualified = find( ...
        mask & DevEligible);

    if ~isempty(qualified)

        [best_sigma,pos] = max( ...
            WorstSigma(qualified));

        best_row = qualified(pos);

        BestCandidateID(k) = ...
            CandidateID(best_row);

        BestSigma(k) = best_sigma;

    end

end

T_summary = table( ...
    IDs,CandidateCount,DevPassCount, ...
    BestCandidateID,BestSigma, ...
    'VariableNames',{ ...
    'ConfigID','CoreCandidates', ...
    'DevPassCount','BestCandidateID', ...
    'Best539Sigma'});

fprintf('\n============================\n');
fprintf('E1b Development Screening Summary\n');
fprintf('============================\n');

disp(T_summary);

%% Step 7 — 数值一致性检查

assert(all(GeometryPass<=N_pose));
assert(all(RankPass<=GeometryPass));

assert(sum(CandidateCount)==22);

assert(sum(DevPassCount)<=22);

% 539集合包含Core，因此合格候选的
% Worst539Sigma不应高于WorstCoreSigma
for j = find(DevEligible)'

    row_id = selected_rows(j);

    core_sigma = ...
        e1b.optimised_candidates{row_id}.final.sigma;

    assert(WorstSigma(j)<=core_sigma+1e-8);

end

fprintf('\nTotal development-qualified: %d / 22\n', ...
    sum(DevEligible));

fprintf('PASS: Core regression verified.\n');

%% Step 8 — 保存结果

save('B5_4_E1b_539pose_robustness.mat', ...
    'T_robustness','T_summary', ...
    'details','selected_rows', ...
    'P_eval','R_eval');

writetable(T_robustness, ...
    'B5_4_E1b_539pose_robustness.csv');

writetable(T_summary, ...
    'B5_4_E1b_539pose_summary.csv');

fprintf('\nE1b Lesson 1.5 completed.\n');

%% ==========================================
% Local Function — Unified 539 Pose Evaluator
%% ==========================================

function g = evaluate_e1b_539( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);
    rank_all = zeros(N,1);

    sigma_min_all = zeros(N,1);
    kappa_all = zeros(N,1);

    angle_margin_deg = nan(N,6);
    distances = nan(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        %% Cable geometry

        S = (R*r')';
        B = S+P;

        D = A-B;
        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            continue;
        end

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

        for p = 1:size(pairs,1)

            i1 = pairs(p,1);
            i2 = pairs(p,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

            distances(k,p) = dij;

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
