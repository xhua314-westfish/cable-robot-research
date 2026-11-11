
%% B5.4 Lesson 3.3
% E1a - Sequential Multi-Variable Rail Optimisation
%
% Research Question:
% Can coordinated anchor-position adjustments improve
% sensing quality or cable clearance while maintaining
% all Core geometry and rank constraints?
%
% 两种独立搜索：
% A: 最大化Worst-Core sigma_min
%    同时保持Cable净空不低于Baseline
%
% B: 最大化Minimum Cable Distance
%    同时保持Worst-Core sigma_min不低于Baseline
%
% 固定变量：
% Rail ID、Attachment r、Pairing
%
% 优化变量：
% t1,t2,t3,t4,t5,t6
%
% 单位：mm；t无量纲

clear; clc; close all;

%% Step 1: Load verified data

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','P_all','R_all','settings');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

load('B5_4_E1a_Config2_feasible_rail_intervals.mat', ...
    'feasible_intervals');

config_id = 2;

cfg = best_configs(config_id);

rail_ids = cfg.rail_ids(:)';
t0 = cfg.t(:)';
r0 = cfg.r;
A0 = cfg.A;

N_pose = size(P_all,1);

assert(N_pose==189);
assert(numel(feasible_intervals)==6);

% 仍使用同一B3距离函数
assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2: Verify original baseline

baseline = evaluate_t( ...
    t0,rail_ids,rail_start,rail_end, ...
    r0,P_all,R_all,settings);

assert(baseline.eligible);

assert(norm(baseline.A-A0,'fro')<1e-9);

sigma0 = baseline.worst_sigma;
distance0 = baseline.min_distance;

fprintf('\n--- B5.4 Lesson 3.3 ---\n');

fprintf('Original t: %s\n',mat2str(t0,5));

fprintf('Original sigma_min: %.6f\n',sigma0);

fprintf('Original clearance: %.4f mm\n',distance0);

%% Step 3: Search parameters
%
% 只使用少量确定性候选位置。
% 不是PSO，也不是全局最优搜索。
%
% 上一节可行区间用于优先生成候选，
% 不是数学上固定的联合优化约束。

N_sweeps = 2;

% 当前t附近的额外位置
local_offsets = [-0.05 -0.025 0.025 0.05];

% 每个检测到的可行区间采样9个点
samples_per_interval = 9;

% 数值目标改善的比较容差
improve_tol = 1e-8;

%% Step 4: Set up two independent searches
%
% 两条搜索均从完全相同的Config 2出发。
%
% Track 1:
%   maximise sigma_min
%   clearance >= baseline clearance
%
% Track 2:
%   maximise clearance
%   sigma_min >= baseline sigma_min

track_names = [
    "Sensing-oriented";
    "Clearance-oriented"
];

N_track = numel(track_names);

track_results = repmat(struct( ...
    'name',"", ...
    't',[], ...
    'A',[], ...
    'sigma',NaN, ...
    'distance',NaN, ...
    'geometry_pass',NaN, ...
    'accepted_steps',0),N_track,1);

% 保存所有试验，而不只是接受的改动
history = struct( ...
    'Track',{}, ...
    'Sweep',{}, ...
    'Cable',{}, ...
    'TrialT',{}, ...
    'GeometryPass',{}, ...
    'Eligible',{}, ...
    'SigmaMin',{}, ...
    'Distance_mm',{}, ...
    'Accepted',{});

%% Step 5: Optimise each track

for track = 1:N_track

    fprintf('\n====================================\n');
    fprintf('%s\n',track_names(track));
    fprintf('====================================\n');

    % 两个Track都从原始Baseline开始
    current_t = t0;
    current_result = baseline;

    accepted_steps = 0;

    for sweep = 1:N_sweeps

        fprintf('\nSweep %d / %d\n', ...
            sweep,N_sweeps);

        sweep_changes = 0;

        %% Search Cable 1 to Cable 6

        for cable_id = 1:6

            % 本次搜索开始时的状态
            best_t = current_t;
            best_result = current_result;

            %% Build candidate positions
            %
            % 读取B5.4 Lesson 3.2的区间。
            % 这些区间是Baseline条件下得到的，
            % 因此只能用于生成优先搜索候选。
            %
            % 同时加入当前点附近的局部候选。

            intervals = feasible_intervals{cable_id};

            candidates = current_t(cable_id);

            for j = 1:size(intervals,1)

                lower = intervals(j,1);
                upper = intervals(j,2);

                candidates = [
                    candidates, ...
                    linspace(lower,upper, ...
                        samples_per_interval)
                ];

            end

            candidates = [
                candidates, ...
                current_t(cable_id)+local_offsets
            ];

            % 不允许越出真实导轨参数范围
            candidates = candidates( ...
                candidates>=0 & candidates<=1);

            % 去除重复采样点
            candidates = unique(round(candidates,8));

            %% Evaluate each position

            for j = 1:numel(candidates)

                candidate_t = current_t;

                % 严格保持其他五个t不变
                candidate_t(cable_id) = candidates(j);

                candidate = evaluate_t( ...
                    candidate_t,rail_ids, ...
                    rail_start,rail_end, ...
                    r0,P_all,R_all,settings);

                accepted = false;

                %% Check mandatory constraints

                if candidate.eligible

                    if track==1

                        % Sensing-oriented
                        %
                        % 净空不能低于原始Baseline
                        clearance_ok = ...
                            candidate.min_distance >= ...
                            distance0-1e-8;

                        improved = ...
                            candidate.worst_sigma > ...
                            best_result.worst_sigma + ...
                            improve_tol;

                        if clearance_ok && improved

                            best_t = candidate_t;
                            best_result = candidate;
                            accepted = true;

                        end

                    else

                        % Clearance-oriented
                        %
                        % sigma不能低于原始Baseline
                        sensing_ok = ...
                            candidate.worst_sigma >= ...
                            sigma0-1e-8;

                        improved = ...
                            candidate.min_distance > ...
                            best_result.min_distance + ...
                            improve_tol;

                        if sensing_ok && improved

                            best_t = candidate_t;
                            best_result = candidate;
                            accepted = true;

                        end

                    end

                end

                %% Record all tested candidates

                h.Track = track_names(track);
                h.Sweep = sweep;
                h.Cable = cable_id;
                h.TrialT = candidates(j);

                h.GeometryPass = candidate.geometry_pass;
                h.Eligible = candidate.eligible;

                h.SigmaMin = candidate.worst_sigma;
                h.Distance_mm = candidate.min_distance;

                % Accepted表示本次候选曾经改进
                % 该Cable扫描中的当前最佳解，
                % 不代表最后一定被采用。
                h.Accepted = accepted;

                history(end+1) = h;

            end

            %% Accept one best change per cable
            %
            % 一次只正式接受一根Anchor位置变化。
            % 接受后再搜索下一根Anchor。
            %
            % 这样可以观察多变量协调变化的过程。

            if norm(best_t-current_t)>1e-10

                old_t_value = current_t(cable_id);

                current_t = best_t;
                current_result = best_result;

                accepted_steps = accepted_steps+1;
                sweep_changes = sweep_changes+1;

                fprintf(['C%d: t %.5f -> %.5f | ' ...
                    'sigma %.6f | dmin %.4f mm\n'], ...
                    cable_id,old_t_value, ...
                    current_t(cable_id), ...
                    current_result.worst_sigma, ...
                    current_result.min_distance);

            end

        end

        fprintf('Accepted changes this sweep: %d\n', ...
            sweep_changes);

        if sweep_changes==0

            fprintf('No further improvement in this sweep.\n');

            break;

        end

    end

    %% Save final result of this track

    track_results(track).name = track_names(track);

    track_results(track).t = current_t;
    track_results(track).A = current_result.A;

    track_results(track).sigma = ...
        current_result.worst_sigma;

    track_results(track).distance = ...
        current_result.min_distance;

    track_results(track).geometry_pass = ...
        current_result.geometry_pass;

    track_results(track).accepted_steps = ...
        accepted_steps;

    assert(current_result.eligible);

end

%% Step 6: Final result comparison

fprintf('\n--- E1a Sequential Search Results ---\n');

Name = [
    "Original Config 2";
    track_names
];

T = [
    t0;
    track_results(1).t;
    track_results(2).t
];

SigmaMin = [
    sigma0;
    track_results(1).sigma;
    track_results(2).sigma
];

MinDistance_mm = [
    distance0;
    track_results(1).distance;
    track_results(2).distance
];

GeometryPass = [
    baseline.geometry_pass;
    track_results(1).geometry_pass;
    track_results(2).geometry_pass
];

T_summary = table( ...
    Name,GeometryPass,SigmaMin,MinDistance_mm, ...
    T(:,1),T(:,2),T(:,3), ...
    T(:,4),T(:,5),T(:,6), ...
    'VariableNames', ...
    {'Design','GeometryPass','SigmaMin', ...
     'MinDistance_mm', ...
     't1','t2','t3','t4','t5','t6'});

disp(T_summary);

%% Step 7: Regression and constraint checks

assert(all(GeometryPass==189));

% Track A不应牺牲Baseline净空
assert(track_results(1).distance>=distance0-1e-8);

% Track B不应牺牲Baseline sigma
assert(track_results(2).sigma>=sigma0-1e-8);

% 所有Anchor仍在原Rail上
for track = 1:N_track

    t = track_results(track).t;
    A = track_results(track).A;

    for i = 1:6

        rid = rail_ids(i);

        expected_A = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

        assert(norm(A(i,:)-expected_A)<1e-8);

    end

end

fprintf('All final constraints passed.\n');

%% Step 8: Visualise objective changes

figure('Color','w', ...
    'Name','B5.4 E1a Sequential Optimisation', ...
    'Position',[100 100 1150 480]);

subplot(1,2,1);

bar(SigmaMin);

xticks(1:3);
xticklabels({'Baseline','Sensing','Clearance'});

ylabel('Worst Core sigma_{min}');
title('Sensing Quality');
grid on;

subplot(1,2,2);

bar(MinDistance_mm);

xticks(1:3);
xticklabels({'Baseline','Sensing','Clearance'});

ylabel('Minimum Cable Distance (mm)');
title('Cable Clearance');
grid on;

%% Step 9: Save without overwriting previous results

save('B5_4_E1a_Config2_sequential_optimisation.mat', ...
    'config_id','cfg','t0', ...
    'baseline','track_results', ...
    'history','T_summary', ...
    'N_sweeps','local_offsets', ...
    'samples_per_interval','settings');

fprintf('\nB5.4 Lesson 3.3 completed.\n');

%% ===========================================
% Local function:
% Rebuild anchors from t and evaluate Core
%% ===========================================
function result = evaluate_t( ...
    t,rail_ids,rail_start,rail_end, ...
    r,P_all,R_all,settings)

    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

    N_pose = size(P_all,1);
    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    worst_sigma = inf;
    worst_kappa = 0;
    min_distance = inf;

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            continue;
        end

        %% Check Cable-Sphere

        outward_dot = sum(S.*D,2);

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Check Cable-Cable
        %
        % 与统一评价器使用相同的距离函数。
        % 对全部姿态检查全部15对Cable。

        cable_ok = true;

        for j = 1:15

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

            %% Measurement Jacobian

            u = D./L;
            H = zeros(6,6);

            for i = 1:6

                H(i,:) = [ ...
                    -u(i,:), ...
                    cross(u(i,:),S(i,:))
                ];

            end

            Hs = H*settings.H_scale;

            s = svd(Hs);

            rankH = sum( ...
                s>settings.rank_relative_tol*s(1));

            if rankH==6
                rank_pass = rank_pass+1;
            end

            worst_sigma = min(worst_sigma,s(end));

            if s(end)>0

                worst_kappa = max( ...
                    worst_kappa,s(1)/s(end));

            else
                worst_kappa = inf;
            end

        end

    end

    eligible = ...
        geometry_pass==N_pose && ...
        rank_pass==N_pose;

    if ~eligible

        worst_sigma = NaN;
        worst_kappa = NaN;

    end

    if isinf(min_distance)
        min_distance = NaN;
    end

    result = struct();

    result.A = A;
    result.geometry_pass = geometry_pass;
    result.rank_pass = rank_pass;

    result.eligible = eligible;
    result.worst_sigma = worst_sigma;
    result.worst_kappa = worst_kappa;
    result.min_distance = min_distance;

end
