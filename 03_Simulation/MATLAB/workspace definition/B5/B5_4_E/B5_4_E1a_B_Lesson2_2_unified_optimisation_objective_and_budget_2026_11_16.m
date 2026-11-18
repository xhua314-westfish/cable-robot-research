
%% B5.4 E1a-B Lesson 2.2
% Unified Optimisation Objective and Budget
%
% Research Question:
% 如何为六组配置建立公平的优化目标和搜索预算？
%
% 本节目标：
% 1. 定义六组配置共同的优化变量
% 2. 定义统一的几何硬约束
% 3. 定义主要Sensing优化目标
% 4. 定义相同的计算预算
% 5. 保存优化协议
%
% 注意：
% 本节不执行优化。
% 只定义后续所有配置必须共同遵守的规则。

clear; clc;

%% Step 1 — 加载已验证数据

data = load( ...
    'B5_4_unified_evaluation_baseline.mat');

base = load( ...
    'B5_4_E1a_B_baseline_results.mat');

settings = data.settings;

config_ids = [2 4 6 8 12 17];

assert(numel(config_ids)==6);

% 确认基线表与配置编号一致
T = base.T_baseline;

assert(isequal(T.ConfigID(:)',config_ids));

%% Step 2 — 定义固定参数

protocol = struct();

protocol.config_ids = config_ids;

% Balloon半径
protocol.rb = settings.rb;

% 六根Cable
protocol.n_cables = 6;

% Core位姿数量
protocol.N_core = size(data.P_all,1);

assert(protocol.N_core==189);

% 每组保留原始Rail IDs、Attachment和Pairing
protocol.fixed_rail_ids = true;

protocol.fixed_attachment = true;

protocol.fixed_pairing = true;

%% Step 3 — 定义优化变量

% 每个Config只优化六个Rail Position
protocol.variable = 'rail_position_t';

protocol.n_variables = 6;

% t_i的允许范围
protocol.t_lower = zeros(1,6);
protocol.t_upper = ones(1,6);

%% Step 4 — 定义统一的硬约束

% Core 189姿态必须全部几何可行
protocol.require_all_geometry = true;

% Jacobian必须全部满秩
protocol.require_rank_6 = true;

% 保留原有数值接触判据
protocol.contact_tol = settings.contact_tol;

% 球面出线数值判据
protocol.sphere_tol = settings.sphere_tol;

% 共同Cable间距基线
protocol.clearance_floor_mm = ...
    min(T.MinCableDistance);

assert(protocol.clearance_floor_mm>0);

% 基线间距的显示值只是近似
fprintf('Clearance floor: %.6f mm\n', ...
    protocol.clearance_floor_mm);

% 这是研究阶段临时基线保持约束，
% 不是实际Cable的机械安全距离。
protocol.physical_clearance_verified = false;

%% Step 5 — 定义优化目标

% 主要目标：
% Maximise minimum scaled singular value
% over all 189 Core poses.

protocol.objective = ...
    'maximise_worst_core_sigma_min';

% 记录其他指标，但暂不加权
protocol.secondary_metrics = { ...
    'minimum_cable_distance', ...
    'minimum_outward_angle', ...
    'maximum_condition_number', ...
    'maximum_cable_stroke'};

%% Step 6 — 定义统一搜索预算

% 第一轮采用顺序坐标搜索
protocol.algorithm = 'sequential_coordinate_search';

% 六组Config每组使用相同预算
protocol.max_trial_evaluations = 120;

% 每组从各自原始B5.3配置开始
protocol.initialisation = ...
    'original_B5_3_configuration';

% 禁止把历史Config2手动修复结果
% 作为本次公平搜索的起点
protocol.use_historical_repair = false;

% 固定实验随机种子
% 如果后续搜索是完全确定性的，
% 则此种子不会影响搜索结果。
protocol.random_seed = 42;

%% Step 7 — 检查原始配置满足新规则

% 数据中的Baseline已经通过Geometry与Rank
assert(all(T.GeometryPass==189));

assert(all(T.RankPass==189));

% 原始六组间距应满足共同阈值
assert(all( ...
    T.MinCableDistance >= ...
    protocol.clearance_floor_mm-1e-10));

fprintf('\n--- Fair Optimisation Protocol ---\n');

fprintf('Configurations: %s\n', ...
    mat2str(config_ids));

fprintf('Variable count: %d\n', ...
    protocol.n_variables);

fprintf('Core poses: %d\n', ...
    protocol.N_core);

fprintf('Objective: %s\n', ...
    protocol.objective);

fprintf('Maximum trials per Config: %d\n', ...
    protocol.max_trial_evaluations);

fprintf('Historical repair used: %d\n', ...
    protocol.use_historical_repair);

%% Step 8 — 保存协议

save('B5_4_E1a_B_optimisation_protocol.mat', ...
    'protocol','config_ids');

fprintf('\nOptimisation protocol saved.\n');
