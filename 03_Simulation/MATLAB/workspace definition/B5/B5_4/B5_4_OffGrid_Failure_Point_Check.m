
%% B5.4 - Off-grid Failure Point Check
% 目的：
% 1. 找出三个配置各自失败的具体姿态
% 2. 输出每个配置的六个Anchor坐标
% 3. 识别Cable-Sphere和Cable-Cable故障
% 4. 可视化失败姿态
%
% 不重新采样，不进行优化。
% 坐标单位：mm

clear; clc; close all;

%% Step 1: 读取已有结果

load('B5_4_E1a_Config2_robustness_verification.mat', ...
    'T_designs','P_test','R_test', ...
    'angles_test_deg','offgrid_details', ...
    'rail_ids','r','settings');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

design_names = [
    "Original Config 2";
    "Sensing-oriented";
    "Clearance-oriented"
];

N_design = 3;
N_pose = size(P_test,1);

assert(N_pose==150);
assert(size(T_designs,1)==3);

pairs = nchoosek(1:6,2);

%% Step 2: 输出每个配置的六个Anchor坐标

A_designs = cell(3,1);
T_anchors = cell(3,1);

fprintf('\n========== ANCHOR COORDINATES ==========\n');

for d = 1:N_design

    t = T_designs(d,:);
    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

    A_designs{d} = A;

    CableID = (1:6)';
    RailID = rail_ids(:);
    RailT = t(:);

    X_mm = A(:,1);
    Y_mm = A(:,2);
    Z_mm = A(:,3);

    T_anchor = table( ...
        CableID,RailID,RailT, ...
        X_mm,Y_mm,Z_mm);

    T_anchors{d} = T_anchor;

    fprintf('\n%s\n',design_names(d));
    disp(T_anchor);

end

%% Step 3: 找到全部失败姿态

failed_ids = cell(3,1);

fprintf('\n========== FAILED POSES ==========\n');

for d = 1:N_design

    old = offgrid_details{d};

    failed_ids{d} = find(~old.geometry_safe);

    fprintf('\n%s\n',design_names(d));

    fprintf('Failed Pose IDs: %s\n', ...
        mat2str(failed_ids{d}'));

    for k = failed_ids{d}(:)'

        fprintf('Pose %d\n',k);

        fprintf('P [x y z] mm: %s\n', ...
            mat2str(P_test(k,:),6));

        fprintf('Roll Pitch Yaw [deg]: %s\n', ...
            mat2str(angles_test_deg(k,:),6));

    end

end

same_failed_pose = isequal( ...
    failed_ids{1},failed_ids{2}) && ...
    isequal(failed_ids{2},failed_ids{3});

fprintf('\nAll designs failed at same Pose ID: %d\n', ...
    same_failed_pose);

%% Step 4: 对每个失败姿态进行详细诊断

diagnosis = cell(3,1);

fprintf('\n========== FAILURE CAUSE ==========\n');

for d = 1:N_design

    A = A_designs{d};

    design_diagnosis = struct([]);

    for m = 1:numel(failed_ids{d})

        k = failed_ids{d}(m);

        P = P_test(k,:);
        R = R_test(:,:,k);

        % 当前姿态下的球面Attachment向量
        S = (R*r')';

        % 当前Attachment世界坐标
        B = S+P;

        % Attachment指向Anchor
        D = A-B;

        L = vecnorm(D,2,2);

        %% 4.1 Cable-Sphere

        outward_dot = sum(S.*D,2);

        sphere_failed = ...
            outward_dot < -settings.sphere_tol;

        T_cables = table( ...
            (1:6)', ...
            outward_dot, ...
            sphere_failed, ...
            L, ...
            'VariableNames', ...
            {'CableID','OutwardDot_mm2', ...
             'SphereFailed','Length_mm'});

        %% 4.2 Cable-Cable

        pair_distances = zeros(15,1);

        for j = 1:15

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            pair_distances(j) = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

        end

        contact_failed = ...
            pair_distances <= settings.contact_tol;

        T_pairs = table( ...
            pairs(:,1),pairs(:,2), ...
            pair_distances,contact_failed, ...
            'VariableNames', ...
            {'Cable1','Cable2', ...
             'Distance_mm','ContactFailed'});

        [min_distance,closest_id] = ...
            min(pair_distances);

        %% 4.3 Print diagnosis

        fprintf('\n--------------------------------\n');
        fprintf('%s | Failed Pose %d\n', ...
            design_names(d),k);
        fprintf('--------------------------------\n');

        fprintf('Position [mm]: %s\n', ...
            mat2str(P,6));

        fprintf('Roll/Pitch/Yaw [deg]: %s\n', ...
            mat2str(angles_test_deg(k,:),6));

        fprintf('\nCable-Sphere diagnostics:\n');
        disp(T_cables);

        fprintf('Failed sphere cables: %s\n', ...
            mat2str(find(sphere_failed)'));

        fprintf('\nAll 15 cable-pair distances:\n');
        disp(T_pairs);

        fprintf('Contact pair IDs:\n');
        disp(pairs(contact_failed,:));

        fprintf('Closest pair: C%d-C%d\n', ...
            pairs(closest_id,1), ...
            pairs(closest_id,2));

        fprintf('Minimum pair distance: %.8f mm\n', ...
            min_distance);

        %% 4.4 Verify stored geometry mask

        newly_safe = ...
            ~any(sphere_failed) && ...
            ~any(contact_failed);

        assert( ...
            newly_safe == ...
            offgrid_details{d}.geometry_safe(k), ...
            'Stored and recomputed geometry disagree.');

        %% 4.5 Save full diagnosis

        design_diagnosis(m).pose_id = k;

        design_diagnosis(m).P = P;
        design_diagnosis(m).R = R;

        design_diagnosis(m).A = A;
        design_diagnosis(m).B = B;

        design_diagnosis(m).outward_dot = ...
            outward_dot;

        design_diagnosis(m).sphere_failed = ...
            sphere_failed;

        design_diagnosis(m).pair_distances = ...
            pair_distances;

        design_diagnosis(m).contact_failed = ...
            contact_failed;

        design_diagnosis(m).T_cables = T_cables;
        design_diagnosis(m).T_pairs = T_pairs;

    end

    diagnosis{d} = design_diagnosis;

end

%% Step 5: 三维可视化
% 每个配置显示第一个失败姿态。
%
% 黑色点：Anchor
% 蓝色菱形：Attachment
% 灰色线：正常Cable
% 红色线：失败Cable
% 紫色星号：气球中心P
%
% 标出各配置的失败位置与旋转角度。

figure( ...
    'Color','w', ...
    'Name','B5.4 Off-grid Failure Investigation', ...
    'Position',[80 80 1550 620]);

tl = tiledlayout(1,3, ...
    'TileSpacing','compact', ...
    'Padding','loose');

for d = 1:3

    nexttile;
    hold on;

    if isempty(diagnosis{d})

        title(design_names(d)+" - No failure");
        continue;

    end

    g = diagnosis{d}(1);

    P = g.P;
    A = g.A;
    B = g.B;

    bad_cables = g.sphere_failed;

    for j = find(g.contact_failed)'

        bad_cables(pairs(j,1)) = true;
        bad_cables(pairs(j,2)) = true;

    end

    %% Draw balloon

    [sx,sy,sz] = sphere(30);

    surf( ...
        settings.rb*sx+P(1), ...
        settings.rb*sy+P(2), ...
        settings.rb*sz+P(3), ...
        'FaceColor',[0.60 0.80 1.00], ...
        'FaceAlpha',0.25, ...
        'EdgeColor','none', ...
        'HandleVisibility','off');

    %% Draw cable + anchor + attachment

    for i = 1:6

        if bad_cables(i)

            cable_color = [0.90 0.10 0.10];
            line_width = 3.5;

        else

            cable_color = [0.40 0.40 0.40];
            line_width = 1.5;

        end

        plot3( ...
            [B(i,1) A(i,1)], ...
            [B(i,2) A(i,2)], ...
            [B(i,3) A(i,3)], ...
            '-', ...
            'Color',cable_color, ...
            'LineWidth',line_width, ...
            'HandleVisibility','off');

        scatter3( ...
            A(i,1),A(i,2),A(i,3), ...
            45,'k','filled', ...
            'HandleVisibility','off');

        scatter3( ...
            B(i,1),B(i,2),B(i,3), ...
            35,[0.15 0.45 0.9], ...
            'd','filled', ...
            'HandleVisibility','off');

        text( ...
            A(i,1),A(i,2),A(i,3), ...
            sprintf(' A%d',i), ...
            'FontSize',9);

        text( ...
            B(i,1),B(i,2),B(i,3), ...
            sprintf(' B%d',i), ...
            'FontSize',9);

    end

    %% Mark balloon centre

    scatter3( ...
        P(1),P(2),P(3), ...
        100,[0.6 0.1 0.7], ...
        '*','LineWidth',2, ...
        'HandleVisibility','off');

    text( ...
        P(1),P(2),P(3), ...
        ' P','FontWeight','bold');

    %% Title with exact pose data

    a = angles_test_deg(g.pose_id,:);

    title({
        char(design_names(d));
        sprintf('Failed Pose %d',g.pose_id);
        sprintf('P=[%.1f %.1f %.1f] mm',P);
        sprintf('RPY=[%.2f %.2f %.2f] deg',a)
    },'FontSize',10);

    xlabel('X - Length (mm)');
    ylabel('Y - Width (mm)');
    zlabel('Z - Height (mm)');

    axis equal;
    grid on;
    view(35,25);

    xlim([-170 170]);
    ylim([-180 180]);
    zlim([-190 190]);

    hold off;

end

title(tl,'B5.4 - Failed Off-grid Poses', ...
    'FontSize',14);

% 图注独立放在窗口底部
annotation('textbox', ...
    [0.24 0.005 0.54 0.035], ...
    'String', ...
    ['Red = Failed Cable | Grey = Normal | ' ...
     'Black = Anchor | Blue = Attachment | ' ...
     'Purple = Balloon Centre'], ...
    'HorizontalAlignment','center', ...
    'EdgeColor','none', ...
    'FontSize',10);

%% Step 6: 保存诊断结果

save('B5_4_offgrid_failure_point_check.mat', ...
    'failed_ids','same_failed_pose', ...
    'A_designs','T_anchors', ...
    'diagnosis','design_names');

fprintf('\nFailure point investigation completed.\n');
fprintf('Saved: B5_4_offgrid_failure_point_check.mat\n');
