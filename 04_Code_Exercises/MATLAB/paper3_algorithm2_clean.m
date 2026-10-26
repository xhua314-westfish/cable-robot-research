%% Paper 3 - Algorithm 2: WCC Feasible Anchor Regions
% Reference: Cheng, Lau & Hughes (2025), Table 1 and Algorithms 1-2.
% Purpose: Reproduce eight-pose WCC intersection and compare seven anchors.
% Scope: Paper reproduction, NOT balloon pose-sensing validation.
% Convention: D = B_world - A; Jbar = [D; (R*r) x D].
% Geometry uses the consistent length units of Paper 3 Table 1.

clc;
clear;
close all;

%% 1. Robot geometry and sampled platform poses
% Anchor coordinates in the world frame, one cable per column (3 x 7).
A = [ 0     1     1     0     0.5   1     0;
      0     0     1     1     0     1     1;
      1     1     1     1     0     0     0];

% Attachment coordinates in the platform frame, one cable per column (3 x 7).
r = [-0.15  0.15  0.15 -0.15  0     0.15 -0.15;
     -0.10 -0.10  0.10  0.10 -0.10  0.10  0.10;
      0.05  0.05  0.05  0.05 -0.05 -0.05 -0.05];

% Orientation is fixed: only translation changes in the eight-pose example.
R = eye(3);
r_world = R*r;

% Sample the eight corners of the translational pose cube.
[X, Y, Z] = ndgrid([0.4, 0.6], [0.4, 0.6], [0.4, 0.6]);
P_all = [X(:), Y(:), Z(:)];
q_all = [P_all, zeros(size(P_all, 1), 3)];

% Cache system dimensions for subsequent loops.
nPoses = size(q_all, 1);
nCables = size(A, 2);

% Inspect the ordered list of platform poses.
disp('Eight platform poses:');
disp(q_all);

% Figure 1: visualize sampled platform center positions.
fig = figure('Name', 'Eight platform poses');
scatter3(P_all(:,1), P_all(:,2), P_all(:,3), 80, 'filled');
xlabel('x');
ylabel('y');
zlabel('z');
title('Paper 3 - Eight platform poses');
axis equal;
grid on;
view(3);
exportgraphics(fig, 'paper3_eight_platform_poses.png', 'Resolution', 220);

%% 2. Common candidate-anchor grid
% Use the same spatial sampling box for all target cables.
ux_grid = -0.5:0.05:1.5;
uy_grid = -0.5:0.05:1.5;
uz_grid = -0.5:0.05:1.5;

% Enumerate candidate anchor coordinates in the world frame (N x 3).
[UX, UY, UZ] = ndgrid(ux_grid, uy_grid, uz_grid);
points = [UX(:), UY(:), UZ(:)];

% A small negative tolerance enforces strictly positive relative tension.
N = size(points, 1);
tol = 1e-9;
fprintf('Candidate anchors per cable: %d\n', N);

%% 3. Cable 7: cumulative intersection over eight poses
% Save per-pose masks and cumulative masks to validate Algorithm 2.
mask_each = false(N, nPoses);
mask_history = false(N, nPoses);
mask_all = true(N, 1);
counts = zeros(nPoses, 1);

for k = 1:nPoses
    % Recalculate moving attachment positions for the current platform pose.
    P = q_all(k, 1:3)';
    B_world = P + r_world;

    % Build the fixed 6 x 6 wrench matrix using cables 1-6.
    D_fixed = B_world(:,1:6) - A(:,1:6);
    M_fixed = cross(r_world(:,1:6), D_fixed, 1);
    J_fixed = [D_fixed; M_fixed];
    assert(rank(J_fixed) == 6, 'Singular fixed basis at pose %d', k);

    % Evaluate cable 7's variable wrench at every candidate anchor.
    D7 = B_world(:,7) - points';
    M7 = cross(repmat(r_world(:,7), 1, N), D7, 1);
    J7 = [D7; M7];

    % Each column of H contains six coefficients for one candidate anchor.
    H = J_fixed \ J7;
    mask_pose = all(H < -tol, 1)';

    % Keep only candidates feasible at every evaluated pose so far.
    mask_each(:,k) = mask_pose;
    mask_all = mask_all & mask_pose;
    mask_history(:,k) = mask_all;
    counts(k) = nnz(mask_all);

    % Display the cumulative remaining candidate count.
    fprintf('Pose %d: %d cumulative feasible points\n', k, counts(k));
end

% Extract candidates satisfying all eight pose constraints.
feasible_points = points(mask_all, :);
fprintf('Cable 7 final: %d / %d (%.2f%%)\n', ...
    nnz(mask_all), N, 100*mean(mask_all));

% Verify intersection monotonicity and agreement of both mask methods.
assert(all(diff(counts) <= 0), 'Cumulative point count increased');
assert(isequal(mask_all, all(mask_each, 2)), 'Intersection masks disagree');
assert(~isempty(feasible_points), 'Cable 7 final region is empty');

% Figure 2: show cable 7's final multi-pose feasible anchor region.
fig = figure('Name', 'Cable 7 multi-pose region');
scatter3(feasible_points(:,1), feasible_points(:,2), ...
    feasible_points(:,3), 5, 'filled');
xlabel('u_x');
ylabel('u_y');
zlabel('u_z');
title('Paper 3 - Cable 7 eight-pose WCC intersection');
axis equal;
grid on;
view(3);
exportgraphics(fig, 'paper3_cable7_multipose_region.png', 'Resolution', 220);

% Figure 3: visualize how many candidate anchors remain after each pose.
fig = figure('Name', 'Feasible counts by pose');
plot(1:nPoses, counts, '-o', 'LineWidth', 1.5);
xlabel('Number of evaluated poses');
ylabel('Remaining candidate anchors');
title('Paper 3 - Algorithm 2 feasible point count');
xticks(1:nPoses);
grid on;
exportgraphics(fig, 'paper3_counts_by_pose.png', 'Resolution', 220);

%% 4. Cable 7: initial grid and eight cumulative point clouds
% Figure 4: iteration 0 is the full candidate grid; 1-8 are filtered sets.
fig = figure('Name', 'Iterations 0-8', 'Position', [60 60 1450 900]);
tiledlayout(3, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

for k = 0:nPoses
    % Select either the original grid or a cumulative feasible point cloud.
    nexttile;
    if k == 0
        current_points = points;
    else
        current_points = points(mask_history(:,k), :);
    end

    % Use matching axis limits to compare how the region contracts.
    scatter3(current_points(:,1), current_points(:,2), ...
        current_points(:,3), 2, 'filled');
    title(sprintf('Iteration %d: %d points', k, size(current_points,1)));
    xlabel('u_x');
    ylabel('u_y');
    zlabel('u_z');
    xlim([-0.5, 1.5]);
    ylim([-0.5, 1.5]);
    zlim([-0.5, 1.5]);
    axis equal;
    grid on;
    view(3);
end

% Save the Figure 3-style iteration comparison.
sgtitle('Paper 3 - Cable 7: initial region and eight-pose intersection');
exportgraphics(fig, 'paper3_fig3_iterations_0to8.png', 'Resolution', 220);

%% 5. All seven cables: single-pose feasible regions (Lesson 5.4)
% Use Section 3.1's reference pose, not the first pose in the eight-pose set.
P_single = [0.65; 0.5; 0.6];
B_single = P_single + r_world;

% Construct the seven original wrench columns at the reference pose.
D_single = B_single - A;
M_single = cross(r_world, D_single, 1);
Jbar_single = [D_single; M_single];

% Store one single-pose feasibility mask per target anchor.
mask_single = false(N, nCables);
single_counts = zeros(nCables, 1);

for target = 1:nCables
    % The other six anchors are held fixed while this anchor varies.
    other = setdiff(1:nCables, target);
    J_other = Jbar_single(:,other);
    assert(rank(J_other) == 6, 'Singular single-pose basis for cable %d', target);

    % Calculate variable target cable wrenches for all anchor candidates.
    D_target = B_single(:,target) - points';
    M_target = cross(repmat(r_world(:,target), 1, N), D_target, 1);
    J_target = [D_target; M_target];

    % Solve the six inequalities and store the feasible point count.
    H = J_other \ J_target;
    mask_single(:,target) = all(H < -tol, 1)';
    single_counts(target) = nnz(mask_single(:,target));
end

% Report and export single-pose results.
single_pct = 100 * single_counts / N;
single_table = table((1:nCables)', single_counts, single_pct, ...
    'VariableNames', {'Cable', 'FeasiblePoints', 'FeasiblePercent'});
disp('Single-pose results at P = [0.65, 0.5, 0.6]:');
disp(single_table);
writetable(single_table, 'paper3_single_pose_cable_fractions.csv');

% Figure 5 (previously missing): seven single-pose anchor regions.
fig = figure('Name', 'All cables - single pose', 'Position', [60 60 1450 760]);
tiledlayout(2, 4, 'TileSpacing', 'compact', 'Padding', 'compact');

for target = 1:nCables
    % Display each target's conditionally feasible anchor region.
    nexttile;
    p = points(mask_single(:,target), :);
    scatter3(p(:,1), p(:,2), p(:,3), 3, 'filled');
    title(sprintf('Cable %d - %.2f%%', target, single_pct(target)));
    xlabel('u_x');
    ylabel('u_y');
    zlabel('u_z');
    xlim([-0.5, 1.5]);
    ylim([-0.5, 1.5]);
    zlim([-0.5, 1.5]);
    axis equal;
    grid on;
    view(3);
end

% Save the seven-panel single-pose comparison.
sgtitle('Paper 3 - Individual anchor regions at one platform pose');
exportgraphics(fig, 'paper3_all_cable_regions_single_pose.png', 'Resolution', 220);

%% 6. All seven cables: eight-pose intersection and approximate PRI
% Compute each target's multi-pose region with the remaining six anchors fixed.
mask_multi = false(N, nCables);
final_counts = zeros(nCables, 1);

for target = 1:nCables
    % Select the six fixed cables and initialize the target's intersection.
    other = setdiff(1:nCables, target);
    mask_target = true(N, 1);

    for k = 1:nPoses
        % Update attachments to the current platform position.
        P = q_all(k,1:3)';
        B_world = P + r_world;

        % Assemble the fixed cable wrench matrix and check its rank.
        D_fixed = B_world(:,other) - A(:,other);
        M_fixed = cross(r_world(:,other), D_fixed, 1);
        J_fixed = [D_fixed; M_fixed];

        if rank(J_fixed) < 6
            % A singular fixed basis invalidates this WCC construction.
            mask_target(:) = false;
            warning('Singular basis: cable %d, pose %d', target, k);
            break;
        end

        % Compute target wrenches and test all six WCC inequalities.
        D_target = B_world(:,target) - points';
        M_target = cross(repmat(r_world(:,target), 1, N), D_target, 1);
        J_target = [D_target; M_target];
        H = J_fixed \ J_target;

        % Intersect the target's feasible masks over platform poses.
        mask_target = mask_target & all(H < -tol, 1)';
    end

    % Store final candidate masks and counts for this target cable.
    mask_multi(:,target) = mask_target;
    final_counts(target) = nnz(mask_target);
end

% Approximate PRI by a grid-point fraction in a shared sampling box.
approx_PRI = final_counts / N;
multi_table = table((1:nCables)', final_counts, approx_PRI, ...
    'VariableNames', {'Cable', 'FeasiblePoints', 'ApproxPRI'});
disp('Eight-pose discrete PRI results:');
disp(multi_table);
writetable(multi_table, 'paper3_multi_pose_approx_pri.csv');

% Both implementations must give the same final count for cable 7.
assert(final_counts(7) == counts(end), 'Cable 7 counts do not match');

% Figure 6: compare the seven multi-pose anchor regions.
fig = figure('Name', 'All cables - eight poses', 'Position', [60 60 1450 760]);
tiledlayout(2, 4, 'TileSpacing', 'compact', 'Padding', 'compact');

for target = 1:nCables
    % Display the eight-pose region for each individual target cable.
    nexttile;
    p = points(mask_multi(:,target), :);
    scatter3(p(:,1), p(:,2), p(:,3), 3, 'filled');
    title(sprintf('Cable %d - %.2f%%', target, 100*approx_PRI(target)));
    xlabel('u_x');
    ylabel('u_y');
    zlabel('u_z');
    xlim([-0.5, 1.5]);
    ylim([-0.5, 1.5]);
    zlim([-0.5, 1.5]);
    axis equal;
    grid on;
    view(3);
end

% Save the seven-panel multi-pose comparison.
sgtitle('Paper 3 - Individual anchor regions across eight poses');
exportgraphics(fig, 'paper3_all_cable_regions_multi_pose.png', 'Resolution', 220);

%% 7. Final WCC numerical checks
% Validate the original seven-anchor configuration at all eight poses.
for k = 1:nPoses
    P = q_all(k,1:3)';
    B_world = P + r_world;

    % Build the complete unnormalized wrench matrix at this pose.
    D = B_world - A;
    Jbar = [D; cross(r_world, D, 1)];
    assert(rank(Jbar(:,1:6)) == 6, 'Singular original basis at pose %d', k);

    % A positive null vector exists when all six coefficients are negative.
    h = Jbar(:,1:6) \ Jbar(:,7);
    assert(all(h < -tol), 'Original anchor WCC failed at pose %d', k);
    fprintf('Original anchors: pose %d WCC = 1\n', k);
end

% Select reproducible held-out anchors from cable 7's retained point cloud.
rng(42);
num_check = min(20, size(feasible_points, 1));
idx = randperm(size(feasible_points, 1), num_check);
test_points = feasible_points(idx, :);
max_h = -inf;

for k = 1:nPoses
    % Reconstruct the six fixed wrench columns independently of stored masks.
    P = q_all(k,1:3)';
    B_world = P + r_world;
    D_fixed = B_world(:,1:6) - A(:,1:6);
    J_fixed = [D_fixed; cross(r_world(:,1:6), D_fixed, 1)];

    for j = 1:num_check
        % Re-evaluate cable 7's wrench at a sampled retained anchor.
        D7 = B_world(:,7) - test_points(j,:)';
        J7 = [D7; cross(r_world(:,7), D7)];
        h = J_fixed \ J7;

        % Verify positive-tension feasibility and track the closest boundary.
        max_h = max(max_h, max(h));
        assert(all(h < -tol), 'Retained point failed WCC');
    end
end

% Display the strongest (least negative) tested constraint coefficient.
fprintf('Independent random-point maximum h: %.6f\n', max_h);
fprintf('All defined checks passed.\n');
