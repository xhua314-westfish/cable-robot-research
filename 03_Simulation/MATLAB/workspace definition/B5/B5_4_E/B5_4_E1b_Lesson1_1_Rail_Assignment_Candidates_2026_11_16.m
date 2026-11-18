
%% B5.4 E1b Lesson 1.1
% Controlled Rail Assignment Candidate Generation
%
% Research Question:
% 在固定Attachment和Pairing的条件下，
% 如何系统生成六根Cable的替代Rail Assignment？
%
% 本节目标：
% 1. 读取E1a公平优化的六组配置
% 2. 枚举单Cable Rail替换
% 3. 枚举两根Cable的Rail交换
% 4. 验证新的Rail Assignment是否合法
% 5. 保存候选以供后续几何和Sensing评价
%
% 注意：
% 这里不评价Cable干涉和Jacobian。
% 也不声称这些候选在物理上一定可行。

clear; clc; close all;

%% Step 1 — 加载六组配置

data = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

results = data.results;

N_config = numel(results);

assert(N_config==6);

% 加载12-Rail模型
folder_B53 = fullfile( ...
    fileparts(pwd),'B5_3');

rail_data = load(fullfile( ...
    folder_B53, ...
    'B5_3_12rail_geometry_baseline.mat'), ...
    'rail_start','rail_end');

rail_start = rail_data.rail_start;
rail_end = rail_data.rail_end;

N_rails = size(rail_start,1);

assert(N_rails==12);
assert(isequal(size(rail_end),[12 3]));

%% Step 2 — 定义候选生成规则

% Rule A：仅一根Cable改换到未使用Rail
% Rule B：两根Cable交换Rail
%
% 目前要求每组使用六条不同Rail。
% 这是当前探索搜索规则，
% 不是已经验证的普遍机械必要条件。

n_cables = 6;

% 对每组Config分别保存候选
candidate_sets = cell(N_config,1);

% 汇总统计
ConfigID = zeros(N_config,1);
SingleMoveCount = zeros(N_config,1);
SwapCount = zeros(N_config,1);
TotalCount = zeros(N_config,1);

%% Step 3 — 遍历原始六组配置

for c = 1:N_config

    cfg = results(c);

    ConfigID(c) = cfg.config_id;

    rho0 = cfg.rail_ids(:)';
    t0 = cfg.t_optimised(:)';

    % 固定Attachment和Pairing
    r_fixed = cfg.r;
    pairing_fixed = cfg.pairing;

    assert(numel(rho0)==6);
    assert(numel(unique(rho0))==6);

    % 找出当前未使用的六条Rail
    unused_rails = setdiff(1:12,rho0);

    assert(numel(unused_rails)==6);

    fprintf('\n============================\n');
    fprintf('Config %d\n',cfg.config_id);

    fprintf('Original Rail IDs: %s\n', ...
        mat2str(rho0));

    fprintf('Unused Rails: %s\n', ...
        mat2str(unused_rails));

    %% Step 4 — 初始化候选储存

    % 保存：
    % 新Rail IDs、初始t、变化方式、
    % 受影响Cable、固定的Attachment及Pairing
    empty_candidate = struct( ...
        'config_id',NaN, ...
        'type',"", ...
        'changed_cables',[], ...
        'rail_ids',[], ...
        't_initial',[], ...
        'r_fixed',[], ...
        'pairing_fixed',[]);

    candidates = repmat( ...
        empty_candidate,51,1);

    idx = 0;

    %% Step 5 — Rule A：单Cable改换Rail

    for cable_id = 1:6

        for new_rail = unused_rails

            idx = idx+1;

            rho_new = rho0;

            % 只改变当前Cable的Rail ID
            rho_new(cable_id) = new_rail;

            candidates(idx).config_id = ...
                cfg.config_id;

            candidates(idx).type = ...
                "SingleMove";

            candidates(idx).changed_cables = ...
                cable_id;

            candidates(idx).rail_ids = ...
                rho_new;

            % 暂时沿用当前t作为后续搜索初值
            % 换Rail后同一个t对应不同的世界坐标
            candidates(idx).t_initial = t0;

            candidates(idx).r_fixed = r_fixed;

            candidates(idx).pairing_fixed = ...
                pairing_fixed;

        end

    end

    SingleMoveCount(c) = idx;

    %% Step 6 — Rule B：两根Cable交换Rail

    % 组合(1,2),(1,3),...,(5,6)
    cable_pairs = nchoosek(1:6,2);

    assert(size(cable_pairs,1)==15);

    for k = 1:size(cable_pairs,1)

        i = cable_pairs(k,1);
        j = cable_pairs(k,2);

        idx = idx+1;

        rho_new = rho0;

        % Cable i和Cable j交换Rail ID
        rho_new([i j]) = rho0([j i]);

        candidates(idx).config_id = ...
            cfg.config_id;

        candidates(idx).type = ...
            "Swap";

        candidates(idx).changed_cables = ...
            [i j];

        candidates(idx).rail_ids = ...
            rho_new;

        candidates(idx).t_initial = t0;

        candidates(idx).r_fixed = r_fixed;

        candidates(idx).pairing_fixed = ...
            pairing_fixed;

    end

    SwapCount(c) = ...
        size(cable_pairs,1);

    TotalCount(c) = idx;

    %% Step 7 — 验证生成的51个候选

    assert(idx==51);

    assignment_matrix = zeros(idx,6);

    for k = 1:idx

        cand = candidates(k);

        rho_new = cand.rail_ids;

        % Rail ID必须属于1到12
        assert(all(rho_new>=1 & ...
            rho_new<=12));

        % 目前只允许六条不同Rail
        assert(numel(unique(rho_new))==6);

        % Attachment坐标必须完全保持不变
        assert(isequal( ...
            cand.r_fixed,r_fixed));

        % 不允许改变原始Pairing
        assert(isequal( ...
            cand.pairing_fixed,pairing_fixed));

        % 保存Rail ID用于重复检查
        assignment_matrix(k,:) = rho_new;

    end

    % 51个Rail Assignment应互不重复
    assert(size(unique( ...
        assignment_matrix,'rows'),1)==51);

    % 不应包含原始Rail Assignment
    assert(~any(all( ...
        assignment_matrix==rho0,2)));

    candidate_sets{c} = candidates;

    fprintf('SingleMove candidates: %d\n', ...
        SingleMoveCount(c));

    fprintf('Swap candidates: %d\n', ...
        SwapCount(c));

    fprintf('Total candidates: %d\n', ...
        TotalCount(c));

end

%% Step 8 — 输出汇总表

T_candidates = table( ...
    ConfigID, ...
    SingleMoveCount,SwapCount,TotalCount);

fprintf('\n============================\n');
fprintf('E1b Rail Assignment Candidate Summary\n');
fprintf('============================\n');

disp(T_candidates);

%% Step 9 — 最终检查

assert(all(SingleMoveCount==36));
assert(all(SwapCount==15));
assert(all(TotalCount==51));

assert(sum(TotalCount)==306);

fprintf('\nPASS: 306 assignments generated.\n');

fprintf('PASS: Attachments and pairing fixed.\n');

fprintf('PASS: Rail IDs unique within each design.\n');

%% Step 10 — 保存

save( ...
    'B5_4_E1b_rail_assignment_candidates.mat', ...
    'candidate_sets','T_candidates', ...
    'rail_start','rail_end');

writetable(T_candidates, ...
    'B5_4_E1b_rail_assignment_candidates.csv');

fprintf('\nE1b Lesson 1.1 completed.\n');
