
%% B5.4 E2 Lesson 2.6
% 539-Pose Geometry & Sensing Verification
%
% Research Question:
% E2优化后的Attachment布局，
% 是否仍能通过539个Development Poses？
%
% 对比：
% 4个E2原始Baseline
% 8个E2优化设计（Track S / Track M）
%
% 不进行新的优化。
% 不允许利用539结果修改设计。
%
% 输出：
% Geometry / Rank / Clearance / Spacing
% Worst Sigma / Kappa
% Minimum Outward Angle
% Minimum Cable Distance
% 失败Pose和Cable编号

clear; clc; close all;

%% Step 1 — 读取现有数据

e2 = load( ...
    'B5_4_E2_sequential_optimisation.mat');

baseline = load( ...
    'B5_4_E2_attachment_baselines.mat');

dev = load( ...
    'B5_4_E1b_539pose_robustness.mat', ...
    'P_eval','R_eval');

core = load( ...
    'B5_4_unified_evaluation_baseline.mat', ...
    'P_all','R_all','settings');

protocol_data = load( ...
    'B5_4_E2_optimisation_protocol.mat');

settings = core.settings;

P_eval = dev.P_eval;
R_eval = dev.R_eval;

protocol = protocol_data.protocol;

clearance_floor = ...
    protocol.clearance_floor_mm;

N_pose = size(P_eval,1);

assert(N_pose==539);
assert(isequal(size(R_eval),[3 3 539]));

% 前189个位姿必须与Core完全一致
assert(isequal(P_eval(1:189,:),core.P_all));

assert(isequal( ...
    R_eval(:,:,1:189),core.R_all));

assert(numel(baseline.e2_baselines)==4);
assert(numel(e2.optimised_designs)==8);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 建立12个待验证设计

N_baseline = 4;
N_optimised = 8;

N_design = N_baseline+N_optimised;

designs = cell(N_design,1);

Design = strings(N_design,1);
Track = strings(N_design,1);

% 原始四组Baseline
for d = 1:N_baseline

    cfg = baseline.e2_baselines{d};

    designs{d} = struct( ...
        'A',cfg.A_fixed, ...
        'r',cfg.r_initial, ...
        'r_baseline',cfg.r_initial);

    Design(d) = string(cfg.name);
    Track(d) = "Baseline";

end

% 八组优化后的设计
for j = 1:N_optimised

    cfg = e2.optimised_designs{j};

    k = N_baseline+j;

    designs{k} = struct( ...
        'A',cfg.A_fixed, ...
        'r',cfg.r_final, ...
        'r_baseline',cfg.r_initial);

    Design(k) = string(cfg.name);
    Track(k) = string(cfg.track);

end

assert(N_design==12);

%% Step 3 — 初始化验证表

GeometryPass = zeros(N_design,1);
RankPass = zeros(N_design,1);

MinOutwardAngle_deg = nan(N_design,1);
MinCableDistance_mm = nan(N_design,1);

MinAttachmentChord_mm = nan(N_design,1);
SpacingFloor_mm = nan(N_design,1);

Worst539Sigma = nan(N_design,1);
Worst539Kappa = nan(N_design,1);

CoreSigma = nan(N_design,1);

MinAnglePose = zeros(N_design,1);
MinAngleCable = zeros(N_design,1);

MinDistancePose = zeros(N_design,1);
MinDistanceCableA = zeros(N_design,1);
MinDistanceCableB = zeros(N_design,1);

GeometryEligible = false(N_design,1);
ClearanceEligible = false(N_design,1);
SpacingEligible = false(N_design,1);

FullEligible = false(N_design,1);

details = cell(N_design,1);

%% Step 4 — 逐个设计验证539位姿

fprintf('\n--- E2 539-Pose Verification ---\n');

fprintf('Designs: %d\n',N_design);
fprintf('Development poses: %d\n',N_pose);

fprintf('Cable clearance floor: %.6f mm\n', ...
    clearance_floor);

for d = 1:N_design

    cfg = designs{d};

    A = cfg.A;
    r = cfg.r;

    r0 = cfg.r_baseline;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    %% 4.1 验证球面位置

    radius_error = max(abs( ...
        vecnorm(r,2,2)-settings.rb));

    assert(radius_error<1e-8);

    %% 4.2 Attachment spacing约束

    MinAttachmentChord_mm(d) = ...
        minimum_chord(r);

    SpacingFloor_mm(d) = ...
        minimum_chord(r0);

    SpacingEligible(d) = ...
        MinAttachmentChord_mm(d)>= ...
        SpacingFloor_mm(d)-1e-8;

    %% 4.3 统一539-Pose评价

    g = evaluate_539( ...
        A,r,P_eval,R_eval,settings);

    details{d} = g;

    GeometryPass(d) = ...
        sum(g.geometry_safe);

    RankPass(d) = ...
        sum(g.geometry_safe & ...
            g.rank_all==6);

    %% 4.4 最小Outward Angle及限制Cable

    [angle_min,linear_idx] = ...
        min(g.angle_matrix(:));

    [angle_pose,angle_cable] = ...
        ind2sub(size(g.angle_matrix), ...
        linear_idx);

    MinOutwardAngle_deg(d) = angle_min;

    MinAnglePose(d) = angle_pose;
    MinAngleCable(d) = angle_cable;

    %% 4.5 最小Cable距离及限制Cable Pair

    [distance_min,linear_idx] = ...
        min(g.distance_matrix(:));

    [distance_pose,pair_id] = ...
        ind2sub(size(g.distance_matrix), ...
        linear_idx);

    MinCableDistance_mm(d) = distance_min;

    MinDistancePose(d) = distance_pose;

    pair = settings.cable_pairs(pair_id,:);

    MinDistanceCableA(d) = pair(1);
    MinDistanceCableB(d) = pair(2);

    %% 4.6 计算Core worst sigma

    % 所有12个设计都应保持Core 189可行
    assert(all(g.geometry_safe(1:189)));

    assert(all(g.rank_all(1:189)==6));

    CoreSigma(d) = ...
        min(g.sigma_min_all(1:189));

    %% 4.7 回归验证Lesson 2.5结果

    if d>N_baseline

        j = d-N_baseline;

        previous_sigma = ...
            e2.T_optimisation.FinalSigma(j);

        assert(abs( ...
            CoreSigma(d)-previous_sigma)<1e-7);

    end

    %% 4.8 完整资格判定

    GeometryEligible(d) = ...
        GeometryPass(d)==539 && ...
        RankPass(d)==539;

    ClearanceEligible(d) = ...
        MinCableDistance_mm(d)>= ...
        clearance_floor-1e-8;

    FullEligible(d) = ...
        GeometryEligible(d) && ...
        ClearanceEligible(d) && ...
        SpacingEligible(d);

    %% 4.9 只有完整合格才能正式排名

    if FullEligible(d)

        Worst539Sigma(d) = ...
            min(g.sigma_min_all);

        Worst539Kappa(d) = ...
            max(g.kappa_all);

    end

    %% 4.10 打印当前结果

    fprintf('\n============================\n');

    fprintf('%s | %s\n', ...
        Design(d),Track(d));

    fprintf('Geometry: %d/539\n', ...
        GeometryPass(d));

    fprintf('Rank: %d/539\n', ...
        RankPass(d));

    fprintf('Core sigma: %.6f\n', ...
        CoreSigma(d));

    fprintf('539 sigma: %.6f\n', ...
        Worst539Sigma(d));

    fprintf('Min angle: %.6f deg\n', ...
        MinOutwardAngle_deg(d));

    fprintf('Limiting angle: Pose %d, C%d\n', ...
        MinAnglePose(d),MinAngleCable(d));

    fprintf('Min Cable distance: %.4f mm\n', ...
        MinCableDistance_mm(d));

    fprintf('Limiting Cable pair: C%d-C%d\n', ...
        MinDistanceCableA(d), ...
        MinDistanceCableB(d));

    fprintf('Min Attachment chord: %.4f mm\n', ...
        MinAttachmentChord_mm(d));

    fprintf('Full eligible: %d\n', ...
        FullEligible(d));

end

%% Step 5 — 生成完整结果表

T_verification = table( ...
    Design,Track, ...
    GeometryPass,RankPass, ...
    GeometryEligible, ...
    ClearanceEligible,SpacingEligible, ...
    FullEligible, ...
    CoreSigma,Worst539Sigma, ...
    Worst539Kappa, ...
    MinOutwardAngle_deg, ...
    MinCableDistance_mm, ...
    MinAttachmentChord_mm, ...
    MinAnglePose,MinAngleCable, ...
    MinDistancePose, ...
    MinDistanceCableA, ...
    MinDistanceCableB);

fprintf('\n====================================\n');
fprintf('E2 539-Pose Verification Results\n');
fprintf('====================================\n');

disp(T_verification);

%% Step 6 — 单独列出Geometry失败方案

failed = T_verification( ...
    ~T_verification.FullEligible,:);

fprintf('\n--- Non-Eligible Designs ---\n');

if isempty(failed)

    fprintf('All 12 designs passed.\n');

else

    disp(failed(:,{ ...
        'Design','Track', ...
        'GeometryPass','RankPass', ...
        'ClearanceEligible', ...
        'SpacingEligible', ...
        'MinOutwardAngle_deg', ...
        'MinAnglePose', ...
        'MinAngleCable'}));

end

%% Step 7 — 统计Track表现

BaselineMask = Track=="Baseline";

TrackSMask = Track=="SensingPriority";

TrackMMask = ...
    Track=="MarginPreservingSensing";

fprintf('\n--- E2 Development Summary ---\n');

fprintf('Baseline eligible: %d/4\n', ...
    sum(FullEligible(BaselineMask)));

fprintf('Track S eligible: %d/4\n', ...
    sum(FullEligible(TrackSMask)));

fprintf('Track M eligible: %d/4\n', ...
    sum(FullEligible(TrackMMask)));

fprintf('Total eligible: %d/12\n', ...
    sum(FullEligible));

%% Step 8 — 539 Sensing不能高于Core Sensing

for d = find(FullEligible)'

    assert(Worst539Sigma(d)<= ...
        CoreSigma(d)+1e-8);

end

assert(all(RankPass<=GeometryPass));

fprintf('\nPASS: Core regression verified.\n');
fprintf('PASS: 539-pose checks completed.\n');

%% Step 9 — 保存结果

save( ...
    'B5_4_E2_539pose_verification.mat', ...
    'T_verification', ...
    'details','designs', ...
    'P_eval','R_eval', ...
    'clearance_floor');

writetable(T_verification, ...
    'B5_4_E2_539pose_verification.csv');

fprintf('\nE2 Lesson 2.6 completed.\n');

%% ==============================================
% Local Function 1 — Attachment最小弦长
%% ==============================================

function dmin = minimum_chord(r)

    pairs = nchoosek(1:6,2);

    dmin = inf;

    for j = 1:size(pairs,1)

        i = pairs(j,1);
        k = pairs(j,2);

        dmin = min( ...
            dmin,norm(r(i,:)-r(k,:)));

    end

end

%% ==============================================
% Local Function 2 — 539-Pose统一评价
%% ==============================================

function g = evaluate_539( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);

    rank_all = zeros(N,1);

    sigma_min_all = nan(N,1);
    kappa_all = nan(N,1);

    angle_matrix = nan(N,6);

    distance_matrix = nan( ...
        N,size(pairs,1));

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;

        D = A-B;
        L = vecnorm(D,2,2);

        % 无效Cable长度视为失败
        if any(L<=1e-9)

            angle_matrix(k,:) = -inf;
            distance_matrix(k,:) = 0;

            continue;

        end

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_value = outward_dot./ ...
            (settings.rb*L);

        sine_value = max( ...
            -1,min(1,sine_value));

        angle_matrix(k,:) = ...
            asind(sine_value)';

        sphere_ok = all( ...
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

            distance_matrix(k,j) = dij;

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        geometry_safe(k) = ...
            sphere_ok && cable_ok;

        %% Scaled Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))];

        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        sigma_min_all(k) = sv(end);

        rank_all(k) = sum( ...
            sv>settings.rank_relative_tol*sv(1));

        if sv(end)>0

            kappa_all(k) = ...
                sv(1)/sv(end);

        else

            kappa_all(k) = inf;

        end

    end

    g.geometry_safe = geometry_safe;

    g.rank_all = rank_all;

    g.sigma_min_all = sigma_min_all;
    g.kappa_all = kappa_all;

    g.angle_matrix = angle_matrix;
    g.distance_matrix = distance_matrix;

end
