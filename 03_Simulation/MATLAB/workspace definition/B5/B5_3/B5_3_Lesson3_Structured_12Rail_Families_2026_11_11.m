% Research Question:
% How can six anchor positions be systematically
% distributed across twelve installable frame rails?
%
% Objectives:
% 1. Define S1, S2 and S3 design families
% 2. Specify deterministic rail assignments
% 3. Apply common rail-position parameters
% 4. Verify all anchors lie on valid rails
% 5. Report anchor spacing without assuming hardware sizes
% 6. Visualise representative layouts
% 7. Save candidates for attachment/pairing design
%
% IMPORTANT:
% Anchor geometry only.
% No attachment selection or cable-pairing optimisation.

clear; clc; close all;

%% Step 1: Load verified twelve-rail geometry

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end','rail_axis', ...
    'Lg','Wg','Hg','rb');

N_rails = size(rail_start,1);

assert(N_rails==12);

n_cables = 6;

fprintf('\n--- B5.3 Lesson 3 ---\n');
fprintf('Available rails: %d\n',N_rails);
fprintf('Cable number: %d\n',n_cables);

%% Step 2: Define three design families
%
% 这些是研究假设，而不是已优化方案。
%
% S1:
% 以上下分层的X方向导轨为主，
% 辅以Z方向导轨。
%
% S2:
% X、Y、Z每个方向各选两条导轨。
%
% S3:
% 使用非对称的3Z+1X+2Y分配。
%
% 每一行代表6根Cable的Anchor所属Rail ID。
% 每个Family使用3组不同的Rail Assignment。

family_names = {
    'S1 - Structured Layered';
    'S2 - Distributed';
    'S3 - Asymmetric'
    };

% S1: 4条水平X导轨 + 2条Z导轨
S1_assignments = [
    5 6 7 8 1 4;
    5 6 7 8 2 3;
    5 6 7 8 1 2
    ];

% S2: 2条X、2条Y、2条Z导轨
S2_assignments = [
    1 4 5 8 9 12;
    2 3 6 7 10 11;
    1 2 7 8 9 10
    ];

% S3: 非对称的3Z、1X、2Y
S3_assignments = [
    1 2 4 7 10 12;
    1 3 4 8 9 12;
    2 3 4 5 10 11
    ];

family_assignments = {
    S1_assignments;
    S2_assignments;
    S3_assignments
    };

N_family = numel(family_names);

assignments_per_family = 3;

%% Step 3: Define common rail-position patterns
%
% 用两种完全相同的t模式比较不同Family。
%
% t为归一化位置，不是mm。
%
% 数值仅用于生成可复现的初始布局，
% 不表示最优滑块位置或真实机械端部禁区。

t_patterns = [
    0.25 0.75 0.35 0.65 0.40 0.60;
    0.40 0.60 0.55 0.45 0.70 0.30
    ];

N_pattern = size(t_patterns,1);

assert(all(t_patterns(:)>=0));
assert(all(t_patterns(:)<=1));

%% Step 4: Verify family design rules

for f = 1:N_family

    assignments = family_assignments{f};

    assert(size(assignments,1)==assignments_per_family);
    assert(size(assignments,2)==6);

    for a = 1:assignments_per_family

        rail_ids = assignments(a,:);

        % 所有Rail ID必须合法
        assert(all(rail_ids>=1 & rail_ids<=12));

        % 当前初始方案规定：
        % 六个Anchors位于六条不同导轨
        assert(numel(unique(rail_ids))==6);

        % 检查具体方向分配
        selected_axes = rail_axis(rail_ids);

        nX = sum(selected_axes=="X");
        nY = sum(selected_axes=="Y");
        nZ = sum(selected_axes=="Z");

        if f==1
            assert(nX==4 && nY==0 && nZ==2);

        elseif f==2
            assert(nX==2 && nY==2 && nZ==2);

        elseif f==3
            assert(nX==1 && nY==2 && nZ==3);
        end

    end
end

fprintf('Family rail-assignment rules verified.\n');

%% Step 5: Generate complete six-anchor layouts

N_total = N_family * assignments_per_family * N_pattern;

% 使用结构体保存所有候选布局
anchor_configs = repmat(struct( ...
    'family_id',[], ...
    'family_name','', ...
    'assignment_id',[], ...
    'pattern_id',[], ...
    'rail_ids',[], ...
    't',[], ...
    'A',[], ...
    'min_anchor_distance',[]),N_total,1);

config_id = 0;

for f = 1:N_family

    assignments = family_assignments{f};

    for a = 1:assignments_per_family

        % 当前Rail Assignment
        rail_ids = assignments(a,:);

        for p = 1:N_pattern

            % 当前6根Cable的t参数
            t = t_patterns(p,:);

            A = zeros(6,3);

            %% Calculate anchor coordinates

            for i = 1:n_cables

                rail_id = rail_ids(i);

                E0 = rail_start(rail_id,:);
                E1 = rail_end(rail_id,:);

                % 导轨参数方程
                A(i,:) = E0+t(i)*(E1-E0);
            end

            %% Check geometric spacing

            % 计算六个Anchor之间所有15对距离
            pairs = nchoosek(1:6,2);

            pair_distances = zeros(15,1);

            for j = 1:15

                i1 = pairs(j,1);
                i2 = pairs(j,2);

                pair_distances(j) = ...
                    norm(A(i1,:)-A(i2,:));
            end

            min_anchor_distance = ...
                min(pair_distances);
            
            % 数学点不允许完全重合
            % 尚未规定实际滑块净空阈值
            assert(min_anchor_distance>1e-6);

            %% Save configuration

            config_id = config_id+1;

            anchor_configs(config_id).family_id = f;

            anchor_configs(config_id).family_name = ...
                family_names{f};

            anchor_configs(config_id).assignment_id = a;

            anchor_configs(config_id).pattern_id = p;

            anchor_configs(config_id).rail_ids = rail_ids;

            anchor_configs(config_id).t = t;

            anchor_configs(config_id).A = A;

            anchor_configs(config_id).min_anchor_distance = ...
                min_anchor_distance;

        end
    end
end

assert(config_id==N_total);

fprintf('Generated anchor configurations: %d\n', ...
    N_total);

%% Step 6: Verify every Anchor is on its assigned Rail
%
% 这个步骤不只检查Anchor是否位于边缘，
% 还验证它确实属于指定的Rail ID。

max_rail_error = 0;

for c = 1:N_total

    config = anchor_configs(c);

    for i = 1:6

        rail_id = config.rail_ids(i);
        t = config.t(i);

        E0 = rail_start(rail_id,:);
        E1 = rail_end(rail_id,:);

        A_expected = E0+t*(E1-E0);

        error = norm( ...
            config.A(i,:)-A_expected);

        max_rail_error = max(max_rail_error,error);

        assert(error<1e-6);
    end
end

fprintf('Maximum rail-location error: %.3e mm\n', ...
    max_rail_error);

%% Step 7: Build summary table

ConfigID = (1:N_total)';

Family = strings(N_total,1);

AssignmentID = zeros(N_total,1);
PatternID = zeros(N_total,1);

MinAnchorDistance_mm = zeros(N_total,1);

for c = 1:N_total

    Family(c) = string(anchor_configs(c).family_name);

    AssignmentID(c) = ...
        anchor_configs(c).assignment_id;

    PatternID(c) = ...
        anchor_configs(c).pattern_id;

    MinAnchorDistance_mm(c) = ...
        anchor_configs(c).min_anchor_distance;

end

T_summary = table( ...
    ConfigID,Family,AssignmentID,PatternID, ...
    MinAnchorDistance_mm);

fprintf('\n--- Anchor Family Summary ---\n');
disp(T_summary);

%% Step 8: Visualise representative layouts
%
% 每种Family展示第一组Rail Assignment
% 与第一种t参数模式。
%
% 仅显示Anchor点，不显示Cable。
% 因为Attachment及Pairing尚未定义。

figure('Color','w', ...
    'Name','B5.3 Structured Anchor Families', ...
    'Position',[100 100 1500 550]);

rail_colors = [
    0.90 0.45 0.15;  % X
    0.15 0.65 0.40;  % Y
    0.10 0.45 0.85   % Z
];

% 定义每个 Family 想要展示的具体 Config ID [S1, S2, S3]
% 将 S2 的展示方案由 Config 7 替换为不偏的 Config 11
selected_configs = [1, 11, 13];


for f = 1:N_family

    % 每种Family的第一组Candidate
    %c = (f-1)*assignments_per_family*N_pattern+1;
    c = selected_configs(f);
    config = anchor_configs(c);

    subplot(1,3,f);
    hold on;

    %% Draw all 12 rails

    for j = 1:N_rails

        E0 = rail_start(j,:);
        E1 = rail_end(j,:);

        switch rail_axis(j)

            case "X"
                color = rail_colors(1,:);

            case "Y"
                color = rail_colors(2,:);

            case "Z"
                color = rail_colors(3,:);

        end

        plot3( ...
            [E0(1) E1(1)], ...
            [E0(2) E1(2)], ...
            [E0(3) E1(3)], ...
            '-', ...
            'Color',[color 0.35], ...
            'LineWidth',1.5, ...
            'HandleVisibility','off');

    end

    %% Draw six selected Anchors

    A = config.A;

    scatter3( ...
        A(:,1),A(:,2),A(:,3), ...
        75,'k','filled', ...
        'HandleVisibility','off');

    for i = 1:6

        text( ...
            A(i,1)+6, ...
            A(i,2)+6, ...
            A(i,3)+6, ...
            sprintf('A%d (R%d)', ...
                i,config.rail_ids(i)), ...
            'FontSize',9, ...
            'FontWeight','bold', ...
            'BackgroundColor','w');

    end

    title(family_names{f}, ...
        'FontSize',12);

    xlabel('X - Length (mm)');
    ylabel('Y - Width (mm)');
    zlabel('Z - Height (mm)');

    axis equal;
    grid on;
    view(35,25);

    xlim([-160 160]);
    ylim([-170 170]);
    zlim([-180 180]);

    hold off;

end

%% Step 9: Print family-level information

fprintf('\n--- Family Counts ---\n');

for f = 1:N_family

    mask = [anchor_configs.family_id]==f;

    family_min = [ ...
        anchor_configs(mask).min_anchor_distance];

    fprintf('%s\n',family_names{f});

    fprintf('  Number of layouts: %d\n',sum(mask));

    fprintf('  Minimum sampled Anchor spacing: %.3f mm\n', ...
        min(family_min));

end

%% Step 10: Save configuration families
%
% 这些是初始Anchor布局，
% 不是完整Cable配置。
%
% 后续Lesson 4将加入：
% Attachment points
% Cable pairing
% Geometry verification
% Preliminary sensing evaluation

save('B5_3_12rail_anchor_families.mat', ...
    'anchor_configs', ...
    'family_names','family_assignments', ...
    't_patterns','T_summary', ...
    'rail_start','rail_end','rail_axis', ...
    'Lg','Wg','Hg','rb');

fprintf('\nB5.3 Lesson 3 completed.\n');

fprintf('Saved: B5_3_12rail_anchor_families.mat\n');