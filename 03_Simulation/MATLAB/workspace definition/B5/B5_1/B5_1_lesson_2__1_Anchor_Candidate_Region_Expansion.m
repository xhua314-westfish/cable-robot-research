%% B5.1 Lesson 2.1
% Anchor Candidate Region Expansion
%
% Research Question:
% Does the original 26-point anchor grid limit
% the six-cable configuration search?
%
% Research Goals:
% 1. Reconstruct original 26 anchor candidates
% 2. Generate 98 expanded anchor candidates
% 3. Verify all points lie on the box boundary
% 4. Verify original points remain available
%
% Units: mm

clear; clc; close all;

%% Step 1: Define the B1 engineering boundary

Lg = 280;   % X - Length
Wg = 300;   % Y - Width
Hg = 320;   % Z - Height

% 各坐标轴正方向的边界位置
half_box = [Lg Wg Hg]/2;

%% Step 2: Reconstruct original anchor candidates

% 原始 3x3 面网格
% 每个坐标轴使用负边界、中心和正边界
x3 = linspace(-Lg/2,Lg/2,3);
y3 = linspace(-Wg/2,Wg/2,3);
z3 = linspace(-Hg/2,Hg/2,3);

% 生成所有 3x3x3 三维网格点
[X3,Y3,Z3] = ndgrid(x3,y3,z3);

% 将网格转换为 N x 3 坐标矩阵
A3_all = [X3(:),Y3(:),Z3(:)];

% 只有至少一个坐标位于边界上的点才保留
% 这样可以删除立方体内部的中心点 [0 0 0]
is_surface3 = any(abs(A3_all)==half_box,2);

A26 = A3_all(is_surface3,:);

fprintf('Original anchor candidates: %d\n', ...
    size(A26,1));

%% Step 3: Generate expanded 5x5 surface grid

% 扩展为每个坐标轴 5 个等间距采样值
x5 = linspace(-Lg/2,Lg/2,5);
y5 = linspace(-Wg/2,Wg/2,5);
z5 = linspace(-Hg/2,Hg/2,5);

% 生成 125 个三维网格点
[X5,Y5,Z5] = ndgrid(x5,y5,z5);

A5_all = [X5(:),Y5(:),Z5(:)];

% 删除内部网格点
% 只保留六个表面上的候选位置
is_surface5 = any(abs(A5_all)==half_box,2);

A98 = A5_all(is_surface5,:);

fprintf('Expanded anchor candidates: %d\n', ...
    size(A98,1));

%% Step 4: Numerical verification

% 确认两个集合的大小
assert(size(A26,1)==26);
assert(size(A98,1)==98);

% 检查新集合没有重复坐标
assert(size(unique(A98,'rows'),1)==98);

% 检查全部新点都在边界面上
assert(all(any(abs(A98)==half_box,2)));

% 检查新集合是否包含全部原始 26 个点
is_old_in_new = ismember(A26,A98,'rows');

assert(all(is_old_in_new), ...
    'Original anchor candidates are missing.');

fprintf('\nAll anchor candidate checks passed.\n');

%% Step 5: Visualise both candidate sets

figure('Color','w');

% 左图：26 个原始候选点
subplot(1,2,1);

scatter3(A26(:,1),A26(:,2),A26(:,3), ...
    50,'filled');

xlabel('X - Length (mm)');
ylabel('Y - Width (mm)');
zlabel('Z - Height (mm)');

title('Original - 26 Anchors');

axis equal;
grid on;
view(3);

% 右图：98 个扩展候选点
subplot(1,2,2);

scatter3(A98(:,1),A98(:,2),A98(:,3), ...
    35,'filled');

xlabel('X - Length (mm)');
ylabel('Y - Width (mm)');
zlabel('Z - Height (mm)');

title('Expanded - 98 Anchors');

axis equal;
grid on;
view(3);

%% Step 6: Save the candidate sets

% 保存两个候选集合，供后面的 B5.2 使用
% 不覆盖已有 B1、B2 数据
save('B5_1_anchor_candidates.mat', ...
    'A26','A98','Lg','Wg','Hg');

fprintf('Anchor candidate sets saved.\n');

