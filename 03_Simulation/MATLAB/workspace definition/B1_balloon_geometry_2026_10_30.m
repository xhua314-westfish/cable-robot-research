%% B1.1-B1.2 Gastric boundary and balloon geometry
clear;clc;close all;

%% 1. Engineering gastric boundary (mm)
Lg = 280;   % X - Length
Wg = 300;   % Y - Width
Hg = 320;   % Z - Height

%% 2. Balloon parameters
V_balloon_ml = 550;
V_balloon = V_balloon_ml * 1000; % mm^3

r_balloon = (3*V_balloon/(4*pi))^(1/3);
D_balloon = 2*r_balloon;

%% 3. Cuboid vertices
% 长方体边界顶点与棱边构建
xlim_box = [-Lg/2, Lg/2];
ylim_box = [-Wg/2, Wg/2];
zlim_box = [-Hg/2, Hg/2];

%构建 8 × 3 矩阵，定义长方体 8 个顶点的 (x, y, z)坐标：
vertices = [
    xlim_box(1) ylim_box(1) zlim_box(1);
    xlim_box(2) ylim_box(1) zlim_box(1);
    xlim_box(2) ylim_box(2) zlim_box(1);
    xlim_box(1) ylim_box(2) zlim_box(1);
    xlim_box(1) ylim_box(1) zlim_box(2);
    xlim_box(2) ylim_box(1) zlim_box(2);
    xlim_box(2) ylim_box(2) zlim_box(2);
    xlim_box(1) ylim_box(2) zlim_box(2)
    ];

% 定义 12 × 2 矩阵，存储长方体 12 条棱边的端点索引对
edges = [
    1 2; 2 3; 3 4; 4 1;
    5 6; 6 7; 7 8; 8 5;
    1 5; 2 6; 3 7; 4 8
    ];

%% 4. Balloon sphere at the origin
P = [0; 0; 0];

% 生成 50 × 50 密度的标准单位球体（半径为 1，圆心在原点）的三维网格坐标矩阵 
[Xs,Ys,Zs] = sphere(50);

% MATLAB 的 sphere(50) 函数只能生成一个标准单位球（半径 $R = 1$，圆心在原点）的网格坐标。
% 如果不进行放缩，画出来的球体半径只有 1 mm。
Xs = r_balloon*Xs + P(1);
Ys = r_balloon*Ys + P(2);
Zs = r_balloon*Zs + P(3);

%% 5. Visualization
figure('Color','w');
hold on;

% Cuboid wireframe
for i = 1:size(edges,1)
    ids = edges(i,:);
    plot3(vertices(ids,1), ...
          vertices(ids,2), ...
          vertices(ids,3), ...
          'k-', 'LineWidth',1.3);
end

% Balloon surface
hBalloon = surf(Xs,Ys,Zs, ...
    'FaceColor',[0.2 0.55 0.9], ...
    'FaceAlpha',0.65, ...
    'EdgeColor','none');

% Balloon centre
hCentre = plot3(P(1),P(2),P(3), ...
    'r.', 'MarkerSize',20);

xlabel('Length X (mm)');
ylabel('Width Y (mm)');
zlabel('Height Z (mm)');

title('B1: Gastric Boundary and 550 mL Balloon');

legend([hBalloon,hCentre], ...
    {'Rigid spherical balloon','Balloon centre'}, ...
    'Location','northeast');

axis equal;
xlim(xlim_box);
ylim(ylim_box);
zlim(zlim_box);
grid on;
view(35,25);
hold off;

%% B1.3 Geometrically feasible balloon-centre region

%% 1. Calculate feasible centre limits
clearance = 0;  % mm

centre_limit = [Lg; Wg; Hg]/2 ...
    - r_balloon - clearance;

assert(all(centre_limit >= 0), ...
    'The balloon cannot fit inside the boundary.');

fprintf('\n--- B1.3 Centre Feasible Region ---\n');
fprintf('X: +/- %.2f mm\n', centre_limit(1));
fprintf('Y: +/- %.2f mm\n', centre_limit(2));
fprintf('Z: +/- %.2f mm\n', centre_limit(3));

%% 2. Generate sample centre positions
step = 10;  % mm

x_values = -Lg/2:step:Lg/2;
y_values = -Wg/2:step:Wg/2;
z_values = -Hg/2:step:Hg/2;

[X,Y,Z] = ndgrid(x_values, y_values, z_values);

points = [X(:), Y(:), Z(:)];

%% 3. Full sphere-containment test
mask_feasible = ...
    abs(points(:,1)) <= centre_limit(1) & ...
    abs(points(:,2)) <= centre_limit(2) & ...
    abs(points(:,3)) <= centre_limit(3);

feasible_points = points(mask_feasible,:);
infeasible_points = points(~mask_feasible,:);

fprintf('Total sampled centres: %d\n', size(points,1));
fprintf('Feasible centres: %d\n', size(feasible_points,1));
fprintf('Infeasible centres: %d\n', size(infeasible_points,1));

%% 4. Verify every retained centre
assert(all(abs(feasible_points) <= centre_limit.' + 1e-9, 'all'), ...
    'Containment verification failed.');

%% 5. Visualise sampled feasible region
figure('Color','w');
hold on;

h1 = scatter3(feasible_points(:,1), ...
    feasible_points(:,2), ...
    feasible_points(:,3), ...
    10, [0.15 0.65 0.45], 'filled');

% Show infeasible positions with low density
h2 = scatter3(infeasible_points(1:10:end,1), ...
    infeasible_points(1:10:end,2), ...
    infeasible_points(1:10:end,3), ...
    5, [0.8 0.8 0.8], 'filled');

xlabel('Length X (mm)');
ylabel('Width Y (mm)');
zlabel('Height Z (mm)');

title('B1.3: Geometrically Feasible Balloon Centres');

legend([h1,h2], ...
    {'Feasible centres','Infeasible centres (sampled)'}, ...
    'Location','northeastoutside');

axis equal;
grid on;
view(35,25);
hold off;

%% B1.4 - Anchor Region Definition
% Candidate anchors on the six boundary faces

%% 1. Boundary dimensions (mm)
% Reuse Lg, Wg, Hg from B1.1
% Lg = 280; Wg = 300; Hg = 320;
hx = Lg/2;
hy = Wg/2;
hz = Hg/2;

%% 2. Sampling resolution
n_face = 3;
%设定每个面采样数为3

x_sample = linspace(-hx,hx,n_face);
y_sample = linspace(-hy,hy,n_face);
z_sample = linspace(-hz,hz,n_face);
% 在 X 轴范围 [-hx, hx] 内生成 3 个等间距坐标（其中 hx 为 X 轴的半长 $L_f/2$）。

%% 3. Generate candidate points
A = [];

% X faces: x = +/- hx
[Y,Z] = meshgrid(y_sample,z_sample);
% 利用前面生成的 y_sample（3个点）和 z_sample（3个点），
% 构建 Y-Z 平面上的二维网格。

% 利用长方体的轴对称性，
% 一次性生成外部框架在某一轴向上"正向"与"负向"两个平行外表面
% （如 $+X$ 面与 $-X$ 面）的所有候选锚点坐标。
for sx = [-1,1]
    %控制循环运行两次
    % -1 表示-x面 

    A_face = [
        sx*hx*ones(numel(Y),1), ...
        Y(:), Z(:) 
        ];
    % numel(Y)：计算矩阵 Y 中的元素总个数。
    % 如果 Y 是 3 * 3$的网格矩阵，numel(Y) 的结果就是9
    % 生成一个 9 * 1 的列向量
    % 将全 1 向量乘以当前的标量坐标（例如当 sx = -1 时乘 -h_x）

    A = [A; A_face];
    % 分号 ; 的作用：在 MATLAB 矩阵拼接中，分号表示纵向/向下追加（Vertical Concatenation）。
end

% Y faces: y = +/- hy
[X,Z] = meshgrid(x_sample,z_sample);

for sy = [-1,1]
    A_face = [
        X(:), ...
        sy*hy*ones(numel(X),1), Z(:)
        ];
    A = [A; A_face];
end

% Z faces: z = +/- hz
[X,Y] = meshgrid(x_sample,y_sample);

for sz = [-1,1]
    A_face = [
        X(:), Y(:), ...
        sz*hz*ones(numel(X),1)
        ];
    A = [A; A_face];
end

%% 4. Remove duplicate points
A = unique(A,'rows','stable');

fprintf('\n--- B1.4 Anchor Candidates ---\n');
fprintf('Sampling per face: %d x %d\n',n_face,n_face);
fprintf('Unique candidate points: %d\n',size(A,1));

%% 5. Verify anchor locations
tol = 1e-9;

on_boundary = ...
    abs(abs(A(:,1))-hx)<tol | ...
    abs(abs(A(:,2))-hy)<tol | ...
    abs(abs(A(:,3))-hz)<tol;

inside_limits = ...
    abs(A(:,1))<=hx+tol & ...
    abs(A(:,2))<=hy+tol & ...
    abs(A(:,3))<=hz+tol;

assert(all(on_boundary & inside_limits), ...
    'Some anchors do not lie on the boundary.');

assert(size(unique(A,'rows'),1)==size(A,1), ...
    'Duplicate anchor points detected.');

%% 6. Visualisation
figure('Color','w');
hold on;

% Use original boundary vertices and edges
for k = 1:size(edges,1)
    ids = edges(k,:);
    plot3(vertices(ids,1), ...
        vertices(ids,2), ...
        vertices(ids,3), ...
        'k-', 'LineWidth',1.1);
end

% Anchor candidate points
hA = scatter3(A(:,1),A(:,2),A(:,3), ...
    55,[0.95 0.45 0.10],'filled');

% Balloon at origin
hB = surf(Xs,Ys,Zs, ...
    'FaceColor',[0.2 0.55 0.9], ...
    'FaceAlpha',0.3, ...
    'EdgeColor','none');

xlabel('Length X (mm)');
ylabel('Width Y (mm)');
zlabel('Height Z (mm)');
title('B1.4: Candidate Anchor Points');

legend([hA,hB], ...
    {'Anchor candidates','550 mL balloon'}, ...
    'Location','northeastoutside');

axis equal;
xlim([-hx hx]);
ylim([-hy hy]);
zlim([-hz hz]);
grid on;
view(35,25);
hold off;

%% B1.5 Candidate Attachment Regions
% Attachment points in the balloon BODY frame

%% 1. Spherical surface sampling
azimuth_deg = 0:45:315;
elevation_deg = -60:30:60;
%theta：Azimuth，方位角。
%phi：Elevation，仰角。

% 这是用于验证程序的初始粗采样方案，不是最优 Attachment 数量或分布。
% 它暂时避开两个极点，以免多个方位角对应同一个位置。它也不是严格的等面积球面采样。

[AZ,EL] = meshgrid(azimuth_deg,elevation_deg);

az = deg2rad(AZ(:));
%利用单冒号将 5 * 8 矩阵打平展成 40 * 1的列向量。
el = deg2rad(EL(:));

%% 2. Local attachment coordinates
r_candidates = r_balloon * [
    cos(el).*cos(az), ...
    cos(el).*sin(az), ...
    sin(el)
    ];
%根据球坐标到直角坐标的转化公式计算候选点坐标：
% x = r_balloon *cos(phi) *cos(theta)
% y = r_balloon *cos(phi) sin(theta)
% z = r_balloon *sin(phi)

%% 3. Numerical verification
radius_check = vecnorm(r_candidates,2,2);

radius_error = max(abs(radius_check-r_balloon));

assert(radius_error < 1e-9, ...
    'Some attachment points are not on the sphere.');

assert(size(unique(round(r_candidates,8),'rows'),1) ...
    == size(r_candidates,1), ...
    'Duplicate attachment candidates found.');

fprintf('\n--- B1.5 Attachment Candidates ---\n');
fprintf('Candidate points: %d\n',size(r_candidates,1));
fprintf('Maximum radius error: %.3e mm\n',radius_error);

%% 4. Initial balloon pose
P = [0;0;0];
R = eye(3);

% Convert BODY coordinates to WORLD coordinates
B_world = (R*r_candidates.' + P).';

%% 5. Visualisation
figure('Color','w');
hold on;

hSphere = surf(Xs,Ys,Zs, ...
    'FaceColor',[0.25 0.55 0.9], ...
    'FaceAlpha',0.25, ...
    'EdgeColor','none');

hAttach = scatter3( ...
    B_world(:,1),B_world(:,2),B_world(:,3), ...
    45,[0.1 0.7 0.35],'filled');

hCentre = plot3(P(1),P(2),P(3), ...
    'r.','MarkerSize',18);

xlabel('Body X (mm)');
ylabel('Body Y (mm)');
zlabel('Body Z (mm)');

title('B1.5: Candidate Attachment Points');

legend([hSphere,hAttach,hCentre], ...
    {'Rigid balloon','Attachment candidates','Centre'}, ...
    'Location','northeastoutside');

axis equal;
grid on;
view(35,25);
hold off;

%% B1.6 Geometry Integration and Verification

%% 1. Initialise pose
P = [0;0;0];
R = eye(3);

% Body-frame attachments -> World-frame positions
B_world = (R*r_candidates.' + P).';

%% 2. Verify geometry
tol = 1e-8;

% Anchor points on boundary
anchor_valid = ...
    (abs(abs(A(:,1))-Lg/2)<tol | ...
    abs(abs(A(:,2))-Wg/2)<tol | ...
    abs(abs(A(:,3))-Hg/2)<tol) & ...
    all(abs(A) <= [Lg Wg Hg]/2+tol,2);

assert(all(anchor_valid));

% Attachment points on sphere
assert(all(abs(vecnorm(r_candidates,2,2) ...
    -r_balloon)<tol));

% Entire sphere inside gastric boundary
centre_limit = [Lg;Wg;Hg]/2-r_balloon;
assert(all(abs(P)<=centre_limit+tol));

% Verify coordinate transformation
assert(max(vecnorm(B_world-P.'- ...
    (R*r_candidates.').',2,2))<tol);

%% 3. Plot integrated geometry
figure('Color','w');
hold on;

% Gastric boundary
for k = 1:size(edges,1)
    ids = edges(k,:);
    plot3(vertices(ids,1), ...
        vertices(ids,2), ...
        vertices(ids,3), ...
        'k-', 'LineWidth',1.0);
end

% Balloon
hBalloon = surf(Xs,Ys,Zs, ...
    'FaceColor',[0.2 0.55 0.9], ...
    'FaceAlpha',0.22, ...
    'EdgeColor','none');

% Candidate anchors
hA = scatter3(A(:,1),A(:,2),A(:,3), ...
    40,[0.95 0.45 0.1],'filled');

% Candidate attachments
hB = scatter3(B_world(:,1), ...
    B_world(:,2),B_world(:,3), ...
    35,[0.1 0.65 0.3],'filled');

% Balloon centre
hP = scatter3(P(1),P(2),P(3), ...
    65,'r','filled');

xlabel('Length X (mm)');
ylabel('Width Y (mm)');
zlabel('Height Z (mm)');
title('B1.6: Integrated Geometry Model');

legend([hBalloon,hA,hB,hP], ...
    {'Balloon','Anchor candidates', ...
    'Attachment candidates','Centre'}, ...
    'Location','northeastoutside');

axis equal;
xlim([-Lg/2,Lg/2]);
ylim([-Wg/2,Wg/2]);
zlim([-Hg/2,Hg/2]);
grid on;
view(35,25);

%% 4. Save geometry dataset
geometry.Lg = Lg;
geometry.Wg = Wg;
geometry.Hg = Hg;

geometry.balloon_volume_ml = V_balloon_ml;
geometry.balloon_radius = r_balloon;
geometry.clearance = 0;

geometry.anchor_candidates = A;
geometry.attachment_candidates_body = r_candidates;
geometry.centre_limit = centre_limit;

% 0=not clinically validated;
% boundary and mounting geometry are engineering assumptions

save('B1_geometry_baseline.mat','geometry');

fprintf('\n--- B1.6 Verification ---\n');
fprintf('Boundary: %.0f x %.0f x %.0f mm\n',Lg,Wg,Hg);
fprintf('Balloon radius: %.3f mm\n',r_balloon);
fprintf('Anchor candidates: %d\n',size(A,1));
fprintf('Attachment candidates: %d\n',size(r_candidates,1));
fprintf('Geometry verification passed.\n');