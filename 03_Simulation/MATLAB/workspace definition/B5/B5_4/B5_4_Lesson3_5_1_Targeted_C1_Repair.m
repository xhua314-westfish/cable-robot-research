
%% B5.4 Lesson 3.5.1
% Targeted Cable 1 Geometry Repair
%
% Research Question:
% Can adjusting only A1 on R5 fix the common
% Cable-Sphere interference at Off-grid Pose 149?
%
% 控制变量：
% 只改变t1
% 固定其余t、Rail ID、Attachment、Pairing
%
% 评价：
% 1. Core 189姿态
% 2. 原有Off-grid 150姿态
% 3. Cable1最小Outward Dot
% 4. Worst sensing sigma_min
% 5. Minimum Cable Distance
%
% 注意：
% 本节没有更改实际硬件参数或优化其他Cable。

clear; clc; close all;

%% Step 1: Load verified baseline

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','P_all','R_all','settings');

load('B5_4_E1a_Config2_robustness_verification.mat', ...
    'T_designs','P_test','R_test', ...
    'angles_test_deg','rail_ids');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

cfg = best_configs(2);
r = cfg.r;

design_names = [
    "Original";
    "Sensing";
    "Clearance"
];

N_design = 3;

assert(size(P_all,1)==189);
assert(size(P_test,1)==150);
assert(rail_ids(1)==5);

%% Step 2: Combine original test sets
%
% 这里先同时评价339个已经明确的姿态。
% 不代表连续Workspace已被验证。

P_eval = [P_all;P_test];

R_eval = cat(3,R_all,R_test);

N_eval = size(P_eval,1);

assert(N_eval==339);

%% Step 3: Define C1 position scan
%
% 根据Lesson 3.2已知C1的条件可行区间，
% 先扫描t1=0.10到0.40。
%
% 此范围是探索性设置。
% 不能将它视为未来联合优化的绝对边界。

t1_values = unique([0.10:0.025:0.40,0.40]);

N_t = numel(t1_values);

fprintf('\n--- B5.4 Lesson 3.5.1 ---\n');
fprintf('Test poses: %d Core + %d Off-grid\n',189,150);
fprintf('C1 positions tested: %d\n',N_t);

%% Step 4: Prepare result storage

N_total = N_design*N_t;

Design = strings(N_total,1);
T1 = zeros(N_total,1);

CorePass = zeros(N_total,1);
OffGridPass = zeros(N_total,1);

CoreRank6 = zeros(N_total,1);
OffGridRank6 = zeros(N_total,1);

Pose149OutwardDot_mm2 = nan(N_total,1);
C1MinOutwardDot_mm2 = nan(N_total,1);

WorstSigma = nan(N_total,1);
MinCableDistance_mm = nan(N_total,1);

JointEligible = false(N_total,1);

row = 0;

%% Step 5: Evaluate all three designs

for d = 1:N_design

    fprintf('\n====================================\n');
    fprintf('%s\n',design_names(d));
    fprintf('====================================\n');

    t_base = T_designs(d,:);

    for j = 1:N_t

        row = row+1;

        t = t_base;

        % 唯一变化的变量
        t(1) = t1_values(j);

        %% Rebuild all six Anchors

        A = zeros(6,3);

        for i = 1:6

            rid = rail_ids(i);

            A(i,:) = rail_start(rid,:) + ...
                t(i)*(rail_end(rid,:)-rail_start(rid,:));

        end

        %% Evaluate identical 339 poses

        g = evaluate_all_poses( ...
            A,r,P_eval,R_eval,settings);

        Design(row) = design_names(d);
        T1(row) = t(1);

        CorePass(row) = ...
            sum(g.geometry_safe(1:189));

        OffGridPass(row) = ...
            sum(g.geometry_safe(190:end));

        CoreRank6(row) = sum( ...
            g.geometry_safe(1:189) & ...
            g.rank_all(1:189)==6);

        OffGridRank6(row) = sum( ...
            g.geometry_safe(190:end) & ...
            g.rank_all(190:end)==6);

        % 原Off-grid Pose 149
        % 合并数据后的索引是189+149
        k149 = 189+149;

        Pose149OutwardDot_mm2(row) = ...
            g.outward_dot(k149,1);

        % C1在全部339姿态中的最小出线裕量
        C1MinOutwardDot_mm2(row) = ...
            min(g.outward_dot(:,1));

        % 全部339姿态的最小Cable距离
        MinCableDistance_mm(row) = ...
            min(g.distances(:));

        % 只有全部姿态几何+Rank通过，
        % 才进入统一Sensing对比
        JointEligible(row) = ...
            CorePass(row)==189 && ...
            OffGridPass(row)==150 && ...
            CoreRank6(row)==189 && ...
            OffGridRank6(row)==150;

        if JointEligible(row)

            WorstSigma(row) = ...
                min(g.sigma_min_all);

        end

        fprintf(['t1=%.3f | Core=%3d | ' ...
            'Off-grid=%3d | g149=%+8.3f | ' ...
            'sigma=%8.5f | dmin=%7.3f\n'], ...
            t(1),CorePass(row), ...
            OffGridPass(row), ...
            Pose149OutwardDot_mm2(row), ...
            WorstSigma(row), ...
            MinCableDistance_mm(row));

    end

end

assert(row==N_total);

%% Step 6: Build comparison table

T_repair = table( ...
    Design,T1, ...
    CorePass,OffGridPass, ...
    CoreRank6,OffGridRank6, ...
    Pose149OutwardDot_mm2, ...
    C1MinOutwardDot_mm2, ...
    WorstSigma,MinCableDistance_mm, ...
    JointEligible);

fprintf('\n--- C1 Repair Results ---\n');
disp(T_repair);

%% Step 7: Report candidate results
%
% 不自动宣称哪个方案最优。
% 先列出同时通过两组姿态的候选。
%
% 特别注意：
% t1=0.4是之前的已知失败Baseline。

fprintf('\n--- Joint-Eligible Candidates ---\n');

for d = 1:N_design

    mask = Design==design_names(d);

    eligible_ids = find(mask & JointEligible);

    fprintf('\n%s\n',design_names(d));

    if isempty(eligible_ids)

        fprintf('No passing C1-only repair found.\n');

    else

        disp(T_repair(eligible_ids,:));

    end

end

%% Step 8: Visualise C1 repair

figure('Color','w', ...
    'Name','B5.4 Targeted C1 Repair', ...
    'Position',[80 80 1200 780]);

colors = lines(3);

tiledlayout(3,1,'TileSpacing','compact');

%% Plot 1: Off-grid geometry count

nexttile;
hold on;

for d = 1:3

    mask = Design==design_names(d);

    plot(T1(mask),OffGridPass(mask), ...
        '-o','Color',colors(d,:), ...
        'LineWidth',1.5, ...
        'DisplayName',design_names(d));

end

yline(150,'--k', ...
    'Off-grid full pass', ...
    'HandleVisibility','off');

xline(0.4,'--r', ...
    'Original t1', ...
    'HandleVisibility','off');

ylabel('Passing poses / 150');
title('Off-grid Geometry');
legend('Location','eastoutside');
grid on;
hold off;

%% Plot 2: Pose 149 outward dot

nexttile;
hold on;

for d = 1:3

    mask = Design==design_names(d);

    plot(T1(mask), ...
        Pose149OutwardDot_mm2(mask), ...
        '-o','Color',colors(d,:), ...
        'LineWidth',1.5);

end

yline(0,'--k');

xline(0.4,'--r');

ylabel('C1 Outward Dot (mm^2)');
title('Cable 1 Outward Direction at Pose 149');
grid on;
hold off;

%% Plot 3: Worst sensing on joint-eligible trials

nexttile;
hold on;

for d = 1:3

    mask = Design==design_names(d);

    plot(T1(mask),WorstSigma(mask), ...
        '-o','Color',colors(d,:), ...
        'LineWidth',1.5);

end

xlabel('Absolute Rail Parameter t1');
ylabel('Worst Scaled sigma_{min}');
title('Sensing for Joint-Eligible Candidates Only');
grid on;
hold off;

%% Step 9: Save diagnosis results

save('B5_4_E1a_C1_targeted_repair.mat', ...
    'T_repair','design_names', ...
    't1_values','JointEligible', ...
    'P_eval','R_eval','settings', ...
    'T_designs','rail_ids','r');

fprintf('\nB5.4 Lesson 3.5.1 completed.\n');
fprintf('Saved: B5_4_E1a_C1_targeted_repair.mat\n');

%% ==============================================
% Local function: Complete pose evaluation
%% ==============================================
function g = evaluate_all_poses( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);
    rank_all = zeros(N,1);

    sigma_min_all = nan(N,1);

    outward_dot = zeros(N,6);
    distances = zeros(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;

        D = A-B;
        L = vecnorm(D,2,2);

        assert(all(L>1e-9));

        %% Cable-Sphere

        outward_dot(k,:) = ...
            sum(S.*D,2)';

        sphere_ok = all( ...
            outward_dot(k,:) >= ...
            -settings.sphere_tol);

        %% Cable-Cable

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

        geometry_safe(k) = sphere_ok && cable_ok;

        %% Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:)) ...
            ];

        end

        Hs = H*settings.H_scale;

        singular_values = svd(Hs);

        sigma_min_all(k) = singular_values(end);

        rank_all(k) = sum( ...
            singular_values > ...
            settings.rank_relative_tol* ...
            singular_values(1));

    end

    g = struct();

    g.geometry_safe = geometry_safe;
    g.rank_all = rank_all;

    g.sigma_min_all = sigma_min_all;

    g.outward_dot = outward_dot;
    g.distances = distances;

end
