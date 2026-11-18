%% B5.4 E1a-B Lesson 1
% Six-Configuration Baseline Verification
%
% 研究问题：
% 能否复现六组原始配置，并验证评价结果的一致性？
%
% 本节目标：
% 1. 读取 B5.3 和 B5.4 历史数据
% 2. 选择六组 Core-eligible 配置
% 3. 核对 Rail、Anchor、Attachment、Pairing
% 4. 对比原始 Geometry、Rank、Sensing 结果
% 5. 生成 Baseline Comparison Table
%
% 注意：
% 本节不进行任何优化！
% 不修改原始配置，也不覆盖历史数据。

clear;
clc;
close all;

%% Step 1 — 定义数据文件路径

% 当前文件夹应为 B5_4
folder_B54 = pwd;

% B5_3 和 B5_4 位于同一级目录
folder_B5 = fileparts(folder_B54);
folder_B53 = fullfile(folder_B5, 'B5_3');

file_config = fullfile(folder_B53, ...
    'B5_3_initial_six_cable_configurations.mat');

file_screening = fullfile(folder_B53, ...
    'B5_3_early_multipose_screening.mat');

file_unified = fullfile(folder_B54, ...
    'B5_4_unified_evaluation_baseline.mat');

% 检查三个文件是否存在
assert(isfile(file_config), ...
    'Missing B5.3 configuration data');

assert(isfile(file_screening), ...
    'Missing B5.3 screening data');

assert(isfile(file_unified), ...
    'Missing B5.4 unified evaluation data');

%% Step 2 — 读取历史数据

% 原始18组配置
original = load(file_config, ...
    'best_configs', 'rb');

% B5.3 多位姿筛选结果
screening_data = load(file_screening, ...
    'screening', 'P_all', 'R_all');

% B5.4 统一评价结果
unified = load(file_unified, ...
    'best_configs', 'new_results', ...
    'eligibility_set', 'settings', ...
    'P_all', 'R_all');

%% Step 3 — 选择六组配置

config_ids = [2 4 6 8 12 17];

N = numel(config_ids);

% 检查原始数据是否完整
assert(numel(original.best_configs) == 18);
assert(numel(screening_data.screening) == 18);
assert(numel(unified.new_results) == 18);

% 检查六组配置与B5.4记录一致
assert(isequal( ...
    sort(unified.eligibility_set(:))', ...
    config_ids));

% 检查189个Core位姿完全相同
assert(size(screening_data.P_all,1) == 189);

assert(isequal( ...
    screening_data.P_all, unified.P_all));

assert(isequal( ...
    screening_data.R_all, unified.R_all));

% 检查Balloon半径
rb = original.rb;

assert(abs(rb-unified.settings.rb) < 1e-10);

fprintf('\n--- E1a-B Lesson 1 ---\n');
fprintf('Selected configurations: %s\n', ...
    mat2str(config_ids));

fprintf('Core poses: 189\n');
fprintf('Balloon radius: %.4f mm\n', rb);

%% Step 4 — 初始化结果表

ConfigID = config_ids(:);

Family = strings(N,1);

GeometryPass = zeros(N,1);
RankPass = zeros(N,1);

WorstSigma = zeros(N,1);
WorstKappa = zeros(N,1);

MinCableDistance = zeros(N,1);
MaxStroke = zeros(N,1);

%% Step 5 — 逐一检查六组配置
for j = 1 : N

      id = config_ids(j);

    % 获取原始Config
    cfg = original.best_configs(id);

    % 获取B5.4保存的同一Config
    cfg_check = unified.best_configs(id);

    % B5.3原始评价结果
    old_result = screening_data.screening{id};

    % B5.4统一评价结果
    new_result = unified.new_results{id};

    %% 5.1 检查配置本身是否一致

    assert(cfg.found);
    assert(cfg_check.found);

    % Rail IDs必须一致
    assert(isequal( ...
        cfg.rail_ids, cfg_check.rail_ids));

    % Rail Positions必须一致
    assert(max(abs( ...
        cfg.t(:)-cfg_check.t(:))) < 1e-12);

    % Anchor坐标必须一致
    assert(max(abs( ...
        cfg.A(:)-cfg_check.A(:))) < 1e-10);

    % Attachment坐标必须一致
    assert(max(abs( ...
        cfg.r(:)-cfg_check.r(:))) < 1e-10);

    % Pairing必须一致
    assert(isequal( ...
        cfg.pairing, cfg_check.pairing));

    %% 5.2 检查配置尺寸

    assert(isequal(size(cfg.A), [6 3]));
    assert(isequal(size(cfg.r), [6 3]));

    % 六个Rail位置参数应在[0,1]
    assert(all(cfg.t(:)>=0));
    assert(all(cfg.t(:)<=1));

    % 六个Attachment必须在球面上
    radius_error = max(abs( ...
        vecnorm(cfg.r,2,2)-rb));

    assert(radius_error < 1e-8);

    % Pairing应是1至6的一个排列
    assert(isequal( ...
        sort(cfg.pairing(:))', 1:6));

    %% 5.3 检查两次评价是否一致

    % Geometry判定
    assert(isequal( ...
        old_result.geometry_safe, ...
        new_result.geometry_safe));

    % Jacobian Rank
    assert(isequal( ...
        old_result.rank_all, ...
        new_result.rank_all));

    % Minimum Singular Value
    sigma_error = max(abs( ...
        old_result.sigma_min_all - ...
        new_result.sigma_min_all));

    assert(isfinite(sigma_error));
    assert(sigma_error < 1e-8);

    % Condition Number
    kappa_error = max(abs( ...
        old_result.kappa_all - ...
        new_result.kappa_all));

    assert(isfinite(kappa_error));
    assert(kappa_error < 1e-6);

    % Cable-Cable Distance
    distance_error = max(abs( ...
        old_result.distances(:) - ...
        new_result.distances(:)));

    assert(distance_error < 1e-8);

    % Cable Length
    length_error = max(abs( ...
        old_result.L_all(:) - ...
        new_result.L_all(:)));

    assert(length_error < 1e-8);

    %% 5.4 统计Core结果

    GeometryPass(j) = sum( ...
        new_result.geometry_safe);

    RankPass(j) = sum( ...
        new_result.geometry_safe & ...
        new_result.rank_all==6);

    % 这里六组全部Core可行，
    % 因此使用同一189位姿计算最差Sensing
    WorstSigma(j) = min( ...
        new_result.sigma_min_all);

    WorstKappa(j) = max( ...
        new_result.kappa_all);

    % 最小Cable-Cable距离
    MinCableDistance(j) = min( ...
        new_result.distances(:));

    % 每根Cable的长度变化范围
    stroke_each = ...
        max(new_result.L_all,[],1) - ...
        min(new_result.L_all,[],1);

    % 取六根Cable中最大的行程需求
    MaxStroke(j) = max(stroke_each);

    Family(j) = string(old_result.name);

    %% 5.5 检查Core资格

    assert(GeometryPass(j)==189);
    assert(RankPass(j)==189);

    %% 5.6 显示每根Cable的具体信息

    fprintf('\n============================\n');
    fprintf('Configuration %d\n', id);
    fprintf('%s\n', Family(j));

    CableID = (1:6)';

    T_cables = table( ...
        CableID, ...
        cfg.rail_ids(:), ...
        cfg.t(:), ...
        cfg.A(:,1), ...
        cfg.A(:,2), ...
        cfg.A(:,3), ...
        cfg.r(:,1), ...
        cfg.r(:,2), ...
        cfg.r(:,3), ...
        'VariableNames', { ...
        'Cable','RailID','t', ...
        'Ax','Ay','Az', ...
        'rx','ry','rz'});

    disp(T_cables);

    fprintf('Original pairing: %s\n', ...
        mat2str(cfg.pairing));

    fprintf('Core geometry: %d/189\n', ...
        GeometryPass(j));

    fprintf('Core Rank-6: %d/189\n', ...
        RankPass(j));

end

%% Step 6 — 创建统一对比表

T_baseline = table( ...
    ConfigID, Family, ...
    GeometryPass, RankPass, ...
    WorstSigma, WorstKappa, ...
    MinCableDistance, MaxStroke);

fprintf('\n============================\n');
fprintf('E1a-B Baseline Comparison\n');
fprintf('============================\n');

disp(T_baseline);

%% Step 7 — 验证历史核心结果

% 以下是B5.3记录的原始Core结果
% 只作为回归核对，并非优化目标

expected_sigma = [ ...
    0.39671;
    0.20262;
    0.26844;
    0.22651;
    0.36627;
    0.27869 ];

assert(max(abs( ...
    WorstSigma-expected_sigma)) < 1e-4);

fprintf('\nPASS: All six baselines verified.\n');

%% Step 8 — 保存结果

% 创建新文件，不覆盖原始B5.3/B5.4数据
save('B5_4_E1a_B_baseline_results.mat', ...
    'T_baseline', 'config_ids');

writetable(T_baseline, ...
    'B5_4_E1a_B_baseline_results.csv');

fprintf('Baseline results saved successfully.\n');


