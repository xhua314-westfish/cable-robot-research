
%% B5.4 E1a-B Lesson 2.6
% Candidate Shortlisting and Research Decisions
%
% 研究问题：
% 根据Sensing、539-pose几何和安装扰动，
% 哪些配置应该保留进入下一轮优化？
%
% 注意：
% 本节不重新优化，也不直接确定最终Prototype。

clear; clc;

%% Step 1 — 加载三个实验的数据

opt = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

rob = load( ...
    'B5_4_E1a_B_539pose_robustness.mat');

inst = load( ...
    'B5_4_E1a_B_installation_robustness.mat');

T_opt = opt.T_comparison;
T_rob = rob.T_robustness;
T_inst = inst.T_installation;

%% Step 2 — 检查三张表配置顺序一致

ConfigID = T_opt.ConfigID;

assert(isequal(ConfigID,T_rob.ConfigID));
assert(isequal(ConfigID,T_inst.ConfigID));

N_config = numel(ConfigID);
assert(N_config==6);

%% Step 3 — 提取共同指标

CoreSigma = T_opt.OptimisedSigma;

DevGeometryPass = T_rob.GeometryPass;
DevRankPass = T_rob.RankPass;

MinAngle_deg = T_rob.MinAngle_deg;
MinDistance_mm = T_rob.MinDistance_mm;

RailEnd_mm = T_rob.MinRailEnd_mm;

PerturbationPass = T_inst.PerturbationPass;
OffRailCount = T_inst.OffRailCount;

%% Step 4 — 定义两级筛选条件

% Level 1：名义配置全部539姿态通过
NominalEligible = ...
    DevGeometryPass==539 & ...
    DevRankPass==539;

% Level 2：在Level 1基础上，
% 12次单Anchor安装扰动全部通过
PerturbationEligible = ...
    NominalEligible & ...
    PerturbationPass==12;

% 当前不把"角度大于某个任意阈值"
% 作为硬约束，因为尚无实测依据。

%% Step 5 — 分配研究状态

Decision = strings(N_config,1);

for i = 1:N_config

    if PerturbationEligible(i)

        Decision(i) = "Retain - robust pilot";

    elseif NominalEligible(i)

        Decision(i) = "Retain - repair needed";

    else

        Decision(i) = "Repair / benchmark";

    end

end

%% Step 6 — 生成决策表

T_decision = table( ...
    ConfigID, ...
    CoreSigma, ...
    DevGeometryPass, ...
    PerturbationPass, ...
    OffRailCount, ...
    MinAngle_deg, ...
    MinDistance_mm, ...
    RailEnd_mm, ...
    NominalEligible, ...
    PerturbationEligible, ...
    Decision);

fprintf('\n--- E1a-B Candidate Decision Table ---\n');

disp(T_decision);

%% Step 7 — 提取下一轮候选

robust_ids = ...
    ConfigID(PerturbationEligible);

repair_ids = ...
    ConfigID(NominalEligible & ...
    ~PerturbationEligible);

benchmark_ids = ...
    ConfigID(~NominalEligible);

fprintf('\n--- Research Decisions ---\n');

fprintf('Robust pilot candidates: %s\n', ...
    mat2str(robust_ids'));

fprintf('Repair candidates: %s\n', ...
    mat2str(repair_ids'));

fprintf('Repair / benchmark: %s\n', ...
    mat2str(benchmark_ids'));

%% Step 8 — 验证本轮数据结论

% 基于你目前实际输出的回归检查
assert(isequal(robust_ids(:)',[8 12]));

assert(isequal(repair_ids(:)',[4 6 17]));

assert(isequal(benchmark_ids(:)',2));

fprintf('\nPASS: Candidate classification verified.\n');

%% Step 9 — 保存研究决策

save('B5_4_E1a_B_candidate_decision.mat', ...
    'T_decision', ...
    'robust_ids','repair_ids','benchmark_ids');

writetable(T_decision, ...
    'B5_4_E1a_B_candidate_decision.csv');

fprintf('Candidate decision saved.\n');
