
%% B5.4 E2 Lesson 2.4
% Optimisation Protocol & Angle-Tie Correction
%
% 目的：
% 1. 修正Lesson 2.3的最大角度候选选择
% 2. 冻结Sensing和Margin-Preserving两条优化路线
% 3. 记录一致的搜索预算
%
% 本节不执行新的几何搜索。

clear; clc;

%% Step 1 — 读取上一节结果

data = load( ...
    'B5_4_E2_attachment_local_sensitivity.mat');

pareto_data = load( ...
    'B5_4_E2_attachment_pareto_diagnosis.mat');

T = data.T_trials;

summary = pareto_data.T_pareto_summary;

Design = string(summary.Design);

assert(height(T)==384);
assert(numel(Design)==4);

%% Step 2 — 修正最大Angle的代表候选

% 对于近似相同的最大出线角，
% 选择其中WorstCoreSigma更高的设计。
%
% 角度容差仅用于处理数值并列，
% 不是物理安全裕量。
angle_tie_tol = 1e-6;

BestAngle_deg = nan(4,1);
BestAngleSigma = nan(4,1);

BestAngleCable = nan(4,1);
BestAngleAlpha = nan(4,1);
BestAngleBeta = nan(4,1);

for d = 1:4

    Td = T( ...
        T.DesignID==d & T.FullEligible,:);

    assert(~isempty(Td));

    % 找到该组测试中最大的出线角
    max_angle = max(Td.MinAngle_deg);

    % 允许数值意义上近似相同的角度
    ties = Td( ...
        Td.MinAngle_deg>= ...
        max_angle-angle_tie_tol,:);

    % 并列时选择最高Sensing
    [~,idx] = max(ties.WorstCoreSigma);

    chosen = ties(idx,:);

    BestAngle_deg(d) = ...
        chosen.MinAngle_deg;

    BestAngleSigma(d) = ...
        chosen.WorstCoreSigma;

    BestAngleCable(d) = chosen.CableID;
    BestAngleAlpha(d) = chosen.Alpha_deg;
    BestAngleBeta(d) = chosen.Beta_deg;

end

%% Step 3 — 输出修正结果

T_corrected = table( ...
    Design, ...
    BestAngleCable, ...
    BestAngleAlpha, ...
    BestAngleBeta, ...
    BestAngle_deg, ...
    BestAngleSigma);

fprintf('\n--- Corrected Angle-Priority Candidates ---\n');

disp(T_corrected);

%% Step 4 — 冻结E2优化协议

protocol = struct();

protocol.name = ...
    'E2 Two-Track Attachment Optimisation';

protocol.designs = Design;

protocol.tracks = ...
    ["SensingPriority"; ...
     "MarginPreservingSensing"];

protocol.variable = ...
    'Six attachment positions on sphere';

protocol.fixed = ...
    'Anchors, rail assignment, cable pairing';

protocol.n_core_poses = 189;

% 每个Sweep的设计
protocol.n_sweeps = 2;
protocol.n_cables = 6;
protocol.n_amplitudes = 2;
protocol.n_directions = 8;

protocol.trials_per_sweep = ...
    protocol.n_cables * ...
    protocol.n_amplitudes * ...
    protocol.n_directions;

protocol.trials_per_track = ...
    protocol.trials_per_sweep * ...
    protocol.n_sweeps;

% 四组设计，两条Track
protocol.total_trial_evaluations = ...
    4*2*protocol.trials_per_track;

% Core中必须全部通过
protocol.required_geometry_pass = 189;
protocol.required_rank_pass = 189;

% 继续使用共同的探索性Cable距离下限
protocol.clearance_floor_mm = 4.650751;

% Attachment spacing继续采用
% 各设计自身的Baseline最低间距
protocol.spacing_rule = ...
    'No decrease below own baseline minimum chord';

% Track M另外要求不降低原Core最小出线角
protocol.margin_rule = ...
    'Min outward angle >= own baseline Core angle';

% 位置扰动参数：
% 第一轮使用2°和5°
% 第二轮细化幅度将在正式搜索代码中明确
protocol.first_sweep_angles_deg = [2 5];

protocol.directions_deg = 0:45:315;

% 统一数值比较容差
protocol.improvement_tol = 1e-8;
protocol.angle_tie_tol = angle_tie_tol;

assert(protocol.trials_per_sweep==96);

assert(protocol.trials_per_track==192);

assert(protocol.total_trial_evaluations==1536);

%% Step 5 — 保存协议

save( ...
    'B5_4_E2_optimisation_protocol.mat', ...
    'protocol','T_corrected');

writetable(T_corrected, ...
    'B5_4_E2_corrected_angle_candidates.csv');

fprintf('\n--- E2 Optimisation Protocol ---\n');

fprintf('Designs: %d\n', ...
    numel(protocol.designs));

fprintf('Tracks: %d\n', ...
    numel(protocol.tracks));

fprintf('Trials per Track: %d\n', ...
    protocol.trials_per_track);

fprintf('Total Trial Evaluations: %d\n', ...
    protocol.total_trial_evaluations);

fprintf('\nPASS: E2 optimisation protocol saved.\n');

