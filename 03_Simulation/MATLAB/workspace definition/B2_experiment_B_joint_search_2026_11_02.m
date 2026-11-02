%% B2.2.2 Experiment B
% Variable Anchors + Variable Attachments
% Six-cable configuration comparison

clear; clc; close all;
rng(42);
% 只要你写了 rng(42)，无论在你的电脑上运行还是在别人电脑上运行
% MATLAB 每次产生的"伪随机数序列"都是一模一样的。

%% 1. Load existing geometry and Experiment A
load('B1_geometry_baseline.mat','geometry');
load('B2_6cable_experiment_A.mat','config6');

A_candidates = geometry.anchor_candidates;
r_candidates = geometry.attachment_candidates_body;
rb = geometry.balloon_radius;

N_trials = 20000;
n = 6;
tol = 1e-9;

P = [0;0;0];
R = eye(3);

S = diag([1 1 1 1/rb 1/rb 1/rb]);
%无量纲化操作 

%% 2. Recalculate Experiment A
A_A = config6.A;
r_A = config6.r;

B_A = (R*r_A.' + P).';
D_A = A_A-B_A;
L_A = vecnorm(D_A,2,2);
U_A = D_A./L_A;

H_A = zeros(n,6);

for i = 1:n
    u = U_A(i,:).';
    s = R*r_A(i,:).';

    H_A(i,:) = [-u.',cross(u,s).'];
end

Hs_A = H_A*S;
%无量纲化操作 
cond_A = cond(Hs_A);
sigma_A = min(svd(Hs_A));

% Check Experiment A initial outward routing
outward_A = sum(D_A.*(B_A-P.'),2);
assert(all(outward_A>=-tol));

%% 3. Initialise Experiment B search
best_cond_B = inf;
best_A_B = [];
best_r_B = [];
best_H_B = [];
best_L_B = [];

count_routing = 0;
count_rank = 0;

%% 4. Joint random search
for k = 1:N_trials

    % Select six unique anchors
    idx_A = randperm(size(A_candidates,1),n);
    A_test = A_candidates(idx_A,:);

    % Select six unique attachments
    idx_r = randperm(size(r_candidates,1),n);
    r_test = r_candidates(idx_r,:);

    % Each row defines one cable pair

    B_test = (R*r_test.'+P).';

    D_test = A_test-B_test;
    L_test = vecnorm(D_test,2,2);

    if any(L_test<tol)
        continue;
    end

    % Straight cable must not enter the balloon
    outward = sum(D_test.*(B_test-P.'),2);

    if any(outward < -tol)
        continue;
    end

    count_routing = count_routing+1;

    %% Measurement Jacobian
    U_test = D_test./L_test;
    H_test = zeros(n,6);

    for i = 1:n
        u = U_test(i,:).';
        s = R*r_test(i,:).';

        H_test(i,:) = [-u.',cross(u,s).'];
    end

    Hs_test = H_test*S;
    singular_values = svd(Hs_test);

    if rank(Hs_test)<6
        continue;
    end

    count_rank = count_rank+1;

    current_cond = ...
        max(singular_values)/min(singular_values);

    %% Record best random candidate
    if current_cond < best_cond_B
        best_cond_B = current_cond;
        best_A_B = A_test;
        best_r_B = r_test;
        best_H_B = Hs_test;
        best_L_B = L_test;
    end
end

%% 5. Report results
fprintf('\n--- B2.2 Experiment B ---\n');

fprintf('Total trials: %d\n',N_trials);
fprintf('Routing passed: %d\n',count_routing);
fprintf('Rank passed: %d\n',count_rank);

fprintf('\nExperiment A condition: %.4f\n',cond_A);
fprintf('Experiment A sigma_min: %.6f\n',sigma_A);

fprintf('\nBest random B condition: %.4f\n',best_cond_B);

if isempty(best_A_B)
    fprintf('No valid random B configuration found.\n');
else
    sigma_B = min(svd(best_H_B));

    fprintf('Best random B sigma_min: %.6f\n',sigma_B);

    fprintf('\nSelected Anchors (mm):\n');
    disp(best_A_B);

    fprintf('Selected Attachments (mm):\n');
    disp(best_r_B);

    fprintf('Cable lengths (mm):\n');
    disp(best_L_B.');

    %% 6. Compare with Experiment A
    % Experiment B's design space also includes
    % the already feasible Experiment A configuration.

    if best_cond_B < cond_A
        winner = 'B - Joint search';
        A_final = best_A_B;
        r_final = best_r_B;
    else
        winner = 'A - Fixed anchors';
        A_final = A_A;
        r_final = r_A;
    end

    fprintf('\nBest available configuration: %s\n',winner);
    fprintf('Best available condition: %.4f\n', ...
        min(best_cond_B,cond_A));

    %% 7. Save results
    resultB.A = best_A_B;
    resultB.r = best_r_B;
    resultB.H_scaled = best_H_B;
    resultB.condition = best_cond_B;
    resultB.sigma_min = sigma_B;
    resultB.lengths = best_L_B;
    resultB.routing_passed = count_routing;
    resultB.rank_passed = count_rank;
    resultB.trials = N_trials;

    resultB.best_available_A = A_final;
    resultB.best_available_r = r_final;
    resultB.winner = winner;

    save('B2_experiment_B_results.mat','resultB');
end

