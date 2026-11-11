%% B5.1 Lesson 2.2
% Attachment Candidate Region Expansion
%
% Research Question:
% Does the original 40-point sampling restrict
% six-cable configuration optimisation?
%
% Goals:
% 1. Load original B1 attachment candidates
% 2. Generate 100 Fibonacci-sphere candidates
% 3. Verify sphere radius and unique coordinates
% 4. Compare minimum point distances
% 5. Visualise and save candidate sets
%

clear; clc; close all;

%% Step 1: Load original B1 attachment candidates

% 使用 B1 已有数据，不重新定义原始40点
load('B1_geometry_baseline.mat','geometry');

% 40个 attachment points
% 每行对应一个球面候选位置
r40 = geometry.attachment_candidates_body;

% 气球半径
rb = 50.8266;

% 检查原始候选数量
assert(isequal(size(r40),[40,3]));

fprintf('Original attachment candidates: %d\n', ...
    size(r40,1));

%% Step 2: Generate Fibonacci-sphere candidates

% 新的候选点数量
N = 100;

% Fibonacci Sphere使用的黄金角
golden_angle = pi*(3-sqrt(5));

% 点编号：0,1,...,99
i = (0:N-1)';

% 在球体Z轴方向均匀分配采样高度
% 使用 i+0.5 避免恰好放在南北极点
z = 1-2*(i+0.5)/N;

% 黄金角控制每个点绕Z轴旋转的角度
phi = i*golden_angle;

% 在XY平面上的归一化半径
rho = sqrt(1-z.^2);

% 计算球面三维坐标
% 每个点距球心的距离都应该等于rb
r100 = rb * [
    rho.*cos(phi), ...
    rho.*sin(phi), ...
    z
    ];

fprintf('Expanded attachment candidates: %d\n', ...
    size(r100,1));

%% Step 3: Numerical verification

% 检查新集合大小
assert(isequal(size(r100),[100,3]));

% 检查全部候选点位于球面上
radius = vecnorm(r100,2,2);

max_radius_error = max(abs(radius-rb));

assert(max_radius_error < 1e-9, ...
    'Some candidates are not on the sphere.');

% 检查坐标是否重复
assert(size(unique(round(r100,8),'rows'),1)==N);

fprintf('Maximum radius error: %.3e mm\n', ...
    max_radius_error);

%% Step 4: Calculate minimum point distances

% 分别比较旧40点和新100点的最小间距
candidate_sets = {r40,r100};
names = {'Original 40','Fibonacci 100'};

for k = 1:2

    r = candidate_sets{k};
    n = size(r,1);

    % 初始化为无穷大，逐对寻找最小距离
    min_distance = inf;

    for a = 1:n
        for b = a+1:n

            % 计算两球面点的三维弦长
            d = norm(r(a,:)-r(b,:));

            % 更新最小距离
            min_distance = min(min_distance,d);

        end
    end

    fprintf('%s minimum distance: %.4f mm\n', ...
        names{k},min_distance);

end

%% Step 5: Visualisation

figure('Color','w');

% 创建仅用于展示的单位球面
[Xs,Ys,Zs] = sphere(40);

for k = 1:2

    subplot(1,2,k);

    % 绘制半透明球体
    surf(rb*Xs,rb*Ys,rb*Zs, ...
        'FaceAlpha',0.08, ...
        'EdgeColor','none');

    hold on;

    % 当前候选点集合
    r = candidate_sets{k};

    % 绘制候选Attachment Points
    scatter3(r(:,1),r(:,2),r(:,3), ...
        35,'filled');

    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');

    title(names{k});

    axis equal;
    grid on;
    view(3);

    hold off;

end

%% Step 6: Save candidate sets

% 保存两套独立候选集合
% 不覆盖B1原始数据
save('B5_1_attachment_candidates.mat', ...
    'r40','r100','rb','N');

fprintf('\nAttachment candidate expansion completed.\n');

