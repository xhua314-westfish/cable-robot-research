
%% B5.4 Lesson 3.2
% E1a - Feasible Rail Interval Identification
%
% Research Question:
% For each cable in Config 2, which rail positions
% preserve all 189 Core poses and Jacobian rank 6?
%
% 研究方法：
% 1. 整条Rail粗扫描
% 2. 检测可行/不可行状态转换
% 3. 用二分法细化所有检测到的边界
% 4. 输出单变量条件可行区间
%
% IMPORTANT:
% 仅改变一个t_i，其他变量全部固定。
% 这里是离散Core测试，不是连续Workspace证明。

clear; clc; close all;

%% Step 1: Load verified data

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','P_all','R_all','settings');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end','rail_axis');

config_id = 2;
cfg = best_configs(config_id);

t0 = cfg.t(:)';
rail_ids = cfg.rail_ids(:)';

A0 = cfg.A;
r0 = cfg.r;

N_pose = size(P_all,1);

assert(N_pose==189);
assert(numel(t0)==6);
assert(numel(rail_ids)==6);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

fprintf('\n--- B5.4 Lesson 3.2 ---\n');
fprintf('Configuration: %d\n',config_id);
fprintf('Original t: %s\n',mat2str(t0,4));

%% Step 2: Define global scan and refinement

% 在完整Rail上采样41个点
% 步长0.025
t_grid = linspace(0,1,41);

% 额外包含原始t，确保Baseline不因采样遗漏
N_bisection = 12;

% 保存每条Cable的扫描数据
scan = cell(6,1);

% 每根Cable的可行区间：
% 每行 [lower_bound, upper_bound]
feasible_intervals = cell(6,1);

% 保存所有检测到的可行边界
transition_brackets = cell(6,1);

%% Step 3: Baseline regression

base = evaluate_at_t( ...
    t0,rail_ids,rail_start,rail_end, ...
    r0,P_all,R_all,settings);

assert(base.geometry_pass==N_pose);
assert(base.rank_pass==N_pose);
assert(base.eligible);
assert(norm(base.A-A0,'fro')<1e-8);

fprintf('Baseline geometry: %d / %d\n', ...
    base.geometry_pass,N_pose);

fprintf('Baseline sigma_min: %.6f\n', ...
    base.worst_sigma);

fprintf('Baseline clearance: %.4f mm\n', ...
    base.min_distance);

%% Step 4: Scan one cable at a time

for cable_id = 1:6

    fprintf('\n====================================\n');
    fprintf('Cable %d | Rail R%d (%s)\n', ...
        cable_id,rail_ids(cable_id), ...
        rail_axis(rail_ids(cable_id)));
    fprintf('====================================\n');

    % 保证包含Baseline
    t_values = unique( ...
        [t_grid,t0(cable_id)]);

    N_sample = numel(t_values);

    geometry_pass = zeros(N_sample,1);
    rank_pass = zeros(N_sample,1);

    eligible = false(N_sample,1);

    worst_sigma = nan(N_sample,1);
    worst_kappa = nan(N_sample,1);

    min_distance = nan(N_sample,1);

    %% 4.1 Evaluate every sampled position

    for k = 1:N_sample

        t_trial = t0;

        % 严格单变量控制
        t_trial(cable_id) = t_values(k);

        result = evaluate_at_t( ...
            t_trial,rail_ids, ...
            rail_start,rail_end, ...
            r0,P_all,R_all,settings);

        geometry_pass(k) = result.geometry_pass;
        rank_pass(k) = result.rank_pass;

        eligible(k) = result.eligible;

        worst_sigma(k) = result.worst_sigma;
        worst_kappa(k) = result.worst_kappa;

        min_distance(k) = result.min_distance;

    end

    %% 4.2 Find all sampled status transitions
    %
    % 找到相邻采样点中可行性发生改变的位置。
    %
    % 这里不假设可行区间只有一个。

    transitions = find( ...
        eligible(1:end-1)~=eligible(2:end));

    refined_boundaries = zeros(numel(transitions),1);
    boundary_brackets = zeros(numel(transitions),2);

    for j = 1:numel(transitions)

        k = transitions(j);

        left = t_values(k);
        right = t_values(k+1);

        left_status = eligible(k);

        %% 4.3 Refine boundary by bisection
        %
        % 左右端点必须具有不同可行状态。
        % 每次选择中点并判断属于哪一侧。

        for iter = 1:N_bisection

            midpoint = (left+right)/2;

            t_trial = t0;
            t_trial(cable_id) = midpoint;

            result_mid = evaluate_at_t( ...
                t_trial,rail_ids, ...
                rail_start,rail_end, ...
                r0,P_all,R_all,settings);

            if result_mid.eligible==left_status

                left = midpoint;

            else

                right = midpoint;

            end

        end

        refined_boundaries(j) = (left+right)/2;

        % 同时保存边界剩余不确定区间
        boundary_brackets(j,:) = [left,right];

    end

    %% 4.4 Build detected feasible intervals
    %
    % 由0、1和全部检测到的状态转换点
    % 构造候选区间，再用中点检查。
    %
    % 注意：
    % 这里只能称为sampled/refined intervals，
    % 不是严格连续安全区间。

    boundaries = [
        0;
        sort(refined_boundaries);
        1
    ];

    intervals = zeros(0,2);

    for j = 1:numel(boundaries)-1

        lower = boundaries(j);
        upper = boundaries(j+1);

        if upper-lower <= 1e-12
            continue;
        end

        midpoint = (lower+upper)/2;

        t_trial = t0;
        t_trial(cable_id) = midpoint;

        result_mid = evaluate_at_t( ...
            t_trial,rail_ids, ...
            rail_start,rail_end, ...
            r0,P_all,R_all,settings);

        if result_mid.eligible

            intervals(end+1,:) = [lower upper];

        end

    end

    % 合并相邻可行区间，避免重复切分
    if size(intervals,1)>1

        merged = intervals(1,:);

        for j = 2:size(intervals,1)

            if abs(intervals(j,1)-merged(end,2))<1e-10

                merged(end,2) = intervals(j,2);

            else

                merged(end+1,:) = intervals(j,:);

            end

        end

        intervals = merged;

    end

    feasible_intervals{cable_id} = intervals;

    transition_brackets{cable_id} = ...
        boundary_brackets;

    %% 4.5 Save full scan

    g = struct();

    g.cable_id = cable_id;
    g.rail_id = rail_ids(cable_id);

    g.t0 = t0(cable_id);
    g.t_values = t_values(:);

    g.geometry_pass = geometry_pass;
    g.rank_pass = rank_pass;
    g.eligible = eligible;

    g.worst_sigma = worst_sigma;
    g.worst_kappa = worst_kappa;

    g.min_distance = min_distance;

    g.intervals = intervals;
    g.boundary_brackets = boundary_brackets;

    scan{cable_id} = g;

    %% 4.6 Print results

    fprintf('Sampled positions: %d\n',N_sample);

    fprintf('Eligible samples: %d / %d\n', ...
        sum(eligible),N_sample);

    fprintf('Detected transitions: %d\n', ...
        numel(transitions));

    fprintf('Detected feasible intervals [t]:\n');
    disp(intervals);

    % 检查Baseline确实处于检测出的可行区域
    inside_baseline = any( ...
        t0(cable_id)>=intervals(:,1)-1e-9 & ...
        t0(cable_id)<=intervals(:,2)+1e-9);

    assert(inside_baseline);

end

%% Step 5: Calculate physical interval lengths
%
% t是归一化参数，不是实际mm。
%
% 每个区间的实际长度：
% (upper-lower)*rail_length

fprintf('\n--- Feasible Interval Summary ---\n');

for i = 1:6

    rid = rail_ids(i);

    rail_length = norm( ...
        rail_end(rid,:)-rail_start(rid,:));

    intervals = feasible_intervals{i};

    fprintf('\nCable %d | Rail R%d | t0=%.3f\n', ...
        i,rid,t0(i));

    for j = 1:size(intervals,1)

        lower = intervals(j,1);
        upper = intervals(j,2);

        physical_length = ...
            (upper-lower)*rail_length;

        fprintf([' Interval %d: ' ...
            't=[%.6f, %.6f], ' ...
            'length=%.3f mm\n'], ...
            j,lower,upper,physical_length);

    end

end

%% Step 6: Visualise geometry feasibility
%
% 六个子图分别对应Cable 1-6。
% 横坐标使用绝对t，不再使用Delta t。
%
% 红线表示Baseline的t0。

figure('Color','w', ...
    'Name','B5.4 E1a Feasible Rail Intervals', ...
    'Position',[100 100 1250 850]);

for i = 1:6

    subplot(3,2,i);
    hold on;

    g = scan{i};

    plot(g.t_values,g.geometry_pass, ...
        '-o','LineWidth',1.5, ...
        'MarkerSize',4, ...
        'Color',[0.10 0.45 0.85]);

    yline(189,'--k','Full Core', ...
    'HandleVisibility','off');

    xline(g.t0,'--r','Baseline');

    % 在横轴附近标出检测到的可行区间
    intervals = feasible_intervals{i};

    for j = 1:size(intervals,1)

        plot(intervals(j,:),[7 7], ...
            '-','Color',[0.15 0.65 0.35], ...
            'LineWidth',6);

    end

    title(sprintf('Cable %d - Rail R%d', ...
        i,g.rail_id));

    xlabel('Absolute rail parameter t');
    ylabel('Passing poses');

    xlim([0 1]);
    ylim([0 200]);

    grid on;
    hold off;

end

sgtitle('B5.4 - Conditional Feasible Rail Intervals');

%% Step 7: Visualise sensing and clearance
%
% 仅显示CoreEligible采样点的Sensing指标。
% 非合格点保留为NaN，不参与排名。

figure('Color','w', ...
    'Name','B5.4 E1a Sensing and Clearance', ...
    'Position',[100 100 1250 750]);

tiledlayout(2,1,'TileSpacing','compact');

colors = lines(6);

nexttile;
hold on;

for i = 1:6

    g = scan{i};

    plot(g.t_values,g.worst_sigma, ...
        '-o', ...
        'Color',colors(i,:), ...
        'LineWidth',1.4, ...
        'DisplayName',sprintf('Cable %d',i));

end

ylabel('Worst Core sigma_{min}');
title('Sensing within Core-Eligible Samples');
legend('Location','eastoutside');
grid on;
hold off;

nexttile;
hold on;

for i = 1:6

    g = scan{i};

    % 只显示满足Core条件的净空
    d = g.min_distance;
    d(~g.eligible) = NaN;

    plot(g.t_values,d, ...
        '-o','Color',colors(i,:), ...
        'LineWidth',1.4, ...
        'DisplayName',sprintf('Cable %d',i));

end

xlabel('Absolute rail parameter t');
ylabel('Minimum Cable Distance (mm)');
title('Cable Clearance within Core-Eligible Samples');
grid on;
hold off;

%% Step 8: Save data for later optimisation
%
% 单变量可行区间是后续优化的参考信息，
% 不是联合优化不可跨越的永久边界。
%
% 此文件不覆盖原始Config 2和历史结果。

save('B5_4_E1a_Config2_feasible_rail_intervals.mat', ...
    'config_id','t0','rail_ids', ...
    'scan','feasible_intervals', ...
    'transition_brackets', ...
    'N_bisection','t_grid', ...
    'settings');

fprintf('\nB5.4 Lesson 3.2 completed.\n');

fprintf(['Saved: ' ...
    'B5_4_E1a_Config2_feasible_rail_intervals.mat\n']);

%% ===============================================
% Local function 1:
% Evaluate a trial with rail parameters t
%% ===============================================
function result = evaluate_at_t( ...
    t,rail_ids,rail_start,rail_end, ...
    r,P_all,R_all,settings)

    A = zeros(6,3);

    % 根据固定Rail ID和当前t重新计算Anchors
    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

    % 调用几何和感知检查
    result = evaluate_core( ...
        A,r,P_all,R_all,settings);

    result.A = A;

end

%% ===============================================
% Local function 2:
% Core geometry and sensing evaluation
%% ===============================================
function result = evaluate_core( ...
    A,r,P_all,R_all,settings)

    N_pose = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    all_rank6 = true;

    min_distance = inf;

    worst_sigma = inf;
    worst_kappa = 0;

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';

        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            all_rank6 = false;
            continue;
        end

        %% Cable-Sphere
        outward_dot = sum(S.*D,2);

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable
        cable_ok = true;

        % 只有球面通过时才需要检查Cable距离。
        % 对综合GeometryPass来说，提前跳过不影响结果。
        if sphere_ok

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

        end

        geometry_ok = sphere_ok && cable_ok;

        if geometry_ok

            geometry_pass = geometry_pass+1;

            %% Jacobian
            u = D./L;

            H = zeros(6,6);

            for i = 1:6

                H(i,:) = [
                    -u(i,:), ...
                    cross(u(i,:),S(i,:))
                ];

            end

            Hs = H*settings.H_scale;

            singular_values = svd(Hs);

            rank_H = sum( ...
                singular_values> ...
                settings.rank_relative_tol* ...
                singular_values(1));

            if rank_H==6

                rank_pass = rank_pass+1;

            else

                all_rank6 = false;

            end

            worst_sigma = min( ...
                worst_sigma,singular_values(end));

            if singular_values(end)>0

                kappa = singular_values(1)/ ...
                    singular_values(end);

            else

                kappa = inf;

            end

            worst_kappa = max(worst_kappa,kappa);

        else

            all_rank6 = false;

        end

    end

    eligible = ...
        geometry_pass==N_pose && ...
        rank_pass==N_pose && all_rank6;

    % 不合格配置不参与统一Sensing排名
    if ~eligible

        worst_sigma = NaN;
        worst_kappa = NaN;

    end

    % 如果没有任何Sphere合格姿态，
    % 最小Cable距离也可能没有计算到。
    if isinf(min_distance)

        min_distance = NaN;

    end

    result = struct();

    result.geometry_pass = geometry_pass;
    result.rank_pass = rank_pass;

    result.eligible = eligible;

    result.worst_sigma = worst_sigma;
    result.worst_kappa = worst_kappa;

    result.min_distance = min_distance;

end
