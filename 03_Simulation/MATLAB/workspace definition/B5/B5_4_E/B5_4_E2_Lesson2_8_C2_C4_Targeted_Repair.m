
%% B5.4 E2 Lesson 2.8
% C2-2 C4 Failure Attribution & Targeted Repair
%
% 研究问题：
% Pose 503的C4出线失败是否可以通过
% 单独调整C4 Attachment修复？
%
% 对象：
% E1b C2-2 Track S / Track M
%
% 固定：
% 所有Anchor、Pairing、C1-C3和C5-C6 Attachment
%
% 变化：
% 仅C4 Attachment
%
% 测试：
% 1. E2优化后原始方案
% 2. 将C4恢复至E2优化前的位置
% 3. 0.5 / 1 / 2 deg，8个切向方向
%
% 所有候选统一评价539个Development Poses。
% 本节属于Development Repair，不是Holdout。

clear; clc; close all;

%% Step 1 — 加载历史结果

e2 = load( ...
    'B5_4_E2_sequential_optimisation.mat');

b = load( ...
    'B5_4_unified_evaluation_baseline.mat', ...
    'settings');

dev = load( ...
    'B5_4_E2_539pose_verification.mat', ...
    'P_eval','R_eval','clearance_floor');

settings = b.settings;

P_eval = dev.P_eval;
R_eval = dev.R_eval;

clearance_floor = dev.clearance_floor;

assert(size(P_eval,1)==539);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 搜索参数

target_name = "E1b C2-2";

track_names = [ ...
    "SensingPriority";
    "MarginPreservingSensing"];

alpha_values = [0.5 1 2];

beta_values = 0:45:315;

target_cable = 4;

n_local = ...
    numel(alpha_values)*numel(beta_values);

assert(n_local==24);

% 比较相同的探索性Attachment spacing规则
spacing_tol = 1e-8;

%% Step 3 — 准备结果

N_track = numel(track_names);

Track = strings(0,1);
CandidateType = strings(0,1);

Alpha_deg = zeros(0,1);
Beta_deg = nan(0,1);

GeometryPass = zeros(0,1);
RankPass = zeros(0,1);

MinAngle_deg = nan(0,1);
MinCableDistance_mm = nan(0,1);
MinAttachmentChord_mm = nan(0,1);

Worst539Sigma = nan(0,1);

FullEligible = false(0,1);

LimitingPose = zeros(0,1);
LimitingCable = zeros(0,1);

repaired_designs = cell(N_track,1);

%% Step 4 — 两条Track逐一诊断

for t = 1:N_track

    track_name = track_names(t);

    % 定位对应优化配置
    matches = find( ...
        e2.T_optimisation.DesignName == ...
            target_name & ...
        e2.T_optimisation.TrackName == ...
            track_name);

    assert(numel(matches)==1);

    cfg = e2.optimised_designs{matches};

    A = cfg.A_fixed;

    r_initial = cfg.r_initial;
    r_final = cfg.r_final;

    spacing_floor = cfg.spacing_floor_mm;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r_initial),[6 3]));
    assert(isequal(size(r_final),[6 3]));

    % 最终C4坐标
    r4_final = r_final(target_cable,:);

    % E2优化前C4坐标
    r4_initial = r_initial(target_cable,:);

    moved_angle = acosd(max(-1,min(1, ...
        dot(r4_initial,r4_final) / ...
        (norm(r4_initial)*norm(r4_final)))));

    fprintf('\n============================\n');
    fprintf('%s\n',track_name);
    fprintf('C4 total movement: %.4f deg\n', ...
        moved_angle);

    %% 4.1 构造候选集合

    % 候选1：未修复的E2最终方案
    candidate_r = {r_final};
    labels = "OptimisedOriginal";

    candidate_alpha = 0;
    candidate_beta = NaN;

    % 候选2：只将C4恢复到原始位置
    r_hybrid = r_final;

    r_hybrid(target_cable,:) = r4_initial;

    candidate_r{end+1} = r_hybrid;
    labels(end+1,1) = "RestoreC4";

    candidate_alpha(end+1,1) = moved_angle;
    candidate_beta(end+1,1) = NaN;

    %% 4.2 围绕E2最终C4构造切平面

    n = r4_final(:);
    n = n/norm(n);

    if abs(dot(n,[0;0;1]))<0.9
        ref_axis = [0;0;1];
    else
        ref_axis = [1;0;0];
    end

    e1 = cross(ref_axis,n);
    e1 = e1/norm(e1);

    e2_basis = cross(n,e1);
    e2_basis = e2_basis/norm(e2_basis);

    %% 4.3 生成24个局部候选

    for ia = 1:numel(alpha_values)

        alpha = alpha_values(ia);

        for ib = 1:numel(beta_values)

            beta = beta_values(ib);

            tangent = ...
                cosd(beta)*e1 + ...
                sind(beta)*e2_basis;

            new_r4 = settings.rb*( ...
                cosd(alpha)*n + ...
                sind(alpha)*tangent);

            trial_r = r_final;

            trial_r(target_cable,:) = new_r4';

            assert(max(abs( ...
                vecnorm(trial_r,2,2)-settings.rb)) ...
                <1e-8);

            candidate_r{end+1} = trial_r;

            labels(end+1,1) = "LocalC4";

            candidate_alpha(end+1,1) = alpha;
            candidate_beta(end+1,1) = beta;

        end

    end

    assert(numel(candidate_r)==26);

    %% Step 5 — 评价全部候选

    best_sigma = -inf;
    best_index = 0;

    evaluations = cell(numel(candidate_r),1);

    for k = 1:numel(candidate_r)

        r_trial = candidate_r{k};

        g = evaluate_539_candidate( ...
            A,r_trial,P_eval,R_eval,settings);

        min_chord = min_attachment_chord(r_trial);

        % 与E2原始约束保持一致
        spacing_ok = ...
            min_chord>=spacing_floor-spacing_tol;

        clearance_ok = ...
            g.min_distance>= ...
            clearance_floor-1e-8;

        eligible = ...
            g.geometry_pass==539 && ...
            g.rank_pass==539 && ...
            clearance_ok && spacing_ok;

        evaluations{k} = g;

        % 记录所有结果，包括失败方案
        Track(end+1,1) = track_name;
        CandidateType(end+1,1) = labels(k);

        Alpha_deg(end+1,1) = ...
            candidate_alpha(k);

        Beta_deg(end+1,1) = ...
            candidate_beta(k);

        GeometryPass(end+1,1) = ...
            g.geometry_pass;

        RankPass(end+1,1) = ...
            g.rank_pass;

        MinAngle_deg(end+1,1) = ...
            g.min_angle;

        MinCableDistance_mm(end+1,1) = ...
            g.min_distance;

        MinAttachmentChord_mm(end+1,1) = ...
            min_chord;

        LimitingPose(end+1,1) = ...
            g.min_angle_pose;

        LimitingCable(end+1,1) = ...
            g.min_angle_cable;

        FullEligible(end+1,1) = eligible;

        if eligible

            Worst539Sigma(end+1,1) = ...
                g.worst_sigma;

            if g.worst_sigma>best_sigma+1e-8

                best_sigma = g.worst_sigma;
                best_index = k;

            end

        else

            Worst539Sigma(end+1,1) = NaN;

        end

    end

    %% Step 6 — 输出两种诊断结果

    original = evaluations{1};
    restored = evaluations{2};

    fprintf('\nOriginal E2 design:\n');
    fprintf('Geometry: %d/539\n', ...
        original.geometry_pass);
    fprintf('Minimum angle: %.6f deg\n', ...
        original.min_angle);

    fprintf('\nRestore original C4:\n');
    fprintf('Geometry: %d/539\n', ...
        restored.geometry_pass);
    fprintf('Minimum angle: %.6f deg\n', ...
        restored.min_angle);

    % 保存最佳合格候选
    output = struct();

    output.name = target_name;
    output.track = track_name;

    output.A_fixed = A;
    output.r_initial = r_initial;
    output.r_optimised = r_final;

    output.spacing_floor_mm = spacing_floor;

    output.best_found = best_index>0;

    if best_index>0

        output.r_repaired = ...
            candidate_r{best_index};

        output.best_sigma = best_sigma;

        output.best_candidate_type = ...
            labels(best_index);

        output.best_alpha_deg = ...
            candidate_alpha(best_index);

        output.best_beta_deg = ...
            candidate_beta(best_index);

        fprintf('\nBEST FEASIBLE REPAIR FOUND\n');

        fprintf('Type: %s\n', ...
            labels(best_index));

        fprintf('Worst 539 sigma: %.6f\n', ...
            best_sigma);

        fprintf('Angle: %.6f deg\n', ...
            evaluations{best_index}.min_angle);

        fprintf('Cable distance: %.4f mm\n', ...
            evaluations{best_index}.min_distance);

    else

        output.r_repaired = [];
        output.best_sigma = NaN;

        fprintf('\nNo feasible C4 repair found ');
        fprintf('in this search.\n');

    end

    repaired_designs{t} = output;

end

%% Step 7 — 汇总结果

T_diagnosis = table( ...
    Track,CandidateType, ...
    Alpha_deg,Beta_deg, ...
    GeometryPass,RankPass, ...
    MinAngle_deg, ...
    MinCableDistance_mm, ...
    MinAttachmentChord_mm, ...
    FullEligible,Worst539Sigma, ...
    LimitingPose,LimitingCable);

fprintf('\n====================================\n');
fprintf('E2 C2-2 C4 Diagnosis Results\n');
fprintf('====================================\n');

% 查看原优化方案和恢复C4的结果
reference_rows = ...
    CandidateType=="OptimisedOriginal" | ...
    CandidateType=="RestoreC4";

disp(T_diagnosis(reference_rows,:));

%% Step 8 — 每条Track的局部搜索统计

for t = 1:N_track

    mask = Track==track_names(t) & ...
        CandidateType=="LocalC4";

    fprintf('\n%s\n',track_names(t));

    fprintf('Feasible local C4 candidates: %d/24\n', ...
        sum(FullEligible(mask)));

    fprintf('Best sigma found: %.6f\n', ...
        repaired_designs{t}.best_sigma);

end

%% Step 9 — 保存完整结果

save( ...
    'B5_4_E2_C2_C4_targeted_repair.mat', ...
    'T_diagnosis','repaired_designs', ...
    'alpha_values','beta_values', ...
    'target_cable', ...
    'clearance_floor');

writetable(T_diagnosis, ...
    'B5_4_E2_C2_C4_targeted_repair.csv');

fprintf('\nE2 Lesson 2.8 completed.\n');

%% ===============================================
% Local Function 1 — Attachment chord
%% ===============================================

function dmin = min_attachment_chord(r)

    pairs = nchoosek(1:6,2);

    dmin = inf;

    for p = 1:size(pairs,1)

        i = pairs(p,1);
        j = pairs(p,2);

        dmin = min(dmin, ...
            norm(r(i,:)-r(j,:)));

    end

end

%% ===============================================
% Local Function 2 — Full 539 evaluation
%% ===============================================

function g = evaluate_539_candidate( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    min_angle = inf;
    min_distance = inf;

    min_angle_pose = 0;
    min_angle_cable = 0;

    worst_sigma = inf;

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;

        D = A-B;
        L = vecnorm(D,2,2);

        if any(L<=1e-9)

            min_angle = -inf;
            min_distance = 0;

            if min_angle_pose==0
                min_angle_pose = k;
                min_angle_cable = ...
                    find(L<=1e-9,1);
            end

            continue;

        end

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_value = outward_dot./ ...
            (settings.rb*L);

        sine_value = max( ...
            -1,min(1,sine_value));

        angles = asind(sine_value);

        [local_angle,cable_id] = ...
            min(angles);

        if local_angle<min_angle

            min_angle = local_angle;
            min_angle_pose = k;
            min_angle_cable = cable_id;

        end

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable

        cable_ok = true;

        for p = 1:size(pairs,1)

            i = pairs(p,1);
            j = pairs(p,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                B(i,:),A(i,:), ...
                B(j,:),A(j,:));

            min_distance = min( ...
                min_distance,dij);

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        geometry_ok = sphere_ok && cable_ok;

        if geometry_ok
            geometry_pass = geometry_pass+1;
        end

        %% Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))];

        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        rankH = sum( ...
            sv>settings.rank_relative_tol*sv(1));

        if geometry_ok && rankH==6
            rank_pass = rank_pass+1;
        end

        worst_sigma = min( ...
            worst_sigma,sv(end));

    end

    g = struct();

    g.geometry_pass = geometry_pass;
    g.rank_pass = rank_pass;

    g.min_angle = min_angle;
    g.min_distance = min_distance;

    g.min_angle_pose = min_angle_pose;
    g.min_angle_cable = min_angle_cable;

    g.worst_sigma = worst_sigma;

end
