
%% B5.4 Lesson 3.1
% E1a - One-Factor-at-a-Time Anchor Position Scan
%
% Research Question:
% How does one anchor's rail position affect
% multi-pose geometry and sensing quality?
%
% 本节只修改Config 2的一个t_i。
% Rail ID、Attachment、Pairing全部固定。
%
% 单位：mm；t为无量纲归一化导轨坐标

clear; clc; close all;

%% Step 1: Load verified B5.4 baseline

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','new_results', ...
    'P_all','R_all','settings');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

config_id = 2;
cfg = best_configs(config_id);

A0 = cfg.A;
r0 = cfg.r;
rail_ids = cfg.rail_ids;
t0 = cfg.t(:)';

N_pose = size(P_all,1);
assert(N_pose==189);

% 确认历史基准为完整Core可行
baseline = new_results{config_id};
assert(all(baseline.geometry_safe));
assert(all(baseline.rank_all==6));

fprintf('\n--- B5.4 Lesson 3.1 ---\n');
fprintf('Configuration: %d\n',config_id);
fprintf('Original t: %s\n',mat2str(t0,3));

%% Step 2: Define controlled scan
%
% 每次只改变一个t_i。
% 偏移量是探索性试验设置，不是机械公差。

delta_values = [-0.40 -0.30 0 0.30 0.40];

% 不重复计算6次零偏移
N_trial = 1 + 6*(numel(delta_values)-1);

TrialID = (1:N_trial)';
ChangedCable = zeros(N_trial,1);
DeltaT = zeros(N_trial,1);

t_trials = zeros(N_trial,6);

% 第一个试验保留原始Config 2
t_trials(1,:) = t0;

idx = 1;

for i = 1:6

    for delta = delta_values

        if delta==0
            continue;
        end

        t_new = t0;
        t_new(i) = t0(i)+delta;

        % 若越出完整导轨范围则跳过
        if t_new(i)<0 || t_new(i)>1
            continue;
        end

        idx = idx+1;

        t_trials(idx,:) = t_new;
        ChangedCable(idx) = i;
        DeltaT(idx) = delta;

    end

end

% 删除因导轨端点限制而未生成的记录
TrialID = TrialID(1:idx);
ChangedCable = ChangedCable(1:idx);
DeltaT = DeltaT(1:idx);
t_trials = t_trials(1:idx,:);

N_trial = idx;

fprintf('Valid scan trials: %d\n',N_trial);

%% Step 3: Prepare result arrays

GeometryPass = zeros(N_trial,1);
RankPass = zeros(N_trial,1);

WorstSigma = nan(N_trial,1);
WorstKappa = nan(N_trial,1);

MinCableDistance_mm = nan(N_trial,1);

CoreEligible = false(N_trial,1);

A_trials = cell(N_trial,1);

%% Step 4: Evaluate every trial

for trial = 1:N_trial

    t = t_trials(trial,:);

    % 保留原有Rail Assignment
    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

    % 保留原Attachment及原Pairing
    r = r0;

    A_trials{trial} = A;

    % 评价当前完整Core
    result = evaluate_trial( ...
        A,r,P_all,R_all,settings);

    GeometryPass(trial) = ...
        sum(result.geometry_safe);

    RankPass(trial) = sum( ...
        result.rank_all(result.geometry_safe)==6);

    MinCableDistance_mm(trial) = ...
        min(result.distances(:));

    CoreEligible(trial) = ...
        GeometryPass(trial)==N_pose && ...
        RankPass(trial)==N_pose;

    % 仅对全部Core通过的配置做统一Sensing排名
    if CoreEligible(trial)

        WorstSigma(trial) = ...
            min(result.sigma_min_all);

        WorstKappa(trial) = ...
            max(result.kappa_all);

    end

    fprintf(['Trial %2d | C%d | dt=%+.2f | ' ...
        'Geom=%3d/189 | sigma=%8.5f | dmin=%7.3f\n'], ...
        trial,ChangedCable(trial),DeltaT(trial), ...
        GeometryPass(trial),WorstSigma(trial), ...
        MinCableDistance_mm(trial));

end

%% Step 5: Baseline regression
%
% Trial 1没有改变配置，因此应与B5.4基准一致。

assert(norm(A_trials{1}-A0,'fro')<1e-8);

assert(GeometryPass(1)==189);
assert(RankPass(1)==189);

sigma0 = min(baseline.sigma_min_all);
dmin0 = min(baseline.distances(:));

assert(abs(WorstSigma(1)-sigma0)<1e-8);
assert(abs(MinCableDistance_mm(1)-dmin0)<1e-8);

fprintf('\nBaseline regression passed.\n');

%% Step 6: Build result table

T_scan = table( ...
    TrialID,ChangedCable,DeltaT, ...
    GeometryPass,RankPass, ...
    CoreEligible,WorstSigma,WorstKappa, ...
    MinCableDistance_mm);

disp(' ');
disp('--- E1a Rail Position Scan ---');
disp(T_scan);

%% Step 7: Diagnose feasible improvements
%
% 这里并不强行合并不同单位的指标。
% 分别找：
% 1. 感知最好的Core合格候选
% 2. 净空最大的Core合格候选
%
% 然后比较它们是否需要权衡。

eligible = find(CoreEligible);

assert(~isempty(eligible));

[~,order_sigma] = max(WorstSigma(eligible));
best_sensing_trial = eligible(order_sigma);

[~,order_clearance] = max( ...
    MinCableDistance_mm(eligible));

best_clearance_trial = eligible(order_clearance);

fprintf('\n--- Controlled Scan Decisions ---\n');

fprintf('Eligible trials: %d / %d\n', ...
    numel(eligible),N_trial);

fprintf('Best sensing trial: %d\n', ...
    best_sensing_trial);

fprintf('Best clearance trial: %d\n', ...
    best_clearance_trial);

fprintf('\nOriginal sigma: %.6f\n',sigma0);
fprintf('Original clearance: %.4f mm\n',dmin0);

fprintf('Best sensing sigma: %.6f\n', ...
    WorstSigma(best_sensing_trial));

fprintf('Best clearance: %.4f mm\n', ...
    MinCableDistance_mm(best_clearance_trial));

%% Step 8: Plot sensitivity by cable
%
% 上图显示是否通过Core几何。
% 下图显示每个试验的最小Cable距离。
%
% 横坐标是t偏移，而不是实际长度(mm)。

figure('Color','w', ...
    'Name','B5.4 E1a Rail Position Sensitivity', ...
    'Position',[100 100 1250 650]);

tiledlayout(2,1,'TileSpacing','compact');

nexttile;
hold on;

colors = lines(6);

for i = 1:6

    mask = ChangedCable==i;

    plot(DeltaT(mask),GeometryPass(mask), ...
        '-o','Color',colors(i,:), ...
        'LineWidth',1.6, ...
        'DisplayName',sprintf('Cable %d',i));

end

yline(189,'--k','Full Core target');

ylabel('Geometry Passing Poses');
title('E1a - Geometry Sensitivity');
ylim([0 200]);
grid on;
legend('Location','eastoutside');
hold off;

nexttile;
hold on;

for i = 1:6

    mask = ChangedCable==i;

    plot(DeltaT(mask), ...
        MinCableDistance_mm(mask), ...
        '-o','Color',colors(i,:), ...
        'LineWidth',1.6, ...
        'DisplayName',sprintf('Cable %d',i));

end

yline(dmin0,'--k','Baseline clearance');

xlabel('Change in Rail Parameter, \Delta t');
ylabel('Minimum Cable Distance (mm)');
title('E1a - Clearance Sensitivity');
grid on;
hold off;

%% Step 9: Save without overwriting original configuration

save('B5_4_E1a_Config2_rail_position_scan.mat', ...
    'config_id','cfg', ...
    't0','t_trials','A_trials', ...
    'T_scan','eligible', ...
    'best_sensing_trial','best_clearance_trial', ...
    'settings','delta_values');

fprintf('\nB5.4 Lesson 3.1 completed.\n');



%% ===============================================
% Local Function: Common Core Evaluator
%% ===============================================
function result = evaluate_trial( ...
    A,r,P_all,R_all,settings)

    N_pose = size(P_all,1);
    pairs = settings.cable_pairs;

    sphere_safe = false(N_pose,1);
    cable_safe = false(N_pose,1);
    geometry_safe = false(N_pose,1);

    distances = zeros(N_pose,15);
    sigma_min_all = zeros(N_pose,1);
    kappa_all = zeros(N_pose,1);
    rank_all = zeros(N_pose,1);

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);
        assert(all(L>1e-9));

        % Cable-Sphere
        outward_dot = sum(S.*D,2);

        sphere_safe(k) = all( ...
            outward_dot>=-settings.sphere_tol);

        % Cable-Cable
        for j = 1:15

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            distances(k,j) = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

        end

        cable_safe(k) = all( ...
            distances(k,:)>settings.contact_tol);

        geometry_safe(k) = ...
            sphere_safe(k) && cable_safe(k);

        % Jacobian
        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [
                -u(i,:), ...
                cross(u(i,:),S(i,:))
            ];

        end

        Hs = H*settings.H_scale;

        s = svd(Hs);

        sigma_min_all(k) = s(end);

        rank_all(k) = sum( ...
            s>settings.rank_relative_tol*s(1));

        if s(end)>0
            kappa_all(k) = s(1)/s(end);
        else
            kappa_all(k) = inf;
        end

    end

    result.geometry_safe = geometry_safe;
    result.sphere_safe = sphere_safe;
    result.cable_safe = cable_safe;

    result.distances = distances;
    result.sigma_min_all = sigma_min_all;
    result.kappa_all = kappa_all;
    result.rank_all = rank_all;

end
