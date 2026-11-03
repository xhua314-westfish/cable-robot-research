%% B3.2 - Lesson 1
% Generate combined translation-rotation test poses

clear; clc; close all;

%% 1. Load existing configurations
load('B1_geometry_baseline.mat','geometry');
load('B2_6cable_experiment_A.mat','config6');
load('B2_experiment_B_results.mat','resultB');
load('B3_1_results.mat','B3_1_results');

A_A = config6.A;
r_A = config6.r;

A_B = resultB.A;
r_B = resultB.r;

P_samples = B3_1_results.P_samples;

%% 2. Define orientation samples in degrees

% Each row: [roll, pitch, yaw]
angles = [
    0   0   0;
    10   0   0;
    -10   0   0;
    0  10   0;
    0 -10   0;
    0   0  10;
    0   0 -10
    ];

N_rotations = size(angles,1);

%% 3. Generate rotation matrices

R_all = zeros(3,3,N_rotations);

for j = 1:N_rotations

    roll  = deg2rad(angles(j,1));
    pitch = deg2rad(angles(j,2));
    yaw   = deg2rad(angles(j,3));

    Rx = [
        1 0 0;
        0 cos(roll) -sin(roll);
        0 sin(roll) cos(roll)
        ];

    Ry = [
        cos(pitch) 0 sin(pitch);
        0 1 0;
        -sin(pitch) 0 cos(pitch)
        ];

    Rz = [
        cos(yaw) -sin(yaw) 0;
        sin(yaw) cos(yaw) 0;
        0 0 1
        ];

    % Rotation convention: ZYX
    R_all(:,:,j) = Rz * Ry * Rx;

end

%% 4. Verify rotation matrices

for j = 1:N_rotations

    R = R_all(:,:,j);

    assert(norm(R.'*R-eye(3),'fro') < 1e-10);
    %正交性检查
    %旋转矩阵必须满足正交矩阵性质 R^T * R = I

    assert(abs(det(R)-1) < 1e-10);
    %纯旋转检查（排除镜像翻转）
    % det(R) = +1：代表真正的刚体旋转（Proper Rotation），符合右手坐标系。
    % det(R) = -1：代表镜像反射/翻转（Improper Rotation / Reflection）。
    % 确保行列式值无限接近于 +1，排除把气球或坐标系"镜像翻转"的错误情况。

end

%% 5. Construct all 189 combined poses

N_positions = size(P_samples,1);
% 这里P_samples 也是 3*3*3 = 27个点
N_poses = N_positions * N_rotations;

P_all = zeros(N_poses,3);
R_pose = zeros(3,3,N_poses);
orientation_id = zeros(N_poses,1);
position_id = zeros(N_poses,1);

idx = 0;

for k = 1:N_positions
    for j = 1:N_rotations

        idx = idx+1;

        P_all(idx,:) = P_samples(k,:);
        R_pose(:,:,idx) = R_all(:,:,j);

        position_id(idx) = k;
        orientation_id(idx) = j;

    end
end

%% 6. Numerical verification
assert(N_poses == 189);
assert(idx == N_poses);
assert(isequal(size(P_all),[189 3]));
assert(isequal(size(R_pose),[3 3 189]));

% First orientation at every position is identity
for k = 1:N_positions
    id = (k-1)*N_rotations+1;
    %第 1 位置的第 1 个姿态应该在第 1 行
    %第 2 位置的第 1 个姿态在第 8 行（即跳过前 7 行后的第 1 行）
    % (2-1)* 7 + 1 = 8

    assert(norm(R_pose(:,:,id)-eye(3),'fro') < 1e-10);
    assert(norm(P_all(id,:)-P_samples(k,:)) < 1e-10);
end

fprintf('\n--- B3.2 Lesson 1 ---\n');
fprintf('Positions: %d\n',N_positions);
fprintf('Orientations: %d\n',N_rotations);
fprintf('Total poses: %d\n',N_poses);
fprintf('Rotation verification passed.\n');
fprintf('Translation-rotation combination passed.\n');

fprintf('\nLesson 1 completed.\n');

%% B3.2 - Lesson 2
% Cable Lengths Across 189 Combined Poses

%% 7. Initialise cable length matrices

n_cables = 6;

L_A = zeros(N_poses, n_cables);
L_B = zeros(N_poses, n_cables);

%% 8. Calculate lengths at each pose

for k = 1:N_poses

    % Current balloon centre (3x1)
    P = P_all(k,:).';

    % Current rotation matrix (3x3)
    R = R_pose(:,:,k);
    
    % Experiment A
    B_world_A = (R*r_A.' + P).';
    D_A = A_A - B_world_A;
    L_A(k,:) = vecnorm(D_A,2,2).';

    % Experiment B
    B_world_B = (R*r_B.' + P).';
    D_B = A_B - B_world_B;
    L_B(k,:) = vecnorm(D_B,2,2).';

end 

%% 9. Basic numerical checks

assert(isequal(size(L_A),[189 6]));
assert(isequal(size(L_B),[189 6]));

assert(all(isfinite(L_A(:))));
assert(all(isfinite(L_B(:))));

assert(all(L_A(:)>0));
assert(all(L_B(:)>0));

fprintf('\n--- B3.2 Lesson 2 ---\n');

fprintf('Experiment A length range: %.3f - %.3f mm\n', ...
    min(L_A(:)), max(L_A(:)));

fprintf('Experiment B length range: %.3f - %.3f mm\n', ...
    min(L_B(:)), max(L_B(:)));

%% 10. Verify consistency with B3.1

% First orientation at each position is R = I
zero_rotation_rows = find(orientation_id == 1);

L_A_previous = B3_1_results.L_A;
L_B_previous = B3_1_results.L_B;

error_A = max(abs( ...
    L_A(zero_rotation_rows,:) - L_A_previous), [], 'all');

error_B = max(abs( ...
    L_B(zero_rotation_rows,:) - L_B_previous), [], 'all');

fprintf('\nConsistency with B3.1:\n');
fprintf('Maximum length difference A: %.3e mm\n',error_A);
fprintf('Maximum length difference B: %.3e mm\n',error_B);

assert(error_A < 1e-8);
assert(error_B < 1e-8);

%% 11. Compare length variation

range_A = max(L_A,[],1) - min(L_A,[],1);
range_B = max(L_B,[],1) - min(L_B,[],1);

variation_table = table( ...
    (1:6).',range_A.',range_B.', ...
    'VariableNames', ...
    {'Cable','Experiment_A','Experiment_B'});

fprintf('\nCable length variation across 189 poses:\n');
disp(variation_table);

fprintf('\nLesson 2 completed.\n');


%% B3.2 - Lesson 3
% Cable-Sphere Interference Across 189 Poses

%% 12. Initialise interference arrays

n_cables = 6;

safe_A = false(N_poses,n_cables);
safe_B = false(N_poses,n_cables);

outward_A = zeros(N_poses,n_cables);
outward_B = zeros(N_poses,n_cables);

tol = 1e-9; % mm^2, numerical tolerance

%% 13. Evaluate all 189 poses
for k = 1:N_poses

    P = P_all(k,:).';
    R = R_pose(:,:,k);

    % Experiment A
    B_world_A = (R*r_A.' + P).';
    D_A = A_A - B_world_A;
    S_A = (R*r_A.').';

    outward_A(k,:) = sum(S_A.*D_A,2).';
    safe_A(k,:) = outward_A(k,:) >= -tol;

    % Experiment B
    B_world_B = (R*r_B.' + P).';
    D_B = A_B - B_world_B;
    S_B = (R*r_B.').';

    outward_B(k,:) = sum(S_B.*D_B,2).';
    safe_B(k,:) = outward_B(k,:) >= -tol;

end

%% 14. Evaluate pose-level feasibility

pose_safe_A = all(safe_A,2);
pose_safe_B = all(safe_B,2);

fprintf('\n--- B3.2 Lesson 3 ---\n');

fprintf('Experiment A: %d / %d poses pass\n', ...
    sum(pose_safe_A),N_poses);

fprintf('Experiment B: %d / %d poses pass\n', ...
    sum(pose_safe_B),N_poses);

%% 15. Compare individual cable failures

failures_A = sum(~safe_A,1);
failures_B = sum(~safe_B,1);

failure_table = table( ...
    (1:6).', ...
    failures_A.', ...
    failures_B.', ...
    'VariableNames', ...
    {'Cable','Failures_A','Failures_B'});

fprintf('\nCable-Sphere Interference Counts:\n');
disp(failure_table);

%% 16. Analyse feasibility by orientation

rotation_safe_A = zeros(N_rotations,1);
rotation_safe_B = zeros(N_rotations,1);

for j = 1:N_rotations

    mask = orientation_id == j;

    rotation_safe_A(j) = sum(pose_safe_A(mask));
    rotation_safe_B(j) = sum(pose_safe_B(mask));

end

rotation_table = table( ...
    (1:N_rotations).', ...
    angles(:,1), ...
    angles(:,2), ...
    angles(:,3), ...
    rotation_safe_A, ...
    rotation_safe_B, ...
    'VariableNames', ...
    {'Case','Roll','Pitch','Yaw','Safe_A','Safe_B'});

fprintf('\nFeasible positions by orientation (out of 27):\n');
disp(rotation_table);

%% 17. Regression test against B3.1

zero_rows = orientation_id == 1;

A_matches = isequal( ...
    pose_safe_A(zero_rows), ...
    B3_1_results.position_safe_A);

B_matches = isequal( ...
    pose_safe_B(zero_rows), ...
    B3_1_results.position_safe_B);

assert(A_matches && B_matches, ...
    'B3.1 zero-rotation results do not match.');

fprintf('B3.1 zero-rotation consistency passed.\n');
fprintf('Lesson 3 completed.\n');

%% B3.2 - Lesson 4
% Cable-Cable Interference Across 189 Poses

%% 18. Initialise cable-pair distance matrices

n_cables = 6;
pairs = nchoosek(1:n_cables,2);

N_pairs = size(pairs,1);

distance_A = zeros(N_poses,N_pairs);
distance_B = zeros(N_poses,N_pairs);

%% 19. Calculate distances at each pose

for k = 1:N_poses

    P = P_all(k,:).';
    R = R_pose(:,:,k);

    % World-frame attachments
    B_world_A = (R*r_A.' + P).';
    B_world_B = (R*r_B.' + P).';

    for j = 1:N_pairs

        i1 = pairs(j,1);
        i2 = pairs(j,2);

        % Experiment A
        distance_A(k,j) = ...
            B3_1_segment_distance_3d_2026_11_02( ...
            B_world_A(i1,:),A_A(i1,:), ...
            B_world_A(i2,:),A_A(i2,:));

        % Experiment B
        distance_B(k,j) = ...
            B3_1_segment_distance_3d_2026_11_02( ...
            B_world_B(i1,:),A_B(i1,:), ...
            B_world_B(i2,:),A_B(i2,:));

    end
end

%% 20. Numerical checks

assert(isequal(size(distance_A),[189 15]));
assert(isequal(size(distance_B),[189 15]));

assert(all(isfinite(distance_A(:))));
assert(all(isfinite(distance_B(:))));

assert(all(distance_A(:)>=0));
assert(all(distance_B(:)>=0));

%% 21. Contact classification

contact_tol = 1e-6; % mm, numerical threshold only

contact_A = distance_A <= contact_tol;
contact_B = distance_B <= contact_tol;

% True if at least one cable pair contacts
pose_contact_A = any(contact_A,2);
pose_contact_B = any(contact_B,2);

fprintf('\n--- B3.2 Lesson 4 ---\n');

fprintf('Cable pairs: %d\n',N_pairs);

fprintf('Experiment A minimum distance: %.6f mm\n', ...
    min(distance_A(:)));

fprintf('Experiment B minimum distance: %.6f mm\n', ...
    min(distance_B(:)));

fprintf('\nPoses with Cable-Cable contact:\n');
fprintf('Experiment A: %d / %d\n', ...
    sum(pose_contact_A),N_poses);

fprintf('Experiment B: %d / %d\n', ...
    sum(pose_contact_B),N_poses);

%% 22. Contact counts by cable pair

contact_count_A = sum(contact_A,1);
contact_count_B = sum(contact_B,1);

contact_table = table( ...
    pairs(:,1),pairs(:,2), ...
    contact_count_A.',contact_count_B.', ...
    'VariableNames', ...
    {'Cable_1','Cable_2','Contacts_A','Contacts_B'});

fprintf('\nContact counts by cable pair:\n');
disp(contact_table);

%% 23. Combined geometric feasibility

% Cable-Sphere feasibility from Lesson 3
% Cable-Cable feasibility from Lesson 4

geometry_safe_A = pose_safe_A & ~pose_contact_A;
geometry_safe_B = pose_safe_B & ~pose_contact_B;

fprintf('\nCombined geometric feasibility:\n');

fprintf('Experiment A: %d / %d\n', ...
    sum(geometry_safe_A),N_poses);

fprintf('Experiment B: %d / %d\n', ...
    sum(geometry_safe_B),N_poses);

%% 24. Regression test against B3.1

zero_rows = orientation_id == 1;

error_distance_A = max(abs( ...
    distance_A(zero_rows,:) - ...
    B3_1_results.distance_A),[],'all');

error_distance_B = max(abs( ...
    distance_B(zero_rows,:) - ...
    B3_1_results.distance_B),[],'all');

fprintf('\nZero-rotation distance consistency:\n');
fprintf('Experiment A error: %.3e mm\n',error_distance_A);
fprintf('Experiment B error: %.3e mm\n',error_distance_B);

assert(error_distance_A<1e-8);
assert(error_distance_B<1e-8);

fprintf('\nLesson 4 completed.\n');


%% B3.2 - Lesson 5.1
% Feasibility diagnosis by orientation

fprintf('\n--- B3.2 Lesson 5.1 ---\n');

combined_count_A = zeros(N_rotations,1);
combined_count_B = zeros(N_rotations,1);
contact56_B = zeros(N_rotations,1);

% Find the column corresponding to Cable Pair 5-6
pair56_idx = find( ...
    pairs(:,1)==5 & pairs(:,2)==6);

assert(numel(pair56_idx)==1);

for j = 1:N_rotations

    mask = orientation_id == j;

    combined_count_A(j) = ...
        sum(geometry_safe_A(mask));

    combined_count_B(j) = ...
        sum(geometry_safe_B(mask));

    contact56_B(j) = ...
        sum(contact_B(mask,pair56_idx));

end

orientation_results = table( ...
    (1:N_rotations).', ...
    angles(:,1), ...
    angles(:,2), ...
    angles(:,3), ...
    combined_count_A, ...
    combined_count_B, ...
    contact56_B, ...
    'VariableNames', ...
    {'Case','Roll','Pitch','Yaw', ...
    'Feasible_A','Feasible_B','Contact56_B'});

disp(orientation_results);

fprintf('Total A feasible: %d\n', ...
    sum(combined_count_A));

fprintf('Total B feasible: %d\n', ...
    sum(combined_count_B));

assert(sum(combined_count_A)==40);
assert(sum(combined_count_B)==105);
assert(sum(contact56_B)==81);

%% Failure breakdown

sphere_fail_B = ~pose_safe_B;
cable_fail_B = pose_contact_B;

fprintf('\nExperiment B failure breakdown:\n');

fprintf('Sphere only: %d\n', ...
    sum(sphere_fail_B & ~cable_fail_B));

fprintf('Cable-Cable only: %d\n', ...
    sum(~sphere_fail_B & cable_fail_B));

fprintf('Both: %d\n', ...
    sum(sphere_fail_B & cable_fail_B));

fprintf('Either failure: %d\n', ...
    sum(sphere_fail_B | cable_fail_B));

assert(sum(sphere_fail_B | cable_fail_B)==84);

fprintf('\nLesson 5.1 completed.\n');


%% B3.2 - Lesson 5.2
% Visualise feasibility for each orientation

configuration_names = {'Experiment A','Experiment B'};
safe_data = {geometry_safe_A,geometry_safe_B};

for c = 1:2

    figure('Color','w', ...
        'Position',[80 80 1250 720]);

    tiledlayout(2,4,'Padding','compact', ...
        'TileSpacing','compact');

    safe_mask = safe_data{c};

    for j = 1:N_rotations

        nexttile;
        hold on;

        idx = orientation_id == j;

        P_current = P_all(idx,:);
        valid = safe_mask(idx);

        % Feasible positions
        scatter3( ...
            P_current(valid,1), ...
            P_current(valid,2), ...
            P_current(valid,3), ...
            48,[0.1 0.65 0.3],'filled');

        % Infeasible positions
        scatter3( ...
            P_current(~valid,1), ...
            P_current(~valid,2), ...
            P_current(~valid,3), ...
            48,[0.85 0.2 0.2],'filled');

        title(sprintf('R=%+d, P=%+d, Y=%+d', ...
            angles(j,1),angles(j,2),angles(j,3)));

        xlabel('X (mm)');
        ylabel('Y (mm)');
        zlabel('Z (mm)');

        xlim([-60 60]);
        ylim([-60 60]);
        zlim([-60 60]);

        axis equal;
        grid on;
        view(35,25);

        text(0.03,0.95, ...
            sprintf('%d/27 feasible',sum(valid)), ...
            'Units','normalized', ...
            'FontSize',10);

    end

    sgtitle(sprintf( ...
        '%s - B3.2 Geometric Feasibility', ...
        configuration_names{c}));

    % Save figure
    filename = sprintf( ...
        'B3_2_Experiment_%s_feasibility.png', ...
        char('A'+c-1));

    exportgraphics(gcf,filename,'Resolution',200);

end

fprintf('\nLesson 5.2 completed.\n');


%% B3.2 - Lesson 5.3
% Save B3.2 results for B4

B3_2_results.P_all = P_all;
B3_2_results.R_pose = R_pose;
B3_2_results.position_id = position_id;
B3_2_results.orientation_id = orientation_id;
B3_2_results.angles = angles;

B3_2_results.L_A = L_A;
B3_2_results.L_B = L_B;

B3_2_results.safe_sphere_A = pose_safe_A;
B3_2_results.safe_sphere_B = pose_safe_B;

B3_2_results.distance_A = distance_A;
B3_2_results.distance_B = distance_B;
B3_2_results.pairs = pairs;

B3_2_results.contact_A = pose_contact_A;
B3_2_results.contact_B = pose_contact_B;

B3_2_results.geometry_safe_A = geometry_safe_A;
B3_2_results.geometry_safe_B = geometry_safe_B;

B3_2_results.orientation_results = orientation_results;

save('B3_2_results.mat','B3_2_results');

fprintf('\nB3.2 results saved successfully.\n');
