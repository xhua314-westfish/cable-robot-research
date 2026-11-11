%% B5.4 Lesson 1
% Unified Geometry and Sensing Evaluator
%
% Research Question:
% Can a unified evaluator reproduce all B5.3
% multi-pose geometry and sensing results?
%
% Objectives:
% 1. Evaluate 18 fixed six-cable configurations
% 2. Reuse the exact 189 Core poses
% 3. Check geometry, sensing and cable lengths
% 4. Compare against saved B5.3 results
% 5. Preserve eligible, focus and repair sets
%
% 本节不进行优化，不改变任何配置
% 再一次检测B5.3的结果是否正确 
% 单位：mm；旋转矩阵无

clear; clc; close all;

%% Step 1: Load B5.3 results

load('B5_3_initial_six_cable_configurations.mat', ...
    'best_configs','rb');

load('B5_3_early_multipose_screening.mat', ...
    'screening','T_results', ...
    'P_all','R_all','angles_deg', ...
    'position_id','orientation_id');

old_results = screening;
old_table = T_results;

N_config = numel(best_configs);
N_pose = size(P_all,1);

assert(N_config==18);
assert(N_pose==189);
assert(all([best_configs.found]));

% 检查B3有限线段距离函数
assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'B3 distance function not found.');

fprintf('\n--- B5.4 Lesson 1 ---\n');
fprintf('Configurations: %d\n',N_config);
fprintf('Core poses: %d\n',N_pose);

%% Step 2: Define common settings
%
% 所有后续实验必须采用相同判据。
% 注意：以下数值是仿真判据，
% 不是实际Cable直径或机械安全距离。

settings = struct();

settings.rb = rb;
settings.sphere_tol = 1e-9;      % mm^2
settings.contact_tol = 1e-6;     % mm
settings.rank_relative_tol = 1e-10;

settings.cable_pairs = nchoosek(1:6,2);

settings.H_scale = diag( ...
    [1 1 1 1/rb 1/rb 1/rb]);

settings.physical_clearance_verified = false;
settings.tension_verified = false;

%% Step 3: Evaluate all 18 configurations
%
% 对全部配置调用同一个评价函数。
% 不允许为某个Family使用特殊判断条件。

new_results = cell(N_config,1);

GeometryPass = zeros(N_config,1);
SpherePass = zeros(N_config,1);
CablePass = zeros(N_config,1);
RankPassFeasible = zeros(N_config,1);

MinSigmaAll = zeros(N_config,1);
MaxKappaAll = zeros(N_config,1);

MinSigmaFeasible = nan(N_config,1);
MaxKappaFeasible = nan(N_config,1);

MinCableDistance = zeros(N_config,1);
MaxStroke = zeros(N_config,1);

for c = 1:N_config

    cfg = best_configs(c);

    result = evaluate_six_cable_configuration( ...
        cfg.A,cfg.r,P_all,R_all,settings);

    new_results{c} = result;

    SpherePass(c) = sum(result.sphere_safe);
    CablePass(c) = sum(result.cable_safe);

    GeometryPass(c) = sum(result.geometry_safe);

    feasible = result.geometry_safe;

    RankPassFeasible(c) = sum( ...
        result.rank_all(feasible)==6);

    % 全部姿态的感知结果，仅用于诊断
    MinSigmaAll(c) = min(result.sigma_min_all);
    MaxKappaAll(c) = max(result.kappa_all);

    % 几何可行姿态的感知结果
    if any(feasible)

        MinSigmaFeasible(c) = min( ...
            result.sigma_min_all(feasible));

        MaxKappaFeasible(c) = max( ...
            result.kappa_all(feasible));

    end

    % 全部189姿态上的最小Cable线段距离
    MinCableDistance(c) = min(result.distances(:));

    % 各Cable的最大减最小长度
    stroke_per_cable = ...
        max(result.L_all,[],1) - ...
        min(result.L_all,[],1);

    MaxStroke(c) = max(stroke_per_cable);

end

%% Step 4: Regression against B5.3
%
% 重点是复现以前的结果，而不是提高性能。
%
% 检查：
% 1. 球面出线mask
% 2. Cable接触mask
% 3. 综合几何mask
% 4. Jacobian Rank
% 5. 奇异值与条件数
% 6. Cable Length和Pair Distance

max_sigma_error = 0;
max_kappa_error = 0;
max_length_error = 0;
max_distance_error = 0;

for c = 1:N_config

    old = old_results{c};
    new = new_results{c};

    assert(isequal(old.sphere_safe,new.sphere_safe));
    assert(isequal(old.cable_safe,new.cable_safe));
    assert(isequal(old.geometry_safe,new.geometry_safe));
    assert(isequal(old.rank_all,new.rank_all));

    sigma_error = max(abs( ...
        old.sigma_min_all-new.sigma_min_all));

    kappa_error = max(abs( ...
        old.kappa_all-new.kappa_all));

    length_error = max(abs( ...
        old.L_all(:)-new.L_all(:)));

    distance_error = max(abs( ...
        old.distances(:)-new.distances(:)));

    % 如果数据出现非有限值，回归应明确失败
    assert(isfinite(sigma_error));
    assert(isfinite(kappa_error));
    assert(isfinite(length_error));
    assert(isfinite(distance_error));

    max_sigma_error = max(max_sigma_error,sigma_error);
    max_kappa_error = max(max_kappa_error,kappa_error);

    max_length_error = max(max_length_error,length_error);
    max_distance_error = max( ...
        max_distance_error,distance_error);

    assert(sigma_error<1e-8);
    assert(kappa_error<1e-6);
    assert(length_error<1e-8);
    assert(distance_error<1e-8);

end

fprintf('\n--- Regression Verification ---\n');

fprintf('Geometry and Rank matched: 18 / 18\n');

fprintf('Maximum sigma difference: %.3e\n', ...
    max_sigma_error);

fprintf('Maximum kappa difference: %.3e\n', ...
    max_kappa_error);

fprintf('Maximum length difference: %.3e mm\n', ...
    max_length_error);

fprintf('Maximum distance difference: %.3e mm\n', ...
    max_distance_error);

%% Step 5: Define candidate eligibility
%
% Core硬门槛：
% 1. 所有189姿态几何可行
% 2. 所有189姿态Jacobian Rank=6
%
% 这是当前数值模型的验收，
% 不是完整硬件可行性认证。

CoreEligible = (GeometryPass==N_pose) & ...
    (RankPassFeasible==N_pose);

eligibility_set = find(CoreEligible);

expected_ids = [2;4;6;8;12;17];

assert(isequal(eligibility_set,expected_ids));
assert(isequal(CoreEligible,old_table.CoreCandidate));

% 用于后续比较的四组重点候选
focus_set = [2 4 12 17];

% 尚未全部通过Core、但适合几何修复的案例
repair_set = [5 11 15];

assert(all(CoreEligible(focus_set)));
assert(all(~CoreEligible(repair_set)));

fprintf('\nCore-eligible configurations: %s\n', ...
    mat2str(eligibility_set'));

fprintf('Focus set: %s\n',mat2str(focus_set));
fprintf('Repair set: %s\n',mat2str(repair_set));

%% Step 6: Create unified result table

ConfigID = (1:N_config)';

Family = string(old_table.Family);

GeometryPercent = 100*GeometryPass/N_pose;

T_unified = table( ...
    ConfigID,Family, ...
    SpherePass,CablePass,GeometryPass, ...
    GeometryPercent,RankPassFeasible, ...
    MinSigmaAll,MaxKappaAll, ...
    MinSigmaFeasible,MaxKappaFeasible, ...
    MinCableDistance,MaxStroke,CoreEligible);

disp(' ');
disp('--- Unified Evaluation Results ---');
disp(T_unified);

%% Step 7: Visualise eligible candidates
%
% 仅比较全部189姿态都满足Core几何要求的配置。
% 避免不同样本数量造成不公平比较。

figure('Color','w', ...
    'Name','B5.4 Eligible Configuration Comparison', ...
    'Position',[100 100 1300 520]);

subplot(1,2,1);

bar(eligibility_set, ...
    MinSigmaFeasible(eligibility_set));

title('Worst Core Sensing');
xlabel('Configuration ID');
ylabel('Minimum Scaled Singular Value');

xticks(eligibility_set);
grid on;

subplot(1,2,2);

bar(eligibility_set, ...
    MinCableDistance(eligibility_set));

title('Minimum Cable Distance');
xlabel('Configuration ID');
ylabel('Minimum Distance (mm)');

xticks(eligibility_set);
grid on;

%% Step 8: Save verified evaluation baseline

save('B5_4_unified_evaluation_baseline.mat', ...
    'new_results','T_unified', ...
    'eligibility_set','focus_set','repair_set', ...
    'best_configs','settings', ...
    'P_all','R_all','angles_deg', ...
    'position_id','orientation_id');

fprintf('\nB5.4 Lesson 1 completed.\n');
fprintf('Saved: B5_4_unified_evaluation_baseline.mat\n');



%% =================================================
% Local Function: Unified Six-Cable Evaluator
%% =================================================
function result = evaluate_six_cable_configuration( ...
    A,r,P_all,R_all,settings)

    N_pose = size(P_all,1);

    pairs = settings.cable_pairs;

    rb = settings.rb;

    sphere_tol = settings.sphere_tol;
    contact_tol = settings.contact_tol;
    rank_tol = settings.rank_relative_tol;

    H_scale = settings.H_scale;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));
    assert(max(abs(vecnorm(r,2,2)-rb))<1e-8);

    % 初始化结果
    sphere_safe = false(N_pose,1);
    cable_safe = false(N_pose,1);
    geometry_safe = false(N_pose,1);

    outward_safe = false(N_pose,6);

    distances = zeros(N_pose,15);
    L_all = zeros(N_pose,6);

    rank_all = zeros(N_pose,1);
    sigma_min_all = zeros(N_pose,1);
    kappa_all = zeros(N_pose,1);

    %% Evaluate every Core pose

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        % 球心到六个Attachment的世界向量
        S = (R*r')';

        % 六个Attachment的世界坐标
        B = S+P;

        % Cable方向，Attachment指向Anchor
        D = A-B;

        % 六根Cable长度
        L = vecnorm(D,2,2);

        assert(all(L>1e-9));

        L_all(k,:) = L';

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        outward_safe(k,:) = ...
            (outward_dot>=-sphere_tol)';

        sphere_safe(k) = all(outward_safe(k,:));

        %% Cable-Cable

        for j = 1:15

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            distances(k,j) = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

        end

        cable_safe(k) = ...
            all(distances(k,:)>contact_tol);

        geometry_safe(k) = ...
            sphere_safe(k) && cable_safe(k);

        %% Sensing Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:)) ...
            ];

        end

        Hs = H*H_scale;

        s = svd(Hs);

        sigma_min_all(k) = s(end);

        rank_all(k) = sum( ...
            s>rank_tol*s(1));

        if s(end)>0
            kappa_all(k) = s(1)/s(end);
        else
            kappa_all(k) = inf;
        end

    end

    %% Return all results

    result = struct();

    result.sphere_safe = sphere_safe;
    result.cable_safe = cable_safe;
    result.geometry_safe = geometry_safe;

    result.outward_safe = outward_safe;
    result.distances = distances;

    result.L_all = L_all;

    result.rank_all = rank_all;
    result.sigma_min_all = sigma_min_all;
    result.kappa_all = kappa_all;

end