%% A5 - Pointwise Platform Workspace Sampling
% Method-inspired implementation based on Paper 1 (a review).
% Geometry: Paper 3 Table 1, used only as a reproducible numerical model.
% D = B_world - A; all coordinates and length limits use consistent units.
% WCC test is specific to the 6-DOF / 7-cable positive-null-vector case.
% The illustrative length limits are NOT hardware specifications.

clc;
clear;
close all;

%% 1. Fixed robot geometry and simulation parameters
% Each column is a fixed base anchor in the world frame.
A = [ 0     1     1     0     0.5   1      0;
      0     0     1     1     0     1      1;
      1     1     1     1     0     0      0 ];

% Each column is an attachment point in the platform's local frame.
r = [-0.15  0.15  0.15 -0.15  0     0.15 -0.15;
     -0.10 -0.10  0.10  0.10 -0.10  0.10  0.10;
      0.05  0.05  0.05  0.05 -0.05 -0.05 -0.05];

% Use identity orientation for the baseline 3D position-only workspace.
R0 = eye(3);

% Set illustrative cable limits and a strict positive-tension tolerance.
L_min = 0.3;
L_max = 1.0;
tol = 1e-9;

%% 2. Generate a uniform 3D platform-position grid
% All coordinates vary from 0.2 to 0.8 in increments of 0.05.
x_values = 0.2:0.05:0.8;
y_values = 0.2:0.05:0.8;
z_values = 0.2:0.05:0.8;

% ndgrid generates all combinations of the three position coordinates.
[X, Y, Z] = ndgrid(x_values, y_values, z_values);

% Store one candidate world-frame platform position per row.
P_all = [X(:), Y(:), Z(:)];
N = size(P_all, 1);

% Confirm the expected number of candidate positions.
assert(N == 2197, 'Unexpected position-grid size.');
fprintf('Platform position samples = %d\n', N);

% Display the sampled positions before any feasibility tests.
fig = figure('Name', 'A5 - Sampled Positions');
scatter3(P_all(:,1), P_all(:,2), P_all(:,3), 8, 'filled');
xlabel('Platform X');
ylabel('Platform Y');
zlabel('Platform Z');
title('A5 - Sampled Platform Positions');
axis equal;
grid on;
view(3);
exportgraphics(fig, 'a5_01_sampled_positions.png', 'Resolution', 220);

%% 3. Calculate WCC feasibility and cable lengths at zero orientation
% Initialize separate masks to keep physical constraints distinct.
mask_wcc = false(N, 1);
mask_length = false(N, 1);
rank_fixed = zeros(N, 1);
L_all = zeros(N, 7);

% Rotate the local attachment coordinates once because orientation is fixed.
r_world = R0 * r;

for k = 1:N
    % Select the current sampled platform translation.
    P = P_all(k,:)';

    % Transform local attachments into world-frame positions.
    B_world = P + r_world;

    % Form cable vectors from base anchors to moving attachments.
    D = B_world - A;

    % Calculate all seven cable lengths and store them.
    L = vecnorm(D, 2, 1);
    L_all(k,:) = L;

    % Test whether every cable length lies within the assumed limits.
    mask_length(k) = all(L >= L_min & L <= L_max);

    % Construct the unnormalized 6-by-7 wrench matrix.
    M = cross(r_world, D, 1);
    Jbar = [D; M];

    % Separate six fixed-basis columns and the seventh target column.
    J_fixed = Jbar(:,1:6);
    j7 = Jbar(:,7);

    % Reject the pose when the chosen six-column basis is singular.
    rank_fixed(k) = rank(J_fixed);
    if rank_fixed(k) < 6
        continue;
    end

    % Calculate relative self-stress coefficients for the seven cables.
    h = J_fixed \ j7;

    % All six coefficients must be negative for the chosen WCC criterion.
    mask_wcc(k) = all(h < -tol);
end

% Intersect WCC and length masks without changing the original masks.
mask_combined = mask_wcc & mask_length;

% Report sampled counts and the percentage of the candidate grid retained.
fprintf('Total sampled positions = %d\n', N);
fprintf('WCC feasible positions = %d\n', nnz(mask_wcc));
fprintf('WCC infeasible positions = %d\n', nnz(~mask_wcc));
fprintf('WCC feasible fraction = %.2f%%\n', 100*mean(mask_wcc));
fprintf('Rank-deficient positions = %d\n', nnz(rank_fixed < 6));
fprintf('Length feasible = %d\n', nnz(mask_length));
fprintf('Combined feasible = %d\n', nnz(mask_combined));
fprintf('Combined coverage = %.2f%%\n', 100*mean(mask_combined));

% The intersection must be a subset of each individual feasible set.
assert(nnz(mask_combined) <= min(nnz(mask_wcc), nnz(mask_length)));

% Check against previously observed values for this geometry and grid.
assert(nnz(mask_wcc) == 861, 'WCC baseline differs from prior run.');
assert(nnz(mask_length) == 1381, 'Length baseline differs from prior run.');
assert(nnz(mask_combined) == 765, 'Combined baseline differs from prior run.');

%% 4. Visualize single-constraint and combined workspaces
% Plot the WCC feasibility classification on the candidate-position grid.
fig = figure('Name', 'A5 - WCC Workspace');
hold on;
scatter3(P_all(~mask_wcc,1), P_all(~mask_wcc,2), ...
         P_all(~mask_wcc,3), 10, [0.85 0.30 0.30], 'filled');
scatter3(P_all(mask_wcc,1), P_all(mask_wcc,2), ...
         P_all(mask_wcc,3), 12, [0.15 0.55 0.85], 'filled');
xlabel('Platform X');
ylabel('Platform Y');
zlabel('Platform Z');
title('A5 - WCC Feasible Platform Workspace');
legend('WCC Infeasible', 'WCC Feasible', 'Location', 'best');
axis equal;
grid on;
view(3);
hold off;
exportgraphics(fig, 'a5_02_wcc_workspace.png', 'Resolution', 220);

% Plot the intersection of WCC and the illustrative length constraint.
fig = figure('Name', 'A5 - Combined Workspace');
hold on;
scatter3(P_all(~mask_combined,1), P_all(~mask_combined,2), ...
         P_all(~mask_combined,3), 10, [0.85 0.30 0.30], 'filled');
scatter3(P_all(mask_combined,1), P_all(mask_combined,2), ...
         P_all(mask_combined,3), 12, [0.15 0.55 0.85], 'filled');
xlabel('Platform X');
ylabel('Platform Y');
zlabel('Platform Z');
title('A5 - WCC and Cable Length Feasible Workspace');
legend('Excluded', 'Combined Feasible', 'Location', 'best');
axis equal;
grid on;
view(3);
hold off;
exportgraphics(fig, 'a5_03_combined_workspace.png', 'Resolution', 220);

%% 5. Evaluate separate WCC and length constraints for sampled roll angles
% Select three discrete roll angles in degrees and convert them to radians.
roll_degrees = [-10, 0, 10];
roll_values = deg2rad(roll_degrees);
nRoll = numel(roll_values);

% Store independent counts and the combined mask for each sampled angle.
WCC_counts = zeros(nRoll,1);
Length_counts = zeros(nRoll,1);
Combined_counts = zeros(nRoll,1);
roll_masks = false(N,nRoll);

for j = 1:nRoll
    % Construct a local-platform rotation about its X-axis.
    phi = roll_values(j);
    R_roll = [1  0         0;
              0  cos(phi) -sin(phi);
              0  sin(phi)  cos(phi)];

    % Recompute rotated attachment vectors for the selected orientation.
    r_roll = R_roll * r;

    % Start with empty WCC and length masks for this particular roll.
    mask_wcc_roll = false(N,1);
    mask_length_roll = false(N,1);

    for k = 1:N
        % Move the rotated platform to the current sampled position.
        P = P_all(k,:)';
        B_world = P + r_roll;

        % Calculate cable vectors and lengths for this pose.
        D = B_world - A;
        L = vecnorm(D,2,1);

        % Record length feasibility independently of WCC.
        mask_length_roll(k) = all(L >= L_min & L <= L_max);

        % Calculate the wrench matrix using the rotated moment arms.
        M = cross(r_roll,D,1);
        Jbar = [D; M];
        J_fixed = Jbar(:,1:6);

        % Skip WCC evaluation when the six fixed columns lose rank.
        if rank(J_fixed) < 6
            continue;
        end

        % Check the six WCC inequalities for this roll and position.
        h = J_fixed \ Jbar(:,7);
        mask_wcc_roll(k) = all(h < -tol);
    end

    % Intersect the two independent constraints for the current roll.
    roll_masks(:,j) = mask_wcc_roll & mask_length_roll;

    % Save per-angle counts for later comparison and documentation.
    WCC_counts(j) = nnz(mask_wcc_roll);
    Length_counts(j) = nnz(mask_length_roll);
    Combined_counts(j) = nnz(roll_masks(:,j));
end

% Print the three-angle results as a compact comparison table.
roll_table = table(roll_degrees', WCC_counts, Length_counts, ...
                   Combined_counts, 'VariableNames', ...
                   {'RollDeg','WCC','Length','Combined'});
disp(roll_table);

% Requiring every sampled roll gives a common feasible-position mask.
mask_all_roll = all(roll_masks,2);
fprintf('All-roll feasible positions = %d\n', nnz(mask_all_roll));

% Check the nested-set property of the three-roll intersection.
assert(nnz(mask_all_roll) <= min(Combined_counts));

% Zero roll must exactly match the combined fixed-orientation baseline.
assert(isequal(roll_masks(:,2),mask_combined), ...
       'Zero-roll mask does not match the baseline combined mask.');

% Check the previously observed three-roll counts and shared intersection.
assert(isequal(Combined_counts, [623;765;175]), ...
       'Roll feasible counts differ from the previously observed result.');
assert(nnz(mask_all_roll) == 95, ...
       'Roll intersection differs from the previously observed result.');

%% 6. Compare the zero-roll and all-roll feasible workspaces
% Use identical axis limits so the difference is visually meaningful.
fig = figure('Name','A5 - Effect of Roll Constraints', ...
             'Position',[100 100 1100 500]);
tiledlayout(1,2,'TileSpacing','compact');

% Left subplot: positions feasible for zero roll only.
nexttile;
P_zero = P_all(roll_masks(:,2),:);
scatter3(P_zero(:,1), P_zero(:,2), P_zero(:,3), 10, 'filled');
xlabel('Platform X');
ylabel('Platform Y');
zlabel('Platform Z');
title(sprintf('Roll 0 deg: %d points',size(P_zero,1)));
xlim([0.2 0.8]);
ylim([0.2 0.8]);
zlim([0.2 0.8]);
axis equal;
grid on;
view(3);

% Right subplot: positions satisfying all three sampled roll angles.
nexttile;
P_shared = P_all(mask_all_roll,:);
scatter3(P_shared(:,1), P_shared(:,2), P_shared(:,3), 15, 'filled');
xlabel('Platform X');
ylabel('Platform Y');
zlabel('Platform Z');
title(sprintf('All-roll intersection: %d points',size(P_shared,1)));
xlim([0.2 0.8]);
ylim([0.2 0.8]);
zlim([0.2 0.8]);
axis equal;
grid on;
view(3);

% Export the side-by-side comparison as the A5 summary figure.
sgtitle('A5 - Effect of Roll Constraints on Workspace');
exportgraphics(fig,'a5_04_roll_intersection.png','Resolution',220);

%% 7. Record concise machine-readable results
% Save the per-angle WCC, length and combined counts for reproduction.
writetable(roll_table,'a5_roll_constraint_counts.csv');

% Report that the script reached its end and passed all specified checks.
fprintf('A5 regression checks passed for the stated parameters.\n');
