
%% B5.4 E2 Lesson 2.1
% Attachment Geometry Baseline & Constraint Audit
%
% Research Question:
% 四组入选设计的Attachment位置是否符合球面约束？
% 它们的最小安装间距分别是多少？
%
% 研究原则：
% 1. 固定Anchor坐标A
% 2. 固定Cable编号与Pairing
% 3. Attachment坐标r是后续优化变量
% 4. 本节仅检查，不执行优化

clear; clc; close all;

%% Step 1 — 加载已完成的E1b研究结果

data = load( ...
    'B5_4_E1b_expanded_pose_estimation.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

e1b = load( ...
    'B5_4_E1b_position_reoptimisation.mat');

e1a = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

% 四组此前估计实验所使用的设计
designs = data.designs;
Design = data.Design(:);

rb = base.settings.rb;

N_design = numel(designs);

assert(N_design==4);
assert(numel(Design)==4);

%% Step 2 — 明确每组设计的来源

% 三组E1b设计的Config ID和Candidate ID
target_pairs = [
    2  2;
    4  1;
    8 16
];

% 原E1a Config 12作为稳健性对照
idx12 = find( ...
    [e1a.results.config_id]==12);

assert(numel(idx12)==1);

% 保存配置来源
source_config = [2;4;8;12];
source_candidate = [2;1;16;NaN];

%% Step 3 — 初始化Attachment检查结果

SphereMaxError_mm = zeros(N_design,1);

MinChordDistance_mm = zeros(N_design,1);

MinSurfaceArc_mm = zeros(N_design,1);

MinAngularSpacing_deg = zeros(N_design,1);

ClosestCableA = zeros(N_design,1);
ClosestCableB = zeros(N_design,1);

% 保存完整的每组Cable间距
attachment_pair_tables = cell(N_design,1);

% 保存经过验证的完整配置
e2_baselines = cell(N_design,1);

% 六个Attachment共有15对
pairs = nchoosek(1:6,2);

assert(size(pairs,1)==15);

%% Step 4 — 循环四组配置

for d = 1:N_design

    A = designs{d}.A;
    r = designs{d}.r;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    %% 4.1 验证设计来源和Cable顺序

    if d<=3

        id = target_pairs(d,1);
        cid = target_pairs(d,2);

        match = find( ...
            e1b.T_optimisation.ConfigID==id & ...
            e1b.T_optimisation.CandidateID==cid);

        assert(numel(match)==1);

        original = ...
            e1b.optimised_candidates{match};

        % Anchor坐标应和此前完全一致
        assert(norm( ...
            A-original.A_final,'fro')<1e-8);

        % Attachment坐标已按Cable顺序配对
        assert(norm( ...
            r-original.r,'fro')<1e-8);

        rail_ids = original.rail_ids;
        t = original.t_final;
        pairing = original.pairing;

    else

        original = e1a.results(idx12);

        assert(norm( ...
            A-original.A_optimised,'fro')<1e-8);

        assert(norm( ...
            r-original.r,'fro')<1e-8);

        rail_ids = original.rail_ids;
        t = original.t_optimised;
        pairing = original.pairing;

    end

    %% 4.2 检查六个Attachment在球面上

    radii = vecnorm(r,2,2);

    radial_errors = abs(radii-rb);

    SphereMaxError_mm(d) = ...
        max(radial_errors);

    % 这里是数值一致性检查，
    % 不是实际Attachment安装公差
    assert(SphereMaxError_mm(d)<1e-5);

    %% 4.3 计算15对Attachment间距

    chord_distance = zeros(15,1);
    angular_spacing = zeros(15,1);
    surface_arc = zeros(15,1);

    for j = 1:15

        i1 = pairs(j,1);
        i2 = pairs(j,2);

        % 球面两点的三维直线距离（弦长）
        chord_distance(j) = ...
            norm(r(i1,:)-r(i2,:));

        % 两个半径向量的夹角
        cosine_value = dot( ...
            r(i1,:),r(i2,:)) / ...
            (norm(r(i1,:))*norm(r(i2,:)));

        cosine_value = max( ...
            -1,min(1,cosine_value));

        angular_spacing(j) = ...
            acosd(cosine_value);

        % 球面最短大圆弧长
        surface_arc(j) = ...
            rb*deg2rad(angular_spacing(j));

    end

    %% 4.4 找到最近的一对Attachment

    [min_chord,closest_id] = ...
        min(chord_distance);

    MinChordDistance_mm(d) = min_chord;

    MinSurfaceArc_mm(d) = ...
        min(surface_arc);

    MinAngularSpacing_deg(d) = ...
        min(angular_spacing);

    ClosestCableA(d) = ...
        pairs(closest_id,1);

    ClosestCableB(d) = ...
        pairs(closest_id,2);

    % 不允许两个Attachment数值上重合
    assert(min_chord>1e-8);

    %% 4.5 保存每对Attachment的数据

    T_pairs = table( ...
        pairs(:,1),pairs(:,2), ...
        chord_distance, ...
        surface_arc, ...
        angular_spacing, ...
        'VariableNames', ...
        {'CableA','CableB', ...
         'ChordDistance_mm', ...
         'SurfaceArc_mm', ...
         'AngularSpacing_deg'});

    attachment_pair_tables{d} = T_pairs;

    %% 4.6 保存E2初始设计

    cfg = struct();

    cfg.name = Design(d);

    % 后续E2固定A
    cfg.A_fixed = A;

    % 后续E2从当前r开始
    cfg.r_initial = r;

    % 保留原始Rail安装信息
    cfg.rail_ids = rail_ids;
    cfg.t_fixed = t;

    % 重要：
    % r_initial已经按Cable编号完成配对。
    % 这里的pairing只是历史来源记录，
    % 不能再次使用r(pairing,:)。
    cfg.pairing_history = pairing;

    e2_baselines{d} = cfg;

    %% 4.7 输出结果

    fprintf('\n============================\n');

    fprintf('%s\n',Design(d));

    fprintf('Sphere max error: %.3e mm\n', ...
        SphereMaxError_mm(d));

    fprintf('Minimum chord distance: %.4f mm\n', ...
        MinChordDistance_mm(d));

    fprintf('Minimum surface arc: %.4f mm\n', ...
        MinSurfaceArc_mm(d));

    fprintf('Minimum angular spacing: %.4f deg\n', ...
        MinAngularSpacing_deg(d));

    fprintf('Closest Attachment pair: C%d-C%d\n', ...
        ClosestCableA(d),ClosestCableB(d));

end

%% Step 5 — 生成统一对比表

T_attachment = table( ...
    Design,source_config,source_candidate, ...
    SphereMaxError_mm, ...
    MinChordDistance_mm, ...
    MinSurfaceArc_mm, ...
    MinAngularSpacing_deg, ...
    ClosestCableA,ClosestCableB, ...
    'VariableNames',{ ...
    'Design','ConfigID','CandidateID', ...
    'SphereMaxError_mm', ...
    'MinChordDistance_mm', ...
    'MinSurfaceArc_mm', ...
    'MinAngularSpacing_deg', ...
    'ClosestCableA','ClosestCableB'});

fprintf('\n====================================\n');
fprintf('E2 Attachment Baseline Audit\n');
fprintf('====================================\n');

disp(T_attachment);

%% Step 6 — 查看四组Attachment间距的范围

fprintf('\nSmallest baseline chord: %.4f mm\n', ...
    min(MinChordDistance_mm));

fprintf('Largest baseline chord minimum: %.4f mm\n', ...
    max(MinChordDistance_mm));

fprintf('Balloon radius: %.4f mm\n',rb);

%% Step 7 — 保存下一阶段的数据

% 不覆盖E1a或E1b的任何结果
save('B5_4_E2_attachment_baselines.mat', ...
    'e2_baselines', ...
    'T_attachment', ...
    'attachment_pair_tables', ...
    'rb','pairs');

writetable(T_attachment, ...
    'B5_4_E2_attachment_baseline_audit.csv');

fprintf('\nPASS: Four attachment baselines verified.\n');

fprintf('E2 Lesson 2.1 completed.\n');
