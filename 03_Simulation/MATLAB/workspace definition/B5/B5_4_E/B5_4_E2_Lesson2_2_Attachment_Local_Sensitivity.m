
%% B5.4 E2 Lesson 2.2
% Attachment Local Sensitivity Analysis
%
% Research Question:
% 单独移动一个Attachment，会如何改变
% Geometry、Sensing和Attachment spacing？
%
% 本节：
% 4个设计 × 6个Cable × 2个幅度 × 8个方向
% = 384次Core 189评价
%
% 固定Anchor及Pairing。
% 每次从原始Attachment布局独立生成扰动。
% 不累积优化，也不使用539数据调参。

clear; clc; close all;

%% Step 1 — 加载现有E2基准

data = load( ...
    'B5_4_E2_attachment_baselines.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

prot = load( ...
    'B5_4_E1a_B_optimisation_protocol.mat');

designs = data.e2_baselines;
Design = string(data.T_attachment.Design);

settings = base.settings;
P_all = base.P_all;
R_all = base.R_all;

rb = settings.rb;

clearance_floor = ...
    prot.protocol.clearance_floor_mm;

assert(numel(designs)==4);
assert(size(P_all,1)==189);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 定义局部扫描参数

% 球面角位移
alpha_values = [2 5];

% 切向方向
beta_values = 0:45:315;

N_alpha = numel(alpha_values);
N_beta = numel(beta_values);

N_cable = 6;

trials_per_design = ...
    N_cable*N_alpha*N_beta;

assert(trials_per_design==96);

N_design = numel(designs);
N_total = N_design*trials_per_design;

fprintf('\n--- E2 Attachment Sensitivity ---\n');
fprintf('Designs: %d\n',N_design);
fprintf('Trials per design: %d\n', ...
    trials_per_design);
fprintf('Total trials: %d\n',N_total);

%% Step 3 — 初始化全局评价表

DesignID = zeros(N_total,1);

CableID = zeros(N_total,1);
Alpha_deg = zeros(N_total,1);
Beta_deg = zeros(N_total,1);

GeometryPass = zeros(N_total,1);
RankPass = zeros(N_total,1);

MinAngle_deg = nan(N_total,1);
MinCableDistance_mm = nan(N_total,1);

MinAttachmentDistance_mm = nan(N_total,1);

WorstCoreSigma = nan(N_total,1);

ClearanceEligible = false(N_total,1);
SpacingEligible = false(N_total,1);

FullEligible = false(N_total,1);

% 保存每组最好的单点扰动配置
best_designs = cell(N_design,1);

% 保存原始性能以供比较
BaselineSigma = nan(N_design,1);
BaselineAngle = nan(N_design,1);
BaselineCableDistance = nan(N_design,1);

row = 0;

%% Step 4 — 分别处理四组设计

for d = 1:N_design

    cfg = designs{d};

    A = cfg.A_fixed;
    r0 = cfg.r_initial;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r0),[6 3]));

    %% 4.1 计算原始Attachment间距

    original_chord = ...
        min_attachment_chord(r0);

    % 使用本设计原有最小间距作为
    % 本轮不降低间距的保守比较约束。
    spacing_floor = original_chord;

    %% 4.2 重新计算基准Geometry与Sensing

    baseline = evaluate_e2_core( ...
        A,r0,P_all,R_all, ...
        settings,clearance_floor);

    assert(baseline.geometry_pass==189);
    assert(baseline.rank_pass==189);
    assert(baseline.clearance_ok);

    BaselineSigma(d) = baseline.sigma;
    BaselineAngle(d) = baseline.min_angle;
    BaselineCableDistance(d) = ...
        baseline.min_cable_distance;

    best_sigma = baseline.sigma;
    best_r = r0;
    best_trial = 0;

    fprintf('\n============================\n');
    fprintf('%s\n',Design(d));

    fprintf('Original sigma: %.6f\n', ...
        baseline.sigma);

    fprintf('Original min chord: %.4f mm\n', ...
        original_chord);

    %% Step 5 — 单Attachment局部扰动

    for cable_id = 1:6

        % 当前Attachment的单位法向量
        n = r0(cable_id,:)'/rb;

        n = n/norm(n);

        %% 5.1 构建切平面基

        % 避免参考轴与法向量接近平行
        if abs(dot(n,[0;0;1]))<0.9

            reference_axis = [0;0;1];

        else

            reference_axis = [1;0;0];

        end

        e1 = cross(reference_axis,n);
        e1 = e1/norm(e1);

        e2 = cross(n,e1);
        e2 = e2/norm(e2);

        assert(abs(dot(e1,n))<1e-10);
        assert(abs(dot(e2,n))<1e-10);

        %% 5.2 不同移动幅度和方向

        for ia = 1:N_alpha

            alpha = alpha_values(ia);

            for ib = 1:N_beta

                beta = beta_values(ib);

                % 切向移动单位方向
                v = cosd(beta)*e1 + ...
                    sind(beta)*e2;

                % 新球面Attachment
                r_new = rb*( ...
                    cosd(alpha)*n + ...
                    sind(alpha)*v);

                % 只改变当前Cable的Attachment
                r_trial = r0;

                r_trial(cable_id,:) = r_new';

                %% 5.3 验证球面半径

                radius_error = max(abs( ...
                    vecnorm(r_trial,2,2)-rb));

                assert(radius_error<1e-8);

                %% 5.4 检查Attachment spacing

                min_chord = ...
                    min_attachment_chord(r_trial);

                spacing_ok = ...
                    min_chord>=spacing_floor-1e-8;

                %% 5.5 评价Core Geometry和Sensing

                g = evaluate_e2_core( ...
                    A,r_trial, ...
                    P_all,R_all,settings, ...
                    clearance_floor);

                %% 5.6 保存试验数据

                row = row+1;

                DesignID(row) = d;
                CableID(row) = cable_id;

                Alpha_deg(row) = alpha;
                Beta_deg(row) = beta;

                GeometryPass(row) = ...
                    g.geometry_pass;

                RankPass(row) = g.rank_pass;

                MinAngle_deg(row) = ...
                    g.min_angle;

                MinCableDistance_mm(row) = ...
                    g.min_cable_distance;

                MinAttachmentDistance_mm(row) = ...
                    min_chord;

                WorstCoreSigma(row) = g.sigma;

                ClearanceEligible(row) = ...
                    g.clearance_ok;

                SpacingEligible(row) = ...
                    spacing_ok;

                % 完整合格条件
                FullEligible(row) = ...
                    g.geometry_pass==189 && ...
                    g.rank_pass==189 && ...
                    g.clearance_ok && ...
                    spacing_ok;

                %% 5.7 记录最佳合格单点扰动

                if FullEligible(row) && ...
                        g.sigma>best_sigma+1e-8

                    best_sigma = g.sigma;
                    best_r = r_trial;

                    best_trial = row;

                end

            end

        end

    end

    %% Step 6 — 保存当前设计最佳结果

    best = struct();

    best.name = Design(d);

    best.A_fixed = A;

    best.r_initial = r0;
    best.r_best = best_r;

    best.sigma_initial = baseline.sigma;
    best.sigma_best = best_sigma;

    best.best_trial_row = best_trial;

    best.spacing_floor_mm = spacing_floor;

    best_designs{d} = best;

    fprintf('Best valid local sigma: %.6f\n', ...
        best_sigma);

    fprintf('Improvement: %.2f %%\n', ...
        100*(best_sigma/baseline.sigma-1));

    if best_trial==0

        fprintf('No improving single-point move.\n');

    else

        fprintf('Best moved Cable: C%d\n', ...
            CableID(best_trial));

        fprintf('Alpha: %.1f deg\n', ...
            Alpha_deg(best_trial));

        fprintf('Beta: %.1f deg\n', ...
            Beta_deg(best_trial));

    end

end

assert(row==N_total);

%% Step 7 — 构建全部试验结果表

T_trials = table( ...
    DesignID,CableID, ...
    Alpha_deg,Beta_deg, ...
    GeometryPass,RankPass, ...
    MinAngle_deg, ...
    MinCableDistance_mm, ...
    MinAttachmentDistance_mm, ...
    WorstCoreSigma, ...
    ClearanceEligible, ...
    SpacingEligible,FullEligible);

%% Step 8 — 汇总每组结果

DesignName = Design(:);

EligibleTrials = zeros(N_design,1);

BestCable = nan(N_design,1);
BestAlpha_deg = nan(N_design,1);
BestBeta_deg = nan(N_design,1);

BestSigma = nan(N_design,1);

for d = 1:N_design

    mask = DesignID==d;

    EligibleTrials(d) = sum( ...
        FullEligible(mask));

    best = best_designs{d};

    BestSigma(d) = best.sigma_best;

    if best.best_trial_row>0

        j = best.best_trial_row;

        BestCable(d) = CableID(j);
        BestAlpha_deg(d) = Alpha_deg(j);
        BestBeta_deg(d) = Beta_deg(j);

    end

end

ImprovementPercent = ...
    100*(BestSigma./BaselineSigma-1);

T_summary = table( ...
    DesignName,EligibleTrials, ...
    BaselineSigma,BestSigma, ...
    ImprovementPercent, ...
    BestCable,BestAlpha_deg,BestBeta_deg);

fprintf('\n====================================\n');
fprintf('E2 Local Attachment Sensitivity Summary\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 9 — 按Cable归纳局部改进潜力

N_rows = N_design*6;

PerDesign = strings(N_rows,1);
PerCable = zeros(N_rows,1);

ValidTrials = zeros(N_rows,1);

BestCableSigma = nan(N_rows,1);
CableImprovementPercent = nan(N_rows,1);

k = 0;

for d = 1:N_design

    for cable_id = 1:6

        k = k+1;

        mask = ...
            DesignID==d & ...
            CableID==cable_id & ...
            FullEligible;

        PerDesign(k) = Design(d);
        PerCable(k) = cable_id;

        ValidTrials(k) = sum(mask);

        if any(mask)

            candidate_max = max( ...
                WorstCoreSigma(mask));

            BestCableSigma(k) = candidate_max;

            CableImprovementPercent(k) = ...
                100*(candidate_max/ ...
                BaselineSigma(d)-1);

        end

    end

end

T_cable = table( ...
    PerDesign,PerCable, ...
    ValidTrials,BestCableSigma, ...
    CableImprovementPercent);

fprintf('\n--- Sensitivity by Attachment Cable ---\n');
disp(T_cable);

%% Step 10 — 检查与保存

assert(height(T_trials)==384);

assert(all(EligibleTrials<=96));

assert(all(BestSigma>=BaselineSigma-1e-8));

save( ...
    'B5_4_E2_attachment_local_sensitivity.mat', ...
    'T_trials','T_summary','T_cable', ...
    'best_designs','alpha_values', ...
    'beta_values','clearance_floor');

writetable(T_trials, ...
    'B5_4_E2_attachment_local_trials.csv');

writetable(T_summary, ...
    'B5_4_E2_attachment_local_summary.csv');

writetable(T_cable, ...
    'B5_4_E2_attachment_cable_sensitivity.csv');

fprintf('\nPASS: 384 local trials completed.\n');
fprintf('E2 Lesson 2.2 completed.\n');

%% ===============================================
% Local Function 1 — 最小Attachment弦长
%% ===============================================

function dmin = min_attachment_chord(r)

    pairs = nchoosek(1:6,2);

    dmin = inf;

    for j = 1:size(pairs,1)

        i1 = pairs(j,1);
        i2 = pairs(j,2);

        d = norm(r(i1,:)-r(i2,:));

        dmin = min(dmin,d);

    end

end

%% ===============================================
% Local Function 2 — Core几何和Jacobian评价
%% ===============================================

function result = evaluate_e2_core( ...
    A,r,P_all,R_all,settings,clearance_floor)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    min_angle = inf;
    min_cable_distance = inf;

    worst_sigma = inf;

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        % Body坐标转World坐标
        S = (R*r')';

        % Attachment世界位置
        B = S+P;

        % Cable方向
        D = A-B;
        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            continue;
        end

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_margin = outward_dot./ ...
            (settings.rb*L);

        sine_margin = max(-1,min(1,sine_margin));

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

            min_cable_distance = min( ...
                min_cable_distance,dij);

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

        worst_sigma = min(worst_sigma,sv(end));

    end

    geometry_ok = geometry_pass==N;
    rank_ok = rank_pass==N;

    clearance_ok = ...
        min_cable_distance>=clearance_floor-1e-8;

    feasible = ...
        geometry_ok && rank_ok && clearance_ok;

    % 不合格方案不能参加正式Sensing排名
    if ~feasible
        worst_sigma = NaN;
    end

    result = struct();

    result.geometry_pass = geometry_pass;
    result.rank_pass = rank_pass;

    result.min_angle = min_angle;

    result.min_cable_distance = ...
        min_cable_distance;

    result.clearance_ok = clearance_ok;

    result.feasible = feasible;
    result.sigma = worst_sigma;

end
