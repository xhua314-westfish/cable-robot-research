
%% B5.4 E2 Lesson 2.3
% Attachment Pareto Analysis & Failure Diagnosis
%
% 研究问题：
% 哪些单Attachment扰动同时具有较好的
% Sensing和Outward Departure Margin？
%
% 不执行新优化，不修改任何Attachment。
% 使用Lesson 2.2保存的384次扫描结果。
%
% 注意：
% Pareto只考虑两个目标：
% 1. Core worst sigma_min
% 2. Core minimum outward angle
%
% Cable clearance和Attachment spacing仍为硬约束。

clear; clc; close all;

%% Step 1 — 读取历史结果

scan = load( ...
    'B5_4_E2_attachment_local_sensitivity.mat');

base = load( ...
    'B5_4_E2_attachment_baselines.mat');

core = load( ...
    'B5_4_unified_evaluation_baseline.mat', ...
    'P_all','R_all','settings');

T = scan.T_trials;

Design = string(base.T_attachment.Design);

N_design = numel(Design);

assert(N_design==4);
assert(height(T)==384);

%% Step 2 — 初始化汇总表

GeometryFail = zeros(N_design,1);
RankFail = zeros(N_design,1);

ClearanceFail = zeros(N_design,1);
SpacingFail = zeros(N_design,1);

FullPass = zeros(N_design,1);

ParetoCount = zeros(N_design,1);

BestSensingSigma = nan(N_design,1);
BestSensingAngle = nan(N_design,1);

BestAngleSigma = nan(N_design,1);
BestAngle_deg = nan(N_design,1);

BaselineAngle_deg = nan(N_design,1);

% 保存每个配置的Pareto候选
pareto_tables = cell(N_design,1);

%% Step 3 — 循环四个设计

for d = 1:N_design

    idx = find(T.DesignID==d);

    assert(numel(idx)==96);

    Td = T(idx,:);

    % 四类失败原因可能重叠，
    % 不能直接把它们相加当作失败总数。

    GeometryFail(d) = sum( ...
        Td.GeometryPass<189);

    RankFail(d) = sum( ...
        Td.RankPass<189);

    ClearanceFail(d) = sum( ...
        ~Td.ClearanceEligible);

    SpacingFail(d) = sum( ...
        ~Td.SpacingEligible);

    FullPass(d) = sum(Td.FullEligible);

    %% Step 3.1 — 计算原始设计Core出线角度

    cfg = base.e2_baselines{d};

    A = cfg.A_fixed;
    r = cfg.r_initial;

    rb = core.settings.rb;

    min_angle = inf;

    for k = 1:189

        P = core.P_all(k,:);
        R = core.R_all(:,:,k);

        S = (R*r')';
        B = S+P;

        D = A-B;
        L = vecnorm(D,2,2);

        angle_sine = sum(S.*D,2)./(rb*L);

        angle_sine = max( ...
            -1,min(1,angle_sine));

        min_angle = min( ...
            min_angle,min(asind(angle_sine)));

    end

    BaselineAngle_deg(d) = min_angle;

    %% Step 3.2 — 提取满足全部约束的扰动

    feasible = Td(Td.FullEligible,:);

    assert(height(feasible)==FullPass(d));

    if isempty(feasible)
        continue;
    end

    sigma = feasible.WorstCoreSigma;
    angle = feasible.MinAngle_deg;

    assert(all(isfinite(sigma)));
    assert(all(isfinite(angle)));

    %% Step 3.3 — Pareto非支配筛选

    n = numel(sigma);

    dominated = false(n,1);

    % 防止浮点数导致虚假的支配关系
    tol_sigma = 1e-9;
    tol_angle = 1e-8;

    for i = 1:n

        for j = 1:n

            if i==j
                continue;
            end

            % j在两个指标上都不劣于i
            no_worse = ...
                sigma(j)>=sigma(i)-tol_sigma && ...
                angle(j)>=angle(i)-tol_angle;

            % j至少在一个指标上严格更好
            strictly_better = ...
                sigma(j)>sigma(i)+tol_sigma || ...
                angle(j)>angle(i)+tol_angle;

            if no_worse && strictly_better

                dominated(i) = true;
                break;

            end

        end

    end

    pareto = feasible(~dominated,:);

    % 当前Pareto仅来自已测试离散点，
    % 不是连续Attachment空间的真实Pareto前沿。
    pareto_tables{d} = pareto;

    ParetoCount(d) = height(pareto);

    %% Step 3.4 — 找出Sensing优先的候选

    [BestSensingSigma(d),idx_best] = ...
        max(feasible.WorstCoreSigma);

    BestSensingAngle(d) = ...
        feasible.MinAngle_deg(idx_best);

    %% Step 3.5 — 找出Outward Angle优先候选

    [BestAngle_deg(d),idx_angle] = ...
        max(feasible.MinAngle_deg);

    BestAngleSigma(d) = ...
        feasible.WorstCoreSigma(idx_angle);

    %% Step 3.6 — 显示当前配置的Pareto结果

    fprintf('\n============================\n');
    fprintf('%s\n',Design(d));

    fprintf('Valid trials: %d/96\n', ...
        FullPass(d));

    fprintf('Geometry failures: %d\n', ...
        GeometryFail(d));

    fprintf('Clearance failures: %d\n', ...
        ClearanceFail(d));

    fprintf('Attachment spacing failures: %d\n', ...
        SpacingFail(d));

    fprintf('Pareto candidates: %d\n', ...
        ParetoCount(d));

    disp(pareto(:,{ ...
        'CableID','Alpha_deg','Beta_deg', ...
        'WorstCoreSigma','MinAngle_deg', ...
        'MinCableDistance_mm', ...
        'MinAttachmentDistance_mm'}));

end

%% Step 4 — 生成对比表

T_pareto_summary = table( ...
    Design, ...
    GeometryFail,RankFail, ...
    ClearanceFail,SpacingFail, ...
    FullPass,ParetoCount, ...
    BaselineAngle_deg, ...
    BestSensingSigma,BestSensingAngle, ...
    BestAngleSigma,BestAngle_deg);

fprintf('\n====================================\n');
fprintf('E2 Pareto & Failure Diagnosis Summary\n');
fprintf('====================================\n');

disp(T_pareto_summary);

%% Step 5 — 检查数据完整性

assert(all(FullPass>=0 & FullPass<=96));

assert(all(ParetoCount<=FullPass));

assert(sum(FullPass)==sum( ...
    scan.T_summary.EligibleTrials));

fprintf('\nTotal valid trial count: %d/384\n', ...
    sum(FullPass));

fprintf('PASS: Pareto classification verified.\n');

%% Step 6 — 绘制Sensing-Angle散点图

figure('Color','w', ...
    'Name','E2 Attachment Pareto Analysis', ...
    'Position',[100 100 1100 700]);

for d = 1:N_design

    subplot(2,2,d);

    idx = T.DesignID==d & T.FullEligible;

    scatter( ...
        T.MinAngle_deg(idx), ...
        T.WorstCoreSigma(idx), ...
        22,'filled');

    hold on;

    if ~isempty(pareto_tables{d})

        Tp = pareto_tables{d};

        scatter( ...
            Tp.MinAngle_deg, ...
            Tp.WorstCoreSigma, ...
            70,'o','LineWidth',1.5);

    end

    xlabel('Minimum Outward Angle (deg)');
    ylabel('Worst Core Sigma');

    title(Design(d));
    grid on;

    legend( ...
        {'Valid trials','Pareto candidates'}, ...
        'Location','best');

end

%% Step 7 — 保存

save( ...
    'B5_4_E2_attachment_pareto_diagnosis.mat', ...
    'T_pareto_summary', ...
    'pareto_tables','Design');

writetable(T_pareto_summary, ...
    'B5_4_E2_attachment_pareto_summary.csv');

for d = 1:N_design

    if ~isempty(pareto_tables{d})

        filename = sprintf( ...
            'B5_4_E2_pareto_design_%d.csv',d);

        writetable(pareto_tables{d},filename);

    end

end

fprintf('\nE2 Lesson 2.3 completed.\n');
