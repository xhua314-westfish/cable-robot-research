
%% B5.4 E1b Lesson 1.3
% Representative Rail Assignment Selection
%
% Research Question:
% 如何从306个Rail Assignment中，
% 选择值得进一步优化的代表性候选？
%
% 每个原始Config最多选择：
% 1. 两个Core + clearance合格候选
% 2. 两个初始不合格但具有修复潜力的候选
%
% 本节只选择候选，不执行位置优化。

clear; clc;

%% Step 1 — 加载上一节筛选数据

data = load( ...
    'B5_4_E1b_initial_assignment_screening.mat');

T = data.T_screening;

candidate_sets = data.candidate_sets;

config_ids = unique(T.ConfigID,'stable');

assert(numel(config_ids)==6);
assert(height(T)==306);

%% Step 2 — 设置选择预算

N_good = 2;
N_repair = 2;

% 每个Config最多4个
N_per_config = N_good+N_repair;

% 当前采用的启发式原则：
% 合格候选：Sensing + Clearance
% 待修复候选：Reference通过，
%           Core通过数量优先

%% Step 3 — 初始化结果

selected_rows = [];

SelectionRole = strings(0,1);

%% Step 4 — 逐个原始Config选择

for c = 1:numel(config_ids)

    id = config_ids(c);

    rows = find(T.ConfigID==id);

    fprintf('\n============================\n');
    fprintf('Config %d\n',id);

    %% 4.1 找出已通过Core和Clearance的候选

    qualified = rows( ...
        T.ClearanceEligible(rows));

    chosen_good = [];

    if ~isempty(qualified)

        % 第一位：最高Worst-Core sigma
        [~,idx] = max( ...
            T.WorstCoreSigma(qualified));

        best_sensing = qualified(idx);

        chosen_good(end+1) = best_sensing;

        % 第二位：最大Cable-Cable距离
        remaining = setdiff( ...
            qualified,chosen_good,'stable');

        if ~isempty(remaining)

            [~,idx] = max( ...
                T.MinDistance_mm(remaining));

            chosen_good(end+1) = remaining(idx);

        end

    end

    %% 4.2 选择具有修复潜力的候选

    % 必须通过参考姿态的Geometry + Rank
    % 但尚未通过完整Core + Clearance
    repair_pool = rows( ...
        T.ReferenceRank6(rows) & ...
        ~T.ClearanceEligible(rows));

    chosen_repair = [];

    if ~isempty(repair_pool)

        % 优先选择：
        % 1. GeometryPass数量更高
        % 2. RankPass数量更高
        % 3. 最小外向角更大
        %
        % 排序按前三列降序
        scores = [ ...
            T.GeometryPass(repair_pool), ...
            T.RankPass(repair_pool), ...
            T.MinAngle_deg(repair_pool)];

        [~,order] = sortrows( ...
            scores,[-1 -2 -3]);

        n_take = min( ...
            N_repair,numel(repair_pool));

        chosen_repair = ...
            repair_pool(order(1:n_take));

    end

    %% 4.3 合并本组候选

    chosen = [ ...
        chosen_good(:);
        chosen_repair(:)];

    roles = [ ...
        repmat("Initial feasible", ...
            numel(chosen_good),1);
        repmat("Repair candidate", ...
            numel(chosen_repair),1)];

    assert(numel(chosen)<=N_per_config);

    selected_rows = [ ...
        selected_rows;
        chosen];

    SelectionRole = [ ...
        SelectionRole;
        roles];

    fprintf('Selected: %d / %d\n', ...
        numel(chosen),N_per_config);

    fprintf('Candidate IDs: %s\n', ...
        mat2str(T.CandidateID(chosen)'));

end

%% Step 5 — 建立候选选择表

T_selected = T(selected_rows,:);

T_selected.SelectionRole = SelectionRole;

fprintf('\n====================================\n');
fprintf('E1b Representative Candidates\n');
fprintf('====================================\n');

disp(T_selected(:,{ ...
    'ConfigID', ...
    'CandidateID', ...
    'CandidateType', ...
    'SelectionRole', ...
    'GeometryPass', ...
    'RankPass', ...
    'WorstCoreSigma', ...
    'MinAngle_deg', ...
    'MinDistance_mm'}));

%% Step 6 — 保存对应配置参数

N_selected = numel(selected_rows);

selected_candidates = cell(N_selected,1);

for k = 1:N_selected

    config_id = ...
        T_selected.ConfigID(k);

    candidate_id = ...
        T_selected.CandidateID(k);

    % 找到该Config在六组中的索引
    config_index = find( ...
        config_ids==config_id);

    % 从Lesson 1.1取回完整配置定义
    selected_candidates{k} = ...
        candidate_sets{config_index}(candidate_id);

end

%% Step 7 — 检查候选身份

assert(N_selected<=24);

for k = 1:N_selected

    cand = selected_candidates{k};

    % 新的Rail Assignment仍然唯一
    assert(numel(unique(cand.rail_ids))==6);

    % 六根Cable的Attachment不能改变
    assert(isequal(size(cand.r_fixed),[6 3]));

    % 初始t必须完整
    assert(numel(cand.t_initial)==6);

end

fprintf('\nTotal selected: %d / 306\n', ...
    N_selected);

fprintf('Representative selection: PASS\n');

%% Step 8 — 保存

save( ...
    'B5_4_E1b_representative_candidates.mat', ...
    'T_selected', ...
    'selected_candidates', ...
    'N_good','N_repair', ...
    'config_ids');

writetable(T_selected, ...
    'B5_4_E1b_representative_candidates.csv');

fprintf('E1b Lesson 1.3 completed.\n');
