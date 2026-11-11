
%% B5.3 Lesson 5
% Early Multi-Pose Geometry, Sensing and Length Screening
%
% Research Question:
% Which of the 18 reference-feasible configurations
% remain suitable across the 189 Core poses?
%
% Objectives:
% 1. Evaluate all 18 fixed configurations
% 2. Check Cable-Sphere and Cable-Cable geometry
% 3. Evaluate multi-pose Jacobian singular values
% 4. Calculate Cable length range and variation
% 5. Check ideal twelve-rail anchor membership
% 6. Identify promising B5.4 starting candidates
%
% IMPORTANT:
% No configuration optimisation in this lesson.
% No measured hardware clearance or tension claims.
%
% Units:
% Length: mm
% Local rotation increments: rad
% Orientation samples: degrees

clear; clc; close all;

%% Step 1: Load saved configurations

load('B5_3_initial_six_cable_configurations.mat', ...
    'anchor_configs','best_configs', ...
    'family_names','rb');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end','Lg','Wg','Hg');

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'B3 segment-distance function not found.');

N_config = numel(best_configs);
n_cables = 6;

assert(N_config==18);

% 此前已经找到18个参考姿态候选
assert(all([best_configs.found]));

fprintf('\n--- B5.3 Lesson 5 ---\n');
fprintf('Loaded configurations: %d\n',N_config);

%% Step 2: Generate identical Core pose set
%
% 平移范围和旋转定义与B5.2完全一致。

position_values = [-20 0 20];

[X,Y,Z] = ndgrid( ...
    position_values,position_values,position_values);

P_samples = [X(:) Y(:) Z(:)];

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

assert(N_pose==189);

P_all = zeros(N_pose,3);
R_all = zeros(3,3,N_pose);

position_id = zeros(N_pose,1);
orientation_id = zeros(N_pose,1);

k = 0;

for i = 1:N_position

    for j = 1:N_rotation

        k = k+1;

        P_all(k,:) = P_samples(i,:);

        roll = deg2rad(angles_deg(j,1));
        pitch = deg2rad(angles_deg(j,2));
        yaw = deg2rad(angles_deg(j,3));

        Rx = [
            1 0 0;
            0 cos(roll) -sin(roll);
            0 sin(roll) cos(roll)
        ];

        Ry = [
            cos(pitch) 0 sin(pitch);
            0 1 0;
            -sin(pitch) 0 cos(pitch)
        ];

        Rz = [
            cos(yaw) -sin(yaw) 0;
            sin(yaw) cos(yaw) 0;
            0 0 1
        ];

        R = Rz*Ry*Rx;

        assert(norm(R'*R-eye(3),'fro')<1e-10);
        assert(abs(det(R)-1)<1e-10);

        R_all(:,:,k) = R;
        position_id(k) = i;
        orientation_id(k) = j;

    end
end

fprintf('Core poses generated: %d\n',N_pose);

%% Step 3: Check rigid-balloon containment
%
% 当前模型仍是半径rb的刚性球。
% 这个Core范围已经在B5.2验证过，
% 这里重新执行回归检查。

half_box = [Lg Wg Hg]/2;

contained = all( ...
    abs(P_samples)+rb<=half_box,2);

assert(all(contained));

fprintf('Balloon centre containment: 27 / 27\n');

%% Step 4: Define numerical criteria

sphere_tol = 1e-9;     % mm^2
contact_tol = 1e-6;    % mm

% 相对Rank判据
rank_relative_tol = 1e-10;

cable_pairs = nchoosek(1:n_cables,2);

N_pairs = size(cable_pairs,1);

assert(N_pairs==15);

% 与B4一致的Jacobian缩放
H_scale = diag([1 1 1 1/rb 1/rb 1/rb]);

%% Step 5: Prepare output storage

screening = cell(N_config,1);

% 汇总指标
SpherePass = zeros(N_config,1);
CablePass = zeros(N_config,1);
GeometryPass = zeros(N_config,1);

RankPassFeasible = zeros(N_config,1);

MinSigmaFeasible = nan(N_config,1);
MedianSigmaFeasible = nan(N_config,1);
MaxKappaFeasible = nan(N_config,1);

MinCableDistance = nan(N_config,1);

MinLength = nan(N_config,1);
MaxLength = nan(N_config,1);
MaxStroke = nan(N_config,1);

%% Step 6: Evaluate each fixed configuration

for c = 1:N_config

    cfg = best_configs(c);

    A = cfg.A;
    r = cfg.r;

    fprintf('\n====================================\n');
    fprintf('Configuration %d / %d\n',c,N_config);
    fprintf('%s\n',family_names{cfg.family_id});
    fprintf('====================================\n');

    % 每个姿态的几何通过情况
    sphere_safe = false(N_pose,1);
    cable_safe = false(N_pose,1);
    geometry_safe = false(N_pose,1);

    % 每根Cable的球面检查
    outward_safe = false(N_pose,n_cables);

    % 每对Cable的最小距离
    distances = zeros(N_pose,N_pairs);

    % 每个姿态下六根Cable的长度
    L_all = zeros(N_pose,n_cables);

    % Jacobian性能
    sigma_min_all = nan(N_pose,1);
    kappa_all = nan(N_pose,1);
    rank_all = zeros(N_pose,1);

    %% Step 7: Verify rail membership

    for i = 1:n_cables

        rid = cfg.rail_ids(i);
        ti = cfg.t(i);

        assert(rid>=1 && rid<=12);
        assert(ti>=0 && ti<=1);

        A_expected = rail_start(rid,:) + ...
            ti*(rail_end(rid,:)-rail_start(rid,:));

        assert(norm(A(i,:)-A_expected)<1e-8);

    end

    % 检查Attachment均在球面
    radius_error = max( ...
        abs(vecnorm(r,2,2)-rb));

    assert(radius_error<1e-8);

    %% Step 8: Evaluate all Core poses

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        % S_i = R*r_i
        % 球心指向当前Attachment的世界向量
        S = (R*r')';

        % Attachment世界位置
        B = S+P;

        % Cable方向：Attachment指向Anchor
        D = A-B;

        L = vecnorm(D,2,2);

        assert(all(L>1e-9));

        L_all(k,:) = L';

        %% 8.1 Cable-Sphere check

        outward_dot = sum(S.*D,2);

        outward_safe(k,:) = ...
            (outward_dot>=-sphere_tol)';

        sphere_safe(k) = all(outward_safe(k,:));

        %% 8.2 Cable-Cable check

        for j = 1:N_pairs

            i1 = cable_pairs(j,1);
            i2 = cable_pairs(j,2);

            distances(k,j) = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

        end

        cable_safe(k) = ...
            all(distances(k,:)>contact_tol);

        %% 8.3 Combined geometry

        geometry_safe(k) = ...
            sphere_safe(k) && cable_safe(k);

        %% 8.4 Measurement Jacobian

        % u_i：Attachment指向Anchor的单位向量
        u = D./L;

        H = zeros(6,6);

        for i = 1:n_cables

            H(i,:) = [
                -u(i,:), ...
                cross(u(i,:),S(i,:))
            ];

        end

        Hs = H*H_scale;

        s = svd(Hs);

        sigma_min_all(k) = s(end);

        % 相对数值Rank
        rank_all(k) = sum( ...
            s>rank_relative_tol*s(1));

        if s(end)>0
            kappa_all(k) = s(1)/s(end);
        else
            kappa_all(k) = inf;
        end

    end

    %% Step 9: Core screening statistics

    SpherePass(c) = sum(sphere_safe);
    CablePass(c) = sum(cable_safe);
    GeometryPass(c) = sum(geometry_safe);

    MinCableDistance(c) = min(distances(:));

    % 只统计几何可行姿态上的感知性能
    feasible = geometry_safe;

    if any(feasible)

        sigma_valid = sigma_min_all(feasible);
        kappa_valid = kappa_all(feasible);

        rank_valid = rank_all(feasible);

        RankPassFeasible(c) = sum(rank_valid==6);

        MinSigmaFeasible(c) = min(sigma_valid);

        MedianSigmaFeasible(c) = ...
            median(sigma_valid);

        MaxKappaFeasible(c) = max(kappa_valid);

    end

    %% Step 10: Cable-length statistics

    % 整个Core姿态集合上的长度范围
    % 包括几何失败姿态，用于诊断潜在行程。
    %
    % 不能把它直接称为实际可运行行程。

    MinLength(c) = min(L_all(:));
    MaxLength(c) = max(L_all(:));

    % 每根Cable分别计算长度变化范围
    stroke_per_cable = ...
        max(L_all,[],1)-min(L_all,[],1);

    % 六根Cable中需要最大行程的一根
    MaxStroke(c) = max(stroke_per_cable);

    %% Step 11: Reference-pose regression

    ref_id = find( ...
        all(P_all==0,2) & orientation_id==1);

    assert(numel(ref_id)==1);

    % Lesson 4的参考姿态配置应当可行
    assert(geometry_safe(ref_id), ...
        'Reference geometry regression failed.');

    % 与Lesson 4保存的sigma_min核对
    sigma_error = abs( ...
        sigma_min_all(ref_id)-cfg.sigma_min);

    assert(sigma_error<1e-8, ...
        'Reference Jacobian regression failed.');

    %% Step 12: Store full diagnostic results

    g = struct();

    g.name = family_names{cfg.family_id};
    g.config_id = c;

    g.A = A;
    g.r = r;
    g.rail_ids = cfg.rail_ids;
    g.t = cfg.t;
    g.pairing = cfg.pairing;

    g.sphere_safe = sphere_safe;
    g.cable_safe = cable_safe;
    g.geometry_safe = geometry_safe;

    g.outward_safe = outward_safe;
    g.distances = distances;

    g.L_all = L_all;
    g.stroke_per_cable = stroke_per_cable;

    g.sigma_min_all = sigma_min_all;
    g.kappa_all = kappa_all;
    g.rank_all = rank_all;

    g.reference_sigma_min = ...
        sigma_min_all(ref_id);

    g.reference_kappa = ...
        kappa_all(ref_id);

    screening{c} = g;

    fprintf('Sphere passing: %d / 189\n',SpherePass(c));

    fprintf('Cable passing: %d / 189\n',CablePass(c));

    fprintf('Geometry passing: %d / 189\n', ...
        GeometryPass(c));

    fprintf('Rank-6 poses among feasible: %d / %d\n', ...
        RankPassFeasible(c),GeometryPass(c));

    fprintf('Worst feasible sigma_min: %.6f\n', ...
        MinSigmaFeasible(c));

    fprintf('Worst feasible kappa: %.6f\n', ...
        MaxKappaFeasible(c));

    fprintf('Minimum cable distance: %.4f mm\n', ...
        MinCableDistance(c));

    fprintf('Maximum calculated stroke: %.3f mm\n', ...
        MaxStroke(c));

end

%% Step 13: Build comparison table

ConfigID = (1:N_config)';

Family = strings(N_config,1);

for c = 1:N_config
    Family(c) = string(screening{c}.name);
end

GeometryPercent = 100*GeometryPass/N_pose;

% 初步的Core严格几何通过条件
CoreFullPass = GeometryPass==N_pose;

% 同时要求全部Core姿态Jacobian满秩
CoreCandidate = CoreFullPass & ...
    RankPassFeasible==N_pose;

T_results = table( ...
    ConfigID,Family, ...
    SpherePass,CablePass,GeometryPass, ...
    GeometryPercent,RankPassFeasible, ...
    MinSigmaFeasible,MedianSigmaFeasible, ...
    MaxKappaFeasible,MinCableDistance, ...
    MinLength,MaxLength,MaxStroke, ...
    CoreFullPass,CoreCandidate);

disp(' ');
disp('--- B5.3 Lesson 5 Results ---');
disp(T_results);

fprintf('\nFull Core geometry pass: %d / %d\n', ...
    sum(CoreFullPass),N_config);

fprintf('Full Core geometry + rank-6: %d / %d\n', ...
    sum(CoreCandidate),N_config);

%% Step 14: Numerical consistency checks

for c = 1:N_config

    g = screening{c};

    assert(isequal(size(g.L_all),[189 6]));
    assert(isequal(size(g.distances),[189 15]));

    assert(all(isfinite(g.L_all(:))));
    assert(all(g.L_all(:)>0));

    assert(all(isfinite(g.distances(:))));
    assert(all(g.distances(:)>=0));

    assert(isequal(g.geometry_safe, ...
        g.sphere_safe & g.cable_safe));

    assert(GeometryPass(c)<=SpherePass(c));
    assert(GeometryPass(c)<=CablePass(c));

    assert(RankPassFeasible(c)<=GeometryPass(c));

end

fprintf('All numerical consistency checks passed.\n');

%% Step 15: Plot Core geometry comparison

figure('Color','w', ...
    'Name','B5.3 Core Multi-Pose Geometry', ...
    'Position',[100 100 1200 550]);

bar(ConfigID,GeometryPass);

hold on;

yline(189,'--', ...
    'Core full-pass target', ...
    'LabelHorizontalAlignment','left');

xlabel('Configuration ID');
ylabel('Geometrically Feasible Core Poses');

title('B5.3 - Core Geometry Screening');

xticks(1:N_config);
ylim([0 200]);

grid on;
hold off;

%% Step 16: Plot sensing performance

figure('Color','w', ...
    'Name','B5.3 Feasible-Pose Sensing', ...
    'Position',[100 100 1200 550]);

bar(ConfigID,MinSigmaFeasible);

xlabel('Configuration ID');

ylabel('Minimum Scaled Singular Value');

title(['B5.3 - Worst Sensing Quality ' ...
    'on Geometrically Feasible Poses']);

xticks(1:N_config);

grid on;

% 注意：
% 这张图仅用于初步观察。
% 不同Config的几何可行姿态数量可能不同，
% 所以不能直接将柱高作为公平的最终排名。

%% Step 17: Preliminary shortlist

% 首先只从满足Core全部几何和Rank要求的
% 配置中选择初步候选。
%
% 如果没有任何配置满足，
% 则报告事实，不降低验收标准。
%
% 为防止单一家族完全占据候选，
% 每个Family最多保留2组初步配置。
%
% 这不是最终Prototype推荐。

shortlist_ids = [];

for f = 1:numel(family_names)

    family_ids = find( ...
        [best_configs.family_id]==f);

    eligible = family_ids(CoreCandidate(family_ids));

    if isempty(eligible)
        continue;
    end

    % 确保 eligible 强制转换为列向量，避免 vertcat 维度冲突
    eligible = eligible(:);

    % 按最差可行姿态sigma_min降序排列
    [~,order] = sort( ...
        MinSigmaFeasible(eligible),'descend');

    n_keep = min(2,numel(order));

    shortlist_ids = [
        shortlist_ids;
        eligible(order(1:n_keep))
    ];

end

fprintf('\n--- Preliminary Core-Eligible Shortlist ---\n');

if isempty(shortlist_ids)

    fprintf('No configuration meets all Core gates.\n');

    fprintf(['B5.4 must improve initial geometry ' ...
        'before strict sensing optimisation.\n']);

else

    disp(T_results(shortlist_ids,:));

end

%% Step 18: Save for B5.4

save('B5_3_early_multipose_screening.mat', ...
    'screening','T_results', ...
    'shortlist_ids', ...
    'P_all','R_all', ...
    'position_id','orientation_id','angles_deg', ...
    'cable_pairs', ...
    'sphere_tol','contact_tol', ...
    'rank_relative_tol','rb');

fprintf('\nB5.3 Lesson 5 completed.\n');

fprintf('Saved: B5_3_early_multipose_screening.mat\n');
