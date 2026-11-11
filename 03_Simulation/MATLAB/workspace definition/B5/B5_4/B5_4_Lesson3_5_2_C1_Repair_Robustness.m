
%% B5.4 Lesson 3.5.2
% C1 Repair Robustness Verification
%
% Research Question:
% Does the repaired C1 configuration remain robust
% under unseen poses and installation perturbations?
%
% 固定：
% Rail Assignment、Attachment、Pairing
%
% 比较：
% Original、Sensing before repair、
% Sensing t1=0.375、Sensing t1=0.350、
% Clearance t1=0.375
%
% 单位：mm, rad, deg

clear; clc; close all;
rng(2026);  % 与原Off-grid的rng(42)区分

%% Step 1: Load verified data

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','P_all','R_all','settings');

load('B5_4_E1a_Config2_robustness_verification.mat', ...
    'T_designs','P_test','R_test','rail_ids');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

assert(size(P_all,1)==189);
assert(size(P_test,1)==150);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

r = best_configs(2).r;
rail_ids = rail_ids(:)';

%% Step 2: Define five fixed configurations
%
% T_designs三行分别是：
% Original / Sensing / Clearance
%
% 本节只是验证既有设计，不重新优化。

design_names = [
    "Original t1=0.400";
    "Sensing t1=0.400";
    "Sensing t1=0.375";
    "Sensing t1=0.350";
    "Clearance t1=0.375"
];

t_designs = [
    T_designs(1,:);
    T_designs(2,:);
    T_designs(2,:);
    T_designs(2,:);
    T_designs(3,:)
];

t_designs(:,1) = [
    0.400;
    0.400;
    0.375;
    0.350;
    0.375
];

N_design = size(t_designs,1);
assert(N_design==5);

%% Step 3: Reuse the existing 339 poses

P_known = [P_all;P_test];
R_known = cat(3,R_all,R_test);

N_known = size(P_known,1);
assert(N_known==339);

%% Step 4: Generate independent validation poses
%
% 与此前Core的范围相同：
% x,y,z各自属于[-20,20] mm
% roll,pitch,yaw各自属于[-5,5] deg
%
% 三轴可以同时旋转。
%
% 这仍然是离散采样，不能证明连续可行。

N_new = 200;

P_new = -20+40*rand(N_new,3);

angles_new_deg = -5+10*rand(N_new,3);

R_new = zeros(3,3,N_new);

for k = 1:N_new

    a = deg2rad(angles_new_deg(k,:));

    cr = cos(a(1)); sr = sin(a(1));
    cp = cos(a(2)); sp = sin(a(2));
    cy = cos(a(3)); sy = sin(a(3));

    Rx = [
        1 0 0;
        0 cr -sr;
        0 sr cr
    ];

    Ry = [
        cp 0 sp;
        0 1 0;
        -sp 0 cp
    ];

    Rz = [
        cy -sy 0;
        sy cy 0;
        0 0 1
    ];

    R_new(:,:,k) = Rz*Ry*Rx;

end

%% Step 5: Define installation error tests
%
% 一次只改变一根Anchor。
% 每根Anchor分别测试正负0.005。
%
% t是归一化参数，误差大小不是实测公差。

delta_t = 0.005;

perturbations = zeros(12,6);

case_id = 0;

for i = 1:6

    for sign_value = [-1 1]

        case_id = case_id+1;

        perturbations(case_id,i) = ...
            sign_value*delta_t;

    end

end

%% Step 6: Initialise result arrays

KnownPass = zeros(N_design,1);
NewPass = zeros(N_design,1);

KnownRank6 = zeros(N_design,1);
NewRank6 = zeros(N_design,1);

MinOutwardDot_mm2 = nan(N_design,1);
MinCableDistance_mm = nan(N_design,1);

WorstSigmaKnown = nan(N_design,1);
WorstSigmaNew = nan(N_design,1);

PerturbationPass = zeros(N_design,1);
OffRailCount = zeros(N_design,1);

MinRailEndDistance_mm = zeros(N_design,1);

details = cell(N_design,1);
perturbation_records = cell(N_design,1);

%% Step 7: Evaluate each configuration

fprintf('\n--- B5.4 Lesson 3.5.2 ---\n');

for d = 1:N_design

    fprintf('\n====================================\n');
    fprintf('%s\n',design_names(d));
    fprintf('====================================\n');

    t = t_designs(d,:);

    A = build_anchors( ...
        t,rail_ids,rail_start,rail_end);

    %% Test 1: Existing 339 poses

    known = evaluate_geometry_sensing( ...
        A,r,P_known,R_known,settings);

    KnownPass(d) = sum(known.geometry_safe);

    KnownRank6(d) = sum( ...
        known.geometry_safe & known.rank_all==6);

    %% Test 2: Independent 200 poses

    unseen = evaluate_geometry_sensing( ...
        A,r,P_new,R_new,settings);

    NewPass(d) = sum(unseen.geometry_safe);

    NewRank6(d) = sum( ...
        unseen.geometry_safe & unseen.rank_all==6);

    %% Minimum signed outward margin
    %
    % 对全部539个姿态和六根Cable取最小值。
    % 正值代表当前采样中全部Cable向外出线。

    MinOutwardDot_mm2(d) = min([
        known.outward_dot(:);
        unseen.outward_dot(:)
    ]);

    MinCableDistance_mm(d) = min([
        known.distances(:);
        unseen.distances(:)
    ]);

    % 所有已知姿态几何通过时，
    % 才计算统一的Worst Sensing排名。
    if KnownPass(d)==N_known && ...
            KnownRank6(d)==N_known

        WorstSigmaKnown(d) = min( ...
            known.sigma_min_all);

    end

    if NewPass(d)==N_new && ...
            NewRank6(d)==N_new

        WorstSigmaNew(d) = min( ...
            unseen.sigma_min_all);

    end

    %% Check rail-end distance

    end_distances = zeros(6,1);

    for i = 1:6

        rid = rail_ids(i);

        Lrail = norm( ...
            rail_end(rid,:)-rail_start(rid,:));

        end_distances(i) = ...
            min(t(i),1-t(i))*Lrail;

    end

    MinRailEndDistance_mm(d) = ...
        min(end_distances);

    %% Test 3: Installation perturbation
    %
    % 对每个扰动重新检查已知339姿态。
    % 不允许把越轨位置自动裁剪到[0,1]。

    case_pass = false(12,1);
    case_offrail = false(12,1);
    case_geometry = nan(12,1);
    case_rank6 = nan(12,1);

    for j = 1:12

        t_trial = t+perturbations(j,:);

        if any(t_trial<0 | t_trial>1)

            case_offrail(j) = true;
            continue;

        end

        A_trial = build_anchors( ...
            t_trial,rail_ids,rail_start,rail_end);

        trial = evaluate_geometry_sensing( ...
            A_trial,r,P_known,R_known,settings);

        case_geometry(j) = sum(trial.geometry_safe);

        case_rank6(j) = sum( ...
            trial.geometry_safe & trial.rank_all==6);

        case_pass(j) = ...
            case_geometry(j)==N_known && ...
            case_rank6(j)==N_known;

    end

    PerturbationPass(d) = sum(case_pass);
    OffRailCount(d) = sum(case_offrail);

    details{d} = struct( ...
        'known',known, ...
        'unseen',unseen, ...
        'A',A,'t',t);

    perturbation_records{d} = struct( ...
        'passed',case_pass, ...
        'offrail',case_offrail, ...
        'geometry_pass',case_geometry, ...
        'rank6_pass',case_rank6);

    %% Print summary

    fprintf('Known: %d / %d\n', ...
        KnownPass(d),N_known);

    fprintf('Independent: %d / %d\n', ...
        NewPass(d),N_new);

    fprintf('Min outward dot: %.3f mm^2\n', ...
        MinOutwardDot_mm2(d));

    fprintf('Min cable distance: %.4f mm\n', ...
        MinCableDistance_mm(d));

    fprintf('Perturbations: %d / 12\n', ...
        PerturbationPass(d));

    fprintf('Off-rail: %d / 12\n',OffRailCount(d));

end

%% Step 8: Regression checks
%
% 前三组中的Original、Sensing before repair
% 应在已知339姿态中出现相同的149/150结果。
%
% 修复后方案应复现Lesson 3.5.1的339/339。

assert(KnownPass(1)==338);
assert(KnownPass(2)==338);

assert(KnownPass(3)==339);
assert(KnownPass(4)==339);
assert(KnownPass(5)==339);

fprintf('\nHistorical regression passed.\n');

%% Step 9: Build result table

T_robust = table( ...
    design_names, ...
    KnownPass,NewPass, ...
    KnownRank6,NewRank6, ...
    MinOutwardDot_mm2, ...
    MinCableDistance_mm, ...
    WorstSigmaKnown,WorstSigmaNew, ...
    PerturbationPass,OffRailCount, ...
    MinRailEndDistance_mm, ...
    'VariableNames',{ ...
    'Design','KnownPass','NewPass', ...
    'KnownRank6','NewRank6', ...
    'MinOutwardDot_mm2', ...
    'MinCableDistance_mm', ...
    'WorstSigmaKnown','WorstSigmaNew', ...
    'PerturbationPass','OffRailCount', ...
    'MinRailEndDistance_mm'});

disp(' ');
disp('--- C1 Repair Robustness Comparison ---');
disp(T_robust);

%% Step 10: Identify failure cases
%
% 如果某组在新增姿态下失败，
% 输出失败的索引和姿态。
% 不能为了得到200/200删除失败点。

for d = 1:N_design

    bad_ids = find( ...
        ~details{d}.unseen.geometry_safe);

    fprintf('\n%s - independent failures: %s\n', ...
        design_names(d),mat2str(bad_ids'));

    for k = bad_ids(:)'

        fprintf('P [mm]: %s\n', ...
            mat2str(P_new(k,:),5));

        fprintf('RPY [deg]: %s\n', ...
            mat2str(angles_new_deg(k,:),5));

        bad_cables = find( ...
            details{d}.unseen.outward_dot(k,:) ...
            < -settings.sphere_tol);

        fprintf('Failed sphere cables: %s\n', ...
            mat2str(bad_cables));

    end

end

%% Step 11: Plot comparison

figure('Color','w', ...
    'Name','B5.4 C1 Repair Robustness', ...
    'Position',[100 100 1250 560]);

subplot(1,2,1);

bar(NewPass);

yline(N_new,'--k','Full pass', ...
    'HandleVisibility','off');

xticks(1:N_design);

xticklabels({ ...
    'Original','Sensing old', ...
    'Sensing .375','Sensing .350', ...
    'Clearance .375'});

xtickangle(25);

ylabel('Passing independent poses / 200');
title('Unseen Combined-Pose Geometry');
ylim([0 N_new+10]);
grid on;

subplot(1,2,2);

bar(PerturbationPass);

xticks(1:N_design);

xticklabels({ ...
    'Original','Sensing old', ...
    'Sensing .375','Sensing .350', ...
    'Clearance .375'});

xtickangle(25);

ylabel('Full 339-pose passing cases / 12');
title('Installation Perturbation Robustness');

ylim([0 13]);
grid on;

%% Step 12: Save

save('B5_4_E1a_C1_repair_robustness.mat', ...
    'T_robust','design_names','t_designs', ...
    'details','perturbation_records', ...
    'P_new','R_new','angles_new_deg', ...
    'perturbations','delta_t', ...
    'settings','rail_ids','r');

fprintf('\nB5.4 Lesson 3.5.2 completed.\n');

%% ==============================================
% Local function 1: Build Anchors
%% ==============================================
function A = build_anchors( ...
    t,rail_ids,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

end

%% ==============================================
% Local function 2: Geometry and Sensing
%% ==============================================
function result = evaluate_geometry_sensing( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);
    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);
    rank_all = zeros(N,1);

    sigma_min_all = nan(N,1);
    outward_dot = zeros(N,6);

    distances = zeros(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        % Attachment球心向量、世界坐标、Cable方向
        S = (R*r')';
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);
        assert(all(L>1e-9));

        %% Cable-Sphere

        outward_dot(k,:) = sum(S.*D,2)';

        sphere_ok = all( ...
            outward_dot(k,:) >= ...
            -settings.sphere_tol);

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

        geometry_safe(k) = sphere_ok && cable_ok;

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

    end

    result = struct();

    result.geometry_safe = geometry_safe;
    result.rank_all = rank_all;

    result.sigma_min_all = sigma_min_all;
    result.outward_dot = outward_dot;

    result.distances = distances;

end
