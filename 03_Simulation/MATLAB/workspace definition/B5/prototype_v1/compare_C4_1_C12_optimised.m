%% C4-1 与 C12：优化后六绳配置的可视化比较
% 两张图均使用参考位姿 P = [0 0 0] mm，R = eye(3)。
% 因此，球体连接点的世界坐标在本图中等于其球体坐标。
% 所有长度单位均为 mm。
%
% 图中：方块 = 框架锚点 A；圆点 = 球体连接点 B；
%       C1–C6 = 绳编号；橙色 = 本轮调整过两端的绳。
%
% 直接运行整个脚本即可。脚本不清空工作区，也不关闭之前的图。

%% 1. 输入两套优化后的安装坐标
% 每行对应一根绳。第 i 行的 A 与第 i 行的 B 配对。

% ---- C4-1 主配置：A2 从角点沿 -X 移动 35 mm ----
A_C4plot = [
    -140,              -150,  -138.666666666667
     105,               150,  -160
       7.777777777778, -150,   160
     -28,               150,   160
     140,              -150,    76.444444444445
    -140,               150,  -131.555555555556
];

B_C4plot = [
     10.121011611978,  -36.235726370376,  -34.174267013668
     -4.021045781437,   38.219193049350,  -33.263609861831
     35.686490264326,   -6.538763291988,   35.595817939549
    -17.795663350404,    1.582215897020,   47.583129639971
     33.744269363747,  -37.876707336538,   -3.165848071079
    -14.675663653258,   47.367022690200,   11.150485431699
];

% ---- C12 备选配置：A6 从原位置沿 +Y 再移动 25 mm ----
A_C12plot = [
    -140,               -150,  -110.222222222222
     140,               -150,    32
      21.777777777778,  -150,   160
      -6.3,              150,   160
    -140,                 39,  -160
     140,               -115,  -160
];

B_C12plot = [
    -34.323838891278,    5.480860213669,  -37.083386073062
     45.883192580237,   -8.926820419061,  -19.959653890054
     40.296226321830,  -13.513475180117,   27.873704460229
     17.735663602806,   14.255031539523,   45.448691729634
    -45.926981036799,   -3.814424106308,  -21.436087542804
    -11.741317179965,  -47.549550673320,  -13.583996805242
];

%% 2. 核对配置身份：区分"本次移动量"和"最终端距"
anchorSets = {A_C4plot, A_C12plot};
bodySets   = {B_C4plot, B_C12plot};
changedIDs = [2, 6];

% 两个配置各自对应的框架角点，以及本次优化前的锚点位置
cornerPts = [140,  150, -160;     % C4-1 的角点
             140, -150, -160];    % C12 的角点

oldAnchorPts = [140,  150, -160;  % C4-1：原 A2 就在角点
                140, -140, -160]; % C12：原 A6 距角点 10 mm

finalAnchors = [A_C4plot(2,:); A_C12plot(6,:)];
shift_mm     = vecnorm(finalAnchors - oldAnchorPts, 2, 2);
endMargin_mm = vecnorm(finalAnchors - cornerPts,    2, 2);

assert(all(abs(shift_mm - [35;25]) < 1e-8), '两组新增退让量不符。');
assert(all(abs(endMargin_mm - 35) < 1e-8), '最终端距不符。');

% 从安装坐标核对球半径，保证两张图绘制同一尺寸的球。
allRadii = vecnorm([B_C4plot; B_C12plot], 2, 2);
ballRadius = mean(allRadii);
assert(max(abs(allRadii - ballRadius)) < 1e-6, ...
    '连接点没有落在同一半径的球面上，请核对坐标。');

%% 3. 构建两套配置共用的框架和画图参数
% 框架尺寸：X = 280，Y = 300，Z = 320 mm。
[xv,yv,zv] = ndgrid([-140 140],[-150 150],[-160 160]);
frameVertices = [xv(:), yv(:), zv(:)];

% 只有一个坐标不同的两个顶点构成一条框架边，共 12 条。
vertexPairs = nchoosek(1:8,2);
changedCoords = frameVertices(vertexPairs(:,1),:) ~= ...
                frameVertices(vertexPairs(:,2),:);
frameEdges = vertexPairs(sum(changedCoords,2)==1,:);
assert(size(frameEdges,1)==12);

[xs,ys,zs] = sphere(48);
frameColor  = [0.72 0.75 0.78];
cableColor  = [0.13 0.34 0.48];
editedColor = [0.86 0.32 0.08];
sphereColor = [0.56 0.79 0.86];

configNames = ["C4-1 | Primary configuration", ...
               "C12 | Backup configuration"];
railNames   = ["Rail 6", "Rail 10"];

% 按当前屏幕大小创建窗口，避免固定像素尺寸超出可用桌面。
figCompare = figure('Color','w', ...
    'Name','C4-1 and C12 | Optimised configurations', ...
    'NumberTitle','off','Units','normalized', ...
    'Position',[0.04 0.12 0.92 0.76]);

% 两个子图之间和窗口边缘留出空白，供标题和坐标轴使用。
layoutCompare = tiledlayout(figCompare,1,2, ...
    'TileSpacing','loose','Padding','loose');

title(layoutCompare,'Optimised six-cable configurations', ...
    'FontSize',16,'FontWeight','bold');
subtitle(layoutCompare, ...
    'Reference pose: P = [0, 0, 0] mm  |  Roll, pitch, yaw = 0°', ...
    'FontSize',11);

axCompare = gobjects(1,2);

%% 4. 使用同一套绘图代码并排展示
for k = 1:2
    ax = nexttile(layoutCompare);
    axCompare(k) = ax;
    hold(ax,'on');

    A = anchorSets{k};
    B = bodySets{k};
    editedID = changedIDs(k);

    % 4.1 框架
    for e = 1:size(frameEdges,1)
        vtx = frameVertices(frameEdges(e,:),:);
        plot3(ax,vtx(:,1),vtx(:,2),vtx(:,3),'-', ...
            'Color',frameColor,'LineWidth',1);
    end

    % 4.2 球体
    surf(ax,ballRadius*xs,ballRadius*ys,ballRadius*zs, ...
        'FaceColor',sphereColor,'FaceAlpha',0.20,'EdgeColor','none');

    % 4.3 六条绳与安装端点。橙色只代表本轮修改过的绳。
    for i = 1:6
        col = cableColor;
        lineWidth = 1.6;
        if i == editedID
            col = editedColor;
            lineWidth = 3.2;
        end

        pts = [B(i,:); A(i,:)];
        plot3(ax,pts(:,1),pts(:,2),pts(:,3),'-', ...
            'Color',col,'LineWidth',lineWidth);

        plot3(ax,A(i,1),A(i,2),A(i,3),'s', ...
            'Color',col,'MarkerFaceColor',col,'MarkerSize',6);
        plot3(ax,B(i,1),B(i,2),B(i,3),'o', ...
            'Color',col,'MarkerFaceColor',col,'MarkerSize',5);

        % 按“配置 × 绳号”设置标签沿绳的位置。
        % 0 对应球端 B，1 对应框架端 A。
        labelFraction = [0.68 0.67 0.66 0.70 0.80 0.72;    % C4-1
            0.64 0.67 0.70 0.70 0.66 0.66];   % C12

        labelPt = B(i,:) + labelFraction(k,i)*(A(i,:)-B(i,:));

        % 默认将文字略微抬离绳线。左图 C5、C6 在当前投影中容易重合，
        % 分别向上、向下错开，同时用细引线指出标签属于哪根绳。
        offset = [0 0 5];
        if k == 1 && i == 5
            offset = [0 0 15];
        elseif k == 1 && i == 6
            offset = [0 0 -15];
        end
        textPt = labelPt + offset;

        plot3(ax,[labelPt(1) textPt(1)], ...
            [labelPt(2) textPt(2)], ...
            [labelPt(3) textPt(3)], ...
            '-','Color',col,'LineWidth',0.6);

        text(ax,textPt(1),textPt(2),textPt(3),sprintf('C%d',i), ...
            'Color',col,'FontWeight','bold','FontSize',10, ...
            'HorizontalAlignment','center','VerticalAlignment','middle', ...
            'BackgroundColor','w','Margin',0.5);

        % 标出被调整的两个端点，减少球面附近标签重叠。
        if i == editedID
            text(ax,A(i,1),A(i,2),A(i,3),sprintf(' A%d',i), ...
                'Color',col,'FontWeight','bold','VerticalAlignment','top');
            text(ax,B(i,1),B(i,2),B(i,3),sprintf(' B%d',i), ...
                'Color',col,'FontWeight','bold','VerticalAlignment','bottom');
        end
    end

    % 4.4 黑色虚线表示角点至最终锚点的 35 mm 导轨段。
    marginLine = [cornerPts(k,:); A(editedID,:)];
    hMargin = plot3(ax,marginLine(:,1),marginLine(:,2),marginLine(:,3), ...
        'k--','LineWidth',2);
    plot3(ax,cornerPts(k,1),cornerPts(k,2),cornerPts(k,3),'kd', ...
        'MarkerFaceColor','w','MarkerSize',6);

    % 等比例显示真实几何，并在框架周围预留空间。
    daspect(ax,[1 1 1]);
    xlim(ax,[-180 180]);
    ylim(ax,[-190 190]);
    zlim(ax,[-200 200]);

    % 两图采用相同的正交投影。让 MATLAB 按各自子图的实际大小取景。
    view(ax,38,23);
    camproj(ax,'orthographic');
    ax.CameraViewAngleMode = 'auto';

    % 实体框架已经画出了 12 条导轨，淡化背景网格，减少双层方框。
    grid(ax,'on');
    box(ax,'off');
    ax.GridAlpha = 0.10;
    ax.FontSize = 9;
    ax.XTick = -100:100:100;
    ax.YTick = -100:100:100;
    ax.ZTick = -100:100:100;

    xlabel(ax,'X (mm)');
    ylabel(ax,'Y (mm)');
    zlabel(ax,'Z (mm)');

    title(ax,{char(configNames(k)), ...
        sprintf('A%d: +%.0f mm on %s  |  Final end margin: %.0f mm', ...
        editedID,shift_mm(k),char(railNames(k)),endMargin_mm(k))}, ...
        'FontSize',11);

    % 图例显式绑定句柄，不把 12 条框架边重复列入。
    hAnchor = plot3(ax,NaN,NaN,NaN,'ks','MarkerFaceColor','k');
    hAttach = plot3(ax,NaN,NaN,NaN,'ko','MarkerFaceColor','k');
    legend(ax,[hAnchor,hAttach,hMargin], ...
        {'Frame anchor','Balloon attachment','35 mm to rail end'}, ...
        'Location','northwest','FontSize',8);
end

% 拖动其中一张图时，另一张跟随旋转；保留句柄以维持同步。
cameraLink = linkprop(axCompare, ...
    {'CameraPosition','CameraTarget','CameraUpVector','CameraViewAngle'});
setappdata(figCompare,'CameraLink',cameraLink);
rotate3d(figCompare,'on');

%% 5. 打印同一测试集上的对比指标
% 以下数值摘自两版已完成的 MATLAB 验证。
% 上图显示参考位姿，表中最差值则取自全部 539 个测试位姿。
comparison = table( ...
    ["C4-1"; "C12"], ...
    shift_mm, endMargin_mm, ...
    [0.590864763; 0.509011990], ...
    [17; 61], ...
    [37.254606; 13.566554], ...
    [13.7606; 5.9769], ...
    [3563; 3563], ...
    'VariableNames',{'Configuration','AdditionalShift_mm','EndMargin_mm', ...
    'WorstSigma539','WorstSigmaPose','MinGap539_mm', ...
    'MinOutAngle539_deg','ContinuousPathsPassed'});

disp(comparison);