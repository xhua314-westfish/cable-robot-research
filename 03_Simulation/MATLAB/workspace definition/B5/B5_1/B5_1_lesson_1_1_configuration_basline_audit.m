
%% B5.1 Lesson 1.1 - Configuration Baseline Audit

clear; clc;

%% Step 1: Load the existing configuration

load('B2_experiment_B_results.mat','resultB');

A = resultB.A;
r = resultB.r;

assert(isequal(size(A),[6,3]));
assert(isequal(size(r),[6,3]));

%% Step 2: Reconstruct Modified B'

r_Bprime = r;
r_Bprime([5,6],:) = r_Bprime([6,5],:);

%% Step 3: Print the cable configuration table

% 为六根 Cable 生成编号
Cable = (1:6)';

T = table(Cable, A, r, r_Bprime, ...
    'VariableNames', ...
    {'Cable','Anchor_B','Attachment_B','Attachment_Bprime'});

disp('--- Configuration B vs Bprime ---');
disp(T);

%% Step 4: Examine anchor-face distribution

% 六个anchor points分别为
% [140, 0 -160; 140 150 160;
% 140 -150 160; 0 -150 160;
% -140 150 160; 0 150 160]

% 检查哪些 anchor 在 X 方向边界
faceX = abs(A(:,1)) == 140;

% 检查哪些 anchor 在 Y 方向边界
faceY = abs(A(:,2)) == 150;

% 检查哪些 anchor 在 Z 方向边界
faceZ = abs(A(:,3)) == 160;

% 输出数量
fprintf('Anchors on X boundary: %d\n',sum(faceX));
fprintf('Anchors on Y boundary: %d\n',sum(faceY));
fprintf('Anchors on Z boundary: %d\n',sum(faceZ));


%% B5.1 Lesson 1.2
% Configuration Distribution and Direction Audit
%研究目标：
% 1. 检查 anchor points 的最小间距
% 2. 检查 attachment points 的最小间距
% 3. 检查 Cable 方向的相似程度

n = size(A,1);
 
%% Step 1: Calculate anchor distances

% 用于存储不同 anchor 之间的距离
D_anchor = zeros(n,n);

for i = 1:n
    for j = i+1:n

        % 两个 anchor 的三维欧氏距离
        d = norm(A(i,:) - A(j,:));

        % 距离矩阵是对称的
        D_anchor(i,j) = d;
        D_anchor(j,i) = d;
    end
end

% 提取上三角区域，排除自身距离
mask = triu(true(n),1);
% true(n)：创建一个 n * n 的全 true（逻辑值 1）矩阵。
% triu 是上三角函数（Upper Triangular）。
% 第二个参数 1 代表从主对角线上方第 1 条斜线开始保留：
% [0 1 1;
% 0 0 1;
% 0 0 0]

    
% 所有不同 anchor 之间的距离
anchor_distances = D_anchor(mask);

% 最小 anchor 间距
min_anchor_distance = min(anchor_distances);

fprintf('\n--- Anchor Distribution ---\n');
fprintf('Minimum anchor distance: %.4f mm\n', ...
    min_anchor_distance);

%% Step 2: Calculate attachment distances

% 用相同的方法计算球面 attachment 间距
D_attachment = zeros(n,n);

for i = 1:n
    for j = i+1:n

        d = norm(r(i,:) - r(j,:));

        D_attachment(i,j) = d;
        D_attachment(j,i) = d;
    end
end

attachment_distances = D_attachment(mask);

min_attachment_distance = min(attachment_distances);

fprintf('\n--- Attachment Distribution ---\n');
fprintf('Minimum attachment distance: %.4f mm\n', ...
    min_attachment_distance);

%% Step 3: Calculate cable directions

P = [0,0,0];
R = eye(3);

% 存储每根 Cable 的单位方向向量
U = zeros(n,3);

for i = 1:n

    % 将 attachment 转换为世界坐标
    B_i = P + (R*r(i,:)')';

    % Cable 从 attachment 指向 anchor
    D_i = A(i,:) - B_i;

    % Cable 长度
    L_i = norm(D_i);

    % 单位方向向量
    U(i,:) = D_i / L_i;
end

%% Step 4: Direction similarity

% 计算任意两根 Cable 方向的内积
S = abs(U*U');

% S(i,j) = |u_i dot u_j|
%
% 接近 1：两个 Cable 方向平行或反平行
% 接近 0：两个 Cable 方向接近正交
%

% 排除对角线自身相似度
S(1:n+1:end) = NaN;

% 查找最高的不同 Cable 方向相似度
max_similarity = max(S(:),[],'omitnan');

% 找到对应的 Cable 编号
[row,col] = find(S == max_similarity,1);

fprintf('\n--- Cable Direction Similarity ---\n');
fprintf('Maximum absolute direction similarity: %.6f\n', ...
    max_similarity);

fprintf('Most similar Cable pair: %d and %d\n', ...
    row,col);

%% Step 6: Print cable directions

disp('--- Cable Unit Direction Vectors ---');
disp(array2table(U, ...
    'VariableNames',{'ux','uy','uz'}, ...
    'RowNames',compose('Cable_%d',1:n)));

%% Step 7: Visualise direction similarity

figure('Color','w');

% 为绘图重新设置对角线
S_plot = abs(U*U');

imagesc(S_plot);
axis equal tight;
colorbar;
clim([0,1]);

xlabel('Cable Number');
ylabel('Cable Number');
title('Experiment B - Cable Direction Similarity');

xticks(1:n);
yticks(1:n);

% 显示每个单元格对应的数值
for i = 1:n
    for j = 1:n
        text(j,i,sprintf('%.2f',S_plot(i,j)), ...
            'HorizontalAlignment','center', ...
            'Color','k');
    end
end

%% B5.1 Lesson 1.3
% Core Workspace Definition

% Research Question:
% What initial motion region should the six-cable
% sensing prototype support?
%
% Goal:
% 1. Define 27 translation samples
% 2. Define 7 orientation samples
% 3. Generate 189 core poses
% 4. Verify balloon containment

%% Step 1: Define the engineering boundary

% B1 established boundary dimensions
Lg = 280;    % X direction
Wg = 300;    % Y direction
Hg = 320;    % Z direction

% Balloon radius from B1
rb = 50.8266;

% Half dimensions of the boundary
half_box = [Lg, Wg, Hg] / 2;

%% Step 2: Define Core translation positions

% Proposed motion range:
% -20, 0, +20 mm on each axis

p_values = [-20, 0, 20];

% Generate all combinations of X, Y, Z
[X,Y,Z] = ndgrid(p_values,p_values,p_values);

% Each row represents one balloon centre
P_core = [X(:),Y(:),Z(:)];

% Total number of positions
N_position = size(P_core,1);

fprintf('Number of core positions: %d\n',N_position);

%% Step 3: Define Core orientation cases

Orientation_core = [
    0   0   0;
    5   0   0;
    -5   0   0;
    0   5   0;
    0  -5   0;
    0   0   5;
    0   0  -5
    ];

N_orientation = size(Orientation_core,1);

fprintf('Number of orientation cases: %d\n', ...
    N_orientation);


%% Step 4: Combine positions and orientations
% The first three columns represent position.
% The last three columns represent roll/pitch/yaw.
%
% Pose_core is a 189x6 matrix.
% Each row is one independent test pose.

Pose_core = zeros(N_position*N_orientation,6);

index = 1;

for i = 1:N_position

    for j = 1:N_orientation

        % Translation coordinates
        Pose_core(index,1:3) = P_core(i,:);

        % Rotation coordinates (degrees)
        Pose_core(index,4:6) = Orientation_core(j,:);

        index = index + 1;

    end
end

N_pose = size(Pose_core,1);

fprintf('Total core poses: %d\n',N_pose);

%% Step 5: Verify position containment

containment = ...
    abs(P_core) + rb <= half_box;
% For a rigid sphere inside the rectangular box:
%
% |Px| + rb <= Lg/2
% |Py| + rb <= Wg/2
% |Pz| + rb <= Hg/2
%

% A position is valid only if all three axes pass
position_valid = all(containment,2);

fprintf('\n--- Core Position Containment ---\n');

fprintf('Valid positions: %d / %d\n', ...
    sum(position_valid),N_position);

% Verify that every core position fits
assert(all(position_valid), ...
    'Some core positions exceed the boundary.');

%% Step 6: Verify sampling dimensions

% Check 27 translation samples
assert(N_position == 27);

% Check 7 orientation samples
assert(N_orientation == 7);

% Check 189 total test poses
assert(N_pose == 189);

% Check no duplicated poses
assert(size(unique(Pose_core,'rows'),1) == N_pose);

fprintf('\nCore Workspace generation passed.\n');

%% Step 7: Print example poses

disp('--- First 10 Core Poses ---');

disp(array2table(Pose_core(1:10,:), ...
    'VariableNames', ...
    {'X','Y','Z','Roll','Pitch','Yaw'}));

%% Step 8: Visualise core centre positions

figure('Color','w');

scatter3(P_core(:,1), ...
    P_core(:,2), ...
    P_core(:,3), ...
    65,'filled');

xlabel('X - Length (mm)');
ylabel('Y - Width (mm)');
zlabel('Z - Height (mm)');

title('B5.1 - Core Workspace Centre Samples');

axis equal;
grid on;
view(3);

