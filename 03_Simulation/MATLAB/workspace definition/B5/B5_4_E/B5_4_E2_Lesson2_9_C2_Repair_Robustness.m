
%% B5.4 E2 Lesson 2.9
% C2-2 Repaired Configuration Robustness
%
% Compare:
% 1. Original E1b C2-2
% 2. Repaired E2 Track S
% 3. Repaired E2 Track M
%
% Test A: Anchor perturbation +/-0.005 along rail
% Test B: Attachment perturbation 0.5 deg on sphere
%
% 12 + 24 = 36 tests/design
% 3 x 36 = 108 tests
%
% All legal perturbations tested on 539 dev poses.
% No optimisation or design modification here.

clear; clc; close all;

%% Step 1 — Load verified files

repair = load( ...
    'B5_4_E2_C2_C4_targeted_repair.mat');

e2 = load( ...
    'B5_4_E2_sequential_optimisation.mat');

dev = load( ...
    'B5_4_E2_539pose_verification.mat', ...
    'P_eval','R_eval','clearance_floor');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat', ...
    'settings');

settings = base.settings;

P_eval = dev.P_eval;
R_eval = dev.R_eval;

clearance_floor = dev.clearance_floor;

assert(size(P_eval,1)==539);
assert(numel(repair.repaired_designs)==2);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — Load Rail geometry

% 兼容Rail MAT保存在B5_4或相邻B5_3文件夹

rail_file = 'B5_3_12rail_geometry_baseline.mat';

if ~isfile(rail_file)

    rail_file = fullfile( ...
        fileparts(pwd),'B5_3', ...
        'B5_3_12rail_geometry_baseline.mat');

end

assert(isfile(rail_file), ...
    'Rail geometry MAT not found.');

rails = load(rail_file, ...
    'rail_start','rail_end');

%% Step 3 — Prepare three configurations

Design = [ ...
    "E1b C2-2 Baseline";
    "E2 C2-2 Repaired S";
    "E2 C2-2 Repaired M"];

designs = cell(3,1);

idx = find( ...
    e2.T_optimisation.DesignName=="E1b C2-2" & ...
    e2.T_optimisation.TrackName=="SensingPriority");

assert(numel(idx)==1);

source = e2.optimised_designs{idx};

% Original E1b baseline
designs{1} = struct( ...
    'A',source.A_fixed, ...
    'r',source.r_initial, ...
    'r_baseline',source.r_initial, ...
    'rail_ids',source.rail_ids, ...
    't',source.t_fixed);

% Repaired E2 configurations
for j = 1:2

    rep = repair.repaired_designs{j};

    assert(rep.best_found, ...
        'A repaired configuration is missing.');

    assert(norm( ...
        rep.A_fixed-source.A_fixed,'fro')<1e-8);

    designs{j+1} = struct( ...
        'A',rep.A_fixed, ...
        'r',rep.r_repaired, ...
        'r_baseline',rep.r_initial, ...
        'rail_ids',source.rail_ids, ...
        't',source.t_fixed);

end

%% Step 4 — Perturbation definitions

anchor_delta_t = 0.005;

attachment_alpha_deg = 0.5;

attachment_beta_deg = [0 90 180 270];

N_design = 3;
N_anchor = 12;
N_attachment = 24;

N_total = ...
    N_design*(N_anchor+N_attachment);

assert(N_total==108);

fprintf('\n--- E2 Lesson 2.9 ---\n');
fprintf('Designs: %d\n',N_design);
fprintf('Anchor tests/design: %d\n',N_anchor);
fprintf('Attachment tests/design: %d\n',N_attachment);
fprintf('Total tests: %d\n',N_total);

%% Step 5 — Record storage

DesignID = zeros(N_total,1);

PerturbationType = strings(N_total,1);

CableID = zeros(N_total,1);

Direction = nan(N_total,1);

OffRail = false(N_total,1);

GeometryPass = nan(N_total,1);
RankPass = nan(N_total,1);

MinAngle_deg = nan(N_total,1);
MinCableDistance_mm = nan(N_total,1);
MinAttachmentChord_mm = nan(N_total,1);

WorstSigma = nan(N_total,1);

GeometryClearancePass = false(N_total,1);
SpacingPass = false(N_total,1);
FullProtocolPass = false(N_total,1);

LimitingPose = nan(N_total,1);
LimitingCable = nan(N_total,1);

% Per-design summary
NominalSigma = nan(N_design,1);
NominalAngle = nan(N_design,1);

AnchorHardPass = zeros(N_design,1);
AttachmentHardPass = zeros(N_design,1);

AnchorFullPass = zeros(N_design,1);
AttachmentFullPass = zeros(N_design,1);

OffRailCount = zeros(N_design,1);

WorstLegalAngle = nan(N_design,1);
WorstLegalDistance = nan(N_design,1);
WorstPassingSigma = nan(N_design,1);

row = 0;

%% Step 6 — Evaluate three designs

for d = 1:N_design

    cfg = designs{d};

    A0 = cfg.A;
    r0 = cfg.r;

    rho = cfg.rail_ids(:)';
    t0 = cfg.t(:)';

    spacing_floor = ...
        min_attachment_chord(cfg.r_baseline);

    assert(isequal(size(A0),[6 3]));
    assert(isequal(size(r0),[6 3]));

    %% 6.1 Verify anchors are on recorded rails

    A_rebuilt = build_anchors( ...
        t0,rho, ...
        rails.rail_start,rails.rail_end);

    assert(norm(A0-A_rebuilt,'fro')<1e-7);

    %% 6.2 Verify nominal configuration

    nominal = evaluate_539( ...
        A0,r0,P_eval,R_eval,settings);

    nominal_hard_ok = ...
        nominal.geometry_pass==539 && ...
        nominal.rank_pass==539 && ...
        nominal.min_distance>= ...
        clearance_floor-1e-8;

    assert(nominal_hard_ok);

    assert(min_attachment_chord(r0)>= ...
        spacing_floor-1e-8);

    NominalSigma(d) = nominal.worst_sigma;
    NominalAngle(d) = nominal.min_angle;

    fprintf('\n============================\n');
    fprintf('%s\n',Design(d));
    fprintf('Nominal sigma: %.6f\n', ...
        NominalSigma(d));

    start_row = row+1;

    %% Step 7 — Anchor perturbations

    for cable_id = 1:6

        for sign_value = [-1 1]

            row = row+1;

            t_trial = t0;
            t_trial(cable_id) = ...
                t_trial(cable_id) + ...
                sign_value*anchor_delta_t;

            DesignID(row) = d;
            PerturbationType(row) = "Anchor";

            CableID(row) = cable_id;
            Direction(row) = sign_value;

            if any(t_trial<0 | t_trial>1)

                OffRail(row) = true;
                continue;

            end

            A_trial = build_anchors( ...
                t_trial,rho, ...
                rails.rail_start,rails.rail_end);

            % Attachment unchanged
            r_trial = r0;

            g = evaluate_539( ...
                A_trial,r_trial, ...
                P_eval,R_eval,settings);

            [GeometryPass(row),RankPass(row), ...
             MinAngle_deg(row), ...
             MinCableDistance_mm(row), ...
             WorstSigma(row), ...
             LimitingPose(row), ...
             LimitingCable(row)] = ...
                unpack_eval(g);

            MinAttachmentChord_mm(row) = ...
                min_attachment_chord(r_trial);

            SpacingPass(row) = ...
                MinAttachmentChord_mm(row)>= ...
                spacing_floor-1e-8;

            GeometryClearancePass(row) = ...
                g.geometry_pass==539 && ...
                g.rank_pass==539 && ...
                g.min_distance>= ...
                clearance_floor-1e-8;

            FullProtocolPass(row) = ...
                GeometryClearancePass(row) && ...
                SpacingPass(row);

        end

    end

    %% Step 8 — Attachment perturbations

    for cable_id = 1:6

        n = r0(cable_id,:)'/settings.rb;

        n = n/norm(n);

        % Stable tangent frame
        if abs(dot(n,[0;0;1]))<0.9
            ref_axis = [0;0;1];
        else
            ref_axis = [1;0;0];
        end

        e1 = cross(ref_axis,n);
        e1 = e1/norm(e1);

        e2 = cross(n,e1);
        e2 = e2/norm(e2);

        for beta = attachment_beta_deg

            row = row+1;

            tangent = cosd(beta)*e1 + ...
                sind(beta)*e2;

            new_r = settings.rb*( ...
                cosd(attachment_alpha_deg)*n + ...
                sind(attachment_alpha_deg)*tangent);

            r_trial = r0;

            r_trial(cable_id,:) = new_r';

            assert(max(abs( ...
                vecnorm(r_trial,2,2)-settings.rb)) ...
                <1e-8);

            DesignID(row) = d;
            PerturbationType(row) = "Attachment";

            CableID(row) = cable_id;
            Direction(row) = beta;

            % Anchors unchanged
            g = evaluate_539( ...
                A0,r_trial, ...
                P_eval,R_eval,settings);

            [GeometryPass(row),RankPass(row), ...
             MinAngle_deg(row), ...
             MinCableDistance_mm(row), ...
             WorstSigma(row), ...
             LimitingPose(row), ...
             LimitingCable(row)] = ...
                unpack_eval(g);

            MinAttachmentChord_mm(row) = ...
                min_attachment_chord(r_trial);

            SpacingPass(row) = ...
                MinAttachmentChord_mm(row)>= ...
                spacing_floor-1e-8;

            GeometryClearancePass(row) = ...
                g.geometry_pass==539 && ...
                g.rank_pass==539 && ...
                g.min_distance>= ...
                clearance_floor-1e-8;

            FullProtocolPass(row) = ...
                GeometryClearancePass(row) && ...
                SpacingPass(row);

        end

    end

    %% Step 9 — Per-design summary

    rows = start_row:row;

    assert(numel(rows)==36);

    anchor_rows = rows( ...
        PerturbationType(rows)=="Anchor");

    attachment_rows = rows( ...
        PerturbationType(rows)=="Attachment");

    AnchorHardPass(d) = sum( ...
        GeometryClearancePass(anchor_rows));

    AttachmentHardPass(d) = sum( ...
        GeometryClearancePass(attachment_rows));

    AnchorFullPass(d) = sum( ...
        FullProtocolPass(anchor_rows));

    AttachmentFullPass(d) = sum( ...
        FullProtocolPass(attachment_rows));

    OffRailCount(d) = sum(OffRail(rows));

    legal_rows = rows(~OffRail(rows));

    WorstLegalAngle(d) = ...
        min(MinAngle_deg(legal_rows));

    WorstLegalDistance(d) = ...
        min(MinCableDistance_mm(legal_rows));

    passing_rows = rows( ...
        GeometryClearancePass(rows));

    if ~isempty(passing_rows)

        WorstPassingSigma(d) = ...
            min(WorstSigma(passing_rows));

    end

    fprintf('Anchor hard pass: %d/12\n', ...
        AnchorHardPass(d));

    fprintf('Attachment hard pass: %d/24\n', ...
        AttachmentHardPass(d));

    fprintf('Anchor full pass: %d/12\n', ...
        AnchorFullPass(d));

    fprintf('Attachment full pass: %d/24\n', ...
        AttachmentFullPass(d));

    fprintf('Off-rail: %d\n',OffRailCount(d));

    fprintf('Worst legal angle: %.6f deg\n', ...
        WorstLegalAngle(d));

end

assert(row==N_total);

%% Step 10 — Detailed results

T_trials = table( ...
    DesignID,PerturbationType, ...
    CableID,Direction,OffRail, ...
    GeometryPass,RankPass, ...
    MinAngle_deg,MinCableDistance_mm, ...
    MinAttachmentChord_mm, ...
    GeometryClearancePass,SpacingPass, ...
    FullProtocolPass,WorstSigma, ...
    LimitingPose,LimitingCable);

%% Step 11 — Summary table

T_summary = table( ...
    Design,NominalSigma,NominalAngle, ...
    AnchorHardPass,AttachmentHardPass, ...
    AnchorFullPass,AttachmentFullPass, ...
    OffRailCount, ...
    WorstLegalAngle,WorstLegalDistance, ...
    WorstPassingSigma);

fprintf('\n====================================\n');
fprintf('E2 C2-2 Repaired Robustness Summary\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 12 — Show all failures

failed = T_trials( ...
    ~T_trials.FullProtocolPass,:);

fprintf('\n--- Failed Perturbations ---\n');

if isempty(failed)

    fprintf('All 108 tests passed.\n');

else

    disp(failed(:,{ ...
        'DesignID','PerturbationType', ...
        'CableID','Direction','OffRail', ...
        'GeometryPass','MinAngle_deg', ...
        'MinCableDistance_mm', ...
        'SpacingPass','LimitingPose', ...
        'LimitingCable'}));

end

%% Step 13 — Verify and save

assert(height(T_trials)==108);

assert(all(AnchorHardPass<=12));
assert(all(AttachmentHardPass<=24));

assert(all(AnchorFullPass<=AnchorHardPass));
assert(all(AttachmentFullPass<=AttachmentHardPass));

save( ...
    'B5_4_E2_C2_repaired_robustness.mat', ...
    'T_summary','T_trials', ...
    'designs','P_eval','R_eval', ...
    'clearance_floor','anchor_delta_t', ...
    'attachment_alpha_deg');

writetable(T_summary, ...
    'B5_4_E2_C2_repaired_robustness.csv');

writetable(T_trials, ...
    'B5_4_E2_C2_repaired_robustness_trials.csv');

fprintf('\nE2 Lesson 2.9 completed.\n');

%% ==============================================
% Local Function 1 — Build rail anchors
%% ==============================================

function A = build_anchors( ...
    t,rho,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rho(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:) - ...
            rail_start(rid,:));

    end

end

%% ==============================================
% Local Function 2 — Minimum attachment chord
%% ==============================================

function dmin = min_attachment_chord(r)

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
% Local Function 3 — Unified 539 evaluator
%% ==============================================

function g = evaluate_539( ...
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

        outward_dot = sum(S.*D,2);

        s = outward_dot./(settings.rb*L);

        s = max(-1,min(1,s));

        angles = asind(s);

        [local_angle,cable_id] = min(angles);

        if local_angle<min_angle

            min_angle = local_angle;
            min_angle_pose = k;
            min_angle_cable = cable_id;

        end

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        cable_ok = true;

        for j = 1:size(pairs,1)

            i = pairs(j,1);
            m = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                B(i,:),A(i,:), ...
                B(m,:),A(m,:));

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

    g.geometry_pass = geometry_pass;
    g.rank_pass = rank_pass;

    g.min_angle = min_angle;
    g.min_distance = min_distance;

    g.min_angle_pose = min_angle_pose;
    g.min_angle_cable = min_angle_cable;

    g.worst_sigma = worst_sigma;

end

%% ==============================================
% Local Function 4 — Unpack evaluator
%% ==============================================

function [geo,rankpass,angle,dist,sigma, ...
          pose,cable] = unpack_eval(g)

    geo = g.geometry_pass;
    rankpass = g.rank_pass;

    angle = g.min_angle;
    dist = g.min_distance;

    % 失败设计不参加正式Sigma排名
    if geo==539 && rankpass==539
        sigma = g.worst_sigma;
    else
        sigma = NaN;
    end

    pose = g.min_angle_pose;
    cable = g.min_angle_cable;

end
