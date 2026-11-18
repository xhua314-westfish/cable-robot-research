
%% B5.4 E2 Lesson 2.7
% Attachment Installation Robustness
%
% Research Question:
% Attachment存在小的球面安装误差时，
% E2配置能否继续通过539个开发位姿？
%
% 对象：
% Lesson 2.6中10个FullEligible设计
%
% 扰动：
% 每次移动一根Attachment
% alpha = 0.5 deg
% beta = 0, 90, 180, 270 deg
%
% 每设计24次，共240次539-pose评价
%
% 本节不修改、修复或优化任何设计。

clear; clc; close all;

%% Step 1 — 加载数据

v = load( ...
    'B5_4_E2_539pose_verification.mat');

b = load( ...
    'B5_4_unified_evaluation_baseline.mat', ...
    'settings');

settings = b.settings;

T_previous = v.T_verification;

P_eval = v.P_eval;
R_eval = v.R_eval;

clearance_floor = v.clearance_floor;

N_pose = size(P_eval,1);

assert(N_pose==539);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 选择539完全合格的设计

selected_rows = find(T_previous.FullEligible);

N_design = numel(selected_rows);

assert(N_design==10);

% 球面切向角扰动
alpha_deg = 0.5;

beta_values = [0 90 180 270];

N_per_design = 6*numel(beta_values);

assert(N_per_design==24);

N_total = N_design*N_per_design;

fprintf('\n--- E2 Attachment Installation Test ---\n');

fprintf('Eligible designs: %d\n',N_design);
fprintf('Perturbations per design: %d\n',N_per_design);

fprintf('Total perturbations: %d\n',N_total);

fprintf('Angular perturbation: %.3f deg\n', ...
    alpha_deg);

fprintf('Equivalent arc: %.4f mm\n', ...
    settings.rb*deg2rad(alpha_deg));

%% Step 3 — 初始化逐次试验结果

Design = strings(N_total,1);
Track = strings(N_total,1);

CableID = zeros(N_total,1);
Beta_deg = zeros(N_total,1);

GeometryPass = zeros(N_total,1);
RankPass = zeros(N_total,1);

MinAngle_deg = nan(N_total,1);
MinCableDistance_mm = nan(N_total,1);
MinAttachmentChord_mm = nan(N_total,1);

WorstSigma = nan(N_total,1);

GeometryClearancePass = false(N_total,1);
SpacingPass = false(N_total,1);
FullProtocolPass = false(N_total,1);

LimitingPose = zeros(N_total,1);
LimitingCable = zeros(N_total,1);

% 汇总
ResultDesign = strings(N_design,1);
ResultTrack = strings(N_design,1);

NominalSigma = nan(N_design,1);
NominalAngle = nan(N_design,1);

GeometryClearancePassCount = zeros(N_design,1);
FullProtocolPassCount = zeros(N_design,1);

GeometryFailCount = zeros(N_design,1);
ClearanceFailCount = zeros(N_design,1);
SpacingFailCount = zeros(N_design,1);

WorstPerturbedAngle = nan(N_design,1);
WorstPerturbedDistance = nan(N_design,1);
WorstPassingSigma = nan(N_design,1);

row = 0;

%% Step 4 — 遍历10个设计

for d = 1:N_design

    old_id = selected_rows(d);

    cfg = v.designs{old_id};

    A = cfg.A;
    r0 = cfg.r;

    r_baseline = cfg.r_baseline;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r0),[6 3]));

    ResultDesign(d) = ...
        string(T_previous.Design(old_id));

    ResultTrack(d) = ...
        string(T_previous.Track(old_id));

    NominalSigma(d) = ...
        T_previous.Worst539Sigma(old_id);

    NominalAngle(d) = ...
        T_previous.MinOutwardAngle_deg(old_id);

    % 本轮沿用E2的保守spacing比较规则
    spacing_floor = minimum_chord(r_baseline);

    fprintf('\n============================\n');

    fprintf('%s | %s\n', ...
        ResultDesign(d),ResultTrack(d));

    fprintf('Nominal sigma: %.6f\n', ...
        NominalSigma(d));

    fprintf('Nominal angle: %.4f deg\n', ...
        NominalAngle(d));

    first_row = row+1;

    %% Step 5 — 逐根Attachment施加扰动

    for cable_id = 1:6

        % 球面法向量
        n = r0(cable_id,:)'/settings.rb;

        n = n/norm(n);

        %% 5.1 构造切向基

        if abs(dot(n,[0;0;1]))<0.9

            reference_axis = [0;0;1];

        else

            reference_axis = [1;0;0];

        end

        e1 = cross(reference_axis,n);
        e1 = e1/norm(e1);

        e2 = cross(n,e1);
        e2 = e2/norm(e2);

        %% 5.2 四个扰动方向

        for beta = beta_values

            row = row+1;

            tangent = ...
                cosd(beta)*e1 + ...
                sind(beta)*e2;

            r_new = settings.rb*( ...
                cosd(alpha_deg)*n + ...
                sind(alpha_deg)*tangent);

            r_trial = r0;

            r_trial(cable_id,:) = r_new';

            % 验证球面约束
            assert(max(abs( ...
                vecnorm(r_trial,2,2)- ...
                settings.rb))<1e-8);

            %% 5.3 539-Pose评价

            g = evaluate_perturbed_design( ...
                A,r_trial,P_eval,R_eval, ...
                settings,clearance_floor);

            min_chord = minimum_chord(r_trial);

            spacing_ok = ...
                min_chord>=spacing_floor-1e-8;

            geometry_clearance_ok = ...
                g.geometry_pass==539 && ...
                g.rank_pass==539 && ...
                g.clearance_ok;

            full_ok = ...
                geometry_clearance_ok && ...
                spacing_ok;

            %% 5.4 保存逐次试验

            Design(row) = ResultDesign(d);
            Track(row) = ResultTrack(d);

            CableID(row) = cable_id;
            Beta_deg(row) = beta;

            GeometryPass(row) = ...
                g.geometry_pass;

            RankPass(row) = ...
                g.rank_pass;

            MinAngle_deg(row) = ...
                g.min_angle;

            MinCableDistance_mm(row) = ...
                g.min_distance;

            MinAttachmentChord_mm(row) = ...
                min_chord;

            GeometryClearancePass(row) = ...
                geometry_clearance_ok;

            SpacingPass(row) = spacing_ok;

            FullProtocolPass(row) = full_ok;

            LimitingPose(row) = ...
                g.angle_pose;

            LimitingCable(row) = ...
                g.angle_cable;

            % 只给通过基本几何与clearance的
            % 方案记录正式WorstSigma
            if geometry_clearance_ok

                WorstSigma(row) = ...
                    g.worst_sigma;

            end

        end

    end

    %% Step 6 — 当前设计汇总

    rows = first_row:row;

    assert(numel(rows)==24);

    GeometryClearancePassCount(d) = ...
        sum(GeometryClearancePass(rows));

    FullProtocolPassCount(d) = ...
        sum(FullProtocolPass(rows));

    GeometryFailCount(d) = sum( ...
        GeometryPass(rows)<539 | ...
        RankPass(rows)<539);

    ClearanceFailCount(d) = sum( ...
        MinCableDistance_mm(rows)< ...
        clearance_floor-1e-8);

    SpacingFailCount(d) = sum( ...
        ~SpacingPass(rows));

    WorstPerturbedAngle(d) = ...
        min(MinAngle_deg(rows));

    WorstPerturbedDistance(d) = ...
        min(MinCableDistance_mm(rows));

    passing_rows = rows( ...
        GeometryClearancePass(rows));

    if ~isempty(passing_rows)

        WorstPassingSigma(d) = ...
            min(WorstSigma(passing_rows));

    end

    fprintf('Geometry + Clearance pass: %d/24\n', ...
        GeometryClearancePassCount(d));

    fprintf('Full protocol pass: %d/24\n', ...
        FullProtocolPassCount(d));

    fprintf('Geometry failures: %d\n', ...
        GeometryFailCount(d));

    fprintf('Clearance failures: %d\n', ...
        ClearanceFailCount(d));

    fprintf('Spacing-rule failures: %d\n', ...
        SpacingFailCount(d));

    fprintf('Worst perturbed angle: %.5f deg\n', ...
        WorstPerturbedAngle(d));

end

assert(row==N_total);

%% Step 7 — 创建逐次数据表

T_trials = table( ...
    Design,Track,CableID,Beta_deg, ...
    GeometryPass,RankPass, ...
    MinAngle_deg,MinCableDistance_mm, ...
    MinAttachmentChord_mm, ...
    GeometryClearancePass,SpacingPass, ...
    FullProtocolPass,WorstSigma, ...
    LimitingPose,LimitingCable);

%% Step 8 — 创建汇总数据表

T_installation = table( ...
    ResultDesign,ResultTrack, ...
    NominalSigma,NominalAngle, ...
    GeometryClearancePassCount, ...
    FullProtocolPassCount, ...
    GeometryFailCount, ...
    ClearanceFailCount, ...
    SpacingFailCount, ...
    WorstPerturbedAngle, ...
    WorstPerturbedDistance, ...
    WorstPassingSigma);

fprintf('\n====================================\n');

fprintf('E2 Attachment Installation Results\n');

fprintf('====================================\n');

disp(T_installation);

%% Step 9 — 显示所有几何/净空失败

% 不把单纯Spacing-rule失败
% 自动称为物理Cable干涉。
hard_failed = T_trials( ...
    ~T_trials.GeometryClearancePass,:);

fprintf('\n--- Geometry / Clearance Failures ---\n');

if isempty(hard_failed)

    fprintf('No hard geometry/clearance failure.\n');

else

    disp(hard_failed(:,{ ...
        'Design','Track', ...
        'CableID','Beta_deg', ...
        'GeometryPass','RankPass', ...
        'MinAngle_deg', ...
        'MinCableDistance_mm', ...
        'LimitingPose','LimitingCable'}));

end

%% Step 10 — 单独列出Spacing-rule失败

spacing_failed = T_trials( ...
    ~T_trials.SpacingPass,:);

fprintf('\n--- Spacing-Rule Failures ---\n');

fprintf('Count: %d\n',height(spacing_failed));

if ~isempty(spacing_failed)

    disp(spacing_failed(:,{ ...
        'Design','Track', ...
        'CableID','Beta_deg', ...
        'MinAttachmentChord_mm'}));

end

%% Step 11 — 完整性检查

assert(height(T_trials)==240);

assert(all( ...
    GeometryClearancePassCount<=24));

assert(all( ...
    FullProtocolPassCount<= ...
    GeometryClearancePassCount));

assert(all( ...
    RankPass<=GeometryPass));

fprintf('\nTotal perturbations: %d\n', ...
    height(T_trials));

fprintf('PASS: Attachment perturbation test completed.\n');

%% Step 12 — 保存

save( ...
    'B5_4_E2_attachment_installation_robustness.mat', ...
    'T_installation','T_trials', ...
    'selected_rows','alpha_deg', ...
    'beta_values','clearance_floor');

writetable(T_installation, ...
    'B5_4_E2_attachment_installation_summary.csv');

writetable(T_trials, ...
    'B5_4_E2_attachment_installation_trials.csv');

fprintf('\nE2 Lesson 2.7 completed.\n');

%% ==========================================
% Local Function 1 — Attachment最小弦长
%% ==========================================

function dmin = minimum_chord(r)

    pairs = nchoosek(1:6,2);

    dmin = inf;

    for p = 1:size(pairs,1)

        i = pairs(p,1);
        j = pairs(p,2);

        dmin = min( ...
            dmin,norm(r(i,:)-r(j,:)));

    end

end

%% ==========================================
% Local Function 2 — 统一539-pose评价
%% ==========================================

function g = evaluate_perturbed_design( ...
    A,r,P_all,R_all,settings,clearance_floor)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    min_angle = inf;
    min_distance = inf;

    angle_pose = 0;
    angle_cable = 0;

    worst_sigma = inf;

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;

        D = A-B;

        L = vecnorm(D,2,2);

        if any(L<=1e-9)

            % 退化Cable视为失败
            min_angle = -inf;
            min_distance = 0;

            continue;

        end

        %% Cable-Sphere

        outward_dot = sum(S.*D,2);

        sine_value = outward_dot./ ...
            (settings.rb*L);

        sine_value = max( ...
            -1,min(1,sine_value));

        angles = asind(sine_value);

        [local_angle,local_cable] = ...
            min(angles);

        if local_angle<min_angle

            min_angle = local_angle;
            angle_pose = k;
            angle_cable = local_cable;

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

        rankH = sum( ...
            sv>settings.rank_relative_tol*sv(1));

        if geometry_ok && rankH==6

            rank_pass = rank_pass+1;

        end

        worst_sigma = min( ...
            worst_sigma,sv(end));

    end

    %% 检查共同几何约束

    clearance_ok = ...
        min_distance>=clearance_floor-1e-8;

    g = struct();

    g.geometry_pass = geometry_pass;
    g.rank_pass = rank_pass;

    g.min_angle = min_angle;
    g.min_distance = min_distance;

    g.angle_pose = angle_pose;
    g.angle_cable = angle_cable;

    g.clearance_ok = clearance_ok;

    % 仅返回计算得到的Sigma，
    % 资格判定在主脚本中进行
    g.worst_sigma = worst_sigma;

end
