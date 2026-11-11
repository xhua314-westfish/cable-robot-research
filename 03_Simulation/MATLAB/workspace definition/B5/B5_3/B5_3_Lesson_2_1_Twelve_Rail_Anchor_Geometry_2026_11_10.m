% B5.3 Lesson 2.1
% Twelve-Rail Anchor Geometry
%
% Research Question:
% How can all anchor points be restricted to
% the twelve edges of the engineering frame?
%
% Objectives:
% 1. Define all 12 frame-edge rails
% 2. Verify each rail is a valid full box edge
% 3. Generate 5 samples per rail
% 4. Remove duplicated spatial corner coordinates
% 5. Preserve shared-rail membership
% 6. Visualise and save the rail model
%
% IMPORTANT:
% This lesson defines IDEAL rail geometry only.
% Pulley offsets, slider sizes and physical clearance
% will be introduced in B5.3 Lesson 2.2.
%
% Units: mm

clear; clc; close all;

%% Step 1: Define B1 engineering geometry

Lg = 280;   % X: Length
Wg = 300;   % Y: Width
Hg = 320;   % Z: Height

rb = 50.8266;

hx = Lg/2;
hy = Wg/2;
hz = Hg/2;

half_box = [hx hy hz];


%% Step 2: Define 12 complete frame-edge rails
%
% R1-R4:  Z-direction rails
% R5-R8:  X-direction rails
% R9-R12: Y-direction rails
%
% 采用每条导轨起点和终点的表示方法。
% 后续可通过Rail ID和参数t来获取任意Anchor坐标。

rail_start = [
    -hx -hy -hz;  % R1  Z
    hx -hy -hz;  % R2  Z
    -hx  hy -hz;  % R3  Z
    hx  hy -hz;  % R4  Z

    -hx -hy -hz;  % R5  X
    -hx  hy -hz;  % R6  X
    -hx -hy  hz;  % R7  X
    -hx  hy  hz;  % R8  X

    -hx -hy -hz;  % R9  Y
    hx -hy -hz;  % R10 Y
    -hx -hy  hz;  % R11 Y
    hx -hy  hz   % R12 Y
    ];

rail_end = [
    -hx -hy  hz;  % R1  Z
    hx -hy  hz;  % R2  Z
    -hx  hy  hz;  % R3  Z
    hx  hy  hz;  % R4  Z

    hx -hy -hz;  % R5  X
    hx  hy -hz;  % R6  X
    hx -hy  hz;  % R7  X
    hx  hy  hz;  % R8  X

    -hx  hy -hz;  % R9  Y
    hx  hy -hz;  % R10 Y
    -hx  hy  hz;  % R11 Y
    hx  hy  hz   % R12 Y
    ];

rail_axis = [
    repmat("Z",4,1);
    repmat("X",4,1);
    repmat("Y",4,1)
    ];

N_rails = size(rail_start,1);
tol = 1e-9;

assert(N_rails == 12);
assert(isequal(size(rail_end),[12 3]));

%% Step 3: Verify all rail segments
%
% 每条导轨必须满足：
% 1. 起点终点处于工程边界
% 2. 只有一个坐标轴变化
% 3. 其余两个坐标固定在边界上
% 4. 长度等于完整边长
% 5. 不与其他导轨重复

rail_length = zeros(N_rails,1);

for j = 1:N_rails

    E0 = rail_start(j,:);
    E1 = rail_end(j,:);

    direction = E1-E0;

    rail_length(j) = norm(direction);

    % 检查端点是否在工程边界内
    assert(all(abs(E0)<=half_box+tol));
    assert(all(abs(E1)<=half_box+tol));

    % 只有一个坐标可以变化
    varying = abs(direction)>tol;

    assert(sum(varying)==1);

    % 另外两个固定坐标必须位于长方体边界
    fixed = ~varying;

    assert(all( ...
        abs(abs(E0(fixed))-half_box(fixed))<tol));

    % 导轨长度必须等于对应完整边长
    expected_length = 2*half_box(varying);

    assert(abs(rail_length(j)-expected_length)<tol);

end

% 检查X、Y、Z方向各有四条
assert(sum(rail_axis=="X")==4);
assert(sum(rail_axis=="Y")==4);
assert(sum(rail_axis=="Z")==4);

% 对每条导轨的两端点排序，防止正反方向重复
rail_keys = zeros(N_rails,6);

for j = 1:N_rails

    endpoints = sortrows( ...
        [rail_start(j,:);rail_end(j,:)]);

    rail_keys(j,:) = reshape(endpoints',1,6);

end

assert(size(unique(rail_keys,'rows'),1)==12);

fprintf('\n--- Rail Geometry Verification ---\n');

fprintf('Valid complete rails: %d / %d\n', ...
    N_rails,N_rails);

fprintf('X-direction rails: %d\n', ...
    sum(rail_axis=="X"));

fprintf('Y-direction rails: %d\n', ...
    sum(rail_axis=="Y"));

fprintf('Z-direction rails: %d\n', ...
    sum(rail_axis=="Z"));

%% Step 4: Generate discrete anchor candidates
%
% 目前每条导轨采样5个位置。
% 这是离散初始化方法，不代表只能安装在这5个点。
%
% 任意导轨位置可表示为：
% A(t) = E0 + t*(E1-E0)
% 其中0 <= t <= 1

samples_per_rail = 5;

t_values = linspace(0,1,samples_per_rail);

N_raw = N_rails*samples_per_rail;

A_rail_raw = zeros(N_raw,3);

rail_id_raw = zeros(N_raw,1);

t_raw = zeros(N_raw,1);

rail_candidates = cell(N_rails,1);

idx = 0;

for j = 1:N_rails

    E0 = rail_start(j,:);
    E1 = rail_end(j,:);

    local_points = zeros(samples_per_rail,3);

    for m = 1:samples_per_rail

        t = t_values(m);

        % 导轨参数方程
        A = E0+t*(E1-E0);

        local_points(m,:) = A;

        idx = idx+1;

        A_rail_raw(idx,:) = A;
        rail_id_raw(idx) = j;
        t_raw(idx) = t;

    end

    rail_candidates{j} = local_points;
end

assert(idx==60);

fprintf('\n--- Candidate Sampling ---\n');

fprintf('Raw samples: %d\n',N_raw);

%% Step 5: Remove duplicated spatial coordinates
%
% 注意：共享角点的空间坐标只有一个，
% 但它同时属于三条Rail。
%
% 因此不能简单去重后丢失Rail ID信息。

[A_rail_unique,~,raw_to_unique] = ...
    unique(A_rail_raw,'rows');

N_unique = size(A_rail_unique,1);

assert(N_unique==44);

% 每行：一个唯一候选位置
% 每列：一条Rail
%
% true表示该候选位置属于对应导轨
candidate_rail_membership = false( ...
    N_unique,N_rails);

for k = 1:N_raw

    unique_id = raw_to_unique(k);
    rail_id = rail_id_raw(k);

    candidate_rail_membership( ...
        unique_id,rail_id) = true;

end

% 统计每个空间点属于多少条Rail
membership_count = ...
    sum(candidate_rail_membership,2);

% 8个角点分别属于3条导轨
corner_mask = membership_count==3;

% 非角点候选只属于1条导轨
interior_mask = membership_count==1;

assert(sum(corner_mask)==8);
assert(sum(interior_mask)==36);

% 本次采样中不应有恰好属于两条Rail的点
assert(all(membership_count==1 | ...
           membership_count==3));

fprintf('Unique spatial points: %d\n',N_unique);

fprintf('Shared corners: %d\n',sum(corner_mask));

fprintf('Single-rail interior points: %d\n', ...
    sum(interior_mask));

%% Step 6: Verify every candidate is on a box edge

for k = 1:N_unique

    A = A_rail_unique(k,:);

    % 必须在工程边界内
    assert(all(abs(A)<=half_box+tol));

    % 至少两个坐标处于边界
    on_boundary = abs(abs(A)-half_box)<tol;

    assert(sum(on_boundary)>=2);

end

% 再检查所有原始记录都落在其指定Rail上
for k = 1:N_raw

    j = rail_id_raw(k);
    t = t_raw(k);

    expected_A = rail_start(j,:) + ...
        t*(rail_end(j,:)-rail_start(j,:));

    assert(norm(A_rail_raw(k,:)-expected_A)<tol);

end

fprintf('All candidate geometry checks passed.\n');

%% Step 7: Print complete rail definitions

RailID = (1:N_rails)';

T_rails = table( ...
    RailID,rail_axis, ...
    rail_start,rail_end,rail_length, ...
    'VariableNames', ...
    {'RailID','Axis','Start_mm', ...
     'End_mm','Length_mm'});

disp(' ');
disp('--- Twelve Rail Definitions ---');
disp(T_rails);

%% Step 8: Visualise rail geometry

fig = figure( ...
    'Color','w', ...
    'Name','B5.3 Twelve-Rail Geometry', ...
    'Position',[100 100 1100 750]);

hold on;

% 三个方向颜色不同
color_X = [0.90 0.45 0.15];
color_Y = [0.15 0.65 0.40];
color_Z = [0.10 0.45 0.85];

for j = 1:N_rails

    E0 = rail_start(j,:);
    E1 = rail_end(j,:);

    switch rail_axis(j)

        case "X"
            current_color = color_X;

        case "Y"
            current_color = color_Y;

        case "Z"
            current_color = color_Z;

    end

    % 绘制完整Rail
    plot3( ...
        [E0(1) E1(1)], ...
        [E0(2) E1(2)], ...
        [E0(3) E1(3)], ...
        '-', ...
        'Color',current_color, ...
        'LineWidth',3, ...
        'HandleVisibility','off');

    % Rail编号放在中点
    midpoint = (E0+E1)/2;

    text( ...
        midpoint(1),midpoint(2),midpoint(3), ...
        sprintf(' R%d',j), ...
        'FontSize',10, ...
        'FontWeight','bold', ...
        'BackgroundColor','w');

end

% 非角点候选用黑色圆点
scatter3( ...
    A_rail_unique(interior_mask,1), ...
    A_rail_unique(interior_mask,2), ...
    A_rail_unique(interior_mask,3), ...
    35,'k','filled', ...
    'HandleVisibility','off');

% 共享角点用紫色方形标记
scatter3( ...
    A_rail_unique(corner_mask,1), ...
    A_rail_unique(corner_mask,2), ...
    A_rail_unique(corner_mask,3), ...
    65,[0.60 0.25 0.80], ...
    's','filled', ...
    'HandleVisibility','off');

%% Step 9: Add clear legend

hX = plot3(NaN,NaN,NaN,'-', ...
    'Color',color_X,'LineWidth',3);

hY = plot3(NaN,NaN,NaN,'-', ...
    'Color',color_Y,'LineWidth',3);

hZ = plot3(NaN,NaN,NaN,'-', ...
    'Color',color_Z,'LineWidth',3);

hInterior = scatter3( ...
    NaN,NaN,NaN,35,'k','filled');

hCorner = scatter3( ...
    NaN,NaN,NaN,65,[0.60 0.25 0.80], ...
    's','filled');

legend( ...
    [hX hY hZ hInterior hCorner], ...
    {'X rails','Y rails','Z rails', ...
     'Rail candidate','Shared corner'}, ...
    'Location','eastoutside');

xlabel('X - Length (mm)');
ylabel('Y - Width (mm)');
zlabel('Z - Height (mm)');

title('B5.3 Lesson 2.1 - Twelve-Rail Geometry');

axis equal;
grid on;
view(35,25);

xlim([-160 160]);
ylim([-170 170]);
zlim([-180 180]);

set(gca,'FontSize',11);

hold off;

%% Step 10: Save verified geometry
%
% 后续B5.3 Lesson 2.2和S1/S2/S3
% 都应使用这份12-Rail数据。
%
% 不覆盖以前的B1-B5.2历史结果。

save('B5_3_12rail_geometry_baseline.mat', ...
    'Lg','Wg','Hg','rb', ...
    'rail_start','rail_end','rail_axis', ...
    'rail_length','T_rails', ...
    'samples_per_rail','t_values', ...
    'A_rail_raw','rail_id_raw','t_raw', ...
    'rail_candidates','A_rail_unique', ...
    'raw_to_unique', ...
    'candidate_rail_membership', ...
    'corner_mask','interior_mask');

fprintf('\nB5.3 Lesson 2.1 completed.\n');

fprintf('Saved: B5_3_12rail_geometry_baseline.mat\n');