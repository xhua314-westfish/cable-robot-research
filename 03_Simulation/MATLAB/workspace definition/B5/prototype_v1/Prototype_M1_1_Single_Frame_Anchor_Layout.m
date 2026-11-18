
%% Prototype V1 - M1.1
% Single-Frame Anchor Layout
%
% 研究目的：
% 保留原始理论Anchor坐标A_i，
% 在外侧建立单层3030实体机架，
% 计算Guide的参考安装位置M_i。
%
% 注意：
% 1. 本节是CAD前的初步几何模型。
% 2. 不修改Anchor、Attachment或Pairing。
% 3. 不代表真实Guide已经满足出线要求。

clear; clc; close all;

%% Step 1 - 设置计算边界

dims = [280 300 320];  % X,Y,Z方向，mm
half = dims/2;

% 3030铝型材截面尺寸
profile_size = 30;

% 计算边界到型材内侧表面的附加间隙
% 第一版先设置为0
mount_gap = 0;

% 型材中心线相对计算边界的外移量
offset = profile_size/2 + mount_gap;

% 简化外包络
outer_dims = dims + 2*(profile_size + mount_gap);

fprintf('\n=== M1.1 Single-Frame Layout ===\n');
fprintf('Computational size: %.1f x %.1f x %.1f mm\n',dims);
fprintf('Profile size: %.1f mm\n',profile_size);
fprintf('Additional gap: %.1f mm\n',mount_gap);
fprintf('Approx. outer size: %.1f x %.1f x %.1f mm\n',outer_dims);

%% Step 2 - 加载12条理论Rail

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

assert(isequal(size(rail_start),[12 3]));
assert(isequal(size(rail_end),[12 3]));

%% Step 3 - 读取之前的Anchor安装结果

csv_file = fullfile( ...
    'Prototype_V1_Mounting_Audit', ...
    'Prototype_V1_anchor_mounting.csv');

assert(isfile(csv_file), ...
    '找不到Lesson 1.2输出的Anchor CSV。');

T = readtable(csv_file);

design_names = unique(string(T.Design),'stable');

%% Step 4 - 对每个配置建立独立窗口

results = table();

for d = 1:numel(design_names)

    idx = find(string(T.Design)==design_names(d));

    assert(numel(idx)==6);

    Td = T(idx,:);

    % 按Cable编号排列
    [~,order] = sort(Td.CableID);
    Td = Td(order,:);

    A = zeros(6,3);
    M = zeros(6,3);
    guide_offset = zeros(6,1);

    %% 4.1 读取六个理论Anchor

    for i = 1:6

        rid = Td.RailID(i);
        t = Td.t_value(i);

        p0 = rail_start(rid,:);
        p1 = rail_end(rid,:);

        A(i,:) = p0 + t*(p1-p0);

        % 找出该Rail沿哪个坐标轴变化
        delta = p1-p0;
        varying_axis = find(abs(delta)>1e-8);

        assert(numel(varying_axis)==1, ...
            '当前Rail不是标准坐标轴方向。');

        fixed_axes = setdiff(1:3,varying_axis);

        % 12条理论Rail位于长方体边线上
        % 因此另外两个坐标等于正/负半尺寸
        for k = fixed_axes

            assert(abs(abs(A(i,k))-half(k))<1e-6, ...
                '理论Anchor不在预期的边线上。');

        end

        %% 4.2 计算单层实体框架参考安装位置

        M(i,:) = A(i,:);

        for k = fixed_axes

            % 在两个固定坐标方向向外偏移
            M(i,k) = A(i,k) + ...
                sign(A(i,k))*offset;

        end

        % 理论Anchor和安装参考位置之间的距离
        guide_offset(i) = norm(M(i,:)-A(i,:));

    end

    %% 4.3 绘图

    fig = figure( ...
        'Color','w', ...
        'Name',char(design_names(d)), ...
        'NumberTitle','off', ...
        'Position',[90+35*d 70+25*d 1100 760], ...
        'ToolBar','figure');

    ax = axes(fig);
    hold(ax,'on');

    % 画12条理论Rail
    for r = 1:12

        plot3(ax, ...
            [rail_start(r,1) rail_end(r,1)], ...
            [rail_start(r,2) rail_end(r,2)], ...
            [rail_start(r,3) rail_end(r,3)], ...
            '--','Color',[0.15 0.45 0.9], ...
            'LineWidth',1.2);

    end

    % 画单层3030实体型材
    for r = 1:12

        p0 = rail_start(r,:);
        p1 = rail_end(r,:);

        delta = p1-p0;
        k = find(abs(delta)>1e-8);
        fixed_axes = setdiff(1:3,k);

        % 实体梁中心位于理论边线外侧
        center = (p0+p1)/2;

        for j = fixed_axes
            center(j) = center(j) + ...
                sign(center(j))*offset;
        end

        % 为了在角部形成连续的概念框架，
        % 将梁的长度延伸到外侧型材中心线
        beam_lengths = profile_size*[1 1 1];

        beam_lengths(k) = dims(k)+2*offset;

        % 绘制长方体梁（非真实型材槽形）
        draw_beam(ax,center,beam_lengths);

    end

    % 显示理论Anchor和安装参考位置
    for i = 1:6

        % A_i: 理论Anchor（橙色）
        scatter3(ax, ...
            A(i,1),A(i,2),A(i,3), ...
            75,[0.95 0.4 0.1],'filled');

        % M_i: 型材安装参考位置（绿色）
        scatter3(ax, ...
            M(i,1),M(i,2),M(i,3), ...
            65,[0.1 0.65 0.3],'filled');

        % A-M之间的Guide占位线
        plot3(ax, ...
            [A(i,1) M(i,1)], ...
            [A(i,2) M(i,2)], ...
            [A(i,3) M(i,3)], ...
            '-','Color',[0.7 0.15 0.65], ...
            'LineWidth',2);

        text(ax, ...
            A(i,1),A(i,2),A(i,3), ...
            sprintf(' A%d',i), ...
            'FontSize',10,'FontWeight','bold');

        text(ax, ...
            M(i,1),M(i,2),M(i,3), ...
            sprintf(' M%d',i), ...
            'FontSize',9,'Color',[0 0.45 0.2]);

    end

    % 画原点
    plot3(ax,0,0,0,'k+', ...
        'MarkerSize',12,'LineWidth',1.5);

    axis(ax,'equal');
    grid(ax,'on');
    box(ax,'on');

    xlabel(ax,'X (mm)');
    ylabel(ax,'Y (mm)');
    zlabel(ax,'Z (mm)');

    title(ax, ...
        sprintf('%s | Single 3030 Frame',design_names(d)));

    view(ax,35,25);
    rotate3d(fig,'on');

    % 为图形留出余量
    xlim(ax,[-outer_dims(1)/2-25,outer_dims(1)/2+25]);
    ylim(ax,[-outer_dims(2)/2-25,outer_dims(2)/2+25]);
    zlim(ax,[-outer_dims(3)/2-25,outer_dims(3)/2+25]);

    hold(ax,'off');

    %% 4.4 保存每个Cable的参考数据

    Ti = table( ...
        repmat(design_names(d),6,1), ...
        Td.CableID, ...
        Td.RailID, ...
        A(:,1),A(:,2),A(:,3), ...
        M(:,1),M(:,2),M(:,3), ...
        guide_offset, ...
        'VariableNames',{ ...
            'Design','CableID','RailID', ...
            'Ax','Ay','Az', ...
            'Mx','My','Mz', ...
            'ReferenceGuideSpan_mm'});

    results = [results; Ti];

end

%% Step 5 - 打印结果

fprintf('\n=== Guide reference geometry ===\n');
disp(results);

fprintf('\nImportant:\n');
fprintf('M_i is a reference mounting location,\n');
fprintf('not a validated cable exit mechanism.\n');

%% Step 6 - 本节局部函数

function draw_beam(ax,center,dim)

    % 使用长方体代表3030型材的实体外包络
    % 不建立T-slot细节，也不模拟角码。

    h = dim/2;

    V = [
        -h(1) -h(2) -h(3);
         h(1) -h(2) -h(3);
         h(1)  h(2) -h(3);
        -h(1)  h(2) -h(3);
        -h(1) -h(2)  h(3);
         h(1) -h(2)  h(3);
         h(1)  h(2)  h(3);
        -h(1)  h(2)  h(3)
    ];

    V = V + center;

    F = [
        1 2 3 4;
        5 6 7 8;
        1 2 6 5;
        2 3 7 6;
        3 4 8 7;
        4 1 5 8
    ];

    patch(ax, ...
        'Vertices',V, ...
        'Faces',F, ...
        'FaceColor',[0.65 0.68 0.73], ...
        'FaceAlpha',0.17, ...
        'EdgeColor',[0.35 0.38 0.42], ...
        'LineWidth',0.6);

end
