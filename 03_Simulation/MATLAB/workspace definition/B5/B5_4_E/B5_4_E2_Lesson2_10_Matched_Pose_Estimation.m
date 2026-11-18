
%% B5.4 E2 Lesson 2.10
% Matched Nonlinear Pose Estimation Comparison
%
% Research Question:
% Does E2 attachment optimisation improve
% six-DOF pose reconstruction accuracy?
%
% Four matched pairs:
% C2-2 Baseline vs E2 Repaired M
% C4-1 Baseline vs E2 Track M
% C8-16 Baseline vs E2 Track M
% C12 Baseline vs E2 Track M
%
% 36 development poses x 20 noise repeats
% 8 designs = 5760 estimation trials
%
% No optimisation in this lesson.
% C2 repaired M has a known installation failure.
% Results are simulation, not hardware accuracy.

clear; clc; close all;

%% Step 1 — Load previous results

v = load( ...
    'B5_4_E2_539pose_verification.mat');

repair = load( ...
    'B5_4_E2_C2_C4_targeted_repair.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat', ...
    'settings');

settings = base.settings;

P_all = v.P_eval;
R_all = v.R_eval;

rb = settings.rb;

assert(size(P_all,1)==539);
assert(isequal(size(R_all),[3 3 539]));

%% Step 2 — Define four matched pairs

pair_names = [ ...
    "E1b C2-2";
    "E1b C4-1";
    "E1b C8-16";
    "E1a C12"];

N_pair = numel(pair_names);

% 每组两种设计：
% Baseline + E2
N_design = 2*N_pair;

Design = strings(N_design,1);
PairID = zeros(N_design,1);
Version = strings(N_design,1);

designs = cell(N_design,1);

for p = 1:N_pair

    name = pair_names(p);

    %% 2.1 Find baseline

    idx_base = find( ...
        string(v.T_verification.Design)==name & ...
        string(v.T_verification.Track)=="Baseline");

    assert(numel(idx_base)==1);

    assert(v.T_verification.FullEligible(idx_base));

    original = v.designs{idx_base};

    row_base = 2*p-1;

    designs{row_base} = struct( ...
        'A',original.A, ...
        'r',original.r);

    Design(row_base) = name+" Baseline";
    PairID(row_base) = p;
    Version(row_base) = "Baseline";

    %% 2.2 Find E2 design

    row_e2 = 2*p;

    if p==1

        % C2-2 targeted repaired M
        rep = repair.repaired_designs{2};

        assert(rep.best_found);

        assert(string(rep.track)== ...
            "MarginPreservingSensing");

        designs{row_e2} = struct( ...
            'A',rep.A_fixed, ...
            'r',rep.r_repaired);

        Design(row_e2) = name+" Repaired M";

    else

        idx_e2 = find( ...
            string(v.T_verification.Design)==name & ...
            string(v.T_verification.Track)== ...
            "MarginPreservingSensing");

        assert(numel(idx_e2)==1);

        assert(v.T_verification.FullEligible(idx_e2));

        opt = v.designs{idx_e2};

        designs{row_e2} = struct( ...
            'A',opt.A, ...
            'r',opt.r);

        Design(row_e2) = name+" E2 M";

    end

    PairID(row_e2) = p;
    Version(row_e2) = "E2";

    %% 2.3 Anchor must be unchanged

    assert(norm( ...
        designs{row_base}.A- ...
        designs{row_e2}.A,'fro')<1e-8);

end

assert(N_design==8);

%% Step 3 — Select the same 36 poses

% Three development subsets
core_ids = unique(round( ...
    linspace(1,189,12)));

offgrid_A_ids = unique(round( ...
    linspace(190,339,12)));

offgrid_B_ids = unique(round( ...
    linspace(340,539,12)));

pose_ids = [ ...
    core_ids, ...
    offgrid_A_ids, ...
    offgrid_B_ids];

assert(numel(pose_ids)==36);

N_pose = numel(pose_ids);

%% Step 4 — Shared noise and solver

noise_sd_mm = 0.1;
N_repeat = 20;

rng(42);

% Equal noise for corresponding poses and repeats
noise_samples = noise_sd_mm* ...
    randn(N_pose,6,N_repeat);

solver.max_iterations = 100;
solver.residual_tol_mm = 1e-8;

solver.lambda = 1e-4;
solver.max_backtracks = 20;

solver.max_dp = 20;
solver.max_dw = deg2rad(10);

solver.scale = diag( ...
    [1 1 1 1/rb 1/rb 1/rb]);

P0 = [0 0 0];
R0 = eye(3);

%% Step 5 — Prepare storage

N_total = N_design*N_pose*N_repeat;

DesignID = zeros(N_total,1);
PoseID = zeros(N_total,1);
RepeatID = zeros(N_total,1);

Converged = false(N_total,1);
Iterations = zeros(N_total,1);

PositionError_mm = nan(N_total,1);
OrientationError_deg = nan(N_total,1);

ResidualNorm_mm = nan(N_total,1);

row = 0;

fprintf('\n--- E2 Matched Pose Estimation ---\n');

fprintf('Designs: %d\n',N_design);
fprintf('Pose samples: %d\n',N_pose);
fprintf('Repeats: %d\n',N_repeat);
fprintf('Noise SD: %.3f mm\n',noise_sd_mm);
fprintf('Total trials: %d\n',N_total);

%% Step 6 — Run nonlinear estimation

for d = 1:N_design

    A = designs{d}.A;
    r = designs{d}.r;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    assert(max(abs( ...
        vecnorm(r,2,2)-rb))<1e-8);

    fprintf('\n%s\n',Design(d));

    for p = 1:N_pose

        pose_id = pose_ids(p);

        P_true = P_all(pose_id,:);
        R_true = R_all(:,:,pose_id);

        % True pose is used only to simulate lengths
        L_true = predict_lengths( ...
            A,r,P_true,R_true);

        for rep = 1:N_repeat

            noise = reshape( ...
                noise_samples(p,:,rep),6,1);

            L_meas = L_true+noise;

            % Estimator does not receive true pose
            [P_est,R_est,success,residual,iters] = ...
                estimate_pose( ...
                A,r,L_meas,P0,R0,solver);

            %% Independent pose error

            pe = norm(P_est-P_true);

            Rerr = R_est*R_true';

            skew_part = Rerr-Rerr';

            sin_angle = norm([ ...
                skew_part(3,2), ...
                skew_part(1,3), ...
                skew_part(2,1)])/2;

            cos_angle = ...
                (trace(Rerr)-1)/2;

            re = atan2d(sin_angle,cos_angle);

            %% Save all trials

            row = row+1;

            DesignID(row) = d;
            PoseID(row) = pose_id;
            RepeatID(row) = rep;

            Converged(row) = success;
            Iterations(row) = iters;

            PositionError_mm(row) = pe;
            OrientationError_deg(row) = re;

            ResidualNorm_mm(row) = residual;

        end
    end
end

assert(row==N_total);
assert(N_total==5760);

%% Step 7 — Individual trial table

T_trials = table( ...
    DesignID,PoseID,RepeatID, ...
    Converged,Iterations, ...
    PositionError_mm, ...
    OrientationError_deg, ...
    ResidualNorm_mm);

%% Step 8 — Summarise all eight designs

Tests = zeros(N_design,1);
ConvergedCount = zeros(N_design,1);

PositionRMSE_mm = nan(N_design,1);
OrientationRMSE_deg = nan(N_design,1);

P95Position_mm = nan(N_design,1);
P95Orientation_deg = nan(N_design,1);

MaxPosition_mm = nan(N_design,1);
MaxOrientation_deg = nan(N_design,1);

MedianIterations = nan(N_design,1);
MedianResidual_mm = nan(N_design,1);

for d = 1:N_design

    mask = DesignID==d;

    pe = PositionError_mm(mask);
    re = OrientationError_deg(mask);

    Tests(d) = sum(mask);

    ConvergedCount(d) = ...
        sum(Converged(mask));

    PositionRMSE_mm(d) = ...
        sqrt(mean(pe.^2));

    OrientationRMSE_deg(d) = ...
        sqrt(mean(re.^2));

    pe_sorted = sort(pe);
    re_sorted = sort(re);

    k95 = ceil(0.95*numel(pe));

    P95Position_mm(d) = pe_sorted(k95);
    P95Orientation_deg(d) = re_sorted(k95);

    MaxPosition_mm(d) = max(pe);
    MaxOrientation_deg(d) = max(re);

    MedianIterations(d) = ...
        median(Iterations(mask));

    MedianResidual_mm(d) = ...
        median(ResidualNorm_mm(mask));

end

ConvergenceRate = ...
    100*ConvergedCount./Tests;

T_summary = table( ...
    Design,PairID,Version, ...
    Tests,ConvergedCount,ConvergenceRate, ...
    PositionRMSE_mm,OrientationRMSE_deg, ...
    P95Position_mm,P95Orientation_deg, ...
    MaxPosition_mm,MaxOrientation_deg, ...
    MedianIterations,MedianResidual_mm);

fprintf('\n====================================\n');
fprintf('E2 Matched Estimation Results\n');
fprintf('====================================\n');

disp(T_summary);

%% Step 9 — Matched improvements

PairName = pair_names;

PositionRMSE_Baseline = ...
    PositionRMSE_mm(1:2:end);

PositionRMSE_E2 = ...
    PositionRMSE_mm(2:2:end);

OrientationRMSE_Baseline = ...
    OrientationRMSE_deg(1:2:end);

OrientationRMSE_E2 = ...
    OrientationRMSE_deg(2:2:end);

PositionImprovementPercent = ...
    100*(1- ...
    PositionRMSE_E2./PositionRMSE_Baseline);

OrientationImprovementPercent = ...
    100*(1- ...
    OrientationRMSE_E2./OrientationRMSE_Baseline);

T_matched = table( ...
    PairName, ...
    PositionRMSE_Baseline,PositionRMSE_E2, ...
    PositionImprovementPercent, ...
    OrientationRMSE_Baseline,OrientationRMSE_E2, ...
    OrientationImprovementPercent);

fprintf('\n====================================\n');
fprintf('E2 Matched Improvement Summary\n');
fprintf('====================================\n');

disp(T_matched);

%% Step 10 — Compare by pose subset

subset_names = [ ...
    "Core";
    "Off-grid A";
    "Off-grid B"];

subset_ids = { ...
    core_ids, ...
    offgrid_A_ids, ...
    offgrid_B_ids};

SubsetDesign = strings(3*N_design,1);
Subset = strings(3*N_design,1);

SubsetPositionRMSE = nan(3*N_design,1);
SubsetOrientationRMSE = nan(3*N_design,1);

k = 0;

for d = 1:N_design

    for s = 1:3

        k = k+1;

        mask = DesignID==d & ...
            ismember(PoseID,subset_ids{s});

        pe = PositionError_mm(mask);
        re = OrientationError_deg(mask);

        assert(numel(pe)==12*N_repeat);

        SubsetDesign(k) = Design(d);
        Subset(k) = subset_names(s);

        SubsetPositionRMSE(k) = ...
            sqrt(mean(pe.^2));

        SubsetOrientationRMSE(k) = ...
            sqrt(mean(re.^2));

    end
end

T_subsets = table( ...
    SubsetDesign,Subset, ...
    SubsetPositionRMSE, ...
    SubsetOrientationRMSE);

fprintf('\n--- E2 Results by Pose Subset ---\n');

disp(T_subsets);

%% Step 11 — Verification

assert(all(Tests==720));

assert(all(isfinite(PositionError_mm)));
assert(all(isfinite(OrientationError_deg)));
assert(all(isfinite(ResidualNorm_mm)));

assert(all(PositionError_mm>=0));
assert(all(OrientationError_deg>=0));

fprintf('\nTotal trials: %d\n',N_total);

fprintf('Total converged: %d / %d\n', ...
    sum(Converged),N_total);

fprintf('PASS: Matched trial counts verified.\n');

%% Step 12 — Plot matched improvements

figure('Color','w', ...
    'Name','E2 Matched Pose Estimation', ...
    'Position',[100 100 1150 500]);

subplot(1,2,1);

bar([PositionRMSE_Baseline,PositionRMSE_E2]);

xticks(1:N_pair);
xticklabels(pair_names);
xtickangle(20);

legend({'Baseline','E2'}, ...
    'Location','best');

ylabel('Position RMSE (mm)');
title('Matched Position Comparison');
grid on;

subplot(1,2,2);

bar([OrientationRMSE_Baseline, ...
     OrientationRMSE_E2]);

xticks(1:N_pair);
xticklabels(pair_names);
xtickangle(20);

legend({'Baseline','E2'}, ...
    'Location','best');

ylabel('Orientation RMSE (deg)');
title('Matched Orientation Comparison');
grid on;

%% Step 13 — Save all results

save( ...
    'B5_4_E2_matched_pose_estimation.mat', ...
    'T_trials','T_summary', ...
    'T_matched','T_subsets', ...
    'Design','PairID','Version', ...
    'designs','pose_ids', ...
    'noise_samples','noise_sd_mm', ...
    'solver','N_repeat');

writetable(T_summary, ...
    'B5_4_E2_matched_pose_summary.csv');

writetable(T_matched, ...
    'B5_4_E2_matched_improvements.csv');

writetable(T_subsets, ...
    'B5_4_E2_matched_pose_subsets.csv');

fprintf('\nE2 Lesson 2.10 completed.\n');

%% ===========================================
% Local Function 1 — Cable length prediction
%% ===========================================

function L = predict_lengths(A,r,P,R)

    S = (R*r')';
    B = S+P;

    L = vecnorm(A-B,2,2);

end

%% ===========================================
% Local Function 2 — Measurement Jacobian
%% ===========================================

function H = length_jacobian(A,r,P,R)

    S = (R*r')';
    D = A-(S+P);

    L = vecnorm(D,2,2);

    assert(all(L>1e-12));

    u = D./L;

    H = zeros(6,6);

    for i = 1:6

        H(i,:) = [ ...
            -u(i,:), ...
            cross(u(i,:),S(i,:))];

    end

end

%% ===========================================
% Local Function 3 — SO(3) rotation increment
%% ===========================================

function Rd = rotation_increment(w)

    theta = norm(w);

    W = [ ...
        0 -w(3) w(2);
        w(3) 0 -w(1);
        -w(2) w(1) 0];

    if theta<1e-10

        Rd = eye(3)+W+0.5*(W*W);

    else

        Rd = eye(3) + ...
            sin(theta)/theta*W + ...
            (1-cos(theta))/theta^2*(W*W);

    end

end

%% ===========================================
% Local Function 4 — Damped Gauss-Newton
%% ===========================================

function [P,R,success,residual,iterations] = ...
    estimate_pose(A,r,L_meas,P0,R0,solver)

    P = P0;
    R = R0;

    success = false;
    iterations = 0;

    for iter = 1:solver.max_iterations

        iterations = iter;

        L_pred = predict_lengths(A,r,P,R);

        e = L_meas-L_pred;

        current_residual = norm(e);

        if current_residual<solver.residual_tol_mm

            success = true;
            break;

        end

        H = length_jacobian(A,r,P,R);

        Hs = H*solver.scale;

        dy = (Hs'*Hs + ...
            solver.lambda^2*eye(6)) \ ...
            (Hs'*e);

        dq = solver.scale*dy;

        dp = dq(1:3)';
        dw = dq(4:6)';

        %% Limit translation and rotation steps

        np = norm(dp);
        nw = norm(dw);

        if np>solver.max_dp
            dp = dp*solver.max_dp/np;
        end

        if nw>solver.max_dw
            dw = dw*solver.max_dw/nw;
        end

        %% Backtracking line search

        alpha = 1;
        accepted = false;

        for bt = 1:solver.max_backtracks

            Pt = P+alpha*dp;

            Rt = rotation_increment( ...
                alpha*dw)*R;

            trial_e = L_meas- ...
                predict_lengths(A,r,Pt,Rt);

            if norm(trial_e)<current_residual

                P = Pt;
                R = Rt;

                accepted = true;
                break;

            end

            alpha = alpha/2;

        end

        if ~accepted
            break;
        end

    end

    residual = norm( ...
        L_meas-predict_lengths(A,r,P,R));

    if residual<solver.residual_tol_mm
        success = true;
    end

end
