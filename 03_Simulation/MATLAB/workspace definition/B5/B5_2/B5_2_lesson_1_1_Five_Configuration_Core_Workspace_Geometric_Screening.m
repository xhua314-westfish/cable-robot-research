% Research Question:
% Which six-cable configurations maintain geometric
% feasibility across the same 189 Core poses?
%
% Research Objectives:
% 1. Compare Original B, Bprime, F1, F2 and F3
% 2. Check cable-sphere interference
% 3. Check cable-cable interference
% 4. Calculate geometric feasibility coverage
% 5. Save detailed results for B5.2 Lesson 2
%
% IMPORTANT:
% This is geometric screening only.
% No Jacobian optimisation or tension analysis.

%% Step 1: Load all five configurations

% 读取Original B
load('B2_experiment_B_results.mat','resultB');

% 读取B5.1中已经优化好的F1/F2/F3
load('B5_1_geometry_constrained_pairing.mat', ...
    'best_configs','family_names','rb');

% 检查B3距离函数是否存在
assert(exist('B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'B3 segment-distance function not found.');

% 保存五种配置的名称
config_names = {
    'Original B';
    'Modified Bprime';
    'F1 - Six-Face Distributed';
    'F2 - Opposite/Layered';
    'F3 - Asymmetric'
    };

N_config = numel(config_names);
n_cables = 6;

% 每个cell保存一个配置的A和r
configs = cell(N_config,1);

% Configuration 1: Original B
configs{1}.A = resultB.A;
configs{1}.r = resultB.r;

% Configuration 2: Modified Bprime
% Anchors不变，只交换Attachment 5和6
configs{2}.A = resultB.A;

r_Bprime = resultB.r;
r_Bprime([5 6],:) = r_Bprime([6 5],:);

configs{2}.r = r_Bprime;

% Configuration 3-5: F1, F2, F3
% 使用已保存的最佳几何可行Pairing
for k = 1:3

    assert(~isempty(best_configs{k}), ...
        'Family F%d has no saved feasible pairing.',k);

    configs{k+2}.A = best_configs{k}.A;
    configs{k+2}.r = best_configs{k}.r;

end

% 检查五种配置是否都是6x3坐标矩阵
for k = 1:N_config

    assert(isequal(size(configs{k}.A),[6 3]));
    assert(isequal(size(configs{k}.r),[6 3]));

    % 检查Attachment是否位于球面
    radius_error = max(abs( ...
        vecnorm(configs{k}.r,2,2)-rb));

    assert(radius_error < 1e-4);

end

fprintf('Five configurations loaded successfully.\n');

%% Step 2: Generate Core Workspace positions

% Core平移采样
p_values = [-20 0 20];

% 生成27个球心位置
[X,Y,Z] = ndgrid(p_values,p_values,p_values);

P_samples = [X(:),Y(:),Z(:)];

% Core单轴旋转采样，单位degree
% 每一行：[Roll Pitch Yaw]
angles_deg = [
    0  0  0;
    5  0  0;
    -5  0  0;
    0  5  0;
    0 -5  0;
    0  0  5;
    0  0 -5
    ];

N_position = size(P_samples,1);
N_rotation = size(angles_deg,1);

N_pose = N_position*N_rotation;

assert(N_position==27);
assert(N_rotation==7);
assert(N_pose==189);

%% Step 3: Build the 189 complete poses

% P_all(k,:) = 第k个姿态的球心位置
P_all = zeros(N_pose,3);

% R_all(:,:,k) = 第k个姿态的旋转矩阵
R_all = zeros(3,3,N_pose);

% 记录姿态来源，方便后续故障诊断
position_id = zeros(N_pose,1);
orientation_id = zeros(N_pose,1);

idx = 0;

for i = 1:N_position

    for j = 1:N_rotation

        idx = idx+1;

        % 保存球心位置
        P_all(idx,:) = P_samples(i,:);

        % 将旋转角从degree转换为rad
        roll = deg2rad(angles_deg(j,1));
        pitch = deg2rad(angles_deg(j,2));
        yaw = deg2rad(angles_deg(j,3));

        % 绕X轴旋转
        Rx = [
            1 0 0;
            0 cos(roll) -sin(roll);
            0 sin(roll) cos(roll)
            ];

        % 绕Y轴旋转
        Ry = [
            cos(pitch) 0 sin(pitch);
            0 1 0;
            -sin(pitch) 0 cos(pitch)
            ];

        % 绕Z轴旋转
        Rz = [
            cos(yaw) -sin(yaw) 0;
            sin(yaw) cos(yaw) 0;
            0 0 1
            ];

        % 与B3.2保持相同ZYX旋转约定
        R = Rz*Ry*Rx;

        % 数值检查：必须是有效旋转矩阵
        assert(norm(R'*R-eye(3),'fro')<1e-10);
        assert(abs(det(R)-1)<1e-10);

        R_all(:,:,idx) = R;

        position_id(idx) = i;
        orientation_id(idx) = j;

    end
end

fprintf('Core poses generated: %d\n',idx);

%% Step 4: Verify Core balloon containment

% B1工程边界半尺寸
half_box = [140 150 160];

% 这里球体不变形，旋转不改变其占用范围
% 只需要检查27个中心位置
containment = all( ...
    abs(P_samples)+rb <= half_box,2);

assert(all(containment), ...
    'Core positions exceed engineering boundary.');

fprintf('Balloon containment: %d / %d positions\n', ...
    sum(containment),N_position);

%% Step 5: Define geometric criteria

% Cable-sphere数值容差，单位mm^2
sphere_tol = 1e-6;

% Cable-cable接触阈值，单位mm
contact_tol = 1e-6;

% 六根Cable一共有15对不同组合
cable_pairs = nchoosek(1:n_cables,2);
N_pairs = size(cable_pairs,1);

assert(N_pairs==15);

% 每个cell保存一个配置的全部结果
geometry_results = cell(N_config,1);

% 汇总表的数值部分
% 每行：SpherePass, CablePass, GeometryPass,
%       MinCableDistance, ReferencePass
summary = zeros(N_config,5);


%% Step 6: Evaluate five configurations

for c = 1:N_config

    fprintf('\n====================================\n');
    fprintf('%s\n',config_names{c});
    fprintf('====================================\n');

    A = configs{c}.A;
    r = configs{c}.r;

    % 每个姿态是否全部通过Cable-sphere检查
    sphere_safe = false(N_pose,1);

    % 每个姿态是否全部通过Cable-cable检查
    cable_safe = false(N_pose,1);

    % 最终综合几何可行性
    geometry_safe = false(N_pose,1);

    % 逐根Cable的球面检查
    % 行：189个姿态
    % 列：6根Cable
    outward_safe = false(N_pose,n_cables);

    % 逐Cable-pair的最小距离
    % 行：189个姿态
    % 列：15对Cable
    distances = zeros(N_pose,N_pairs);

    %% Step 7: Evaluate each Core pose
    for k = 1:N_pose
        % 当前球心位置
        P = P_all(k,:);

        % 当前球体姿态
        R = R_all(:,:,k);

        % Body-frame Attachment旋转至世界坐标
        % S是球心指向Attachment的向量
        S = (R*r')';

        % Attachment在世界坐标系下的位置
        B = S + P;

        % Cable向量：Attachment指向Anchor
        D = A-B;

        % 排除退化Cable长度
        L = vecnorm(D,2,2);
        assert(all(L > 1e-9));

        %% 7.1 Cable-sphere interference

        % 外法线向量与Cable向量的点积
        outward_dot = sum(S.*D,2);

        % 判断每根Cable是否向球内出线
        outward_safe(k,:) = ...
            (outward_dot >= -sphere_tol)';

        % 六根Cable全部通过才算当前姿态通过
        sphere_safe(k) = all(outward_safe(k,:));

        %% 7.2 Cable-cable interference

        % 无论sphere检查是否失败，
        % 都计算全部15对Cable距离，
        % 避免丢失同时存在的干涉信息。

        for j = 1:N_pairs

            i1 = cable_pairs(j,1);
            i2 = cable_pairs(j,2);
            
            % 调用B3已验证的有限线段距离函数
            distances(k,j) = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                B(i1,:),A(i1,:), ...
                B(i2,:),A(i2,:));
        end

        % 全部15对都满足数值净空要求
        cable_safe(k) = ...
            all(distances(k,:) > contact_tol);

        %% 7.3 Combined geometric feasibility

        geometry_safe(k) = ...
           sphere_safe(k) && cable_safe(k);

    end

    %% Step 8: Summarise current configuration

    N_sphere = sum(sphere_safe);
    N_cable = sum(cable_safe);
    N_geometry = sum(geometry_safe);

    % 189姿态与15对Cable中的全局最小距离
    min_cable_distance = min(distances(:));

    fprintf('Sphere passing: %d / %d\n', ...
        N_sphere,N_pose);

    fprintf('Cable-cable passing: %d / %d\n', ...
        N_cable,N_pose);

    fprintf('Combined geometry passing: %d / %d\n', ...
        N_geometry,N_pose);

    fprintf('Minimum cable-pair distance: %.6f mm\n', ...
        min_cable_distance);

    %% Step 9: Reference-pose regression test

    % Core中的参考姿态:
    % P=[0 0 0], orientation=[0 0 0]
    reference_id = find( ...
        all(P_all==0,2) & orientation_id==1);

    assert(numel(reference_id)==1);

    reference_pass = geometry_safe(reference_id);

    fprintf('Reference pose geometry pass: %d\n', ...
        reference_pass);

    if ~reference_pass
        fprintf('\n[诊断信息] 配置 "%s" 未能通过参考姿态检查！\n', config_names{c});
    
        % 检查 1: 是否发生了 Cable-Sphere 出线/穿透问题
        if ~sphere_safe(reference_id)
        bad_cables = find(~outward_safe(reference_id, :));
        dots = sum(configs{c}.r .* (configs{c}.A - configs{c}.r), 2)';
        fprintf('  -> 穿球/向内出线的缆索编号: %s\n', mat2str(bad_cables));
        fprintf('  -> 各缆索点积 outward_dot: %s\n', mat2str(dots, 4));
        end
    
        % 检查 2: 是否发生了 Cable-Cable 干涉碰撞
        if ~cable_safe(reference_id)
            ref_dists = distances(reference_id, :);
            bad_pairs = find(ref_dists <= contact_tol);
            fprintf('  -> 发生干涉碰撞的缆索对序号 (1~15): %s\n', mat2str(bad_pairs));
            for p_idx = bad_pairs
                pair_cables = cable_pairs(p_idx, :);
                fprintf('     缆索对 [%d, %d] 间距为: %.8f mm\n', ...
                    pair_cables(1), pair_cables(2), ref_dists(p_idx));
            end
        end
    end


    

    %% Step 10: Store detailed results
    geometry_results{c}.name = config_names{c};

    geometry_results{c}.A = A;
    geometry_results{c}.r = r;

    geometry_results{c}.sphere_safe = sphere_safe;
    geometry_results{c}.cable_safe = cable_safe;
    geometry_results{c}.geometry_safe = geometry_safe;

    geometry_results{c}.outward_safe = outward_safe;
    geometry_results{c}.distances = distances;

    geometry_results{c}.N_sphere = N_sphere;
    geometry_results{c}.N_cable = N_cable;
    geometry_results{c}.N_geometry = N_geometry;

    geometry_results{c}.min_cable_distance = ...
         min_cable_distance;

    % 五个指标保存到汇总矩阵
    summary(c,:) = [
         N_sphere, ...
         N_cable, ...
         N_geometry, ...
         min_cable_distance, ...
         double(reference_pass)
         ];
end

%% Step 11: Generate comparison table

result_table = table( ...
    string(config_names), ...
    summary(:,1), ...
    summary(:,2), ...
    summary(:,3), ...
    100*summary(:,3)/N_pose, ...
    summary(:,4), ...
    logical(summary(:,5)), ...
    'VariableNames', ...
    {'Configuration', ...
    'SpherePass', ...
    'CablePass', ...
    'GeometryPass', ...
    'GeometryPercent', ...
    'MinCableDistance', ...
    'ReferencePass'});

disp(' ');
disp('--- B5.2 Core Geometry Comparison ---');
disp(result_table);

%% Step 12: Numerical consistency checks

for c = 1:N_config

    g = geometry_results{c};

    % 每个姿态必须检查15对Cable
    assert(isequal(size(g.distances),[189 15]));

    % 每个姿态记录六根Cable的球面检查
    assert(isequal(size(g.outward_safe),[189 6]));

    % 距离应当是有限非负实数
    assert(all(isfinite(g.distances(:))));
    assert(all(g.distances(:)>=0));

    % 综合通过必须同时满足两类几何检查
    assert(isequal(g.geometry_safe, ...
        g.sphere_safe & g.cable_safe));

    % 通过数量的基本关系
    assert(g.N_geometry<=g.N_sphere);
    assert(g.N_geometry<=g.N_cable);

end

fprintf('\nAll B5.2 numerical checks passed.\n');

%% Step 13: Visualise five-configuration comparison

figure('Color','w','Name','B5.2 Core Geometry');

bar(summary(:,3));

xticks(1:N_config);
xticklabels({'B','Bprime','F1','F2','F3'});

xlabel('Configuration');
ylabel('Geometry Passing Poses');
title('B5.2 - Core Workspace Geometry Comparison');

ylim([0 189]);
grid on;

% 标注每个配置通过的姿态数量
for c = 1:N_config

    text(c,summary(c,3)+4, ...
        sprintf('%d/189',summary(c,3)), ...
        'HorizontalAlignment','center', ...
        'FontSize',10);

end

%% Step 14: Save results for the next lesson

% 保留逐姿态、逐Cable和逐Cable-pair数据，
% 方便B5.2 Lesson 2分析失败原因。
save('B5_2_five_config_core_geometry.mat', ...
    'geometry_results','result_table', ...
    'config_names','P_all','R_all', ...
    'position_id','orientation_id', ...
    'angles_deg','cable_pairs', ...
    'sphere_tol','contact_tol','rb');

fprintf('B5.2 Core geometry results saved.\n');