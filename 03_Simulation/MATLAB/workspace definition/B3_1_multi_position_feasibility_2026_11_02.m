%% B3.1 - Lesson 1
% Load six-cable configurations and generate 27 positions

clear; clc; close all;

%% 1. Load saved B1 and B2 data
load('B1_geometry_baseline.mat', 'geometry');
load('B2_6cable_experiment_A.mat', 'config6');
load('B2_experiment_B_results.mat', 'resultB');

% Experiment A
A_A = config6.A;
r_A = config6.r;

% Experiment B
A_B = resultB.A;
r_B = resultB.r;

rb = geometry.balloon_radius;

%% 2. Verify configuration dimensions
assert(isequal(size(A_A), [6 3]));
assert(isequal(size(r_A), [6 3]));
assert(isequal(size(A_B), [6 3]));
assert(isequal(size(r_B), [6 3]));

fprintf('Both configurations loaded successfully.\n');
fprintf('Balloon radius: %.4f mm\n', rb);

%% 3. Generate 27 balloon-centre positions
values = [-50 0 50];
%这表明了气球的水平方向移动 每个轴可以从-50移动到+50

[Px, Py, Pz] = ndgrid(values, values, values);
%相当于3个for循环 3*3*3 

P_samples = [Px(:), Py(:), Pz(:)];
    
N_positions = size(P_samples, 1);

fprintf('\nNumber of test positions: %d\n', N_positions);

assert(N_positions == 27);

%% 4. Verify full sphere containment
half_boundary = [
    geometry.Lg;
    geometry.Wg;
    geometry.Hg
    ] / 2;

centre_limit = half_boundary - rb;

is_contained = all( ...
    abs(P_samples) <= centre_limit.', 2);

fprintf('Contained positions: %d / %d\n', ...
    sum(is_contained), N_positions);

assert(all(is_contained), ...
    'Some balloon positions are outside the boundary.');

%% 5. Display sampled positions
disp('First 10 sampled positions (mm):');
disp(P_samples(1:10,:));

%% 6. Save the test set in the workspace
R = eye(3);

fprintf('\nLesson 1 completed.\n');

%% B3.1 - Lesson 2
% Calculate cable lengths at 27 positions

%% 7. Initialise cable-length matrices

L_A = zeros(N_positions, 6);
L_B = zeros(N_positions, 6);

%% 8. Calculate cable lengths at each position

for k = 1:N_positions

    % Current balloon-centre position
    P = P_samples(k,:).';

    % Experiment A: world-frame attachments
    B_world_A = (R*r_A.' + P).';

    % Experiment A: cable vectors and lengths
    D_A = A_A - B_world_A;
    L_A(k,:) = vecnorm(D_A, 2, 2).';

    % Experiment B: world-frame attachments
    B_world_B = (R*r_B.' + P).';

    % Experiment B: cable vectors and lengths
    D_B = A_B - B_world_B;
    L_B(k,:) = vecnorm(D_B, 2, 2).';

end

%% 9. Verify results
assert(isequal(size(L_A), [27 6]));
assert(isequal(size(L_B), [27 6]));
% 矩阵尺寸是否是 27*6

assert(all(isfinite(L_A(:))));
assert(all(isfinite(L_B(:))));
%isfinite 检查数据是否为有限实数。
% 这确保矩阵中没有任何 NaN（非数/计算报错）或 Inf（无穷大）。

assert(all(L_A(:) > 0));
assert(all(L_B(:) > 0));

fprintf('\n--- B3.1 Lesson 2 ---\n');
fprintf('Cable length matrices verified.\n');

%% 10. Compare cable-length ranges

fprintf('\nExperiment A:\n');
fprintf('Minimum cable length: %.3f mm\n', min(L_A(:)));
fprintf('Maximum cable length: %.3f mm\n', max(L_A(:)));

fprintf('\nExperiment B:\n');
fprintf('Minimum cable length: %.3f mm\n', min(L_B(:)));
fprintf('Maximum cable length: %.3f mm\n', max(L_B(:)));

%% 11. Cable length variation for each cable

range_A = max(L_A,[],1) - min(L_A,[],1);
range_B = max(L_B,[],1) - min(L_B,[],1);

fprintf('\nCable length variation (mm):\n');

results = table( ...
    (1:6).', ...
    range_A.', ...
    range_B.', ...
    'VariableNames', ...
    {'Cable','Experiment_A','Experiment_B'});

disp(results);

%% 12. Visualise cable length changes

figure('Color','w','Position',[100 100 1100 450]);

tiledlayout(1,2,'Padding','compact');

nexttile;
plot(1:N_positions,L_A,'LineWidth',1.4);
title('Experiment A');
xlabel('Sampled Position Index');
ylabel('Cable Length (mm)');
grid on;
xlim([1 N_positions]);

nexttile;
plot(1:N_positions,L_B,'LineWidth',1.4);
title('Experiment B');
xlabel('Sampled Position Index');
ylabel('Cable Length (mm)');
grid on;
xlim([1 N_positions]);

sgtitle('B3.1: Cable Lengths Across 27 Positions');

fprintf('\nLesson 2 completed.\n');

%% B3.1 - Lesson 3
% Cable-Sphere Interference at 27 Positions

%% 13. Initialise interference matrices

% true  = cable does not enter the sphere
% false = cable enters the sphere
safe_A = false(N_positions, 6);
safe_B = false(N_positions, 6);

outward_A = zeros(N_positions, 6);
outward_B = zeros(N_positions, 6);

tol = 1e-9;  % mm^2 numerical tolerance

%% 14. Evaluate each sampled position

for k = 1:N_positions

    P = P_samples(k,:).';

    % Experiment A
    B_world_A = (R*r_A.' + P).';
    D_A = A_A - B_world_A;
    S_A = B_world_A - P.';

    outward_A(k,:) = sum(S_A .* D_A, 2).';
    safe_A(k,:) = outward_A(k,:) >= -tol;

    % Experiment B
    B_world_B = (R*r_B.' + P).';
    D_B = A_B - B_world_B;
    S_B = B_world_B - P.';

    outward_B(k,:) = sum(S_B .* D_B, 2).';
    safe_B(k,:) = outward_B(k,:) >= -tol;

end

%% 15. Position is valid only if all 6 cables pass

position_safe_A = all(safe_A, 2);
position_safe_B = all(safe_B, 2);

n_safe_A = sum(position_safe_A);
n_safe_B = sum(position_safe_B);

fprintf('\n--- B3.1 Lesson 3 ---\n');

fprintf('Experiment A safe positions: %d / %d\n', ...
    n_safe_A, N_positions);

fprintf('Experiment B safe positions: %d / %d\n', ...
    n_safe_B, N_positions);

%% 16. Count failures for each cable

failures_A = sum(~safe_A, 1);
failures_B = sum(~safe_B, 1);

failure_table = table( ...
    (1:6).', ...
    failures_A.', ...
    failures_B.', ...
    'VariableNames', ...
    {'Cable','Failures_A','Failures_B'});

fprintf('\nCable-Sphere Interference Counts:\n');
disp(failure_table);

%% 17. Display failed position indices

fprintf('Failed positions for A:\n');
disp(find(~position_safe_A).');

fprintf('Failed positions for B:\n');
disp(find(~position_safe_B).');

fprintf('\nLesson 3 completed.\n');

%% B3.1 - Lesson 3
% Cable-Sphere Interference at 27 Positions

%% 13. Initialise interference matrices

% true  = cable does not enter the sphere
% false = cable enters the sphere

safe_A = false(N_positions, 6);
safe_B = false(N_positions, 6);

outward_A = zeros(N_positions, 6);
outward_B = zeros(N_positions, 6);

tol = 1e-9;  % mm^2 numerical tolerance

%% 14. Evaluate each sampled position

for k = 1:N_positions

    P = P_samples(k,:).';

    % Experiment A
    B_world_A = (R*r_A.' + P).';
    D_A = A_A - B_world_A;
    S_A = B_world_A - P.';

    outward_A(k,:) = sum(S_A .* D_A, 2).';
    safe_A(k,:) = outward_A(k,:) >= -tol;

    % Experiment B
    B_world_B = (R*r_B.' + P).';
    D_B = A_B - B_world_B;
    S_B = B_world_B - P.';

    outward_B(k,:) = sum(S_B .* D_B, 2).';
    safe_B(k,:) = outward_B(k,:) >= -tol;

end

%% 15. Position is valid only if all 6 cables pass

position_safe_A = all(safe_A, 2);
position_safe_B = all(safe_B, 2);
% 行（第 1 维）：代表 27 个不同的采样位置 (k = 1 ... 27)。
% 列（第 2 维）：代表机器人的 6 根钢索 (1 ... 6)。


n_safe_A = sum(position_safe_A);
n_safe_B = sum(position_safe_B);

fprintf('\n--- B3.1 Lesson 3 ---\n');

fprintf('Experiment A safe positions: %d / %d\n', ...
    n_safe_A, N_positions);

fprintf('Experiment B safe positions: %d / %d\n', ...
    n_safe_B, N_positions);

%% 16. Count failures for each cable

failures_A = sum(~safe_A, 1);
failures_B = sum(~safe_B, 1);

failure_table = table( ...
    (1:6).', ...
    failures_A.', ...
    failures_B.', ...
    'VariableNames', ...
    {'Cable','Failures_A','Failures_B'});

fprintf('\nCable-Sphere Interference Counts:\n');
disp(failure_table);


%% B3.1 - Lesson 4
%% 17. Cable-Cable minimum distance

config_A = A_A;
config_B = A_B;
attach_A = r_A;
attach_B = r_B;

n = 6;
pairs = nchoosek(1:n,2);
% 6根钢索两两配对，共有 C_6^2 = 15 组组合
% 它是按下面的逻辑生成的顺序 
% for Cable_1 = 1:5
%   for Cable_2 = (Cable_1 + 1):6
    % 依次生成配对 (Cable_1, Cable_2)
%end
%end

N_pairs = size(pairs,1);

distance_A = zeros(N_positions,N_pairs);
distance_B = zeros(N_positions,N_pairs);

for k = 1:N_positions

    P = P_samples(k,:).';

    Bworld_A = (R*attach_A.'+P).';
    Bworld_B = (R*attach_B.'+P).';

    for j = 1:N_pairs

        i1 = pairs(j,1);
        % 提取第 j 组配对中"第一根钢索"的编号
        i2 = pairs(j,2);

        distance_A(k,j) = ...
            B3_1_segment_distance_3d_2026_11_02( ...
            Bworld_A(i1,:),config_A(i1,:), ...
            Bworld_A(i2,:),config_A(i2,:));

        distance_B(k,j) = ...
            B3_1_segment_distance_3d_2026_11_02( ...
            Bworld_B(i1,:),config_B(i1,:), ...
            Bworld_B(i2,:),config_B(i2,:));
    end
end

%% Report minimum distances

min_dist_A = min(distance_A,[],2);
min_dist_B = min(distance_B,[],2);

fprintf('\n--- B3.1 Lesson 4 ---\n');
fprintf('Cable pairs per position: %d\n',N_pairs);

fprintf('Experiment A global minimum: %.6f mm\n', ...
    min(distance_A(:)));
fprintf('Experiment B global minimum: %.6f mm\n', ...
    min(distance_B(:)));

% Numerical contact threshold for initial screening
collision_tol = 1e-6; % mm, numerical only

collision_A = any(distance_A<=collision_tol,2);
collision_B = any(distance_B<=collision_tol,2);

fprintf('A positions with contact: %d / %d\n', ...
    sum(collision_A),N_positions);
fprintf('B positions with contact: %d / %d\n', ...
    sum(collision_B),N_positions);

%% Combined geometric screening

geometry_safe_A = position_safe_A & ~collision_A;
geometry_safe_B = position_safe_B & ~collision_B;

fprintf('\nCombined geometric screening:\n');
fprintf('Experiment A: %d / %d\n', ...
    sum(geometry_safe_A),N_positions);
fprintf('Experiment B: %d / %d\n', ...
    sum(geometry_safe_B),N_positions);

fprintf('\nLesson 4 completed.\n');

%% B3.1 - Lesson 5.1
% Diagnose Cable-Cable contact pairs

fprintf('\n--- Lesson 5.1: Contact Diagnosis ---\n');

tol_contact = 1e-6; % mm

% Count contacts for each cable pair
contacts_A = sum(distance_A <= tol_contact, 1);
contacts_B = sum(distance_B <= tol_contact, 1);

contact_table = table( ...
    pairs(:,1), ...
    pairs(:,2), ...
    contacts_A.', ...
    contacts_B.', ...
    'VariableNames', ...
    {'Cable_1','Cable_2','Contacts_A','Contacts_B'});

disp(contact_table);

% Find the globally closest cable pair
[dmin_A,idx_A] = min(distance_A(:));
%：将 27 * 15 的二维矩阵按列拉平（展平）为一条包含 27 * 15 = 405 个元素的一维列向量。

[k_A,j_A] = ind2sub(size(distance_A),idx_A);
% dmin_A（最小距离数值）：这 405 个距离中的绝对最小值（单位：mm）。
% idx_A（一维线性索引）：最小值在这个拉平后的一维向量里的位置序号（取值范围：1 ~ 405）。
% k_A（行号 / Row）：对应 第几号采样位置（取值范围：1 ~ 27）。
% j_A（列号 / Column）：对应 第几组钢索配对（取值范围：1 ~ 15）。

[dmin_B,idx_B] = min(distance_B(:));
[k_B,j_B] = ind2sub(size(distance_B),idx_B);
% Index to Subscript（一维索引 转 二维行列下标）。
% 据矩阵原始维度 [27, 15]，把一维的序号 idx_A 还原为二维矩阵的行号和列号。

fprintf('Experiment A closest pair: %d-%d, position %d\n', ...
    pairs(j_A,1),pairs(j_A,2),k_A);

fprintf('Experiment B closest pair: %d-%d, position %d\n', ...
    pairs(j_B,1),pairs(j_B,2),k_B);

% Report clearance margin for each position
fprintf('\nMinimum pair distances for B (mm):\n');
disp(min(distance_B,[],2).');

%% B3.1 - Lesson 5.2
% 3D geometric feasibility comparison

figure('Color','w','Position',[100 100 1200 520]);

safe_all = {geometry_safe_A,geometry_safe_B};
names = {'Experiment A','Experiment B'};

for j = 1:2

    subplot(1,2,j);
    hold on;

    mask = safe_all{j};

    % Feasible balloon centres
    scatter3( ...
        P_samples(mask,1), ...
        P_samples(mask,2), ...
        P_samples(mask,3), ...
        75,[0.1 0.65 0.3],'filled');

    % Infeasible balloon centres
    scatter3( ...
        P_samples(~mask,1), ...
        P_samples(~mask,2), ...
        P_samples(~mask,3), ...
        75,[0.85 0.2 0.2],'filled');

    title(sprintf('%s: %d/27 Feasible', ...
        names{j},sum(mask)));

    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');

    xlim([-70 70]);
    ylim([-70 70]);
    zlim([-70 70]);

    axis equal;
    grid on;
    view(35,25);

    legend('Feasible','Infeasible', ...
        'Location','best');

end

sgtitle('B3.1 - Six-Cable Geometric Feasibility');

%% Save results for B3.2

B3_1_results.P_samples = P_samples;
B3_1_results.R = R;

B3_1_results.geometry_safe_A = geometry_safe_A;
B3_1_results.geometry_safe_B = geometry_safe_B;

B3_1_results.position_safe_A = position_safe_A;
B3_1_results.position_safe_B = position_safe_B;

B3_1_results.distance_A = distance_A;
B3_1_results.distance_B = distance_B;
B3_1_results.pairs = pairs;

B3_1_results.L_A = L_A;
B3_1_results.L_B = L_B;


save('B3_1_results.mat','B3_1_results');

fprintf('\nB3.1 results saved.\n');

