
%% Prototype V1 - M1.2
% Physical Frame Occupancy Check
%
% 目的：
% 检查 M1.1 得到的 M_i -> A_i 参考连接线
% 是否穿过 3030 铝型材的截面包络。
%
% 注意：
% 当前使用 30x30 mm 实心包络近似型材。
% 这不是精确的 T-slot CAD 碰撞检查。

clear; clc; close all;

%% Step 1 - 基本尺寸

profile_size = 30;          % 3030型材，mm
half_profile = profile_size/2;

% 计算边界半尺寸
half_dims = [140 150 160];

%% Step 2 - 读取之前保存的Anchor结果

file_csv = fullfile( ...
    'Prototype_V1_Mounting_Audit', ...
    'Prototype_V1_anchor_mounting.csv');

assert(isfile(file_csv), ...
    '找不到Lesson 1.2的Anchor CSV。');

T = readtable(file_csv);

% 读取原始12条Rail
rail_file = 'B5_3_12rail_geometry_baseline.mat';

if ~isfile(rail_file)
    rail_file = fullfile( ...
        fileparts(pwd),'B5_3',rail_file);
end

assert(isfile(rail_file), ...
    '找不到12-Rail几何文件。');

G = load(rail_file);

rail_start = G.rail_start;
rail_end = G.rail_end;

%% Step 3 - 初始化检查结果

N = height(T);

A_all = zeros(N,3);
M_all = zeros(N,3);

Span_mm = zeros(N,1);

% 是否穿过本Rail的型材包络
CrossesProfile = false(N,1);

% 是否靠近Rail的物理端点
NearRailCorner = false(N,1);

%% Step 4 - 检查每根Cable的Anchor

for n = 1:N

    rid = T.RailID(n);
    t = T.t_value(n);

    p0 = rail_start(rid,:);
    p1 = rail_end(rid,:);

    % 理论Anchor
    A = p0 + t*(p1-p0);

    % 找出Rail延伸方向
    delta = p1-p0;
    varying_axis = find(abs(delta)>1e-8);

    assert(numel(varying_axis)==1);

    % 另外两个方向构成型材横截面
    fixed_axes = setdiff(1:3,varying_axis);

    % 型材中心位置
    M = A;

    for k = fixed_axes

        M(k) = A(k) + ...
            sign(A(k))*half_profile;

    end

    A_all(n,:) = A;
    M_all(n,:) = M;

    Span_mm(n) = norm(M-A);

    %% Step 4.1 - 对M到A的线段进行采样

    % 不包含两个端点
    lambda = linspace(0.05,0.95,21)';

    points = M + lambda.*(A-M);

    % 检查采样点是否位于型材截面内
    inside = true(numel(lambda),1);

    for k = fixed_axes

        inside = inside & ...
            abs(points(:,k)-M(k)) ...
            < half_profile-1e-8;

    end

    CrossesProfile(n) = any(inside);

    %% Step 4.2 - 标记靠近Rail端点的位置

    rail_length = norm(p1-p0);

    d_end = min(t,1-t)*rail_length;

    % 20mm仅用于标记角部风险
    NearRailCorner(n) = d_end<20;

end

%% Step 5 - 整理结果

T_result = table( ...
    string(T.Design), ...
    T.CableID, ...
    T.RailID, ...
    A_all(:,1),A_all(:,2),A_all(:,3), ...
    M_all(:,1),M_all(:,2),M_all(:,3), ...
    Span_mm, ...
    CrossesProfile, ...
    NearRailCorner, ...
    'VariableNames',{ ...
        'Design','CableID','RailID', ...
        'Ax','Ay','Az', ...
        'Mx','My','Mz', ...
        'ReferenceSpan_mm', ...
        'CrossesProfile', ...
        'NearRailCorner'});

fprintf('\n=== M1.2 Frame Occupancy Check ===\n');

disp(T_result);

fprintf('\nSegments crossing profile envelope: %d / %d\n', ...
    sum(CrossesProfile),N);

fprintf('Anchors within 20mm of a rail end: %d / %d\n', ...
    sum(NearRailCorner),N);

%% Step 6 - 绘制C12 Cable 6截面

idx = find( ...
    string(T_result.Design)=="C12 E2 M" & ...
    T_result.CableID==6);

assert(numel(idx)==1);

rid = T_result.RailID(idx);

delta = rail_end(rid,:)-rail_start(rid,:);

varying_axis = find(abs(delta)>1e-8);
fixed_axes = setdiff(1:3,varying_axis);

A = A_all(idx,:);
M = M_all(idx,:);

figure('Color','w', ...
    'Position',[150 150 760 650]);

hold on;

% 3030型材的实体截面包络
rectangle( ...
    'Position',[ ...
        M(fixed_axes(1))-half_profile, ...
        M(fixed_axes(2))-half_profile, ...
        profile_size,profile_size], ...
    'FaceColor',[0.83 0.86 0.90], ...
    'EdgeColor',[0.3 0.35 0.4], ...
    'LineWidth',2);

% M -> A 参考连接线
plot( ...
    [M(fixed_axes(1)) A(fixed_axes(1))], ...
    [M(fixed_axes(2)) A(fixed_axes(2))], ...
    'm-','LineWidth',3);

% 型材中心
plot(M(fixed_axes(1)),M(fixed_axes(2)), ...
    'go','MarkerSize',10, ...
    'MarkerFaceColor','g');

% 理论Anchor
plot(A(fixed_axes(1)),A(fixed_axes(2)), ...
    'ro','MarkerSize',10, ...
    'MarkerFaceColor','r');

text(M(fixed_axes(1)),M(fixed_axes(2)), ...
    ' M6','FontWeight','bold');

text(A(fixed_axes(1)),A(fixed_axes(2)), ...
    ' A6','FontWeight','bold');

axis equal;
grid on;

xlabel(sprintf('Axis %d (mm)',fixed_axes(1)));
ylabel(sprintf('Axis %d (mm)',fixed_axes(2)));

title( ...
    'C12 Cable 6 - 3030 Profile Cross-section');

xlim([M(fixed_axes(1))-35, ...
      M(fixed_axes(1))+35]);

ylim([M(fixed_axes(2))-35, ...
      M(fixed_axes(2))+35]);

hold off;

%% Step 7 - 保存数据

output_dir = 'Prototype_M1_2_Output';

if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

writetable(T_result, ...
    fullfile(output_dir, ...
    'M1_2_Frame_Occupancy.csv'));

save(fullfile(output_dir, ...
    'M1_2_Frame_Occupancy.mat'), ...
    'T_result','profile_size');

exportgraphics(gcf, ...
    fullfile(output_dir, ...
    'C12_C6_Profile_CrossSection.png'), ...
    'Resolution',300);

fprintf('\nM1.2 occupancy analysis completed.\n');
fprintf('Results saved to: %s\n',output_dir);
