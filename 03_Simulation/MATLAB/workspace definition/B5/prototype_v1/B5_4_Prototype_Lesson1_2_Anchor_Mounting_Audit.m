
%% Prototype V1 - Mechanical Lesson 1.2
% Anchor Mounting Footprint Analysis
%
% 研究问题：
% 目前四组E2配置的Anchor位置，
% 是否能安装不同尺寸的普通居中式Rail夹具？
%
% 注意：
% 本节不移动Anchor，不进行配置优化。
% 只检查机械安装包络。
%
% 输入：
% E1a、E1b、E2的实际保存结果
% B5.3的12-Rail几何模型
%
% 输出：
% 1. 每根Anchor位置的安装空间
% 2. 四种假设夹具尺寸的通过情况
% 3. 每组设计的统计汇总
% 4. CSV和MAT结果

clear; clc; close all;

%% Step 1 - 加载E2最终设计

e2 = load( ...
    'B5_4_E2_539pose_verification.mat');

repair = load( ...
    'B5_4_E2_C2_C4_targeted_repair.mat');

e1b = load( ...
    'B5_4_E1b_position_reoptimisation.mat');

e1a = load( ...
    'B5_4_E1a_B_fair_sequential_results.mat');

% 加载12条Rail
rail_file = 'B5_3_12rail_geometry_baseline.mat';

if ~isfile(rail_file)

    rail_file = fullfile( ...
        fileparts(pwd),'B5_3', ...
        'B5_3_12rail_geometry_baseline.mat');

end

assert(isfile(rail_file), ...
    'Cannot find B5_3 rail geometry.');

rails = load(rail_file, ...
    'rail_start','rail_end');

rail_start = rails.rail_start;
rail_end = rails.rail_end;

assert(isequal(size(rail_start),[12 3]));
assert(isequal(size(rail_end),[12 3]));

%% Step 2 - 四组最终配置

design_names = [
    "C2-2 Repaired M"
    "C4-1 E2 M"
    "C8-16 E2 M"
    "C12 E2 M"
];

source_names = [
    "E1b C2-2"
    "E1b C4-1"
    "E1b C8-16"
    "E1a C12"
];

N_design = numel(design_names);

A_all = cell(N_design,1);
rail_ids_all = cell(N_design,1);
t_all = cell(N_design,1);

%% Step 3 - 提取真实Anchor及Rail参数

for d = 1:N_design

    if d==1

        % C2-2使用定向修复后的M方案
        cfg = repair.repaired_designs{2};

        assert(cfg.best_found);

        A_all{d} = cfg.A_fixed;

    else

        % 其他三个配置来自E2的539验证
        idx = find( ...
            string(e2.T_verification.Design)== ...
                source_names(d) & ...
            string(e2.T_verification.Track)== ...
                "MarginPreservingSensing");

        assert(numel(idx)==1);

        cfg = e2.designs{idx};

        A_all{d} = cfg.A;

    end

    % 对于C2、C4、C8，
    % Rail IDs来自对应E1b优化结果
    if d<=3

        config_ids = [2 4 8];
        candidate_ids = [2 1 16];

        idx = find( ...
            e1b.T_optimisation.ConfigID== ...
                config_ids(d) & ...
            e1b.T_optimisation.CandidateID== ...
                candidate_ids(d));

        assert(numel(idx)==1);

        src = e1b.optimised_candidates{idx};

        rail_ids_all{d} = src.rail_ids(:);
        t_all{d} = src.t_final(:);

    else

        % C12 E2来自E1a C12
        idx = find( ...
            [e1a.results.config_id]==12);

        assert(numel(idx)==1);

        src = e1a.results(idx);

        rail_ids_all{d} = src.rail_ids(:);
        t_all{d} = src.t_optimised(:);

    end

    %% 校验Anchor与Rail几何是否对应

    A = A_all{d};
    rho = rail_ids_all{d};
    t = t_all{d};

    assert(isequal(size(A),[6 3]));
    assert(numel(rho)==6);
    assert(numel(t)==6);

    for i = 1:6

        rid = rho(i);

        A_reconstructed = ...
            rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)- ...
            rail_start(rid,:));

        assert(norm( ...
            A(i,:)-A_reconstructed)<1e-6, ...
            'Anchor and rail geometry mismatch.');

    end

end

%% Step 4 - 定义假设的夹具安装尺寸

% 单位：mm
%
% 这些参数是探索性安装包络，
% 并非已确认的零件型号。

mount_lengths_mm = [20 30 40 60];

% Rail两端希望保留的安装余量
end_reserve_mm = 5;

N_size = numel(mount_lengths_mm);

%% Step 5 - 初始化数据

N_anchor = N_design*6;

Design = strings(N_anchor,1);

CableID = zeros(N_anchor,1);
RailID = zeros(N_anchor,1);

t_value = zeros(N_anchor,1);

RailLength_mm = zeros(N_anchor,1);

DistanceToStart_mm = zeros(N_anchor,1);
DistanceToEnd_mm = zeros(N_anchor,1);

MinRailEnd_mm = zeros(N_anchor,1);

% 不同尺寸下是否可安装
PassMatrix = false(N_anchor,N_size);

row = 0;

%% Step 6 - 分别检查所有Anchor

for d = 1:N_design

    rho = rail_ids_all{d};
    t = t_all{d};

    for i = 1:6

        row = row+1;

        rid = rho(i);

        p0 = rail_start(rid,:);
        p1 = rail_end(rid,:);

        rail_length = norm(p1-p0);

        % t=0代表起点，t=1代表终点
        distance_start = ...
            t(i)*rail_length;

        distance_end = ...
            (1-t(i))*rail_length;

        distance_min = ...
            min(distance_start,distance_end);

        Design(row) = design_names(d);

        CableID(row) = i;
        RailID(row) = rid;

        t_value(row) = t(i);

        RailLength_mm(row) = rail_length;

        DistanceToStart_mm(row) = ...
            distance_start;

        DistanceToEnd_mm(row) = ...
            distance_end;

        MinRailEnd_mm(row) = ...
            distance_min;

        %% 检查不同尺寸的居中式夹具

        for j = 1:N_size

            w = mount_lengths_mm(j);

            % 普通居中式夹具需要：
            % Anchor两侧各有w/2的安装长度
            % 并额外保留end_reserve
            required_end_distance = ...
                w/2 + end_reserve_mm;

            PassMatrix(row,j) = ...
                distance_min>= ...
                required_end_distance-1e-8;

        end

    end

end

assert(row==24);

%% Step 7 - 输出逐Anchor检查表

T_anchor = table( ...
    Design,CableID,RailID,t_value, ...
    RailLength_mm, ...
    DistanceToStart_mm, ...
    DistanceToEnd_mm, ...
    MinRailEnd_mm);

for j = 1:N_size

    variable_name = sprintf( ...
        'Mount_%dmm_Pass', ...
        mount_lengths_mm(j));

    T_anchor.(variable_name) = ...
        PassMatrix(:,j);

end

fprintf('\n====================================\n');
fprintf('Prototype V1 Mounting Footprint Audit\n');
fprintf('====================================\n');

disp(T_anchor);

%% Step 8 - 按配置和夹具尺寸汇总

N_summary = N_design*N_size;

SummaryDesign = strings(N_summary,1);

MountLength_mm = zeros(N_summary,1);

RequiredRailEnd_mm = zeros(N_summary,1);

AnchorPassCount = zeros(N_summary,1);

LimitingCable = zeros(N_summary,1);
LimitingDistance_mm = zeros(N_summary,1);

NeedsSpecialMount = false(N_summary,1);

srow = 0;

for d = 1:N_design

    rows = find(Design==design_names(d));

    assert(numel(rows)==6);

    % 找到该配置最靠近Rail端点的Anchor
    [min_end,local_idx] = ...
        min(MinRailEnd_mm(rows));

    limiting_cable = ...
        CableID(rows(local_idx));

    for j = 1:N_size

        srow = srow+1;

        w = mount_lengths_mm(j);

        required_distance = ...
            w/2 + end_reserve_mm;

        pass_count = sum( ...
            PassMatrix(rows,j));

        SummaryDesign(srow) = ...
            design_names(d);

        MountLength_mm(srow) = w;

        RequiredRailEnd_mm(srow) = ...
            required_distance;

        AnchorPassCount(srow) = ...
            pass_count;

        LimitingCable(srow) = ...
            limiting_cable;

        LimitingDistance_mm(srow) = ...
            min_end;

        NeedsSpecialMount(srow) = ...
            pass_count<6;

    end

end

T_summary = table( ...
    SummaryDesign,MountLength_mm, ...
    RequiredRailEnd_mm, ...
    AnchorPassCount, ...
    LimitingCable, ...
    LimitingDistance_mm, ...
    NeedsSpecialMount);

fprintf('\n====================================\n');
fprintf('Mounting Feasibility by Design\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 9 - 单独输出需要特殊安装的Anchor

% 以30 mm安装座作为示例
reference_mount_length = 30;

reference_index = find( ...
    mount_lengths_mm==reference_mount_length);

assert(numel(reference_index)==1);

failed_rows = find( ...
    ~PassMatrix(:,reference_index));

fprintf('\n--- 30 mm Centered Mount Scenario ---\n');

fprintf('Required rail-end distance: %.1f mm\n', ...
    reference_mount_length/2+end_reserve_mm);

if isempty(failed_rows)

    fprintf('All anchors pass.\n');

else

    disp(T_anchor(failed_rows,{ ...
        'Design','CableID','RailID', ...
        'MinRailEnd_mm'}));

end

%% Step 10 - 可视化夹具尺寸与通过数量

figure( ...
    'Color','w', ...
    'Position',[100 100 1050 520]);

pass_grid = reshape( ...
    AnchorPassCount, ...
    N_size,N_design)';

bar(mount_lengths_mm,pass_grid','grouped');

xlabel('Mount footprint length (mm)');
ylabel('Anchors passing / 6');

title( ...
    'Prototype V1: Centered Rail Mount Feasibility');

legend(cellstr(design_names), ...
    'Location','southoutside', ...
    'Orientation','horizontal');

ylim([0 6.5]);
yticks(0:6);

grid on;

%% Step 11 - 保存结果

output_dir = fullfile( ...
    pwd,'Prototype_V1_Mounting_Audit');

if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

save(fullfile(output_dir, ...
    'Prototype_V1_mounting_audit.mat'), ...
    'T_anchor','T_summary', ...
    'PassMatrix', ...
    'mount_lengths_mm', ...
    'end_reserve_mm');

writetable(T_anchor, ...
    fullfile(output_dir, ...
    'Prototype_V1_anchor_mounting.csv'));

writetable(T_summary, ...
    fullfile(output_dir, ...
    'Prototype_V1_mounting_summary.csv'));

exportgraphics(gcf, ...
    fullfile(output_dir, ...
    'Prototype_V1_mounting_comparison.png'), ...
    'Resolution',300);

fprintf('\nPASS: Mounting footprint audit completed.\n');
fprintf('Results saved to:\n%s\n',output_dir);
