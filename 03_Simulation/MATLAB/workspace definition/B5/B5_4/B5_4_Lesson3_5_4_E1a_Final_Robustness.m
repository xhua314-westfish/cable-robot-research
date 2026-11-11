
%% B5.4 Lesson 3.5.4
% E1a Final Robustness Verification
%
% Research Question:
% Which repaired configuration is more robust:
% C4 t=0.450 or C4 t=0.470?
%
% Test:
% 1. Nominal 539 poses
% 2. Six anchors with +/-0.005 installation offsets
% 3. Minimum outward angle and cable distance
% 4. Worst Jacobian singular value
%
% 注意：
% 这里只测试单根Anchor独立扰动。
% 不能代替多根Anchor同时存在安装误差的验证。

clear; clc; close all;

%% Step 1: Load saved 539-pose dataset

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','settings');

load('B5_4_E1a_C4_targeted_repair.mat', ...
    't0','P_eval','R_eval','rail_ids');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

r = best_configs(2).r;

rail_ids = rail_ids(:)';

N_pose = size(P_eval,1);

assert(N_pose==539);
assert(rail_ids(4)==8);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2: Define two candidate designs

tA = t0;
tB = t0;

tA(4) = 0.450;
tB(4) = 0.470;

t_designs = [tA;tB];

design_names = [
    "Sensing t4=0.450";
    "Robust t4=0.470"
];

N_design = 2;

%% Step 3: Define installation perturbations

delta_t = 0.005;

perturbations = zeros(12,6);
changed_cable = zeros(12,1);
direction = zeros(12,1);

n = 0;

for i = 1:6

    for sign_value = [-1 1]

        n = n+1;

        perturbations(n,i) = ...
            sign_value*delta_t;

        changed_cable(n) = i;
        direction(n) = sign_value;

    end

end

%% Step 4: Prepare results

NominalPass = zeros(N_design,1);
NominalRank6 = zeros(N_design,1);

WorstSigma = nan(N_design,1);

MinOutwardAngle_deg = nan(N_design,1);
MinCableDistance_mm = nan(N_design,1);

WeakestCable = zeros(N_design,1);
WeakestPose = zeros(N_design,1);

PerturbationPass = zeros(N_design,1);
WorstPerturbationGeometry = zeros(N_design,1);

MinPerturbedOutwardAngle_deg = ...
    nan(N_design,1);

MinPerturbedCableDistance_mm = ...
    nan(N_design,1);

perturbation_records = cell(N_design,1);

fprintf('\n--- B5.4 Lesson 3.5.4 ---\n');

%% Step 5: Evaluate candidates

for d = 1:N_design

    fprintf('\n====================================\n');
    fprintf('%s\n',design_names(d));
    fprintf('====================================\n');

    t = t_designs(d,:);

    A = build_anchors( ...
        t,rail_ids,rail_start,rail_end);

    %% 5.1 Nominal 539-pose evaluation

    g = evaluate_poses( ...
        A,r,P_eval,R_eval,settings);

    NominalPass(d) = sum(g.geometry_safe);

    NominalRank6(d) = sum( ...
        g.geometry_safe & g.rank_all==6);

    assert(NominalPass(d)==539);
    assert(NominalRank6(d)==539);

    WorstSigma(d) = min(g.sigma_min_all);

    [MinOutwardAngle_deg(d),idx] = ...
        min(g.angle_margin_deg(:));

    [pose_id,cable_id] = ind2sub( ...
        size(g.angle_margin_deg),idx);

    WeakestPose(d) = pose_id;
    WeakestCable(d) = cable_id;

    MinCableDistance_mm(d) = ...
        min(g.distances(:));

    fprintf('Nominal geometry: %d / 539\n', ...
        NominalPass(d));

    fprintf('Worst sigma: %.6f\n',WorstSigma(d));

    fprintf('Minimum outward angle: %.6f deg\n', ...
        MinOutwardAngle_deg(d));

    fprintf('Limiting pose: %d\n',WeakestPose(d));

    fprintf('Limiting cable: C%d\n',WeakestCable(d));

    fprintf('Minimum cable distance: %.4f mm\n', ...
        MinCableDistance_mm(d));

    %% 5.2 Installation perturbation evaluation

    trial_pass = false(12,1);
    trial_geometry = zeros(12,1);
    trial_rank6 = zeros(12,1);

    trial_min_angle = nan(12,1);
    trial_min_distance = nan(12,1);

    for j = 1:12

        trial_t = t+perturbations(j,:);

        % 不能通过截断掩盖越轨
        if any(trial_t<0 | trial_t>1)

            fprintf( ...
                'C%d dt=%+.4f: OFF-RAIL\n', ...
                changed_cable(j), ...
                perturbations(j,changed_cable(j)));

            continue;

        end

        A_trial = build_anchors( ...
            trial_t,rail_ids,rail_start,rail_end);

        g_trial = evaluate_poses( ...
            A_trial,r,P_eval,R_eval,settings);

        trial_geometry(j) = ...
            sum(g_trial.geometry_safe);

        trial_rank6(j) = sum( ...
            g_trial.geometry_safe & ...
            g_trial.rank_all==6);

        trial_min_angle(j) = ...
            min(g_trial.angle_margin_deg(:));

        trial_min_distance(j) = ...
            min(g_trial.distances(:));

        trial_pass(j) = ...
            trial_geometry(j)==539 && ...
            trial_rank6(j)==539;

        fprintf( ...
            'C%d dt=%+.4f: %d/539 | angle=%+.4f\n', ...
            changed_cable(j), ...
            perturbations(j,changed_cable(j)), ...
            trial_geometry(j),trial_min_angle(j));

    end

    PerturbationPass(d) = sum(trial_pass);

    WorstPerturbationGeometry(d) = ...
        min(trial_geometry);

    MinPerturbedOutwardAngle_deg(d) = ...
        min(trial_min_angle);

    MinPerturbedCableDistance_mm(d) = ...
        min(trial_min_distance);

    perturbation_records{d} = table( ...
        changed_cable,direction, ...
        trial_geometry,trial_rank6, ...
        trial_min_angle,trial_min_distance, ...
        trial_pass, ...
        'VariableNames',{ ...
        'Cable','Direction', ...
        'GeometryPass','Rank6Pass', ...
        'MinAngle_deg','MinDistance_mm', ...
        'Passed'});

end

%% Step 6: Comparison table

T_final = table( ...
    design_names,NominalPass,NominalRank6, ...
    WorstSigma,MinOutwardAngle_deg, ...
    MinCableDistance_mm, ...
    WeakestCable,WeakestPose, ...
    PerturbationPass, ...
    WorstPerturbationGeometry, ...
    MinPerturbedOutwardAngle_deg, ...
    MinPerturbedCableDistance_mm, ...
    'VariableNames',{ ...
    'Design','NominalPass','NominalRank6', ...
    'WorstSigma','MinAngle_deg','MinDistance_mm', ...
    'WeakestCable','WeakestPose', ...
    'PerturbationPass','WorstPerturbationGeometry', ...
    'MinPerturbedAngle_deg', ...
    'MinPerturbedDistance_mm'});

disp(' ');
disp('--- E1a Final Robustness Comparison ---');
disp(T_final);

fprintf('\n--- Perturbation Details ---\n');

for d = 1:N_design

    fprintf('\n%s\n',design_names(d));

    disp(perturbation_records{d});

end

%% Step 7: Visualisation

figure('Color','w', ...
    'Name','E1a Final Robustness Comparison', ...
    'Position',[100 100 1150 700]);

tiledlayout(2,2,'TileSpacing','compact');

nexttile;
bar(WorstSigma);
xticks(1:2);
xticklabels({'t4=.450','t4=.470'});
ylabel('Worst scaled sigma_{min}');
title('Sensing Quality');
grid on;

nexttile;
bar(MinOutwardAngle_deg);
xticks(1:2);
xticklabels({'t4=.450','t4=.470'});
ylabel('Minimum outward angle (deg)');
title('Nominal Outward Margin');
grid on;

nexttile;
bar(PerturbationPass);
xticks(1:2);
xticklabels({'t4=.450','t4=.470'});
ylabel('Passing tests / 12');
title('Installation Robustness');
ylim([0 13]);
grid on;

nexttile;
bar(MinPerturbedOutwardAngle_deg);
xticks(1:2);
xticklabels({'t4=.450','t4=.470'});
ylabel('Minimum outward angle (deg)');
title('Worst Perturbed Outward Margin');
grid on;

%% Step 8: Save

save('B5_4_E1a_final_robustness.mat', ...
    'T_final','t_designs','design_names', ...
    'perturbation_records','perturbations', ...
    'delta_t','settings','rail_ids','r', ...
    'P_eval','R_eval');

fprintf('\nB5.4 Lesson 3.5.4 completed.\n');

%% ============================================
% Local function 1: Build Anchor coordinates
%% ============================================
function A = build_anchors( ...
    t,rail_ids,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        rid = rail_ids(i);

        A(i,:) = rail_start(rid,:) + ...
            t(i)*(rail_end(rid,:)-rail_start(rid,:));

    end

end

%% ============================================
% Local function 2: Common geometry evaluator
%% ============================================
function g = evaluate_poses( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);
    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);

    rank_all = zeros(N,1);
    sigma_min_all = zeros(N,1);

    angle_margin_deg = zeros(N,6);
    distances = zeros(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);

        assert(all(L>1e-9));

        %% Cable-Sphere outward margin

        outward_dot = sum(S.*D,2);

        sine_margin = outward_dot./ ...
            (settings.rb*L);

        sine_margin = max(-1,min(1,sine_margin));

        angle_margin_deg(k,:) = ...
            asind(sine_margin)';

        sphere_safe = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable-Cable distance

        cable_safe = true;

        for j = 1:15

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

            distances(k,j) = dij;

            if dij<=settings.contact_tol
                cable_safe = false;
            end

        end

        geometry_safe(k) = ...
            sphere_safe && cable_safe;

        %% Sensing Jacobian

        u = D./L;
        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [
                -u(i,:), ...
                cross(u(i,:),S(i,:))
            ];

        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        sigma_min_all(k) = sv(end);

        rank_all(k) = sum( ...
            sv>settings.rank_relative_tol*sv(1));

    end

    g.geometry_safe = geometry_safe;

    g.rank_all = rank_all;
    g.sigma_min_all = sigma_min_all;

    g.angle_margin_deg = angle_margin_deg;
    g.distances = distances;

end
