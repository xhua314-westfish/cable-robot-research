
%% B5.4 E1b Lesson 1.6
% Installation Robustness and Shortlist Comparison
%
% Research Question:
% 哪些E1b候选能在小安装扰动下维持几何和测量性能？
%
% 六个设计：
% E1b C2-2, C4-10, C4-1, C6-3, C8-16
% E1a Config 12 (历史稳健性对照)
%
% 扰动：每根Anchor分别 +/-0.005
% 每个设计12种扰动，共72种
% 合法扰动全部评价539个Development Poses
%
% 本节不优化，不改变原始设计。

clear; clc; close all;

%% Step 1 — 读取实验数据

e1b = load( ...
    'B5_4_E1b_position_reoptimisation.mat');

rob = load( ...
    'B5_4_E1b_539pose_robustness.mat');

e1a = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

prot = load( ...
    'B5_4_E1a_B_optimisation_protocol.mat');

folder_B53 = fullfile(fileparts(pwd),'B5_3');

rails = load(fullfile(folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

settings = base.settings;

P_eval = rob.P_eval;
R_eval = rob.R_eval;

N_pose = size(P_eval,1);
assert(N_pose==539);

clearance_floor = ...
    prot.protocol.clearance_floor_mm;

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 统一纠正539位姿的Clearance判定

T_dev = rob.T_robustness;

DevFullEligible = ...
    T_dev.GeometryPass==539 & ...
    T_dev.RankPass==539 & ...
    T_dev.MinDistance_mm>=clearance_floor-1e-8;

assert(sum(DevFullEligible)==16);

fprintf('\n--- Unified Development Eligibility ---\n');

fprintf('Geometry + Rank: %d / 22\n', ...
    sum(T_dev.DevEligible));

fprintf('Geometry + Rank + Clearance: %d / 22\n', ...
    sum(DevFullEligible));

%% Step 3 — 选择六个对照设计

target_pairs = [ ...
     2  2;
     4 10;
     4  1;
     6  3;
     8 16];

N_e1b = size(target_pairs,1);
N_design = N_e1b+1;

designs = cell(N_design,1);

Design = strings(N_design,1);

for j = 1:N_e1b

    id = target_pairs(j,1);
    cid = target_pairs(j,2);

    % 从E1b优化表中找到准确的设计
    match = find( ...
        e1b.T_optimisation.ConfigID==id & ...
        e1b.T_optimisation.CandidateID==cid);

    assert(numel(match)==1);

    cfg = e1b.optimised_candidates{match};

    designs{j} = struct( ...
        'rail_ids',cfg.rail_ids, ...
        't',cfg.t_final, ...
        'r',cfg.r);

    Design(j) = sprintf('E1b C%d-%d',id,cid);

    % 保证该候选已经通过539完整约束
    idx = find( ...
        T_dev.ConfigID==id & ...
        T_dev.CandidateID==cid);

    assert(numel(idx)==1);
    assert(DevFullEligible(idx));

end

% 添加E1a原始Config 12作为对照
idx12 = find( ...
    [e1a.results.config_id]==12);

assert(numel(idx12)==1);

c12 = e1a.results(idx12);

designs{N_design} = struct( ...
    'rail_ids',c12.rail_ids, ...
    't',c12.t_optimised, ...
    'r',c12.r);

Design(N_design) = "E1a C12";

%% Step 4 — 定义12个安装扰动

delta_t = 0.005;

perturbations = zeros(12,6);

ChangedCable = zeros(12,1);
Direction = zeros(12,1);

n = 0;

for cable_id = 1:6

    for sign_value = [-1 1]

        n = n+1;

        perturbations(n,cable_id) = ...
            sign_value*delta_t;

        ChangedCable(n) = cable_id;
        Direction(n) = sign_value;

    end

end

assert(n==12);

%% Step 5 — 初始化结果

NominalGeometry = zeros(N_design,1);
NominalSigma = nan(N_design,1);

NominalAngle = nan(N_design,1);
NominalDistance = nan(N_design,1);

MinRailEnd_mm = nan(N_design,1);

PerturbationPass = zeros(N_design,1);

OffRailCount = zeros(N_design,1);
GeometryFailureCount = zeros(N_design,1);
ClearanceFailureCount = zeros(N_design,1);

WorstPerturbedAngle = nan(N_design,1);
WorstPerturbedDistance = nan(N_design,1);
WorstPassingSigma = nan(N_design,1);

details = cell(N_design,1);

%% Step 6 — 对六个设计逐个验证

for d = 1:N_design

    cfg = designs{d};

    rho = cfg.rail_ids(:)';
    t0 = cfg.t(:)';
    r = cfg.r;

    % 记录轨道长度和到端点距离
    rail_end_distance = zeros(6,1);

    for i = 1:6

        rid = rho(i);

        L_rail = norm( ...
            rails.rail_end(rid,:) - ...
            rails.rail_start(rid,:));

        rail_end_distance(i) = ...
            min(t0(i),1-t0(i))*L_rail;

    end

    MinRailEnd_mm(d) = ...
        min(rail_end_distance);

    %% 6.1 名义配置重新评价

    A0 = build_anchors( ...
        t0,rho,rails.rail_start,rails.rail_end);

    nominal = evaluate_design( ...
        A0,r,P_eval,R_eval,settings);

    NominalGeometry(d) = nominal.geometry_pass;

    NominalAngle(d) = nominal.min_angle;
    NominalDistance(d) = nominal.min_distance;

    % 名义配置必须满足完整的539约束
    nominal_ok = ...
        nominal.geometry_pass==539 && ...
        nominal.rank_pass==539 && ...
        nominal.min_distance>=clearance_floor-1e-8;

    assert(nominal_ok, ...
        'Nominal design did not pass all constraints');

    NominalSigma(d) = nominal.worst_sigma;

    %% 6.2 逐根施加安装扰动

    OffRail = false(12,1);
    GeometryPass = nan(12,1);
    RankPass = nan(12,1);

    MinAngle_deg = nan(12,1);
    MinDistance_mm = nan(12,1);
    WorstSigma = nan(12,1);

    FullPass = false(12,1);

    fprintf('\n============================\n');
    fprintf('%s\n',Design(d));

    for j = 1:12

        t_trial = t0+perturbations(j,:);

        if any(t_trial<0 | t_trial>1)

            OffRail(j) = true;

            fprintf('C%d %+d: OFF-RAIL\n', ...
                ChangedCable(j),Direction(j));

            continue;

        end

        A_trial = build_anchors( ...
            t_trial,rho, ...
            rails.rail_start,rails.rail_end);

        g = evaluate_design( ...
            A_trial,r,P_eval,R_eval,settings);

        GeometryPass(j) = g.geometry_pass;
        RankPass(j) = g.rank_pass;

        MinAngle_deg(j) = g.min_angle;
        MinDistance_mm(j) = g.min_distance;

        clearance_ok = ...
            g.min_distance>=clearance_floor-1e-8;

        FullPass(j) = ...
            g.geometry_pass==539 && ...
            g.rank_pass==539 && ...
            clearance_ok;

        if FullPass(j)
            WorstSigma(j) = g.worst_sigma;
        end

        fprintf([ ...
            'C%d %+d | Geometry %d/539 | ', ...
            'Angle %+7.4f deg | ', ...
            'Gap %.4f mm | Pass %d\n'], ...
            ChangedCable(j),Direction(j), ...
            GeometryPass(j),MinAngle_deg(j), ...
            MinDistance_mm(j),FullPass(j));

    end

    %% 6.3 汇总当前设计

    PerturbationPass(d) = sum(FullPass);
    OffRailCount(d) = sum(OffRail);

    GeometryFailureCount(d) = sum( ...
        ~OffRail & GeometryPass<539);

    ClearanceFailureCount(d) = sum( ...
        ~OffRail & ...
        MinDistance_mm<clearance_floor-1e-8);

    valid = ~OffRail;

    if any(valid)

        WorstPerturbedAngle(d) = ...
            min(MinAngle_deg(valid));

        WorstPerturbedDistance(d) = ...
            min(MinDistance_mm(valid));

    end

    if any(FullPass)

        WorstPassingSigma(d) = ...
            min(WorstSigma(FullPass));

    end

    details{d} = table( ...
        ChangedCable,Direction, ...
        OffRail,GeometryPass,RankPass, ...
        MinAngle_deg,MinDistance_mm, ...
        WorstSigma,FullPass);

    fprintf('Perturbation pass: %d/12\n', ...
        PerturbationPass(d));

    fprintf('Off-rail: %d/12\n', ...
        OffRailCount(d));

end

%% Step 7 — 建立最终对比表

T_install = table( ...
    Design, ...
    NominalGeometry,NominalSigma, ...
    NominalAngle,NominalDistance, ...
    MinRailEnd_mm, ...
    PerturbationPass,OffRailCount, ...
    GeometryFailureCount,ClearanceFailureCount, ...
    WorstPerturbedAngle, ...
    WorstPerturbedDistance, ...
    WorstPassingSigma);

fprintf('\n====================================\n');
fprintf('E1b Shortlist Installation Robustness\n');
fprintf('====================================\n');

disp(T_install);

%% Step 8 — 显示所有失败案例

fprintf('\n--- Failed Perturbations ---\n');

for d = 1:N_design

    T = details{d};

    failed = T(~T.FullPass,:);

    if ~isempty(failed)

        fprintf('\n%s\n',Design(d));
        disp(failed);

    end

end

%% Step 9 — 保存

save('B5_4_E1b_shortlist_installation_robustness.mat', ...
    'T_install','details','designs', ...
    'perturbations','delta_t', ...
    'clearance_floor','DevFullEligible');

writetable(T_install, ...
    'B5_4_E1b_shortlist_installation_robustness.csv');

fprintf('\nE1b Lesson 1.6 completed.\n');

%% ===============================================
% Local Function 1 — 构建Anchor
%% ===============================================

function A = build_anchors( ...
    t,rho,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rho(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

end

%% ===============================================
% Local Function 2 — 539-Pose Geometry & Sensing
%% ===============================================

function g = evaluate_design( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    worst_sigma = inf;
    min_angle = inf;
    min_distance = inf;

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

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

        min_angle = min( ...
            min_angle,min(asind(sine_margin)));

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

            min_distance = min(min_distance,dij);

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        geometry_ok = sphere_ok && cable_ok;

        if geometry_ok
            geometry_pass = geometry_pass+1;
        end

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

        rankH = sum( ...
            sv>settings.rank_relative_tol*sv(1));

        if geometry_ok && rankH==6
            rank_pass = rank_pass+1;
        end

        worst_sigma = min(worst_sigma,sv(end));

    end

    g.geometry_pass = geometry_pass;
    g.rank_pass = rank_pass;

    g.min_angle = min_angle;
    g.min_distance = min_distance;

    g.worst_sigma = worst_sigma;

end
