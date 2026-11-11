
%% B5.4 Lesson 3.4
% Off-Grid Pose and Anchor Installation Robustness
%
% Research Question:
% Do the E1a optimised configurations remain feasible
% under unseen poses and small anchor-position errors?
%
% 测试对象：
% 1. Original Config 2
% 2. Sensing-oriented E1a
% 3. Clearance-oriented E1a
%
% Test A: 150个未采样的组合姿态
% Test B: 单根Anchor分别施加 +/-0.005 的t偏差
%
% 注意：
% 本实验不改变Attachment、Pairing和Rail ID。
% 扰动大小属于探索性假设，不是实测公差。

clear; clc; close all;
rng(42);

%% Step 1: Load verified results

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','P_all','R_all','settings');

load('B5_4_E1a_Config2_sequential_optimisation.mat', ...
    'track_results','t0','config_id');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end','rail_axis');

assert(config_id==2);

cfg = best_configs(2);

rail_ids = cfg.rail_ids(:)';
r = cfg.r;

% 固定三种待验证设计
design_names = [
    "Original Config 2";
    "Sensing-oriented";
    "Clearance-oriented"
];

T_designs = [
    t0;
    track_results(1).t;
    track_results(2).t
];

N_design = size(T_designs,1);
N_core = size(P_all,1);

assert(N_design==3);
assert(N_core==189);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2: Generate unseen combined-motion poses
%
% 平移每个轴独立取[-20,20] mm
% Roll/Pitch/Yaw各自独立取[-5,+5] deg
%
% 与原Core不同：
% 允许三个轴同时旋转。
%
% 本节只进行随机离散验证，
% 不声称连续空间全部可行。

N_offgrid = 150;

P_test = -20 + 40*rand(N_offgrid,3);

angles_test_deg = ...
    -5 + 10*rand(N_offgrid,3);

R_test = zeros(3,3,N_offgrid);

for k = 1:N_offgrid

    a = deg2rad(angles_test_deg(k,:));

    roll = a(1);
    pitch = a(2);
    yaw = a(3);

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

    R_test(:,:,k) = Rz*Ry*Rx;

    assert(norm( ...
        R_test(:,:,k)'*R_test(:,:,k)-eye(3), ...
        'fro')<1e-10);

end

fprintf('\n--- B5.4 Lesson 3.4 ---\n');
fprintf('Designs: %d\n',N_design);
fprintf('Unseen test poses: %d\n',N_offgrid);

%% Step 3: Define installation perturbations
%
% 每个Cable分别施加正负t偏差。
% 一次只改变一根Anchor。
%
% 共6 x 2 = 12次/设计。

delta_t = 0.005;

perturbations = zeros(12,6);

row = 0;

for i = 1:6

    for direction = [-1 1]

        row = row+1;

        perturbations(row,i) = ...
            direction*delta_t;

    end

end

assert(row==12);

%% Step 4: Prepare result storage

OffGridGeometryPass = zeros(N_design,1);
OffGridRank6Pass = zeros(N_design,1);

OffGridMinSigma = nan(N_design,1);
OffGridMaxKappa = nan(N_design,1);

PerturbationPass = zeros(N_design,1);
OffRailCount = zeros(N_design,1);

MinRailEndDistance_mm = zeros(N_design,1);

offgrid_details = cell(N_design,1);
perturbation_details = cell(N_design,1);

%% Step 5: Evaluate three designs

for d = 1:N_design

    fprintf('\n====================================\n');
    fprintf('%s\n',design_names(d));
    fprintf('====================================\n');

    t = T_designs(d,:);

    %% 5.1 Rebuild Anchor coordinates

    A = build_anchors( ...
        t,rail_ids,rail_start,rail_end);

    %% 5.2 Calculate distance to nearest rail end
    %
    % 这里只计算数学上的端点距离。
    % 尚未设置真实滑块禁止安装区域。

    end_distances = zeros(6,1);

    for i = 1:6

        rid = rail_ids(i);

        rail_length = norm( ...
            rail_end(rid,:)-rail_start(rid,:));

        end_distances(i) = ...
            min(t(i),1-t(i))*rail_length;

    end

    MinRailEndDistance_mm(d) = ...
        min(end_distances);

    %% 5.3 Test A: Unseen combined poses

    offgrid = evaluate_poses( ...
        A,r,P_test,R_test,settings);

    offgrid_details{d} = offgrid;

    OffGridGeometryPass(d) = ...
        sum(offgrid.geometry_safe);

    OffGridRank6Pass(d) = ...
        sum(offgrid.geometry_safe & ...
            offgrid.rank_all==6);

    feasible = offgrid.geometry_safe;

    if any(feasible)

        OffGridMinSigma(d) = min( ...
            offgrid.sigma_min_all(feasible));

        OffGridMaxKappa(d) = max( ...
            offgrid.kappa_all(feasible));

    end

    fprintf('Off-grid geometry: %d / %d\n', ...
        OffGridGeometryPass(d),N_offgrid);

    fprintf('Off-grid feasible Rank 6: %d / %d\n', ...
        OffGridRank6Pass(d),N_offgrid);

    fprintf('Off-grid feasible min sigma: %.6f\n', ...
        OffGridMinSigma(d));

    %% 5.4 Test B: Individual installation errors

    perturbation_geometry = nan(12,1);
    perturbation_rank = nan(12,1);

    offrail = false(12,1);

    for trial = 1:12

        t_trial = t+perturbations(trial,:);

        % 不允许通过clip掩盖越轨问题
        if any(t_trial<0 | t_trial>1)

            offrail(trial) = true;
            continue;

        end

        A_trial = build_anchors( ...
            t_trial,rail_ids,rail_start,rail_end);

        pert = evaluate_poses( ...
            A_trial,r,P_all,R_all,settings);

        perturbation_geometry(trial) = ...
            sum(pert.geometry_safe);

        perturbation_rank(trial) = ...
            sum(pert.geometry_safe & ...
                pert.rank_all==6);

    end

    passed = ...
        ~offrail & ...
        perturbation_geometry==N_core & ...
        perturbation_rank==N_core;

    PerturbationPass(d) = sum(passed);
    OffRailCount(d) = sum(offrail);

    perturbation_details{d} = struct( ...
        'delta_t',perturbations, ...
        'geometry_pass',perturbation_geometry, ...
        'rank6_pass',perturbation_rank, ...
        'offrail',offrail, ...
        'passed',passed);

    fprintf('Installation perturbation: %d / 12\n', ...
        PerturbationPass(d));

    fprintf('Off-rail perturbations: %d / 12\n', ...
        OffRailCount(d));

    fprintf('Minimum rail-end distance: %.3f mm\n', ...
        MinRailEndDistance_mm(d));

end

%% Step 6: Build comparison table

T_robustness = table( ...
    design_names, ...
    OffGridGeometryPass, ...
    OffGridRank6Pass, ...
    OffGridMinSigma, ...
    OffGridMaxKappa, ...
    PerturbationPass, ...
    OffRailCount, ...
    MinRailEndDistance_mm, ...
    'VariableNames', { ...
    'Design', ...
    'OffGridGeometryPass', ...
    'OffGridRank6Pass', ...
    'OffGridMinSigma', ...
    'OffGridMaxKappa', ...
    'PerturbationPass', ...
    'OffRailCount', ...
    'MinRailEndDistance_mm'});

disp(' ');
disp('--- Off-Grid and Installation Robustness ---');
disp(T_robustness);

%% Step 7: Visualise robustness comparison

figure('Color','w', ...
    'Name','B5.4 E1a Robustness Verification', ...
    'Position',[100 100 1200 510]);

subplot(1,2,1);

bar(OffGridGeometryPass);

yline(N_offgrid,'--k', ...
    'All unseen poses', ...
    'HandleVisibility','off');

xticks(1:3);
xticklabels({'Original','Sensing','Clearance'});

ylabel('Passing poses / 150');
title('Off-Grid Combined-Pose Geometry');

ylim([0 N_offgrid+10]);
grid on;

subplot(1,2,2);

bar(PerturbationPass);

xticks(1:3);
xticklabels({'Original','Sensing','Clearance'});

ylabel('Full-Core passing perturbations / 12');
title('Anchor Installation Perturbations');

ylim([0 13]);
grid on;

%% Step 8: Save without overwriting earlier data

save('B5_4_E1a_Config2_robustness_verification.mat', ...
    'T_robustness','T_designs', ...
    'P_test','R_test','angles_test_deg', ...
    'offgrid_details','perturbation_details', ...
    'perturbations','delta_t', ...
    'rail_ids','r','settings');

fprintf('\nB5.4 Lesson 3.4 completed.\n');

%% ================================================
% Local Function 1: Build Anchors
%% ================================================
function A = build_anchors( ...
    t,rail_ids,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

end

%% ================================================
% Local Function 2: Unified Pose Evaluation
%% ================================================
function result = evaluate_poses( ...
    A,r,P_all,R_all,settings)

    N_pose = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_safe = false(N_pose,1);
    sphere_safe = false(N_pose,1);
    cable_safe = false(N_pose,1);

    sigma_min_all = zeros(N_pose,1);
    kappa_all = zeros(N_pose,1);
    rank_all = zeros(N_pose,1);

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        % 世界坐标下的球面Attachment向量
        S = (R*r')';

        % Cable几何
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);

        assert(all(L>1e-9));

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sphere_safe(k) = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable

        cable_ok = true;

        for j = 1:size(pairs,1)

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        cable_safe(k) = cable_ok;

        geometry_safe(k) = ...
            sphere_safe(k) && cable_safe(k);

        %% Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))
            ];

        end

        Hs = H*settings.H_scale;

        s = svd(Hs);

        sigma_min_all(k) = s(end);

        rank_all(k) = sum( ...
            s>settings.rank_relative_tol*s(1));

        if s(end)>0

            kappa_all(k) = s(1)/s(end);

        else

            kappa_all(k) = inf;

        end

    end

    result = struct();

    result.geometry_safe = geometry_safe;
    result.sphere_safe = sphere_safe;
    result.cable_safe = cable_safe;

    result.rank_all = rank_all;
    result.sigma_min_all = sigma_min_all;
    result.kappa_all = kappa_all;

end
