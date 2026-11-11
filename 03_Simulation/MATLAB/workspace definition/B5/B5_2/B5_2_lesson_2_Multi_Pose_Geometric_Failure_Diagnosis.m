%% B5.2 Lesson 2
% Multi-Pose Geometric Failure Diagnosis
%
% Research Question:
% Which cables and cable pairs cause failures,
% and at which Core poses?
%
% Objectives:
% 1. Classify sphere-only, cable-only and combined failures
% 2. Identify problematic individual cables
% 3. Identify colliding cable pairs
% 4. Locate the worst failure poses
% 5. Save diagnostic results for visualisation


clear; clc; close all;

%% Step 1: Load previous geometry results

load('B5_2_five_config_core_geometry.mat', ...
    'geometry_results','config_names', ...
    'P_all','R_all','orientation_id', ...
    'angles_deg','cable_pairs', ...
    'sphere_tol','contact_tol');

N_config = numel(geometry_results);
N_pose = size(P_all,1);

assert(N_config == 5);
assert(N_pose == 189);
assert(size(cable_pairs,1) == 15);

% 保存各配置诊断结果
diagnosis = cell(N_config,1);

%% Step 2: Analyse each configuration

for c = 1:N_config

    g = geometry_results{c};

    fprintf('\n====================================\n');
    fprintf('%s\n',config_names{c});
    fprintf('====================================\n');
    
    % 读取之前已经计算好的检查结果
    sphere_safe = g.sphere_safe;
    cable_safe = g.cable_safe;

    % 每根Cable的球面检查结果
    outward_safe = g.outward_safe;
    % outward_safe 是一个 189 * 6 的逻辑矩阵，
    % 矩阵的第 j 列严格对应第 j 根 Cable。
   
    % 189x15 Cable-pair距离矩阵
    distances = g.distances;

    %% Step 3: Classify failure categories

    % 只有Cable-sphere失败
    sphere_only = ~sphere_safe & cable_safe;

    % 只有Cable-cable失败
    cable_only = sphere_safe & ~cable_safe;

    % 两种干涉同时发生
    both_fail = ~sphere_safe & ~cable_safe;

    % 综合失败
    geometry_fail = ~(sphere_safe & cable_safe);

    N_sphere_only = sum(sphere_only);
    N_cable_only = sum(cable_only);
    N_both = sum(both_fail);

    fprintf('\n--- Failure Categories ---\n');

    fprintf('Sphere-only failures: %d\n', ...
        N_sphere_only);

    fprintf('Cable-only failures: %d\n', ...
        N_cable_only);

    fprintf('Both failures: %d\n',N_both);

    fprintf('Total failed poses: %d / %d\n', ...
        sum(geometry_fail),N_pose);

    % 三类失败应恰好组成全部失败姿态
    assert( ...
        N_sphere_only+N_cable_only+N_both ...
        == sum(geometry_fail));

    %% Step 4: Find individual cable-sphere failures
    
    % 每列代表一根Cable
    % 统计这根Cable在多少个姿态下未通过
    sphere_fail_counts = sum(~outward_safe,1);
    % 通过按列求和来统计每一根缆索在 189 个姿态下的失效次数。

    fprintf('\n--- Cable-Sphere Failure Counts ---\n');

    T_sphere = table( ...
        (1:6)',sphere_fail_counts', ...
        'VariableNames', ...
        {'Cable','FailureCount'});

    disp(T_sphere);
    
    %% Step 5: Find cable-cable contact pairs
    
    % 判断189姿态下每对Cable是否数值接触
    contact_mask = distances <= contact_tol;

    % 统计每对Cable发生接触的姿态数量
    pair_fail_counts = sum(contact_mask,1);

    fprintf('\n--- Cable-Cable Contact Counts ---\n');

    T_pairs = table( ...
        cable_pairs(:,1), ...
        cable_pairs(:,2), ...
        pair_fail_counts', ...
        min(distances,[],1)', ...
        'VariableNames', ...
        {'Cable1','Cable2', ...
        'ContactCount','MinimumDistance_mm'});

    disp(T_pairs);
    
    %% Step 6: Diagnose worst cable-sphere pose

    % 需要重新计算outward_dot的实际数值
    % 因为Lesson 1只保存了logical结果
    outward_dot_all = zeros(N_pose,6);
    
    A = g.A;
    r = g.r;

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        % 球心到世界坐标Attachment的向量
        S = (R*r')';

        % 世界坐标Attachment位置
        B = S + P;

        % Cable向量
        D = A-B;

        % 外法线与Cable的点积
        outward_dot_all(k,:) = sum(S.*D,2)';

    end

    % 找到所有Cable及姿态中的最小点积
    [min_outward,linear_idx] = ...
        min(outward_dot_all(:));

    [worst_sphere_pose,worst_sphere_cable] = ...
        ind2sub(size(outward_dot_all),linear_idx);

    fprintf('\n--- Worst Cable-Sphere Pose ---\n');

    fprintf('Pose index: %d\n',worst_sphere_pose);

    fprintf('Cable number: %d\n',worst_sphere_cable);

    fprintf('Position [mm]:\n');
    disp(P_all(worst_sphere_pose,:));

    fprintf('Orientation [roll pitch yaw] deg:\n');

    disp(angles_deg( ...
        orientation_id(worst_sphere_pose),:));

    fprintf('Minimum outward dot: %.6f mm^2\n', ...
        min_outward);

    % 如果min_outward >= -sphere_tol，
    % 说明当前配置所有Core姿态都通过了
    % Cable-sphere检查。
    if min_outward >= -sphere_tol
        fprintf('No cable-sphere failure detected.\n');
    end

    %% Step 7: Diagnose worst cable-pair pose

    % 全部189x15距离中的全局最小值
    [min_distance,linear_idx] = ...
        min(distances(:));

    [worst_pair_pose,worst_pair_id] = ...
        ind2sub(size(distances),linear_idx);

    worst_pair = cable_pairs(worst_pair_id,:);

    fprintf('\n--- Minimum Cable-Pair Distance ---\n');

    fprintf('Pose index: %d\n',worst_pair_pose);

    fprintf('Cable pair: %d and %d\n', ...
        worst_pair(1),worst_pair(2));

    fprintf('Position [mm]:\n');
    disp(P_all(worst_pair_pose,:));

    fprintf('Orientation [roll pitch yaw] deg:\n');

    disp(angles_deg( ...
        orientation_id(worst_pair_pose),:));

    fprintf('Minimum distance: %.8f mm\n', ...
        min_distance);

    if min_distance > contact_tol
        fprintf('No cable-cable contact detected.\n');
    end

    %% Step 8: Save diagnostics

    diagnosis{c}.name = config_names{c};

    diagnosis{c}.sphere_only = sphere_only;
    diagnosis{c}.cable_only = cable_only;
    diagnosis{c}.both_fail = both_fail;

    diagnosis{c}.sphere_fail_counts = ...
        sphere_fail_counts;

    diagnosis{c}.pair_fail_counts = ...
        pair_fail_counts;

    diagnosis{c}.outward_dot_all = ...
        outward_dot_all;

    diagnosis{c}.worst_sphere_pose = ...
        worst_sphere_pose;

    diagnosis{c}.worst_sphere_cable = ...
        worst_sphere_cable;

    diagnosis{c}.worst_pair_pose = ...
        worst_pair_pose;

    diagnosis{c}.worst_pair = worst_pair;

end

%% Step 9: Visualise failure distribution

% 每个配置绘制两种故障统计
figure('Color','w', ...
    'Name','B5.2 Geometric Failure Diagnosis', ...
    'Position',[100 100 1200 800]);

% 第一张图：逐Cable球面失败次数
subplot(2,1,1);

sphere_matrix = zeros(N_config,6);

for c = 1:N_config
    sphere_matrix(c,:) = ...
        diagnosis{c}.sphere_fail_counts;
end

imagesc(sphere_matrix);
colorbar;

title('Cable-Sphere Failure Counts');

xlabel('Cable Number');
ylabel('Configuration');

xticks(1:6);
yticks(1:N_config);
yticklabels(config_names);

% 第二张图：逐Cable-pair接触次数
subplot(2,1,2);

pair_matrix = zeros(N_config,15);

for c = 1:N_config
    pair_matrix(c,:) = ...
        diagnosis{c}.pair_fail_counts;
end

imagesc(pair_matrix);
colorbar;

title('Cable-Cable Contact Counts');

xlabel('Cable Pair');
ylabel('Configuration');

% 设置15对Cable的名称
pair_labels = strings(15,1);

for j = 1:15
    pair_labels(j) = sprintf('%d-%d', ...
        cable_pairs(j,1),cable_pairs(j,2));
end

xticks(1:15);
xticklabels(pair_labels);

yticks(1:N_config);
yticklabels(config_names);

%% Step 10: Save results

save('B5_2_failure_diagnosis.mat', ...
    'diagnosis','config_names', ...
    'geometry_results','P_all','R_all', ...
    'orientation_id','angles_deg', ...
    'cable_pairs','sphere_tol','contact_tol');

fprintf('\nB5.2 Lesson 2 diagnosis completed.\n');