%% C12 第 3 步：定位保证下界最低的路径，以及实际检查到的最近绳对
% 输入：工作区中已存在 reportC12 和 resultC12
% 每一类运动分别找两条记录：
%   ① 哪条路径的整段保证下界最低？
%   ② 哪条路径在已检查中点上出现了最小绳距？

motion = reportC12.summary.Motion;
gapFloor = resultC12.clearanceFloor_mm;
nTypes = numel(motion);

% 表一：按整段保证下界选路径
boundStart = zeros(nTypes,1);
boundEnd   = zeros(nTypes,1);
lowerGap   = zeros(nTypes,1);
midGapOnBoundPath = zeros(nTypes,1);

% 表二：按实际计算的中点绳距选路径
midStart = zeros(nTypes,1);
midEnd   = zeros(nTypes,1);
fraction = zeros(nTypes,1);
cableI   = zeros(nTypes,1);
cableJ   = zeros(nTypes,1);
midGap   = zeros(nTypes,1);

for k = 1:nTypes
    T = reportC12.paths{k};
    assert(all(T.Status == "Pass"), '第 %d 类存在未通过路径。', k);

    % 找出整段保证下界最低的路径
    [lowerGap(k), iBound] = min(T.GapLowerBound_mm);
    boundStart(k) = T.StartPose(iBound);
    boundEnd(k)   = T.EndPose(iBound);
    midGapOnBoundPath(k) = T.MinCheckedGap_mm(iBound);

    % 独立找出实际检查中点距离最小的路径及绳对
    [midGap(k), iMid] = min(T.MinCheckedGap_mm);
    midStart(k) = T.StartPose(iMid);
    midEnd(k)   = T.EndPose(iMid);
    fraction(k) = T.PathFraction(iMid);
    cableI(k)   = T.CableI(iMid);
    cableJ(k)   = T.CableJ(iMid);
end

% 直接用 MATLAB 保存的全精度下界计算保证余量
boundTable = table(motion, boundStart, boundEnd, lowerGap, ...
    lowerGap-gapFloor, midGapOnBoundPath, ...
    'VariableNames', {'Motion','StartPose','EndPose','LowerBound_mm', ...
    'MarginAboveFloor_mm','MinCheckedMidGap_mm'});

midTable = table(motion, midStart, midEnd, fraction, cableI, cableJ, midGap, ...
    'VariableNames', {'Motion','StartPose','EndPose','PathFraction', ...
    'CableI','CableJ','MinCheckedMidGap_mm'});

format long g
disp('表一：每类运动中，整段保证下界最低的路径');
disp(boundTable);

disp('表二：每类运动中，已检查中点距离最小的绳对');
disp(midTable);

%% C12 Step 4：加密两条代表路径，计算最小绳距的上下界
% 前置：工作区已有 resultC12 和 reportC12。
% 距离单位 mm；路径进度 t 从 0 到 1。
% 本节只细化绳–绳距离，绳–球检查沿用前一步的通过结果。

assert(exist('B3_1_segment_distance_3d_2026_11_02','file') == 2, ...
    '请先将 C4 阶段使用的有限线段距离函数所在文件夹加入 MATLAB 路径。');

%% 1. 恢复已经验证的 C12 配置和同一组位姿
dataDir = fileparts(which('verify_C12_25mm'));
V4 = load(fullfile(dataDir,'B5_4_E2_539pose_verification.mat'), ...
          'P_eval','R_eval');

sel4 = reportC12.selected;
A4 = resultC12.A;
r4 = resultC12.r;
A4(6,:) = sel4.A6_mm;
r4(6,:) = sel4.B6_mm;

assert(norm(A4(6,:) - [140 -115 -160]) < 1e-6, ...
    '当前配置与 C12 新增退让 25 mm 的候选不符。');

radius4 = max(vecnorm(r4,2,2));
pairs4 = nchoosek(1:6,2);      % 全部 15 对绳都参加，允许最近绳对变化
targetWidth = 0.05;            % 最小绳距区间的目标宽度，mm
targets4 = [130 455; 174 382];
bridge4 = reportC12.paths{4};  % 两条目标路径都属于额外样本连接

nTargets = size(targets4,1);
lower4 = zeros(nTargets,1);
upper4 = zeros(nTargets,1);
bestT4 = zeros(nTargets,1);
bestPair4 = zeros(nTargets,2);
intervals4 = zeros(nTargets,1);

%% 2. 对每条路径自动选取足够密的采样间隔
for k = 1:nTargets
    q0 = targets4(k,1);
    q1 = targets4(k,2);

    old = bridge4(bridge4.StartPose==q0 & bridge4.EndPose==q1,:);
    assert(height(old)==1 && old.Status=="Pass", ...
        '在上一轮报告中没有找到唯一的已通过路径。');

    P0 = V4.P_eval(q0,:);
    dp = V4.P_eval(q1,:) - P0;
    travel = norm(dp);
    R0 = V4.R_eval(:,:,q0);
    R1 = V4.R_eval(:,:,q1);

    % 与前一步一致：球心直线移动，姿态沿最短轴角旋转。
    Q = R0.'*R1;
    axisSin = 0.5*[Q(3,2)-Q(2,3);
                   Q(1,3)-Q(3,1);
                   Q(2,1)-Q(1,2)];
    sinTheta = norm(axisSin);
    cosTheta = max(-1,min(1,(trace(Q)-1)/2));
    theta = atan2(sinTheta,cosTheta);
    assert(sinTheta > 1e-12,'这两条指定路径应有可识别的旋转轴。');

    v = axisSin/sinTheta;
    K = [0,-v(3),v(2); v(3),0,-v(1); -v(2),v(1),0];
    K2 = K*K;

    % 分成 n 段后，任意位置距最近采样点最多半个步长。
    % 两根绳合计可能靠近的距离最多为
    % travel/n + 4*radius4*sin(theta/(4*n))。
    % 利用 sin(x)<=x，选择使该界限不超过 targetWidth 的 n。
    n = max(1,ceil((travel + radius4*theta)/targetWidth));

    % 取 4 的倍数，使旧报告中的 t=0.75 也落在采样网格上。
    n = 4*ceil(n/4);
    intervals4(k) = n;
    tGrid = (0:n)'/n;          % 同时包含起点和终点

    gapCurve = inf(n+1,1);
    pairIndex = zeros(n+1,1);

    for m = 1:numel(tGrid)
        tNow = tGrid(m);
        phi = tNow*theta;
        Rnow = R0*(eye(3)+sin(phi)*K+(1-cos(phi))*K2);
        Pnow = P0+tNow*dp;
        Bnow = (Rnow*r4.').' + Pnow;

        for j = 1:size(pairs4,1)
            i1 = pairs4(j,1);
            i2 = pairs4(j,2);
            d = B3_1_segment_distance_3d_2026_11_02( ...
                Bnow(i1,:),A4(i1,:),Bnow(i2,:),A4(i2,:));
            assert(isfinite(d),'线段距离计算出现非有限值。');
            if d < gapCurve(m)
                gapCurve(m) = d;
                pairIndex(m) = j;
            end
        end
    end

    % 旧报告的已查中点也是有效采样；保留两轮中更紧的界限。
    [sampleMin,mBest] = min(gapCurve);
    motionAllowance = travel/n + 4*radius4*sin(theta/(4*n));
    lower4(k) = max(old.GapLowerBound_mm, sampleMin-motionAllowance);
    upper4(k) = sampleMin;
    bestT4(k) = tGrid(mBest);
    bestPair4(k,:) = pairs4(pairIndex(mBest),:);

    if old.MinCheckedGap_mm < upper4(k)
        upper4(k) = old.MinCheckedGap_mm;
        bestT4(k) = old.PathFraction;
        bestPair4(k,:) = [old.CableI,old.CableJ];
    end

    assert(lower4(k) <= upper4(k)+1e-8 && ...
           upper4(k)-lower4(k) <= targetWidth+1e-8, ...
           '上下界未达到预期，请核对配置和距离计算。');
end

%% 3. 输出两条路径各自的结果
refined4 = table(targets4(:,1),targets4(:,2),intervals4,lower4,upper4, ...
    upper4-lower4,lower4-resultC12.clearanceFloor_mm, ...
    bestT4,bestPair4(:,1),bestPair4(:,2), ...
    'VariableNames',{'StartPose','EndPose','Intervals','Lower_mm','Upper_mm', ...
    'Width_mm','GuaranteedMargin_mm','BestSampleT','CableI','CableJ'});

format short g
disp(refined4);

%% C12 Step 5：Pose 382 的完整构型与 Cable 1–5 最近距离
% 前置：已运行第 4 步，工作区中有 A4、r4、V4。
% A4：六个框架锚点；r4：六个球体连接点；单位 mm。

%% 1. 恢复 Pose 382 的真实几何
poseID = 382;
P5 = V4.P_eval(poseID,:);
R5 = V4.R_eval(:,:,poseID);
B5world = (R5*r4.').' + P5;

% 按 R = Rz(yaw)*Ry(pitch)*Rx(roll) 提取显示用角度。
roll5  = atan2d(R5(3,2), R5(3,3));
pitch5 = atan2d(-R5(3,1), hypot(R5(1,1),R5(2,1)));
yaw5   = atan2d(R5(2,1), R5(1,1));

%% 2. 找出 Cable 1 与 Cable 5 上的最近点
% 用 s、t 表示各自绳上的位置：0 = 球端 B，1 = 框架端 A。
% 有限线段的最近点可能位于端点，也可能同时位于两条绳内部。
b1 = B5world(1,:);  a1 = A4(1,:);
b5 = B5world(5,:);  a5 = A4(5,:);
u = a1-b1;
v = a5-b5;
uu = dot(u,u);
vv = dot(v,v);
assert(uu > 0 && vv > 0, '检测到零长度绳段。');

% 四种端点情形：把一根绳的端点投影到另一根有限绳段。
st = [0, dot(b1-b5,v)/vv;
      1, dot(a1-b5,v)/vv;
      dot(b5-b1,u)/uu, 0;
      dot(a5-b1,u)/uu, 1];
st = max(0,min(1,st));

% 两根绳内部的公共垂线情形。
normal = cross(u,v);
den = dot(normal,normal);
if den > 0
    sInterior = dot(cross(b5-b1,v),normal)/den;
    tInterior = dot(cross(b5-b1,u),normal)/den;
    if all([sInterior,tInterior] >= 0 & [sInterior,tInterior] <= 1)
        st(end+1,:) = [sInterior,tInterior];
    end
end

points1 = b1 + st(:,1).*u;
points5 = b5 + st(:,2).*v;
[gap5,idx5] = min(vecnorm(points1-points5,2,2));
near1 = points1(idx5,:);
near5 = points5(idx5,:);

% 核对画出来的距离与前面验证使用的距离函数一致。
gapCheck = B3_1_segment_distance_3d_2026_11_02(b1,a1,b5,a5);
assert(abs(gap5-gapCheck) < 1e-6, '最近点与原距离函数结果不一致。');

attachGap5 = norm(b1-b5);
fprintf('Pose %d：Cable 1–5 最近距离 = %.6f mm\n',poseID,gap5);
fprintf('B1–B5 连接点中心距 = %.6f mm\n',attachGap5);
fprintf('最近点距各自球端：沿 Cable 1 为 %.3f mm，沿 Cable 5 为 %.3f mm。\n', ...
    norm(near1-b1),norm(near5-b5));

%% 3. 左图画完整构型，右图放大球端与最近点
figure('Color','w','Name','C12 | Pose 382','Position',[100 100 1200 600]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

% 两张图用同一套颜色。蓝色为 Cable 1，橙色为 Cable 5。
col1 = [0.00 0.35 0.70];
col5 = [0.85 0.33 0.08];
otherCol = [0.62 0.65 0.68];
gapCol = [0.45 0.12 0.55];

% 框架顶点和 12 条导轨。
[xv,yv,zv] = ndgrid([-140 140],[-150 150],[-160 160]);
vertices = [xv(:),yv(:),zv(:)];
edgePairs = nchoosek(1:8,2);
isEdge = sum(vertices(edgePairs(:,1),:) ~= vertices(edgePairs(:,2),:),2)==1;
edgePairs = edgePairs(isEdge,:);

ax1 = nexttile;
hold(ax1,'on');
for k = 1:size(edgePairs,1)
    pts = vertices(edgePairs(k,:),:);
    plot3(pts(:,1),pts(:,2),pts(:,3),'-','Color',[.78 .80 .82]);
end

[xs,ys,zs] = sphere(48);
rb5 = norm(r4(1,:));
surf(P5(1)+rb5*xs,P5(2)+rb5*ys,P5(3)+rb5*zs, ...
    'FaceColor',[.55 .78 .84],'FaceAlpha',.18,'EdgeColor','none');

for i = 1:6
    col = otherCol;
    if i==1, col=col1; elseif i==5, col=col5; end
    pts = [B5world(i,:); A4(i,:)];
    plot3(pts(:,1),pts(:,2),pts(:,3),'-','Color',col, ...
        'LineWidth',1.2+1.4*ismember(i,[1 5]));
    plot3(A4(i,1),A4(i,2),A4(i,3),'s','Color',col,'MarkerFaceColor',col);
    plot3(pts(1,1),pts(1,2),pts(1,3),'o','Color',col,'MarkerFaceColor',col);
    text(A4(i,1),A4(i,2),A4(i,3),sprintf(' A%d',i),'Color',col);
    text(pts(1,1),pts(1,2),pts(1,3),sprintf(' B%d',i),'Color',col);
end
axis equal; grid on; box on; view(38,22);
xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
title({sprintf('C12 | Pose %d | A6 shift +25 mm',poseID), ...
       sprintf('P = [%.1f, %.1f, %.1f] mm',P5), ...
       sprintf('Roll %.1f°, pitch %.1f°, yaw %.1f°',roll5,pitch5,yaw5)});

ax2 = nexttile;
hold(ax2,'on');

% 从球端向外画到最近点之后 8 mm；保留两根绳的真实方向与比例。
tip1 = b1 + min(1,st(idx5,1)+8/sqrt(uu))*u;
tip5 = b5 + min(1,st(idx5,2)+8/sqrt(vv))*v;
pts1 = [b1;tip1]; pts5 = [b5;tip5];
h1 = plot3(pts1(:,1),pts1(:,2),pts1(:,3),'-','Color',col1,'LineWidth',3);
h5 = plot3(pts5(:,1),pts5(:,2),pts5(:,3),'-','Color',col5,'LineWidth',3);

% 虚线连接 B1/B5；紫色实线连接两条绳上的最近点。
chord = [b1;b5]; shortest = [near1;near5];
hc = plot3(chord(:,1),chord(:,2),chord(:,3),'k--','LineWidth',1.5);
hg = plot3(shortest(:,1),shortest(:,2),shortest(:,3),'-o', ...
    'Color',gapCol,'MarkerFaceColor',gapCol,'LineWidth',2);
text(b1(1),b1(2),b1(3),' B1','Color',col1,'FontWeight','bold');
text(b5(1),b5(2),b5(3),' B5','Color',col5,'FontWeight','bold');

% 让两条关键线段尽量正对读者，减少投影造成的视觉缩短。
cameraDir = cross(b5-b1,near5-near1);
axis equal; grid on; box on;
if norm(cameraDir)>1e-8
    view(ax2,cameraDir/norm(cameraDir));
else
    view(ax2,38,22);
end
xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
title({'Cable 1 and Cable 5 near the balloon', ...
       sprintf('Pose %d | path 174 to 382, t = 1',poseID)});
legend([h1 h5 hc hg],{'Cable 1','Cable 5', ...
    sprintf('B1–B5 chord: %.3f mm',attachGap5), ...
    sprintf('Cable gap: %.3f mm',gap5)},'Location','best');

%% C12 Step 6：提取已验证版本的六组 CAD 安装坐标
% A 使用框架坐标系，B 使用球体坐标系，单位均为 mm。
% CAD 建模使用球体坐标，Pose 382 的世界坐标只用于复现该姿态。

selectedC12 = reportC12.selected;
assert(height(selectedC12)==1 && selectedC12.Offset_mm==25 && ...
    selectedC12.BIndex==41 && selectedC12.Pass, ...
    '当前报告与选定的 C12 新增退让 25 mm 版本不一致。');

A_C12 = resultC12.A;
B_C12 = resultC12.r;
A_C12(6,:) = selectedC12.A6_mm;
B_C12(6,:) = selectedC12.B6_mm;

% 用已知的框架坐标和球端安装间距核对配置身份。
assert(norm(A_C12(6,:) - [140 -115 -160]) < 1e-6);
assert(abs(norm(B_C12(1,:) - B_C12(5,:)) - 21.584095) < 1e-5);

coordsC12 = array2table([(1:6)', A_C12, B_C12], ...
    'VariableNames', {'CableID','Ax_frame_mm','Ay_frame_mm','Az_frame_mm', ...
    'Bx_body_mm','By_body_mm','Bz_body_mm'});

format long g
disp(coordsC12);
fprintf('A6 最终端距 = %.3f mm\n', selectedC12.EndMargin_mm);
fprintf('539 位姿最差缩放 sigma_min = %.9f，Pose %d\n', ...
    selectedC12.WorstSigma, selectedC12.WorstPose);