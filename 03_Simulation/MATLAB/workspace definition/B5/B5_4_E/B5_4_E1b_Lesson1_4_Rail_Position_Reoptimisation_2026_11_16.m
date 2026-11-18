
%% B5.4 E1b Lesson 1.4
% Rail Assignment + Position Re-optimisation
%
% 研究问题：
% 对24个新的Rail Assignment，
% 重新优化Anchor位置能否恢复Geometry并提高Sensing？
%
% 固定：Attachment r、Pairing、当前候选Rail IDs
% 变量：六个Rail Position t_i
%
% 搜索分为两种状态：
% A. 不可行：优先恢复Geometry、Rank和Clearance
% B. 可行：最大化Worst-Core sigma_min
%
% 统一预算：每个候选120次完整Core评价
%
% 注意：
% 本节不使用539-pose结果进行优化。
% 不保证找到全局最优解。

clear; clc; close all;

%% Step 1 — 加载数据

sel = load( ...
    'B5_4_E1b_representative_candidates.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

prot = load( ...
    'B5_4_E1a_B_optimisation_protocol.mat');

folder_B53 = fullfile( ...
    fileparts(pwd),'B5_3');

rails = load(fullfile(folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'B3 distance function not found');

candidates = sel.selected_candidates;
T_selected = sel.T_selected;

settings = base.settings;
P_all = base.P_all;
R_all = base.R_all;

clearance_floor = ...
    prot.protocol.clearance_floor_mm;

N_candidate = numel(candidates);
N_pose = size(P_all,1);

assert(N_candidate==24);
assert(N_pose==189);

%% Step 2 — 固定搜索预算

N_sweeps = 2;
N_cable = 6;
N_trials_per_cable = 10;

budget = N_sweeps*N_cable*N_trials_per_cable;

assert(budget==120);
assert(budget==prot.protocol.max_trial_evaluations);

% 只有超过此容差才算Sensing改善
improve_tol = 1e-8;

fprintf('\n--- E1b Lesson 1.4 ---\n');
fprintf('Selected candidates: %d\n',N_candidate);
fprintf('Core poses: %d\n',N_pose);
fprintf('Budget per candidate: %d\n',budget);
fprintf('Clearance floor: %.6f mm\n', ...
    clearance_floor);

%% Step 3 — 初始化结果存储

% 使用cell保存每个候选的完整设计
optimised_candidates = cell(N_candidate,1);

% 结果表对应的变量
ConfigID = zeros(N_candidate,1);
CandidateID = zeros(N_candidate,1);

SelectionRole = strings(N_candidate,1);

InitialGeometry = zeros(N_candidate,1);
FinalGeometry = zeros(N_candidate,1);

InitialRank = zeros(N_candidate,1);
FinalRank = zeros(N_candidate,1);

InitialDistance = nan(N_candidate,1);
FinalDistance = nan(N_candidate,1);

InitialSigma = nan(N_candidate,1);
FinalSigma = nan(N_candidate,1);

InitialFeasible = false(N_candidate,1);
FinalFeasible = false(N_candidate,1);

TrialCount = zeros(N_candidate,1);
AcceptedChanges = zeros(N_candidate,1);

% 用cell记录每个候选120次试验
search_history = cell(N_candidate,1);

%% Step 4 — 优化24个候选

for c = 1:N_candidate

    cand = candidates{c};

    ConfigID(c) = cand.config_id;
    CandidateID(c) = T_selected.CandidateID(c);

    SelectionRole(c) = ...
        T_selected.SelectionRole(c);

    % 当前候选已确定新的Rail IDs
    rho = cand.rail_ids(:)';

    % 保持已经配对完成的Attachment
    r = cand.r_fixed;

    % 记录Pairing身份，但不能再次排列r
    pairing = cand.pairing_fixed;

    % 新Rail上的初始位置
    t0 = cand.t_initial(:)';

    assert(numel(rho)==6);
    assert(numel(unique(rho))==6);
    assert(numel(t0)==6);
    assert(isequal(size(r),[6 3]));

    %% 4.1 重新评价初始配置

    initial = evaluate_e1b_candidate( ...
        t0,rho,rails.rail_start,rails.rail_end, ...
        r,P_all,R_all,settings,clearance_floor);

    % 与Lesson 1.2的保存数据进行回归检查
    assert(initial.geometry_pass== ...
        T_selected.GeometryPass(c));

    assert(initial.rank_pass== ...
        T_selected.RankPass(c));

    assert(abs(initial.min_distance- ...
        T_selected.MinDistance_mm(c))<1e-8);

    InitialGeometry(c) = initial.geometry_pass;
    InitialRank(c) = initial.rank_pass;
    InitialDistance(c) = initial.min_distance;

    InitialFeasible(c) = initial.feasible;

    if initial.feasible
        InitialSigma(c) = initial.sigma;
    end

    fprintf('\n============================\n');
    fprintf('Config %d | Candidate %d\n', ...
        ConfigID(c),CandidateID(c));

    fprintf('Role: %s\n',SelectionRole(c));

    fprintf('Rail IDs: %s\n',mat2str(rho));

    fprintf('Initial Geometry: %d/189\n', ...
        initial.geometry_pass);

    fprintf('Initial Clearance: %.4f mm\n', ...
        initial.min_distance);

    %% 4.2 初始化搜索

    current_t = t0;
    current = initial;

    trial_count = 0;
    accepted_changes = 0;

    % 每个候选单独保存120次评价
    H = zeros(budget,10);

    % H的列依次表示：
    % 1 TrialID
    % 2 Sweep
    % 3 Cable
    % 4 TrialT
    % 5 GeometryPass
    % 6 RankPass
    % 7 MinDistance
    % 8 Sigma（不可行时为NaN）
    % 9 Feasible
    % 10 ImprovedBestWithinScan

    %% Step 5 — 两轮顺序搜索

    for sweep = 1:N_sweeps

        for cable_id = 1:6

            % 固定当前扫描开始时的其他五个t
            start_t = current_t;

            best_t = current_t;
            best = current;

            %% 5.1 生成10个位置候选

            if sweep==1

                % 第一轮：全Rail搜索
                t_values = linspace(0,1,10);

            else

                % 第二轮：局部细化
                t_center = current_t(cable_id);

                fractions = ...
                    [0.05 0.10 0.20 0.40 0.70];

                left = t_center- ...
                    t_center*fractions;

                right = t_center+ ...
                    (1-t_center)*fractions;

                t_values = [left right];

            end

            assert(numel(t_values)==10);

            %% 5.2 评价10个候选

            for p = 1:10

                trial_t = start_t;

                % 每次只改变一根Cable的Anchor位置
                trial_t(cable_id) = t_values(p);

                trial = evaluate_e1b_candidate( ...
                    trial_t,rho, ...
                    rails.rail_start,rails.rail_end, ...
                    r,P_all,R_all,settings, ...
                    clearance_floor);

                trial_count = trial_count+1;

                %% 5.3 两阶段接受规则

                improved = false;

                if trial.feasible && ~best.feasible

                    % Stage A -> Stage B
                    % 从不可行进入完全可行，直接接受
                    improved = true;

                elseif trial.feasible && best.feasible

                    % Stage B：只比较Sensing
                    improved = ...
                        trial.sigma > ...
                        best.sigma+improve_tol;

                elseif ~trial.feasible && ~best.feasible

                    % Stage A：两个都不合格时
                    % 按照字典序减少约束违反程度
                    %
                    % 首先增加Geometry通过数；
                    % 再增加Rank通过数；
                    % 最后改善最小Cable间距。
                    %
                    % 如果前三项完全相同，
                    % 再比较最小出线角度。

                    if trial.geometry_pass > ...
                            best.geometry_pass

                        improved = true;

                    elseif trial.geometry_pass == ...
                            best.geometry_pass

                        if trial.rank_pass > best.rank_pass

                            improved = true;

                        elseif trial.rank_pass == ...
                                best.rank_pass

                            if trial.min_distance > ...
                                    best.min_distance+1e-8

                                improved = true;

                            elseif abs( ...
                                    trial.min_distance- ...
                                    best.min_distance)<1e-8

                                improved = ...
                                    trial.min_angle > ...
                                    best.min_angle+1e-8;

                            end

                        end

                    end

                end

                % 如果已经找到可行解，
                % 绝对不接受新的不可行解。

                if improved
                    best_t = trial_t;
                    best = trial;
                end

                %% 5.4 记录该次评价

                H(trial_count,:) = [ ...
                    trial_count, ...
                    sweep, ...
                    cable_id, ...
                    t_values(p), ...
                    trial.geometry_pass, ...
                    trial.rank_pass, ...
                    trial.min_distance, ...
                    trial.sigma, ...
                    double(trial.feasible), ...
                    double(improved)];

            end

            %% 5.5 接受当前Cable的最佳位置

            if abs(best_t(cable_id)- ...
                    current_t(cable_id))>1e-10

                current_t = best_t;
                current = best;

                accepted_changes = ...
                    accepted_changes+1;

            end

        end

    end

    %% Step 6 — 保存当前候选优化结果

    assert(trial_count==budget);

    FinalGeometry(c) = current.geometry_pass;
    FinalRank(c) = current.rank_pass;
    FinalDistance(c) = current.min_distance;

    FinalFeasible(c) = current.feasible;

    if current.feasible
        FinalSigma(c) = current.sigma;
    end

    TrialCount(c) = trial_count;
    AcceptedChanges(c) = accepted_changes;

    out = struct();

    out.config_id = ConfigID(c);
    out.candidate_id = CandidateID(c);

    out.rail_ids = rho;
    out.t_initial = t0;
    out.t_final = current_t;

    out.A_final = current.A;

    out.r = r;
    out.pairing = pairing;

    out.initial = initial;
    out.final = current;

    optimised_candidates{c} = out;

    search_history{c} = H;

    fprintf('Final Geometry: %d/189\n', ...
        current.geometry_pass);

    fprintf('Final Clearance: %.4f mm\n', ...
        current.min_distance);

    fprintf('Final Feasible: %d\n', ...
        current.feasible);

    if current.feasible
        fprintf('Final Sigma: %.6f\n', ...
            current.sigma);
    else
        fprintf('Final Sigma: NOT ELIGIBLE\n');
    end

    fprintf('Final t: %s\n', ...
        mat2str(current_t,6));

    fprintf('Accepted changes: %d\n', ...
        accepted_changes);

end

%% Step 7 — 生成全部24个候选的结果表

T_optimisation = table( ...
    ConfigID,CandidateID,SelectionRole, ...
    InitialGeometry,FinalGeometry, ...
    InitialRank,FinalRank, ...
    InitialDistance,FinalDistance, ...
    InitialSigma,FinalSigma, ...
    InitialFeasible,FinalFeasible, ...
    TrialCount,AcceptedChanges);

fprintf('\n====================================\n');
fprintf('E1b Position Re-optimisation Results\n');
fprintf('====================================\n');

disp(T_optimisation);

%% Step 8 — 统计修复情况

initial_failed = ~InitialFeasible;

repaired = initial_failed & FinalFeasible;

unresolved = initial_failed & ~FinalFeasible;

fprintf('\n--- E1b Summary ---\n');

fprintf('Initial feasible: %d / 24\n', ...
    sum(InitialFeasible));

fprintf('Final feasible: %d / 24\n', ...
    sum(FinalFeasible));

fprintf('Repaired candidates: %d\n', ...
    sum(repaired));

fprintf('Unresolved candidates: %d\n', ...
    sum(unresolved));

fprintf('Total candidate evaluations: %d\n', ...
    sum(TrialCount));

%% Step 9 — 回归和预算检查

assert(all(TrialCount==120));
assert(sum(TrialCount)==2880);

% 原本已经可行的候选，
% 不应在优化后丢失可行资格
assert(all(FinalFeasible(InitialFeasible)));

% 对原本已可行的候选，
% 不能接受较差的Sensing结果
assert(all( ...
    FinalSigma(InitialFeasible) >= ...
    InitialSigma(InitialFeasible)-1e-8));

% 所有最终合格候选都满足统一间距下限
assert(all( ...
    FinalDistance(FinalFeasible)>= ...
    clearance_floor-1e-8));

fprintf('\nPASS: Search budgets verified.\n');
fprintf('PASS: Previously feasible candidates retained.\n');

%% Step 10 — 保存研究数据

save('B5_4_E1b_position_reoptimisation.mat', ...
    'T_optimisation', ...
    'optimised_candidates', ...
    'search_history', ...
    'clearance_floor','settings');

writetable(T_optimisation, ...
    'B5_4_E1b_position_reoptimisation.csv');

fprintf('\nE1b Lesson 1.4 completed.\n');

%% ================================================
% Local Function 1 — Anchor坐标重建
%% ================================================

function A = build_anchors_e1b( ...
    t,rho,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rho(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:) - ...
                  rail_start(rid,:));

    end

end

%% ================================================
% Local Function 2 — 统一Core评价
%% ================================================

function result = evaluate_e1b_candidate( ...
    t,rho,rail_start,rail_end, ...
    r,P_all,R_all,settings,clearance_floor)

    A = build_anchors_e1b( ...
        t,rho,rail_start,rail_end);

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    min_distance = inf;
    min_angle = inf;

    worst_sigma = inf;

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        %% Cable geometry

        S = (R*r')';
        B = S+P;

        D = A-B;
        L = vecnorm(D,2,2);

        % 退化Cable记为不合格
        if any(L<=1e-9)
            continue;
        end

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_margin = outward_dot./ ...
            (settings.rb*L);

        sine_margin = max(-1,min(1,sine_margin));

        angle = asind(sine_margin);

        min_angle = min( ...
            min_angle,min(angle));

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

            min_distance = min( ...
                min_distance,dij);

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        geometry_ok = sphere_ok && cable_ok;

        if geometry_ok
            geometry_pass = geometry_pass+1;
        end

        %% Jacobian

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

        worst_sigma = min( ...
            worst_sigma,sv(end));

    end

    %% 判断完整Core是否合格

    geometry_ok = geometry_pass==N;
    rank_ok = rank_pass==N;

    clearance_ok = ...
        min_distance>=clearance_floor-1e-8;

    feasible = ...
        geometry_ok && rank_ok && clearance_ok;

    % 不合格候选不参与Sensing排名
    if ~feasible
        worst_sigma = NaN;
    end

    %% 返回评价结果

    result = struct();

    result.A = A;

    result.geometry_pass = geometry_pass;
    result.rank_pass = rank_pass;

    result.min_distance = min_distance;
    result.min_angle = min_angle;

    result.sigma = worst_sigma;
    result.feasible = feasible;

end
