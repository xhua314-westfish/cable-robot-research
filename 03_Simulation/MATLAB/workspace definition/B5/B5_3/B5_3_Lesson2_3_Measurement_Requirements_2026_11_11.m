%% B5.3 Lesson 2.3
% Measurement Requirements and Acceptance Criteria
%
% Research Question:
% What performance must the six-cable sensing system achieve?
%
% Objectives:
% 1. Define measurable research requirements
% 2. Separate current criteria from unknown specifications
% 3. Avoid inventing sensor or hardware performance values
% 4. Build a reusable requirements database
% 5. Save requirements for B5.3-B5.6
%
% IMPORTANT:
% This script defines REQUIREMENTS, not measured results.
% TBD values must not be reported as verified performance.

%% Step 1: Load established geometry assumptions

% 读取之前完成的12导轨模型
load('B5_3_12rail_geometry_baseline.mat', ...
    'Lg','Wg','Hg','rb', ...
    'rail_start','rail_end');

assert(size(rail_start,1)==12);
assert(size(rail_end,1)==12);

fprintf('\n--- B5.3 Measurement Requirements ---\n');
fprintf('Frame dimensions: %g x %g x %g mm\n', ...
    Lg,Wg,Hg);

fprintf('Balloon radius: %.4f mm\n',rb);
fprintf('Cable count: 6\n');

%% Step 2: Define evaluation workspace
%
% 与B5.2保持一致。
% 这些属于暂定工程采样范围，
% 不是临床验证的运动边界。

requirements = struct();

requirements.core_position_mm = [-20 0 20];

requirements.core_rotation_deg = [
    0  0  0;
    5  0  0;
    -5  0  0;
    0  5  0;
    0 -5  0;
    0  0  5;
    0  0 -5
    ];

requirements.benchmark_position_mm = [-50 0 50];

requirements.benchmark_rotation_deg = [
    0   0   0;
    10   0   0;
    -10   0   0;
    0  10   0;
    0 -10   0;
    0   0  10;
    0   0 -10
    ];

N_core = numel(requirements.core_position_mm)^3 ...
    * size(requirements.core_rotation_deg,1);

N_benchmark = numel(requirements.benchmark_position_mm)^3 ...
    * size(requirements.benchmark_rotation_deg,1);

assert(N_core==189);
assert(N_benchmark==189);

%% Step 3: Define requirement IDs and descriptions
%
% 每一项需求必须明确：
% ID、Name、Metric、Unit、Target、Status、Method
%
% Target中使用NaN表示尚未确定的数值指标。
% 不要把NaN替换为没有依据的工程标准。

ID = ["R01";"R02";"R03";"R04";"R05";"R06"; ...
    "R07";"R08";"R09";"R10";"R11";"R12"; ...
    "R13";"R14"];

Name = [
    "Rigid pose estimation";
    "Core geometric feasibility";
    "Position RMSE";
    "Orientation RMSE";
    "Maximum pose error";
    "Local observability";
    "Physical cable clearance";
    "Rail mountability";
    "Cable stroke";
    "Low-tension operation";
    "Reconstruction reliability";
    "Measurement update rate";
    "Installation robustness";
    "Independent ground truth"
    ];

Metric = [
    "6-DOF reconstruction capability";
    "Passing sampled Core poses";
    "3D position RMSE";
    "SO(3) geodesic angle RMSE";
    "Maximum position/orientation errors";
    "Rank of scaled Jacobian";
    "Minimum physical cable clearance";
    "Number of off-rail anchors";
    "Maximum cable length variation";
    "Tension and balloon disturbance";
    "Estimator failure rate";
    "Estimated poses per second";
    "Sensitivity to mounting errors";
    "Independent pose measurement accuracy"
    ];

Unit = [
    "Boolean";
    "poses";
    "mm";
    "degree";
    "mm / degree";
    "rank";
    "mm";
    "count";
    "mm";
    "N / disturbance";
    "percent";
    "Hz";
    "multiple";
    "mm / degree"
    ];

% 数值要求
% NaN = 当前还没有被合理确定
%
% R02: 暂定Core中所有189个姿态通过几何检查
% R06: 六自由度局部可观测要求Rank=6
% R08: 所有Anchor必须在Rails上，离轨数=0

NumericTarget = [
    NaN;
    189;
    NaN;
    NaN;
    NaN;
    6;
    NaN;
    0;
    NaN;
    NaN;
    NaN;
    NaN;
    NaN;
    NaN
    ];

% Requirement status
% Defined = 指标定义明确
% Provisional = 暂定目标
% TBD = 数值或方案尚待确定
%
% 这里不使用Verified，
% 因为尚未验证新的12导轨候选配置。

Status = [
    "Defined";
    "Provisional";
    "TBD";
    "TBD";
    "TBD";
    "Defined";
    "TBD";
    "Defined";
    "TBD";
    "TBD";
    "TBD";
    "TBD";
    "TBD";
    "TBD"
    ];

%% Step 4: Define evaluation procedures

Method = [
    "Noise-free nonlinear pose reconstruction";
    "189 Core poses and geometric checks";
    "Independent ground-truth pose comparison";
    "Relative rotation matrix angle";
    "Worst-case errors on held-out poses";
    "SVD of scaled measurement Jacobian";
    "Finite cable diameter and clearance model";
    "Point-to-rail geometric verification";
    "Cable length range over evaluation poses";
    "Tension and passive motion experiments";
    "Record divergence and failed estimates";
    "Timing on intended processing hardware";
    "Mounting parameter perturbation study";
    "External pose tracking or reference system"
    ];

%% Step 5: Build requirements table

T_requirements = table( ...
    ID,Name,Metric,Unit,NumericTarget,Status,Method);

assert(height(T_requirements)==14);

% Requirement ID不允许重复
assert(numel(unique(T_requirements.ID))==14);

% 确认必要描述字段不为空
assert(all(strlength(T_requirements.Name)>0));
assert(all(strlength(T_requirements.Metric)>0));
assert(all(strlength(T_requirements.Unit)>0));
assert(all(strlength(T_requirements.Method)>0));

fprintf('\n--- Requirement Matrix ---\n');
disp(T_requirements);

%% Step 6: Define engineering assumptions
%
% 以下属于本阶段已经确定的研究方向，
% 不是已经验证的硬件能力。

requirements.system_mode = ...
    "Passive sensing";

requirements.balloon_model = ...
    "Rigid sphere - initial model";

requirements.cable_number = 6;

requirements.mounting_model = ...
    "Twelve frame-edge rails";

requirements.guide_concept = ...
    "Fixed guidance preferred for V1";

requirements.effective_exit_model = ...
    "Ideal fixed effective anchor - provisional";

requirements.tension_concept = ...
    "Low positive tension, nonintrusive";

requirements.measurement_primary = ...
    "Cable length";

requirements.deformation_estimation = ...
    "Future research";

%% Step 7: Define numerical geometry conventions
%
% 以下两个数值是沿用B5.2的数值判据。
% 它们不是实际硬件的安全净空。

requirements.sphere_tolerance_mm2 = 1e-6;

requirements.cable_contact_tolerance_mm = 1e-6;

requirements.core_geometry_target = 189;

requirements.local_rank_target = 6;

requirements.rail_off_boundary_target = 0;

% 真实硬件参数仍未知
requirements.cable_diameter_mm = NaN;
requirements.physical_clearance_mm = NaN;

requirements.length_noise_sd_mm = NaN;
requirements.length_zero_bias_mm = NaN;

requirements.position_rmse_target_mm = NaN;
requirements.orientation_rmse_target_deg = NaN;

requirements.tension_min_N = NaN;
requirements.tension_max_N = NaN;

requirements.update_rate_Hz = NaN;

%% Step 8: Validate requirements consistency

assert(requirements.core_geometry_target==N_core);
assert(requirements.local_rank_target==6);

% 未知指标必须保持为NaN
assert(isnan(requirements.position_rmse_target_mm));

assert(isnan(requirements.orientation_rmse_target_deg));

assert(isnan(requirements.cable_diameter_mm));

assert(isnan(requirements.tension_max_N));

% 确认已定义的数值目标
defined_mask = ~isnan(T_requirements.NumericTarget);

fprintf('\n--- Requirements Status ---\n');

fprintf('Total requirements: %d\n', ...
    height(T_requirements));

fprintf('Numerically specified targets: %d\n', ...
    sum(defined_mask));

fprintf('Unspecified numerical targets: %d\n', ...
    sum(~defined_mask));

fprintf('Core geometry target: %d / %d\n', ...
    requirements.core_geometry_target,N_core);

fprintf('Local Jacobian rank target: %d\n', ...
    requirements.local_rank_target);

%% Step 9: Save for future research
%
% 将需求矩阵保存为MAT和CSV两种格式。
%
% MAT供后续MATLAB读取。
% CSV方便检查和同步到GitHub。
%
% 此处不会修改之前的仿真结果。

save('B5_3_measurement_requirements.mat', ...
    'requirements','T_requirements');

writetable(T_requirements, ...
    'B5_3_measurement_requirements.csv');

fprintf('\nMeasurement requirements saved.\n');

fprintf('B5.3 Lesson 2.3 completed.\n');