
%% B5.4 E1a-B Lesson 2.3
% Fair Six-Configuration Sequential Coordinate Search
%
% Research Question:
% 在相同搜索预算下，调整六个Anchor位置，
% 能否提高六组配置的worst-Core sensing quality？
%
% 固定：
% 1. Rail IDs
% 2. Attachment points
% 3. Cable pairing
%
% 变量：
% t = [t1,t2,t3,t4,t5,t6]
%
% 主要目标：
% Maximise worst-Core scaled sigma_min
%
% 硬约束：
% 1. 189/189 Core geometry
% 2. 189/189 Rank-6
% 3. Common minimum cable distance floor
%
% 单位：
% Geometry: mm
% Rail parameter t: dimensionless
% Local rotation: rad
%
% 注意：
% 这是一轮公平的确定性Pilot Search。
% 不是全局最优性证明。

clear; clc; close all;

%% Step 1 — 读取研究数据

% B5.4已保存的统一评价数据
data = load( ...
    'B5_4_unified_evaluation_baseline.mat');

% 上一节保存的优化协议
protocol_data = load( ...
    'B5_4_E1a_B_optimisation_protocol.mat');

protocol = protocol_data.protocol;

% 原始Baseline Comparison Table
base_data = load( ...
    'B5_4_E1a_B_baseline_results.mat');

% B5.3导轨几何数据
folder_B54 = pwd;
folder_B53 = fullfile( ...
    fileparts(folder_B54),'B5_3');

rail_data = load(fullfile( ...
    folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

rail_start = rail_data.rail_start;
rail_end = rail_data.rail_end;

% 加入B3有限线段距离函数所在目录
helper_folder = fullfile( ...
    fileparts(folder_B54),'B5_3');

addpath(helper_folder);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'Cable distance function not found');

%% Step 2 — 检查统一实验协议

config_ids = protocol.config_ids(:)';

N_config = numel(config_ids);
N_pose = size(data.P_all,1);

assert(N_config==6);
assert(N_pose==189);

% 两轮搜索
% Sweep 1: 10 candidates per cable
% Sweep 2: 10 candidates per cable

N_sweeps = 2;
trials_per_cable = 10;

budget_expected = ...
    N_sweeps*6*trials_per_cable;

assert(budget_expected== ...
    protocol.max_trial_evaluations);

assert(strcmp( ...
    protocol.objective, ...
    'maximise_worst_core_sigma_min'));

% 统一约束
clearance_floor = ...
    protocol.clearance_floor_mm;

settings = data.settings;

% 数值改进容差
improve_tol = 1e-8;

fprintf('\n--- E1a-B Fair Search ---\n');
fprintf('Configurations: %s\n', ...
    mat2str(config_ids));

fprintf('Core poses: %d\n',N_pose);

fprintf('Search trials per Config: %d\n', ...
    budget_expected);

fprintf('Common clearance floor: %.6f mm\n', ...
    clearance_floor);

%% Step 3 — 初始化结果和搜索记录

% 每个配置保存一次优化结果
results = repmat(struct( ...
    'config_id',NaN, ...
    'rail_ids',[], ...
    't_original',[], ...
    't_optimised',[], ...
    'A_optimised',[], ...
    'r',[], ...
    'pairing',[], ...
    'sigma_original',NaN, ...
    'sigma_optimised',NaN, ...
    'distance_original',NaN, ...
    'distance_optimised',NaN, ...
    'kappa_optimised',NaN, ...
    'geometry_pass',NaN, ...
    'rank_pass',NaN, ...
    'accepted_changes',0, ...
    'trial_count',0),N_config,1);

% 保存所有候选的评价历史
history = struct( ...
    'ConfigID',{}, ...
    'Sweep',{}, ...
    'Cable',{}, ...
    'TrialID',{}, ...
    'TrialT',{}, ...
    'GeometryPass',{}, ...
    'RankPass',{}, ...
    'SigmaMin',{}, ...
    'Distance_mm',{}, ...
    'Feasible',{}, ...
    'Accepted',{});

%% Step 4 — 依次优化六个Config

for c = 1:N_config

    config_id = config_ids(c);

    cfg = data.best_configs(config_id);

    % 固定Rail IDs和Attachment
    rail_ids = cfg.rail_ids(:)';
    r = cfg.r;

    % cfg.r已经完成原始Pairing
    % 这里不能再次排列Attachment坐标！

    t0 = cfg.t(:)';

    % 原始Baseline
    baseline = evaluate_rail_candidate( ...
        t0,rail_ids,rail_start,rail_end, ...
        r,data.P_all,data.R_all,settings, ...
        clearance_floor);

    assert(baseline.feasible);

    % 原始结果回归验证
    old = data.new_results{config_id};

    assert(abs( ...
        baseline.sigma - ...
        min(old.sigma_min_all))<1e-8);

    assert(abs( ...
        baseline.min_distance - ...
        min(old.distances(:)))<1e-8);

    assert(norm( ...
        baseline.A-cfg.A,'fro')<1e-8);

    fprintf('\n============================\n');
    fprintf('Config %d\n',config_id);

    fprintf('Original t: %s\n', ...
        mat2str(t0,5));

    fprintf('Original sigma: %.6f\n', ...
        baseline.sigma);

    % 当前最优配置从原始Baseline开始
    current_t = t0;
    current_result = baseline;

    trial_count = 0;
    accepted_changes = 0;

    %% Step 5 — 执行两个Sweep

    for sweep = 1:N_sweeps

        fprintf('\nSweep %d\n',sweep);

        % 逐根Cable优化
        for cable_id = 1:6

            % 当前Cable开始扫描时，
            % 保存尚未改变的五个位置参数
            start_t = current_t;

            best_t = current_t;
            best_result = current_result;

            %% Step 5.1 — 生成10个候选位置

            if sweep==1

                % 第一轮：全Rail均匀扫描
                % 包含t=0和t=1
                candidates = linspace( ...
                    0,1,trials_per_cable);

            else

                % 第二轮：当前结果附近局部搜索
                %
                % 负方向5点，正方向5点
                % 基于当前位置两侧的可用空间。
                % 不越过[0,1]，不需要裁剪。

                t_center = current_t(cable_id);

                left_space = t_center;
                right_space = 1-t_center;

                fractions = [ ...
                    0.05 0.10 0.20 0.40 0.70];

                left_candidates = ...
                    t_center-left_space*fractions;

                right_candidates = ...
                    t_center+right_space*fractions;

                candidates = [ ...
                    left_candidates, ...
                    right_candidates];

            end

            assert(numel(candidates)==10);
            assert(all(candidates>=0 & ...
                candidates<=1));

            %% Step 5.2 — 评价10个候选

            for p = 1:trials_per_cable

                trial_t = start_t;

                % 只改变当前Cable的t
                trial_t(cable_id) = candidates(p);

                % 统一评价189个Core姿态
                trial_result = evaluate_rail_candidate( ...
                    trial_t,rail_ids, ...
                    rail_start,rail_end, ...
                    r,data.P_all,data.R_all, ...
                    settings,clearance_floor);

                % 每调用一次完整Evaluator都计数
                trial_count = trial_count+1;

                accepted = false;

                %% Step 5.3 — 判断是否接受新候选

                if trial_result.feasible

                    % 只有满足全部硬约束的候选
                    % 才能参与sigma_min比较

                    improved = ...
                        trial_result.sigma > ...
                        best_result.sigma+improve_tol;

                    if improved

                        best_t = trial_t;
                        best_result = trial_result;
                        accepted = true;

                    end

                end

                %% Step 5.4 — 记录每次评价

                h.ConfigID = config_id;
                h.Sweep = sweep;
                h.Cable = cable_id;
                h.TrialID = trial_count;

                h.TrialT = candidates(p);

                h.GeometryPass = ...
                    trial_result.geometry_pass;

                h.RankPass = ...
                    trial_result.rank_pass;

                h.SigmaMin = trial_result.sigma;

                h.Distance_mm = ...
                    trial_result.min_distance;

                h.Feasible = trial_result.feasible;

                % 表示曾更新当前扫描中的best
                % 不代表最终一定采用此Trial
                h.Accepted = accepted;

                history(end+1) = h;

            end

            %% Step 5.5 — 更新当前最优位置

            if abs(best_t(cable_id)- ...
                    current_t(cable_id))>1e-10

                old_value = current_t(cable_id);

                current_t = best_t;
                current_result = best_result;

                accepted_changes = accepted_changes+1;

                fprintf([ ...
                    'C%d: %.5f -> %.5f | ', ...
                    'sigma %.6f | dmin %.4f mm\n'], ...
                    cable_id,old_value, ...
                    current_t(cable_id), ...
                    current_result.sigma, ...
                    current_result.min_distance);

            end

        end

    end

    %% Step 6 — 保存该Config的最终结果

    assert(trial_count==budget_expected);
    assert(current_result.feasible);

    results(c).config_id = config_id;

    results(c).rail_ids = rail_ids;

    results(c).t_original = t0;

    results(c).t_optimised = current_t;

    results(c).A_optimised = current_result.A;

    % 保持原始Attachment及Pairing
    results(c).r = r;
    results(c).pairing = cfg.pairing;

    results(c).sigma_original = baseline.sigma;

    results(c).sigma_optimised = ...
        current_result.sigma;

    results(c).distance_original = ...
        baseline.min_distance;

    results(c).distance_optimised = ...
        current_result.min_distance;

    results(c).kappa_optimised = ...
        current_result.kappa;

    results(c).geometry_pass = ...
        current_result.geometry_pass;

    results(c).rank_pass = ...
        current_result.rank_pass;

    results(c).accepted_changes = ...
        accepted_changes;

    results(c).trial_count = trial_count;

    fprintf('\nConfig %d completed.\n',config_id);

    fprintf('Final t: %s\n', ...
        mat2str(current_t,6));

    fprintf('Final sigma: %.6f\n', ...
        current_result.sigma);

    fprintf('Final clearance: %.4f mm\n', ...
        current_result.min_distance);

    fprintf('Accepted cable changes: %d\n', ...
        accepted_changes);

end

%% Step 7 — 六组配置公平比较

ConfigID = [results.config_id]';

OriginalSigma = [results.sigma_original]';
OptimisedSigma = [results.sigma_optimised]';

OriginalDistance = ...
    [results.distance_original]';

OptimisedDistance = ...
    [results.distance_optimised]';

OptimisedKappa = ...
    [results.kappa_optimised]';

GeometryPass = ...
    [results.geometry_pass]';

RankPass = ...
    [results.rank_pass]';

TrialCount = ...
    [results.trial_count]';

AcceptedChanges = ...
    [results.accepted_changes]';

% 相同Core集合上的sigma改善比例
ImprovementPercent = 100*( ...
    OptimisedSigma./OriginalSigma-1);

T_comparison = table( ...
    ConfigID, ...
    OriginalSigma,OptimisedSigma, ...
    ImprovementPercent, ...
    OriginalDistance,OptimisedDistance, ...
    OptimisedKappa, ...
    GeometryPass,RankPass, ...
    TrialCount,AcceptedChanges);

fprintf('\n============================\n');
fprintf('E1a-B Fair Optimisation Results\n');
fprintf('============================\n');

disp(T_comparison);

%% Step 8 — 最终验收检查

assert(all(GeometryPass==189));
assert(all(RankPass==189));

assert(all(TrialCount==120));

assert(all( ...
    OptimisedDistance>= ...
    clearance_floor-1e-8));

% 本算法只接受sigma改善
assert(all( ...
    OptimisedSigma>= ...
    OriginalSigma-1e-8));

% 六组配置总共720次候选评价
assert(numel(history)==720);

fprintf('\nPASS: All six configurations optimised.\n');

fprintf('PASS: 120 evaluations per Config.\n');

fprintf('PASS: Core geometry and rank retained.\n');

%% Step 9 — 绘制对比图

figure('Color','w', ...
    'Name','E1a-B Fair Comparison', ...
    'Position',[100 100 1150 480]);

subplot(1,2,1);

bar(ConfigID, ...
    [OriginalSigma OptimisedSigma], ...
    'grouped');

xlabel('Configuration ID');
ylabel('Worst Core Scaled Sigma Min');

title('Before vs After: Sensing');

legend({'Original','Optimised'}, ...
    'Location','best');

grid on;

subplot(1,2,2);

bar(ConfigID, ...
    [OriginalDistance OptimisedDistance], ...
    'grouped');

xlabel('Configuration ID');
ylabel('Minimum Ideal Cable Distance (mm)');

title('Before vs After: Clearance');

legend({'Original','Optimised'}, ...
    'Location','best');

grid on;

%% Step 10 — 保存研究结果

% 保存所有优化参数与搜索历史
save('B5_4_E1a_B_fair_sequential_results.mat', ...
    'results','history','T_comparison', ...
    'protocol','settings');

% 保存可直接查看的对比表
writetable(T_comparison, ...
    'B5_4_E1a_B_fair_sequential_results.csv');

fprintf('\nE1a-B Lesson 2.3 completed.\n');

%% ==================================================
% Local Function 1
% 根据Rail ID和t重建六个Anchor坐标
%% ==================================================
function A = build_rail_anchors( ...
    t,rail_ids,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        % Rail参数化方程
        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

end

%% ==================================================
% Local Function 2
% 对一个候选配置评价全部Core姿态
%% ==================================================
function result = evaluate_rail_candidate( ...
    t,rail_ids,rail_start,rail_end, ...
    r,P_all,R_all,settings,clearance_floor)

    A = build_rail_anchors( ...
        t,rail_ids,rail_start,rail_end);

    N_pose = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    worst_sigma = inf;
    worst_kappa = 0;
    min_distance = inf;

    %% 遍历189个Core姿态

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        % Attachment世界坐标
        S = (R*r')';
        B = S+P;

        % Cable向量和长度
        D = A-B;
        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            continue;
        end

        %% Cable-Sphere Geometry

        outward_dot = sum(S.*D,2);

        sphere_ok = all( ...
            outward_dot>=settings.sphere_tol*(-1));

        %% Cable-Cable Geometry

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

        %% Geometry统计

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

        s = svd(Hs);

        rankH = sum( ...
            s>settings.rank_relative_tol*s(1));

        if geometry_ok && rankH==6
            rank_pass = rank_pass+1;
        end

        % 只有整个配置最终几何可行，
        % 下面的worst sigma才用于排名。
        % 这里先对所有姿态记录诊断值。
        worst_sigma = min(worst_sigma,s(end));

        if s(end)>0
            worst_kappa = max( ...
                worst_kappa,s(1)/s(end));
        else
            worst_kappa = inf;
        end

    end

    %% 判断完整配置是否合格

    eligible = ...
        geometry_pass==N_pose && ...
        rank_pass==N_pose;

    clearance_ok = ...
        min_distance>=clearance_floor-1e-8;

    feasible = eligible && clearance_ok;

    % 不合格配置不参加目标比较
    if ~feasible
        worst_sigma = NaN;
        worst_kappa = NaN;
    end

    %% 返回结果

    result = struct();

    result.A = A;

    result.geometry_pass = geometry_pass;
    result.rank_pass = rank_pass;

    result.min_distance = min_distance;

    result.sigma = worst_sigma;
    result.kappa = worst_kappa;

    result.eligible = eligible;
    result.feasible = feasible;

end
