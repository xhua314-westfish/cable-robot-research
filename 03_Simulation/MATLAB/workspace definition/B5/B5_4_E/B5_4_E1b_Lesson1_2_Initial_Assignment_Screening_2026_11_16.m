
%% B5.4 E1b Lesson 1.2
% Initial Rail Assignment Geometry & Sensing Screening
%
% Research Question:
% 改变Rail Assignment后，306个候选中有多少
% 能在初始t位置下通过Geometry和Rank检查？
%
% 本节：
% 1. 固定Attachment、Pairing
% 2. 使用上一节保存的新Rail IDs
% 3. 暂时保持初始t不变
% 4. 评价全部189个Core姿态
% 5. 记录可行性、失败类型和Sensing
%
% 注意：
% 几何失败不等于该Rail Assignment不可优化！
% 本节不是最终候选淘汰。

clear; clc; close all;

%% Step 1 — 读取E1b候选

cand_data = load( ...
    'B5_4_E1b_rail_assignment_candidates.mat');

candidate_sets = cand_data.candidate_sets;

rail_start = cand_data.rail_start;
rail_end = cand_data.rail_end;

% B5.4统一评价数据
base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

settings = base.settings;
P_all = base.P_all;
R_all = base.R_all;

% E1a优化结果，用于对照
e1a = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

% 共同优化协议
prot = load( ...
    'B5_4_E1a_B_optimisation_protocol.mat');

clearance_floor = ...
    prot.protocol.clearance_floor_mm;

% 检查有限线段距离函数
assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'B3 segment-distance function not found');

N_config = numel(candidate_sets);
N_pose = size(P_all,1);

assert(N_config==6);
assert(N_pose==189);

%% Step 2 — 找到参考位姿

% 参考位姿：P=[0 0 0]，R=I
ref_id = find( ...
    all(abs(P_all)<1e-12,2) & ...
    base.orientation_id==1);

assert(numel(ref_id)==1);

fprintf('\n--- E1b Lesson 1.2 ---\n');

fprintf('Configurations: %d\n',N_config);
fprintf('Candidates per Config: 51\n');
fprintf('Core poses: %d\n',N_pose);
fprintf('Reference pose ID: %d\n',ref_id);

fprintf('Clearance floor: %.6f mm\n', ...
    clearance_floor);

%% Step 3 — 初始化全部306次评价的结果

N_total = sum(cellfun( ...
    @numel,candidate_sets));

assert(N_total==306);

ConfigID = zeros(N_total,1);
CandidateID = zeros(N_total,1);

CandidateType = strings(N_total,1);
ChangedCable = strings(N_total,1);

ReferenceGeometry = false(N_total,1);
ReferenceRank6 = false(N_total,1);

SpherePass = zeros(N_total,1);
CablePass = zeros(N_total,1);
GeometryPass = zeros(N_total,1);
RankPass = zeros(N_total,1);

CoreEligible = false(N_total,1);
ClearanceEligible = false(N_total,1);

WorstCoreSigma = nan(N_total,1);
WorstCoreKappa = nan(N_total,1);

MinAngle_deg = nan(N_total,1);
MinDistance_mm = nan(N_total,1);

% 保存完整评价结果，方便后续诊断
evaluation_details = cell(N_total,1);

row = 0;

%% Step 4 — 循环六组原始Config

for c = 1:N_config

    candidates = candidate_sets{c};

    assert(numel(candidates)==51);

    fprintf('\n============================\n');
    fprintf('Config %d\n', ...
        candidates(1).config_id);

    %% Step 5 — 评价该Config的51个候选

    for j = 1:numel(candidates)

        row = row+1;

        cand = candidates(j);

        ConfigID(row) = cand.config_id;
        CandidateID(row) = j;

        CandidateType(row) = cand.type;

        ChangedCable(row) = ...
            string(mat2str( ...
            cand.changed_cables));

        % 新的Rail Assignment
        rho = cand.rail_ids(:)';

        % 初始Rail Position保持不变
        t = cand.t_initial(:)';

        % 已经完成原始Pairing的Attachment
        r = cand.r_fixed;

        % 注意：不能再执行r(pairing,:)

        %% 5.1 重建Anchor坐标

        A = zeros(6,3);

        for i = 1:6

            rid = rho(i);

            A(i,:) = ...
                rail_start(rid,:) + ...
                t(i)*( ...
                rail_end(rid,:) - ...
                rail_start(rid,:));

        end

        %% 5.2 评价全部189个Core姿态

        g = evaluate_assignment( ...
            A,r,P_all,R_all,settings);

        evaluation_details{row} = g;

        %% 5.3 参考位姿判定

        ReferenceGeometry(row) = ...
            g.geometry_safe(ref_id);

        ReferenceRank6(row) = ...
            g.geometry_safe(ref_id) && ...
            g.rank_all(ref_id)==6;

        %% 5.4 Core通过数量

        SpherePass(row) = ...
            sum(g.sphere_safe);

        CablePass(row) = ...
            sum(g.cable_safe);

        GeometryPass(row) = ...
            sum(g.geometry_safe);

        RankPass(row) = sum( ...
            g.geometry_safe & ...
            g.rank_all==6);

        %% 5.5 计算几何裕量

        MinAngle_deg(row) = ...
            min(g.angle_margin_deg(:));

        MinDistance_mm(row) = ...
            min(g.distances(:));

        %% 5.6 完整Core资格

        CoreEligible(row) = ...
            GeometryPass(row)==N_pose && ...
            RankPass(row)==N_pose;

        ClearanceEligible(row) = ...
            CoreEligible(row) && ...
            MinDistance_mm(row)>= ...
            clearance_floor-1e-8;

        % 只有Core完整通过，
        % 才报告合格配置的worst sensing。
        if CoreEligible(row)

            WorstCoreSigma(row) = ...
                min(g.sigma_min_all);

            WorstCoreKappa(row) = ...
                max(g.kappa_all);

        end

    end

    % 统计本组筛选结果
    mask = ConfigID(1:row)== ...
        candidates(1).config_id;

    fprintf('Reference geometry: %d / 51\n', ...
        sum(ReferenceGeometry(1:row) & mask));

    fprintf('Reference rank-6: %d / 51\n', ...
        sum(ReferenceRank6(1:row) & mask));

    fprintf('Core eligible: %d / 51\n', ...
        sum(CoreEligible(1:row) & mask));

    fprintf('Core + clearance: %d / 51\n', ...
        sum(ClearanceEligible(1:row) & mask));

end

assert(row==N_total);

%% Step 6 — 生成306候选完整结果表

T_screening = table( ...
    ConfigID,CandidateID, ...
    CandidateType,ChangedCable, ...
    ReferenceGeometry,ReferenceRank6, ...
    SpherePass,CablePass, ...
    GeometryPass,RankPass, ...
    CoreEligible,ClearanceEligible, ...
    WorstCoreSigma,WorstCoreKappa, ...
    MinAngle_deg,MinDistance_mm);

%% Step 7 — 生成六组Config汇总表

IDs = [e1a.results.config_id]';

N = numel(IDs);

ReferencePassCount = zeros(N,1);
CorePassCount = zeros(N,1);
ClearancePassCount = zeros(N,1);

BestCandidateID = nan(N,1);
BestCandidateSigma = nan(N,1);

E1aSigma = zeros(N,1);

for c = 1:N

    id = IDs(c);
    mask = ConfigID==id;

    ReferencePassCount(c) = sum( ...
        ReferenceRank6(mask));

    CorePassCount(c) = sum( ...
        CoreEligible(mask));

    ClearancePassCount(c) = sum( ...
        ClearanceEligible(mask));

    E1aSigma(c) = ...
        e1a.results(c).sigma_optimised;

    % 只在满足共同Core和间距要求的候选中
    % 找到当前初始t位置下的最高sigma

    qualified = find( ...
        mask & ClearanceEligible);

    if ~isempty(qualified)

        [best_sigma,local_id] = max( ...
            WorstCoreSigma(qualified));

        best_row = qualified(local_id);

        BestCandidateID(c) = ...
            CandidateID(best_row);

        BestCandidateSigma(c) = best_sigma;

    end

end

T_summary = table( ...
    IDs,ReferencePassCount, ...
    CorePassCount,ClearancePassCount, ...
    E1aSigma, ...
    BestCandidateID,BestCandidateSigma, ...
    'VariableNames',{ ...
    'ConfigID','ReferencePass', ...
    'CorePass','CoreClearancePass', ...
    'E1aSigma', ...
    'BestCandidateID','BestCandidateSigma'});

fprintf('\n====================================\n');
fprintf('E1b Initial Assignment Screening\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 8 — 核查结果逻辑

assert(all( ...
    ReferencePassCount<=51));

assert(all( ...
    CorePassCount<=ReferencePassCount));

assert(all( ...
    ClearancePassCount<=CorePassCount));

assert(all( ...
    GeometryPass<=SpherePass));

assert(all( ...
    GeometryPass<=CablePass));

assert(all(RankPass<=GeometryPass));

fprintf('\nTotal reference-qualified: %d / 306\n', ...
    sum(ReferenceRank6));

fprintf('Total Core-qualified: %d / 306\n', ...
    sum(CoreEligible));

fprintf('Total Core + clearance: %d / 306\n', ...
    sum(ClearanceEligible));

fprintf('\nInitial screening completed.\n');

%% Step 9 — 绘制筛选结果

figure('Color','w', ...
    'Name','E1b Initial Rail Assignment Screening', ...
    'Position',[100 100 1100 500]);

bar(IDs, ...
    [ReferencePassCount, ...
     CorePassCount, ...
     ClearancePassCount], ...
    'grouped');

xlabel('Original Configuration ID');
ylabel('Passing candidates / 51');

title('E1b - Initial Rail Assignment Screening');

legend( ...
    {'Reference','Core 189', ...
     'Core + Clearance'}, ...
    'Location','best');

ylim([0 55]);
grid on;

%% Step 10 — 保存数据

save('B5_4_E1b_initial_assignment_screening.mat', ...
    'T_screening','T_summary', ...
    'evaluation_details', ...
    'candidate_sets', ...
    'settings','P_all','R_all', ...
    'clearance_floor');

writetable(T_screening, ...
    'B5_4_E1b_initial_assignment_screening.csv');

writetable(T_summary, ...
    'B5_4_E1b_initial_assignment_summary.csv');

fprintf('\nE1b Lesson 1.2 results saved.\n');

%% ================================================
% Local Function
% 评价一个Rail Assignment的Core 189位姿
%% ================================================

function g = evaluate_assignment( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    sphere_safe = false(N,1);
    cable_safe = false(N,1);
    geometry_safe = false(N,1);

    rank_all = zeros(N,1);

    sigma_min_all = zeros(N,1);
    kappa_all = zeros(N,1);

    angle_margin_deg = zeros(N,6);
    distances = zeros(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        % 六个Attachment在世界坐标下的方向
        S = (R*r')';

        % 六个Attachment的世界坐标
        B = S+P;

        % Cable方向：Attachment -> Anchor
        D = A-B;

        % Cable长度
        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            % 退化Cable视为几何失败
            continue;
        end

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_margin = outward_dot./ ...
            (settings.rb*L);

        sine_margin = max( ...
            -1,min(1,sine_margin));

        angle_margin_deg(k,:) = ...
            asind(sine_margin)';

        sphere_safe(k) = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable

        cable_ok = true;

        for j = 1:15

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                B(i1,:),A(i1,:), ...
                B(i2,:),A(i2,:));

            distances(k,j) = dij;

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        cable_safe(k) = cable_ok;

        geometry_safe(k) = ...
            sphere_safe(k) && cable_safe(k);

        %% Measurement Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))];
        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        sigma_min_all(k) = sv(end);

        rank_all(k) = sum( ...
            sv>settings.rank_relative_tol*sv(1));

        if sv(end)>0

            kappa_all(k) = sv(1)/sv(end);

        else

            kappa_all(k) = inf;

        end

    end

    g.sphere_safe = sphere_safe;
    g.cable_safe = cable_safe;
    g.geometry_safe = geometry_safe;

    g.rank_all = rank_all;

    g.sigma_min_all = sigma_min_all;
    g.kappa_all = kappa_all;

    g.angle_margin_deg = angle_margin_deg;
    g.distances = distances;

end
