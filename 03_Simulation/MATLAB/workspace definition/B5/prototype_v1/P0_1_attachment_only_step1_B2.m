%% P0.1 — Attachment-only Step 1
% 研究问题：
% 固定六个 anchor，只把 C4-1 的 B2 沿球面移动。
% 比较 B2 的实际位移与 Cable 2 的长度变化。
%
% 单位：坐标和长度为 mm，球面移动角为 deg。
% 参考位姿：球心 P = [0 0 0]，姿态 R = eye(3)。

clear;
clc;

%% 1. 读入 C4-1 的原始 E2 配置
scriptDir = fileparts(mfilename('fullpath'));
dataFile = fullfile(scriptDir, 'B5_4_E2_539pose_verification.mat');
assert(isfile(dataFile), '请把脚本放在验证 MAT 文件所在的文件夹。');

data = load(dataFile, 'T_verification', 'designs');
records = data.T_verification;

isTarget = string(records.Design) == "E1b C4-1" & ...
           string(records.Track)  == "MarginPreservingSensing";
idx = find(isTarget);
assert(isscalar(idx), '没有找到唯一的 C4-1 E2 M 配置，请检查表中的名称。');

cfg = data.designs{idx};
A = cfg.A;       % 6×3，每一行是一个框架端 anchor
r = cfg.r;       % 6×3，每一行是与同一行 anchor 配对的球面 attachment

% 本轮用原始锚点。C4-1 的 A2 应位于这个框架顶点。
assert(norm(A(2,:) - [140 150 -160]) < 1e-6, ...
       'A2 与已核对的 C4-1 原始坐标不一致。');

%% 2. 建立 B2 处的径向方向和一个球面切向方向
cableID = 2;
r2 = r(cableID,:);           % 原始 B2，球体坐标系
rb = norm(r2);               % 从原始数据读取半径，避免手动取整
n = r2 / rb;                 % 径向单位向量

% 把 X 轴投影到 B2 的切平面。
% 若 X 轴与 n 近乎平行，换用 Y 轴，避免切向量长度过小。
refAxis = [1 0 0];
if abs(dot(refAxis, n)) > 0.95
    refAxis = [0 1 0];
end

t = refAxis - dot(refAxis, n) * n;
t = t / norm(t);
assert(abs(dot(n, t)) < 1e-12, '径向与切向应当垂直。');

%% 3. 计算原始参考位姿的六条绳长
% 一般情况下，球面连接点的世界坐标为 B = P + R*r。
% 本例 P=0、R=I，所以 B 的数值恰好等于 r。
L0 = vecnorm(A - r, 2, 2);   % 按行取模，得到 6×1 的绳长向量

%% 4. 对 B2 分别施加 -2、0、+2 度的球面位置调整
angleDeg = [-2; 0; 2];
numCases = numel(angleDeg);

radiusError   = zeros(numCases, 1);
pointShift    = zeros(numCases, 1);
lengthCable2  = zeros(numCases, 1);
deltaCable2   = zeros(numCases, 1);
maxOtherDelta = zeros(numCases, 1);

otherCables = [1 3 4 5 6];

for k = 1:numCases
    alpha = angleDeg(k);

    % 每个工况都从同一原始配置出发，避免累积上一次的移动。
    rTest = r;

    % 只有第 2 行变化。cosd 和 sind 直接使用"度"。
    rTest(cableID,:) = rb * (cosd(alpha) * n + sind(alpha) * t);

    % 重新计算全部六条绳长，检查这次调整实际影响了哪些绳。
    L = vecnorm(A - rTest, 2, 2);
    deltaL = L - L0;

    radiusError(k)   = abs(norm(rTest(cableID,:)) - rb);
    pointShift(k)    = norm(rTest(cableID,:) - r2);
    lengthCable2(k)  = L(cableID);
    deltaCable2(k)   = deltaL(cableID);
    maxOtherDelta(k) = max(abs(deltaL(otherCables)));
end

%% 5. 打印结果并检查几何关系
result = table(angleDeg, radiusError, pointShift, lengthCable2, ...
               deltaCable2, maxOtherDelta, ...
    'VariableNames', {'Angle_deg', 'RadiusError_mm', 'B2Shift_mm', ...
                      'Cable2Length_mm', 'DeltaL2_mm', 'MaxOtherDelta_mm'});

format long g;
fprintf('原始 A2 = [%9.4f %9.4f %9.4f] mm\n', A(cableID,:));
fprintf('原始 B2 = [%9.4f %9.4f %9.4f] mm\n', r2);
fprintf('原始 Cable 2 长度 = %.6f mm\n\n', L0(cableID));
disp(result);

tol = 1e-9;  % 仅用于浮点数自检
assert(all(radiusError < tol),   'B2 偏离了原球面。');
assert(all(maxOtherDelta < tol), '其他五条绳的长度发生了意外变化。');

% 三角不等式：固定 A2 时，绳长变化的绝对值不能超过 B2 的位移。
assert(all(abs(deltaCable2) <= pointShift + tol), ...
       '绳长变化超过了端点位移，请检查几何计算。');

%% 6. 固定 attachment 设计，让整个球沿 +X 平移 1 mm
% 研究问题：
% 对完全相同的球体平移，原始 B2 和 +2° 的 B2 会给出怎样的绳长变化？
% 球体姿态始终为 R = I，因此世界坐标 B = 球心 P + 体坐标 r。

designAngles = [0; 2];       % 两种 B2 安装设计，单位 deg
deltaP = [1 0 0];            % 整个球的平移，单位 mm
numDesigns = numel(designAngles);

startL2 = zeros(numDesigns, 1);
endL2   = zeros(numDesigns, 1);
exactL2 = zeros(numDesigns, 1);
linearL2 = zeros(numDesigns, 1);
allDeltaL = zeros(numDesigns, 6);

for k = 1:numDesigns
    % 第一步：确定这一轮的设计。只改变 B2 在球体上的安装坐标。
    rDesign = r;
    alpha = designAngles(k);
    rDesign(2,:) = rb * (cosd(alpha) * n + sind(alpha) * t);

    % 第二步：球心位于原点。计算该设计自己的六条起始绳长。
    Bstart = rDesign;
    Dstart = A - Bstart;                  % 从球面连接点指向框架锚点
    Lstart = vecnorm(Dstart, 2, 2);       % 6×1，每行一条绳

    % 第三步：保持 attachment 安装位置不变，让整个球平移。
    % deltaP 加到每一行，因此六个连接点都沿 +X 移动 1 mm。
    Bend = Bstart + deltaP;
    Lend = vecnorm(A - Bend, 2, 2);

    % 第四步：同一个设计，运动后减运动前，得到精确的几何绳长差。
    deltaL = Lend - Lstart;
    allDeltaL(k,:) = deltaL.';
    startL2(k) = Lstart(2);
    endL2(k)   = Lend(2);
    exactL2(k) = deltaL(2);

    % 第五步：用运动开始时的绳方向做一阶预测。
    u2 = Dstart(2,:) / Lstart(2);
    linearL2(k) = -dot(u2, deltaP);
end

% 精确几何值与一阶近似之差。这里没有加入编码器噪声。
linearResidual = exactL2 - linearL2;

motionResult = table(designAngles, startL2, endL2, exactL2, ...
    linearL2, linearResidual, ...
    'VariableNames', {'B2Design_deg', 'StartL2_mm', 'EndL2_mm', ...
    'ExactDeltaL2_mm', 'LinearDeltaL2_mm', ...
    'ExactMinusLinear_mm'});

disp('同一个 +X 1 mm 平移，两种 B2 安装设计的 Cable 2 响应：');
disp(motionResult);

% 两种设计只在 B2 上有区别，因此其他五条绳对同一平移的响应应相同。
otherIDs = [1 3 4 5 6];
otherResponseDiff = allDeltaL(2,otherIDs) - allDeltaL(1,otherIDs);
fprintf('两种设计中，其他五条绳的运动响应最大差异 = %.9f mm\n', ...
    max(abs(otherResponseDiff)));


%% 7. 在参考位姿比较两种 B2 设计的测量 Jacobian
% 研究问题：
% B2 改装后，Cable 2 对 X 平移的响应略微减弱。
% 六根绳共同测量时，整个系统的最弱方向也会变弱吗？
%
% 本节沿用前面生成的 A、r、rb、n、t 和 motionResult。
% 位姿固定为 P = 0、R = I，因此球心到连接点的世界向量 s 就等于 rDesign。

b2Angles = [0; 2];
numCases = numel(b2Angles);

HsAll = zeros(6, 6, numCases);
row2 = zeros(numCases, 6);
sigmaMin = zeros(numCases, 1);
kappa = zeros(numCases, 1);

for k = 1:numCases
    % 1. 从同一 E2 基线出发，仅改变 B2 的球面安装位置
    rDesign = r;
    alpha = b2Angles(k);
    rDesign(2,:) = rb * (cosd(alpha) * n + sind(alpha) * t);

    % 2. 计算六条绳各自的方向：从球面连接点指向框架锚点
    s = rDesign;                       % 6×3，每行是一个球心到连接点的向量
    D = A - s;                         % 参考位姿下，连接点的世界坐标等于 s
    L = vecnorm(D, 2, 2);              % 6×1，每条绳的长度
    u = D ./ L;                        % 6×3，每行除以对应绳长，得到单位向量

    % 3. 构造缩放 Jacobian
    % 左三列：对世界 X、Y、Z 平移的响应
    % 右三列：对绕世界 X、Y、Z 轴微小旋转的响应，除以 rb 统一尺度
    Hs = [-u, cross(u, s, 2) / rb];
    HsAll(:,:,k) = Hs;
    row2(k,:) = Hs(2,:);

    % 4. MATLAB 的 svd 按从大到小的顺序返回奇异值
    singularValues = svd(Hs);
    sigmaMin(k) = singularValues(end);
    kappa(k) = singularValues(1) / singularValues(end);
end

% 5. 先看一根绳：B2 改装使第 2 行的哪些分量发生变化？
row2Table = array2table([b2Angles, row2], ...
    'VariableNames', {'B2_deg', 'Tx', 'Ty', 'Tz', ...
    'RotX_scaled', 'RotY_scaled', 'RotZ_scaled'});
disp('Cable 2 在两种设计下的缩放 Jacobian 行：');
disp(row2Table);

% 对照第 6 节：那里使用 +X 1 mm，所以一阶长度预测的数值等于 Tx。
% 对照的是 LinearDeltaL2_mm；ExactDeltaL2_mm 还包含有限位移效应。
assert(max(abs(row2(:,1) - motionResult.LinearDeltaL2_mm)) < 1e-10, ...
    '第 2 行 Tx 与上一节线性预测不一致，请检查绳方向或设计顺序。');

% 6. 再看整个系统：每一行变化多少？最小奇异值如何变化？
rowChange = vecnorm(HsAll(:,:,2) - HsAll(:,:,1), 2, 2);
disp('各根绳对应的 Jacobian 行变化量：');
disp(table((1:6)', rowChange, 'VariableNames', {'CableID', 'RowChange'}));

systemTable = table(b2Angles, sigmaMin, kappa, ...
    'VariableNames', {'B2_deg', 'SigmaMin_scaled', 'Kappa_scaled'});
disp('参考位姿下的六绳系统指标：');
disp(systemTable);

%% 8. 在相同的 539 个位姿上比较原始 B2 和 +2° B2
% 研究问题：
% 参考位姿下，+2° 使 sigma_min 略有提高。
% 在整个开发位姿集上，两种设计各自的最差值如何变化？

%% 8.1 读取位姿，并准备结果矩阵
poseData = load(dataFile, 'P_eval', 'R_eval');
P_eval = poseData.P_eval;     % 539×3，每一行是一个球心位置，单位 mm
R_eval = poseData.R_eval;     % 3×3×539，每一页是一个旋转矩阵

numPoses = size(P_eval, 1);
assert(isequal(size(P_eval), [539 3]), 'P_eval 的尺寸与预期不符。');
assert(isequal(size(R_eval), [3 3 numPoses]), 'R_eval 的尺寸与预期不符。');

designAngles = [0; 2];
numDesigns = numel(designAngles);

% 行：位姿编号。列：第 1 列原始 B2，第 2 列 +2° B2。
sigmaByPose = zeros(numPoses, numDesigns);

%% 8.2 外层固定设计，内层改变整球位姿
for k = 1:numDesigns
    alpha = designAngles(k);
    rDesign = r;

    % B2 的安装位置只在进入位姿循环之前设定一次。
    rDesign(2,:) = rb * (cosd(alpha) * n + sind(alpha) * t);

    for q = 1:numPoses
        P = P_eval(q,:);         % 本位姿的球心，1×3
        R = R_eval(:,:,q);       % 从球体坐标系转到世界坐标系

        % rDesign 每行是一个点。先转成列向量旋转，再恢复成每行一个点。
        s = (R * rDesign.').';   % 6×3，世界坐标下从球心出发的六个力臂
        Bworld = s + P;          % 6×3，六个连接点的世界坐标

        D = A - Bworld;          % 从球面连接点指向对应锚点
        L = vecnorm(D, 2, 2);    % 六条绳长
        u = D ./ L;              % 六条绳的单位方向

        % 旋转块用力臂 s。沿用前一节的球半径缩放。
        Hs = [-u, cross(u, s, 2) / rb];
        singularValues = svd(Hs);

        sigmaByPose(q,k) = singularValues(end);
    end
end

%% 8.3 每种设计独立寻找自己的最差位姿
% min(..., [], 1) 表示沿行向下搜索，对每一列分别取最小值。
[worstSigma, worstPose] = min(sigmaByPose, [], 1);

% 基线自检：上一步已经独立复现的 C4-1 原始结果。
assert(abs(worstSigma(1) - 0.5827023452) < 1e-6, ...
    '原始最差 sigma_min 未复现，请检查输入设计、力臂和缩放。');
assert(worstPose(1) == 17, '原始设计的最差位姿与已核对的 Pose 17 不符。');

% 顺便取出两种设计在原始最差位姿上的结果，以便横向比较。
sigmaAtOriginalWorst = sigmaByPose(worstPose(1), :).';

summary539 = table(designAngles, worstSigma.', worstPose.', ...
    sigmaAtOriginalWorst, ...
    'VariableNames', {'B2_deg', 'WorstSigma539', 'WorstPoseID', ...
    'SigmaAtOriginalWorstPose'});

disp('两种设计各自的最差结果，以及在原始最差位姿的横向对照：');
disp(summary539);

%% 8.4 同一位姿下比较两种设计，保留改动影响最大的两个例子
% 正数：+2° 在该位姿提高了 sigma_min。负数：降低了 sigma_min。
deltaSigma = sigmaByPose(:,2) - sigmaByPose(:,1);

tol = 1e-10;  % 只用于排除浮点舍入差异，不代表工程显著性阈值
fprintf('逐位姿比较：提高 %d 个，下降 %d 个，数值持平 %d 个。\n', ...
    sum(deltaSigma > tol), sum(deltaSigma < -tol), ...
    sum(abs(deltaSigma) <= tol));

[largestGain, gainPose] = max(deltaSigma);
[largestLoss, lossPose] = min(deltaSigma);

fprintf('逐位姿差值最大：Pose %d，差值 %+.8f\n', gainPose, largestGain);
fprintf('逐位姿差值最小：Pose %d，差值 %+.8f\n', lossPose, largestLoss);

% 先分别找最差值，再比较。这是本节要回答的主要问题。
worstChangePct = 100 * (worstSigma(2) - worstSigma(1)) / worstSigma(1);
fprintf('两种设计各自最差 sigma_min 的相对变化：%+.4f%%\n', worstChangePct);

%% 9. C4-1：两个 A2 位置 × B2 球面局部搜索
% 输入沿用前文：A, r, rb, n, t, P_eval, R_eval, dataFile
% 目标：在通过采样几何检查的候选中，最大化 539 位姿最差 sigma_min。

assert(exist('B3_1_segment_distance_3d_2026_11_02', 'file') == 2, ...
    '请先将项目中有限线段距离函数所在文件夹加入 MATLAB 路径。');

settings = load(dataFile, 'clearance_floor');
gapFloor = settings.clearance_floor;    % 原模型中心线距离阈值，单位 mm
numPoses = size(P_eval, 1);

%% 9.1 生成 B2 球面候选
% n 是原 B2 的径向单位向量，t 是前面用过的第一个切向方向。
% t2 与 n、t 都垂直。方位角 0° 恰好对应上一节测试的正方向。
t2 = cross(n, t);
t2 = t2 / norm(t2);
 
% B2 球面候选：原点 + 3 圈，每圈 16 个方位，共 49 个位置。
% 球心角决定移动多远；方位角决定从原始 B2 朝哪个方向移动。
arcLevels = [2; 4; 6];
bearingLevels = (0:22.5:337.5)';

arcList = [0; repelem(arcLevels, numel(bearingLevels))]; % 球心角：决定移动距离
bearingList = [0; repmat(bearingLevels, numel(arcLevels), 1)]; % 方位角：决定移动方向

numB = numel(arcList);
bCandidates = zeros(numB, 3);

for j = 1:numB
    tangentDir = cosd(bearingList(j)) * t + sind(bearingList(j)) * t2;
    bCandidates(j,:) = rb * ...
        (cosd(arcList(j)) * n + sind(arcList(j)) * tangentDir);
end

assert(max(abs(vecnorm(bCandidates, 2, 2) - rb)) < 1e-9, ...
    '存在偏离球面的 B2 候选。');

%% 9.2 预先计算未改变的十对绳在各位姿下的最小距离
% 这十对不涉及 Cable 2，因此对本次全部 34 种设计都相同。
otherIDs = [1 3 4 5 6];
fixedPairs = nchoosek(otherIDs, 2);
fixedGap = inf(numPoses, 1);

for q = 1:numPoses
    B = (R_eval(:,:,q) * r.').' + P_eval(q,:);
    for p = 1:size(fixedPairs, 1)
        i = fixedPairs(p,1);
        k = fixedPairs(p,2);
        gap = B3_1_segment_distance_3d_2026_11_02( ...
            B(i,:), A(i,:), B(k,:), A(k,:));
        fixedGap(q) = min(fixedGap(q), gap);
    end
end

%% 9.3 扫描两个锚点工况，每个工况评估完全相同的 B2 候选
anchorOffsets = [0: 5: 40];   % C4-1 的 A2 从原始角点沿 Rail 6 向 -X 方向移动，单位 mm。
numRows = numel(anchorOffsets) * numB;

% 各列依次为：A2退让、B2球心角、B2方位角、最差灵敏度、最差位姿、
% 最小出球角、全局最小绳距、涉及C2的最小绳距、几何通过位姿数。
values = zeros(numRows, 9);
row = 0;

for offset = anchorOffsets
    Atest = A;
    Atest(2,:) = A(2,:) + [-offset, 0, 0];

    for j = 1:numB
        rTest = r;
        rTest(2,:) = bCandidates(j,:);

        sigma = zeros(numPoses, 1);
        minAngle = zeros(numPoses, 1);
        cable2Gap = inf(numPoses, 1);

        for q = 1:numPoses
            s = (R_eval(:,:,q) * rTest.').';     % 球心到连接点的力臂
            B = s + P_eval(q,:);                 % 连接点世界坐标
            D = Atest - B;
            u = D ./ vecnorm(D, 2, 2);

            % 系统灵敏度：六条绳共同构成的缩放 Jacobian
            Hs = [-u, cross(u, s, 2) / rb];
            singularValues = svd(Hs);
            sigma(q) = singularValues(end);

            % 出球角：0° 表示沿球面切线出发，负值表示朝球内出发。
            % 对六条绳取最小值，避免只关注 C2 而漏掉原有限制绳。
            sineAngle = sum((s / rb) .* u, 2);
            minAngle(q) = min(asind(max(-1, min(1, sineAngle))));

            % 重新计算 C2 与其他五根绳的有限线段距离。
            for k = otherIDs
                gap = B3_1_segment_distance_3d_2026_11_02( ...
                    B(2,:), Atest(2,:), B(k,:), Atest(k,:));
                cable2Gap(q) = min(cable2Gap(q), gap);
            end
        end

        allGap = min(fixedGap, cable2Gap);
        geometryPass = (minAngle >= 0) & (allGap >= gapFloor);
        [worstSigma, worstPose] = min(sigma);

        row = row + 1;
        values(row,:) = [offset, arcList(j), bearingList(j), ...
            worstSigma, worstPose, min(minAngle), min(allGap), ...
            min(cable2Gap), nnz(geometryPass)];
    end
end

scan = array2table(values, 'VariableNames', ...
    {'A2Offset_mm','B2Arc_deg','B2Bearing_deg','WorstSigma', ...
     'WorstPose','MinOutAngle_deg','MinAllGap_mm','MinC2Gap_mm','GeomPass'});

%% 9.4 用已知结果校验本轮实现
original = scan(scan.A2Offset_mm == 0  & scan.B2Arc_deg == 0,:);
anchorOnly = scan(scan.A2Offset_mm == 20 & scan.B2Arc_deg == 0,:);
knownPlus2 = scan(scan.A2Offset_mm == 0 & scan.B2Arc_deg == 2 & ...
                  scan.B2Bearing_deg == 0,:);

assert(abs(original.WorstSigma - 0.5827023452) < 1e-6, '原始基线不符。');
assert(abs(anchorOnly.WorstSigma - 0.5633828565) < 1e-6, '20 mm 基线不符。');
assert(abs(knownPlus2.WorstSigma - 0.5767803401) < 1e-6, ...
    '未复现上一节 +2° 的结果，请检查切向方向。');

%% 9.5 选出每个 A2 工况下最好的可行 B2
% 原始 B2 也参加竞争。如果移动 B2 没有收益，可以直接保留原点。
eligible = scan.GeomPass == numPoses & scan.WorstSigma > 1e-9;

at0  = sortrows(scan(eligible & scan.A2Offset_mm == 0,:),  'WorstSigma','descend');
at20 = sortrows(scan(eligible & scan.A2Offset_mm == 20,:), 'WorstSigma','descend');
assert(~isempty(at0) && ~isempty(at20), '至少一个锚点工况没有可行候选。');

comparison = [original; anchorOnly; at0(1,:); at20(1,:)];
comparison.Group = ["Original"; "AnchorOnly"; "BestB_at_A0"; "BestB_at_A20"];
comparison = movevars(comparison, 'Group', 'Before', 1);

disp('四组比较：每行的 WorstSigma 都已在 539 个位姿上独立取最小值');
disp(comparison);

% 追回比例：以"只移动锚点造成的最差灵敏度损失"为分母。
anchorLoss = original.WorstSigma - anchorOnly.WorstSigma;
attachmentGain = at20.WorstSigma(1) - anchorOnly.WorstSigma;
fprintf('A2 内移 20 mm 造成的 WorstSigma 损失：%.8f\n', anchorLoss);
fprintf('固定 A2 在 20 mm 后，调整 B2 追回：%.8f\n', attachmentGain);
fprintf('在本轮候选中追回原损失的比例：%.2f%%\n', ...
    100 * attachmentGain / anchorLoss);
fprintf('可行候选数：A2 = 0 mm 时 %d/%d；A2 = 20 mm 时 %d/%d。\n', ...
    height(at0), numB, height(at20), numB);

%% 10. C4-1：读取 A2–B2 联合网格，比较不同安装退让条件
% 前提：第 9 节已使用扩展后的 arcList、bearingList 和 anchorOffsets 运行。
% scan 中每一行都是一个已完成 539 位姿评估的 A2–B2 组合。

%% 10.1 核对搜索规模和上一轮的两个已知获胜点
assert(height(scan) == 441, ...
    '预期 9 个 A2 × 49 个 B2 = 441 个组合，请核对第 9 节设置。');

oldA0 = scan(scan.A2Offset_mm == 0 & scan.B2Arc_deg == 4 & ...
             scan.B2Bearing_deg == 270, :);
oldA20 = scan(scan.A2Offset_mm == 20 & scan.B2Arc_deg == 4 & ...
              scan.B2Bearing_deg == 225, :);

assert(height(oldA0) == 1 && abs(oldA0.WorstSigma - 0.5908678114) < 1e-6, ...
    '上一轮 A2=0 mm、B2=(4°,270°) 的结果未复现。');
assert(height(oldA20) == 1 && abs(oldA20.WorstSigma - 0.5901165409) < 1e-6, ...
    '上一轮 A2=20 mm、B2=(4°,225°) 的结果未复现。');

%% 10.2 每个 A2 位置单独选 B2，得到"退让距离—最佳性能"对照表
eligible = scan.GeomPass == numPoses & scan.WorstSigma > 1e-9;
bestByA = scan([], :);                 % 空表，保留 scan 的列名和数据类型

for offset = anchorOffsets
    candidates = scan(eligible & scan.A2Offset_mm == offset, :);

    if isempty(candidates)
        fprintf('A2 = %g mm：本轮没有通过筛选的 B2。\n', offset);
        continue;
    end

    % 优先级：最差灵敏度越大越好。
    % 若数值完全相同，依次优先出球角较大、C2 间距较大、B2 改动较小者。
    candidates = sortrows(candidates, ...
        {'WorstSigma','MinOutAngle_deg','MinC2Gap_mm','B2Arc_deg'}, ...
        {'descend','descend','descend','ascend'});

    bestByA = [bestByA; candidates(1,:)]; %#ok<AGROW>
end

% 对每个 A2，计算"允许 B2 移动"相对"保持原始 B2"的实际增益。
% 这里逐行找同一 A2 下的基线，避免不同退让距离之间错配。
bestByA.GainVsOriginalB2_pct = zeros(height(bestByA), 1);

for p = 1:height(bestByA)
    offset = bestByA.A2Offset_mm(p);
    baseline = scan(scan.A2Offset_mm == offset & scan.B2Arc_deg == 0, :);
    bestByA.GainVsOriginalB2_pct(p) = ...
        100 * (bestByA.WorstSigma(p) - baseline.WorstSigma) / baseline.WorstSigma;
end

disp('每个 A2 退让距离对应的最佳可行 B2：');
disp(bestByA(:, {'A2Offset_mm','B2Arc_deg','B2Bearing_deg', ...
    'WorstSigma','GainVsOriginalB2_pct','WorstPose', ...
    'MinOutAngle_deg','MinAllGap_mm','MinC2Gap_mm'}));

%% 10.3 区分"恰好退让 20 mm"和"至少退让 20 mm"
exact20 = bestByA(bestByA.A2Offset_mm == 20, :);

atLeast20 = bestByA(bestByA.A2Offset_mm >= 20, :);
assert(~isempty(exact20) && ~isempty(atLeast20), '20 mm 工况缺少可行组合。');

atLeast20 = sortrows(atLeast20, ...
    {'WorstSigma','MinOutAngle_deg','MinC2Gap_mm','A2Offset_mm'}, ...
    {'descend','descend','descend','ascend'});

decision = [exact20; atLeast20(1,:)];
decision.Scenario = ["Exactly_20_mm"; "At_least_20_mm"];

disp('两个安装情景的选择：');
disp(decision(:, {'Scenario','A2Offset_mm','B2Arc_deg','B2Bearing_deg', ...
    'WorstSigma','WorstPose','MinOutAngle_deg','MinAllGap_mm','MinC2Gap_mm'}));

%% 10.4 画出允许 B2 调整前后，最差灵敏度如何随 A2 退让而改变
anchorCurve = sortrows(scan(scan.B2Arc_deg == 0, :), 'A2Offset_mm');

figure('Color','w');
plot(anchorCurve.A2Offset_mm, anchorCurve.WorstSigma, ...
     'o--', 'LineWidth',1.4, 'DisplayName','Original B2');
hold on;
plot(bestByA.A2Offset_mm, bestByA.WorstSigma, ...
     's-', 'LineWidth',1.6, 'DisplayName','Best feasible B2 in grid');
xlabel('A2 inward offset on Rail 6 (mm)');
ylabel('Worst scaled \sigma_{min} over 539 poses');
title('C4-1: effect of B2 adjustment at each A2 position');
legend('Location','best');
grid on;

%% 11. 提取 C4-1 的 35 mm 工程候选，生成六条绳的安装坐标表

% 1. 取出 35 mm 工况下已经通过筛选、WorstSigma 最高的那一行。
selected35 = bestByA(bestByA.A2Offset_mm == 35, :);
assert(height(selected35) == 1, '未找到唯一的 35 mm 候选。');
assert(selected35.GeomPass == numPoses && numPoses == 539, ...
    '所选候选未通过预期的 539 个采样位姿检查。');

% 2. 用搜索时的两个角度找回同一个 B2，保留完整坐标精度。
idxB = find(arcList == selected35.B2Arc_deg & ...
    bearingList == selected35.B2Bearing_deg);
assert(isscalar(idxB), 'B2 候选索引不唯一或不存在。');

% 3. 复制原始六绳配置，只修改 Cable 2 的两个端点。
A35 = A;                                % 框架坐标系，mm
r35 = r;                                % 球体坐标系，mm
A35(2,:) = A(2,:) + [-selected35.A2Offset_mm, 0, 0];
r35(2,:) = bCandidates(idxB,:);

% 4. 独立核对端点位置和 B2 的实际移动量。
assert(norm(A35(2,:) - [105, 150, -160]) < 1e-8, 'A2 坐标不符。');
assert(abs(norm(r35(2,:)) - rb) < 1e-8, '新 B2 偏离球面。');

b2Shift = norm(r35(2,:) - r(2,:));      % 两安装点之间的直线距离，mm
expectedShift = 2 * rb * sind(selected35.B2Arc_deg / 2);
assert(abs(b2Shift - expectedShift) < 1e-8, 'B2 弦长与球心角不符。');

% 5. 输出 CAD 安装坐标。每行按 CableID 配对，A 和 B 各用自己的坐标系。
coords35 = array2table([(1:6)', A35, r35], 'VariableNames', ...
    {'CableID','Ax_frame_mm','Ay_frame_mm','Az_frame_mm', ...
    'Bx_body_mm','By_body_mm','Bz_body_mm'});

disp(coords35);
fprintf('A2 框架坐标 [mm] = [% .6f % .6f % .6f]\n', A35(2,:));
fprintf('B2 球体坐标 [mm] = [% .6f % .6f % .6f]\n', r35(2,:));
fprintf('B2 相对原始安装点的弦长位移 = %.4f mm\n', b2Shift);
fprintf('最差 sigma_min = %.9f，位姿编号 = %d\n', ...
    selected35.WorstSigma, selected35.WorstPose);

%% 12. C4-1 / 35 mm：相同姿态下，相邻位置之间的连续平移检查
% 模型沿用第 9 节：刚性球、固定锚点、连接点到锚点之间为直线绳。
% 输入：A35, r35, rb, P_eval, R_eval, gapFloor

numPoses = size(P_eval,1);
cablePairs = nchoosek(1:6,2);
maxDepth = 12;

%% 12.1 找出同姿态下，沿 X/Y/Z 的相邻位置
% 分组时取整仅用于识别网格。计算距离时使用原始坐标。
posKey = round(P_eval,9);
rotKey = round(reshape(R_eval,9,numPoses).',12);
edges = zeros(0,3);                       % [起点Pose, 终点Pose, 运动轴]

for ax = 1:3
    fixedAxes = setdiff(1:3,ax);
    [~,~,lineID] = unique([rotKey, posKey(:,fixedAxes)],'rows');

    for line = 1:max(lineID)
        ids = find(lineID == line);
        [~,order] = sort(posKey(ids,ax));
        ids = ids(order);
        if numel(ids) < 2
            continue
        end
        assert(all(diff(posKey(ids,ax)) > 0), ...
            '存在重复位姿，请先核对评估网格。');
        edges = [edges; ids(1:end-1), ids(2:end), ...
                 repmat(ax,numel(ids)-1,1)]; %#ok<AGROW>
    end
end

assert(~isempty(edges),'未找到同姿态的轴向相邻位置。');
fprintf('连续平移路径：X %d 条，Y %d 条，Z %d 条。\n', ...
    nnz(edges(:,3)==1), nnz(edges(:,3)==2), nnz(edges(:,3)==3));

%% 12.2 对每条路径检查绳–球和绳–绳干涉
numEdges = size(edges,1);
status = strings(numEdges,1);
gapLower = nan(numEdges,1);           % 通过路径的整段绳距下界
minCheckedGap = inf(numEdges,1);      % 实际计算过的中点中，最小绳距
minProjection = nan(numEdges,1);      % 整段最小向外投影，单位 mm
closestPair = zeros(numEdges,2);
closestFraction = nan(numEdges,1);    % 0 = 起点，1 = 终点

for e = 1:numEdges
    q0 = edges(e,1);
    q1 = edges(e,2);
    p0 = P_eval(q0,:);
    dp = P_eval(q1,:) - p0;
    pathLength = norm(dp);

    R = R_eval(:,:,q0);
    assert(norm(R - R_eval(:,:,q1),'fro') < 1e-10, ...
        '路径两端姿态不一致。');
    s = (R * r35.').';
    normals = s / rb;

    % 固定姿态直线平移时，向外投影的最小值一定出现在端点。
    proj0 = sum(normals .* (A35 - (s + p0)),2);
    proj1 = sum(normals .* (A35 - (s + P_eval(q1,:))),2);
    minProjection(e) = min([proj0; proj1]);
    if minProjection(e) < 0
        status(e) = "SphereFail";
        continue
    end

    pending = [0, 1, 0];              % 每行 [起始比例, 终止比例, 深度]
    acceptedLower = inf;
    unresolved = false;
    status(e) = "Pass";

    while ~isempty(pending)
        part = pending(end,:);
        pending(end,:) = [];
        a = part(1); b = part(2); depth = part(3);
        mid = (a+b)/2;
        Bmid = s + (p0 + mid*dp);

        gaps = zeros(size(cablePairs,1),1);
        for k = 1:size(cablePairs,1)
            i = cablePairs(k,1);
            j = cablePairs(k,2);
            gaps(k) = B3_1_segment_distance_3d_2026_11_02( ...
                Bmid(i,:), A35(i,:), Bmid(j,:), A35(j,:));
        end
        assert(all(isfinite(gaps)),'绳距计算产生非有限值。');
        [midGap,kMin] = min(gaps);

        if midGap < minCheckedGap(e)
            minCheckedGap(e) = midGap;
            closestPair(e,:) = cablePairs(kMin,:);
            closestFraction(e) = mid;
        end

        lower = midGap - (b-a)*pathLength;
        if midGap < gapFloor
            status(e) = "CableFail";  % 已找到具体违反阈值的位置
            break
        elseif lower >= gapFloor
            acceptedLower = min(acceptedLower,lower);
        elseif depth < maxDepth
            pending = [pending; a,mid,depth+1; mid,b,depth+1]; %#ok<AGROW>
        else
            unresolved = true;
        end
    end

    if status(e) == "Pass" && unresolved
        status(e) = "Unresolved";
    elseif status(e) == "Pass"
        gapLower(e) = acceptedLower;
    end
end

%% 12.3 汇总结果，并定位已检查中点中最接近的一对绳
axisNames = ["X";"Y";"Z"];
paths35 = table(edges(:,1),edges(:,2),axisNames(edges(:,3)),status, ...
    minProjection,gapLower,minCheckedGap,closestPair(:,1), ...
    closestPair(:,2),closestFraction, ...
    'VariableNames',{'StartPose','EndPose','Axis','Status', ...
    'MinOutProjection_mm','GapLowerBound_mm','MinCheckedGap_mm', ...
    'CableI','CableJ','PathFraction'});

fprintf('Pass %d/%d，SphereFail %d，CableFail %d，Unresolved %d。\n', ...
    nnz(status=="Pass"),numEdges,nnz(status=="SphereFail"), ...
    nnz(status=="CableFail"),nnz(status=="Unresolved"));
fprintf('沿用的绳中心线距离阈值 = %.6f mm。\n',gapFloor);

if all(status=="Pass")
    fprintf('所有已检查平移路径共同的绳距下界 = %.6f mm。\n',min(gapLower));
else
    disp(paths35(status~="Pass",:));
end

checked = paths35(isfinite(paths35.MinCheckedGap_mm),:);
if ~isempty(checked)
    checked = sortrows(checked,'MinCheckedGap_mm');
    disp('已检查中点中，绳距最小的位置：');
    disp(checked(1,:));
end

%% 13. C4-1 / 35 mm：固定球心的连续旋转检查

%% 13.1 按球心位置分组，连接同一位置的每一对不同姿态
[~,~,posGroup] = unique(round(P_eval,9),'rows');
rotEdges = zeros(0,2);

for g = 1:max(posGroup)
    ids = find(posGroup == g);
    if numel(ids) < 2
        continue
    end

    % 同一位置如有重复姿态，只保留一个代表编号。
    keys = round(reshape(R_eval(:,:,ids),9,[]).',12);
    [~,uniqueRows] = unique(keys,'rows','stable');
    ids = ids(uniqueRows);

    if numel(ids) >= 2
        rotEdges = [rotEdges; nchoosek(ids(:),2)]; %#ok<AGROW>
    end
end

assert(~isempty(rotEdges),'未找到同一球心位置下的不同姿态。');
numRot = size(rotEdges,1);
fprintf('固定球心的连续旋转路径：%d 条。\n',numRot);

%% 13.2 对每条最短旋转路径做整段几何检查
pairs13 = nchoosek(1:6,2);
maxDepth13 = 12;
rotStatus = strings(numRot,1);
angleDeg = zeros(numRot,1);
gapBound = nan(numRot,1);
outBound = nan(numRot,1);
sampleGap = inf(numRot,1);
samplePair = zeros(numRot,2);
sampleFraction = nan(numRot,1);

for e = 1:numRot
    q0 = rotEdges(e,1);
    q1 = rotEdges(e,2);
    P = P_eval(q0,:);
    assert(norm(P_eval(q1,:) - P) < 1e-8,'路径两端球心不一致。');

    R0 = R_eval(:,:,q0);
    R1 = R_eval(:,:,q1);
    relativeR = R0.' * R1;

    % 提取最短旋转的角度和轴。用 atan2 保留小角度精度。
    axisSin = 0.5 * [relativeR(3,2)-relativeR(2,3);
                     relativeR(1,3)-relativeR(3,1);
                     relativeR(2,1)-relativeR(1,2)];
    cosTheta = max(-1,min(1,(trace(relativeR)-1)/2));
    theta = atan2(norm(axisSin),cosTheta);
    angleDeg(e) = rad2deg(theta);

    % 本项目局部姿态网格应远离 180°，在这里显式核对。
    assert(norm(axisSin) > 1e-12, ...
        '发现重合或接近 180° 的姿态对，请检查其 Pose 编号。');
    axis = axisSin / norm(axisSin);
    K = [0,       -axis(3),  axis(2);
         axis(3),  0,       -axis(1);
        -axis(2),  axis(1),  0];

    % 先验证插值确实能从 R0 到达指定的 R1。
    Rend = R0 * (eye(3) + sin(theta)*K + (1-cos(theta))*(K*K));
    assert(norm(Rend-R1,'fro') < 1e-8,'旋转插值终点不符。');

    anchorRadius = vecnorm(A35-P,2,2);
    pending = [0,1,0];               % 起始比例、终止比例、细分深度
    acceptedGap = inf;
    acceptedOut = inf;
    unresolved = false;
    rotStatus(e) = "Pass";

    while ~isempty(pending)
        part = pending(end,:);
        pending(end,:) = [];
        a = part(1); b = part(2); depth = part(3);
        mid = (a+b)/2;

        phi = mid*theta;
        Rmid = R0 * (eye(3) + sin(phi)*K + (1-cos(phi))*(K*K));
        s = (Rmid*r35.').';
        Bmid = P+s;

        % 六根绳的向外投影，单位 mm。负值表示从连接点朝球内出发。
        normals = s/rb;
        outMid = sum(normals .* (A35-P),2) - rb;

        gaps = zeros(size(pairs13,1),1);
        for k = 1:size(pairs13,1)
            i = pairs13(k,1);
            j = pairs13(k,2);
            gaps(k) = B3_1_segment_distance_3d_2026_11_02( ...
                Bmid(i,:),A35(i,:),Bmid(j,:),A35(j,:));
        end
        assert(all(isfinite([gaps;outMid])),'几何计算产生非有限值。');
        [dMid,kMin] = min(gaps);

        if dMid < sampleGap(e)
            sampleGap(e) = dMid;
            samplePair(e,:) = pairs13(kMin,:);
            sampleFraction(e) = mid;
        end

        % c 是相对本段中点，单位法向变化量的上界。
        c = 2*sin((b-a)*theta/4);
        lowerGap = dMid - 2*rb*c;
        lowerOut = min(outMid - anchorRadius*c);

        if min(outMid) < 0
            rotStatus(e) = "SphereFail";
            break
        elseif dMid < gapFloor
            rotStatus(e) = "CableFail";
            break
        elseif lowerGap >= gapFloor && lowerOut >= 0
            acceptedGap = min(acceptedGap,lowerGap);
            acceptedOut = min(acceptedOut,lowerOut);
        elseif depth < maxDepth13
            pending = [pending; a,mid,depth+1; mid,b,depth+1]; %#ok<AGROW>
        else
            unresolved = true;
        end
    end

    if rotStatus(e) == "Pass" && unresolved
        rotStatus(e) = "Unresolved";
    elseif rotStatus(e) == "Pass"
        gapBound(e) = acceptedGap;
        outBound(e) = acceptedOut;
    end
end

%% 13.3 输出判定、整段下界和具体位姿编号
rotPaths35 = table(rotEdges(:,1),rotEdges(:,2),angleDeg,rotStatus, ...
    gapBound,outBound,sampleGap,samplePair(:,1),samplePair(:,2), ...
    sampleFraction,'VariableNames', ...
    {'StartPose','EndPose','Rotation_deg','Status','GapLowerBound_mm', ...
     'OutProjectionLowerBound_mm','MinCheckedGap_mm','CableI','CableJ', ...
     'PathFraction'});

fprintf('Pass %d/%d，SphereFail %d，CableFail %d，Unresolved %d。\n', ...
    nnz(rotStatus=="Pass"),numRot,nnz(rotStatus=="SphereFail"), ...
    nnz(rotStatus=="CableFail"),nnz(rotStatus=="Unresolved"));

if all(rotStatus=="Pass")
    fprintf('旋转路径共同的绳距下界 = %.6f mm。\n',min(gapBound));
    fprintf('旋转路径共同的向外投影下界 = %.6f mm。\n',min(outBound));
else
    disp(rotPaths35(rotStatus~="Pass",:));
end

[~,idxClosest] = min(sampleGap);
disp('已检查旋转中点中，绳距最小的位置：');
disp(rotPaths35(idxClosest,:));

%% 14. C4-1 / 35 mm：相邻位置之间的同步平移 + 旋转
% 前置变量：edges, posGroup, P_eval, R_eval, A35, r35, rb, gapFloor

%% 14.1 从已验证的平移路径提取相邻位置，组合两端的不同姿态
positionPairs = unique(sort( ...
    [posGroup(edges(:,1)), posGroup(edges(:,2))], 2), 'rows');

rotKeys14 = round(reshape(R_eval,9,[]).',12);
poseIDsAt = cell(max(posGroup),1);

for g = 1:max(posGroup)
    ids = find(posGroup == g);
    [~,keep] = unique(rotKeys14(ids,:),'rows','stable');
    poseIDsAt{g} = ids(keep);
end

edgeBlocks = cell(size(positionPairs,1),1);
for k = 1:size(positionPairs,1)
    ids0 = poseIDsAt{positionPairs(k,1)};
    ids1 = poseIDsAt{positionPairs(k,2)};
    [q0,q1] = ndgrid(ids0,ids1);
    q0 = q0(:);
    q1 = q1(:);

    % 两端姿态相同的路径已在第 12 节检查。
    differentR = any(rotKeys14(q0,:) ~= rotKeys14(q1,:),2);
    edgeBlocks{k} = [q0(differentR), q1(differentR)];
end

mixedEdges = vertcat(edgeBlocks{:});
assert(~isempty(mixedEdges),'未生成组合路径，请核对位置与姿态分组。');
numMixed = size(mixedEdges,1);
usedPoses = unique(mixedEdges(:));

fprintf('相邻位置对 = %d；组合路径 = %d。\n', ...
    size(positionPairs,1),numMixed);
fprintf('参与组合路径的端点位姿 = %d / %d。\n', ...
    numel(usedPoses),size(P_eval,1));

%% 14.2 检查每条组合路径
pairs14 = nchoosek(1:6,2);
maxDepth14 = 12;

status14 = strings(numMixed,1);
gapBound14 = nan(numMixed,1);
outBound14 = nan(numMixed,1);
minGap14 = inf(numMixed,1);
gapPair14 = zeros(numMixed,2);
gapAt14 = nan(numMixed,1);
failAt14 = nan(numMixed,1);
failCable14 = nan(numMixed,1);
failPair14 = nan(numMixed,2);

for e = 1:numMixed
    q0 = mixedEdges(e,1);
    q1 = mixedEdges(e,2);
    P0 = P_eval(q0,:);
    dp = P_eval(q1,:) - P0;
    travel = norm(dp);
    R0 = R_eval(:,:,q0);
    R1 = R_eval(:,:,q1);

    % 最短轴角旋转，与第 13 节一致。
    Q = R0.'*R1;
    axisSin = 0.5*[Q(3,2)-Q(2,3);
                   Q(1,3)-Q(3,1);
                   Q(2,1)-Q(1,2)];
    sinTheta = norm(axisSin);
    cosTheta = max(-1,min(1,(trace(Q)-1)/2));
    assert(sinTheta > 1e-12, ...
        'Pose %d 到 %d 的旋转轴不明确，请核对端点。',q0,q1);
    theta = atan2(sinTheta,cosTheta);
    v = axisSin/sinTheta;
    K = [0,-v(3),v(2); v(3),0,-v(1); -v(2),v(1),0];
    K2 = K*K;
    assert(norm(R0*(eye(3)+sin(theta)*K+(1-cos(theta))*K2)-R1, ...
        'fro') < 1e-8,'旋转插值终点不符。');

    pending = [0,1,0];       % [子段起点比例，终点比例，细分深度]
    acceptedGap = inf;
    acceptedOut = inf;
    unresolved = false;
    status14(e) = "Pass";

    while ~isempty(pending)
        part = pending(end,:);
        pending(end,:) = [];
        a = part(1); b = part(2); depth = part(3);
        mid = (a+b)/2;

        Pmid = P0 + mid*dp;
        phi = mid*theta;
        Rmid = R0*(eye(3)+sin(phi)*K+(1-cos(phi))*K2);
        s = (Rmid*r35.').';
        Bmid = Pmid+s;

        outMid = sum((s/rb).*(A35-Pmid),2)-rb;
        gaps = zeros(size(pairs14,1),1);
        for k = 1:size(pairs14,1)
            i = pairs14(k,1);
            j = pairs14(k,2);
            gaps(k) = B3_1_segment_distance_3d_2026_11_02( ...
                Bmid(i,:),A35(i,:),Bmid(j,:),A35(j,:));
        end
        assert(all(isfinite([outMid;gaps])),'几何计算产生非有限值。');

        [dMid,kPair] = min(gaps);
        [gMid,kCable] = min(outMid);
        if dMid < minGap14(e)
            minGap14(e) = dMid;
            gapPair14(e,:) = pairs14(kPair,:);
            gapAt14(e) = mid;
        end

        % 记录实际观测到的违反条件及其位置。
        if gMid < 0 || dMid < gapFloor
            failAt14(e) = mid;
            if gMid < 0
                failCable14(e) = kCable;
                status14(e) = "SphereFail";
            end
            if dMid < gapFloor
                failPair14(e,:) = pairs14(kPair,:);
                status14(e) = "CableFail";
                if gMid < 0
                    status14(e) = "BothFail";
                end
            end
            break
        end

        % 从中点推导整段下界，同时计入平移和旋转。
        h = (b-a)*travel/2;
        c = 2*sin((b-a)*theta/4);
        lowerGap = dMid - 2*(h+rb*c);
        lowerOut = min(outMid - h - vecnorm(A35-Pmid,2,2)*c);

        if lowerGap >= gapFloor && lowerOut >= 0
            acceptedGap = min(acceptedGap,lowerGap);
            acceptedOut = min(acceptedOut,lowerOut);
        elseif depth < maxDepth14
            pending = [pending; a,mid,depth+1; mid,b,depth+1]; %#ok<AGROW>
        else
            unresolved = true;
        end
    end

    if status14(e) == "Pass"
        if unresolved
            status14(e) = "Unresolved";
        else
            gapBound14(e) = acceptedGap;
            outBound14(e) = acceptedOut;
        end
    end
end

%% 14.3 汇总，与第 12、13 节使用相同的指标
mixedPaths35 = table(mixedEdges(:,1),mixedEdges(:,2),status14, ...
    gapBound14,outBound14,minGap14,gapPair14(:,1),gapPair14(:,2), ...
    gapAt14,failAt14,failCable14,failPair14(:,1),failPair14(:,2), ...
    'VariableNames',{'StartPose','EndPose','Status','GapLowerBound_mm', ...
    'OutProjectionLowerBound_mm','MinCheckedGap_mm','CableI','CableJ', ...
    'PathFraction','FailFraction','SphereFailCable','FailPairI','FailPairJ'});

fprintf('Pass %d/%d，SphereFail %d，CableFail %d，BothFail %d，Unresolved %d。\n', ...
    nnz(status14=="Pass"),numMixed,nnz(status14=="SphereFail"), ...
    nnz(status14=="CableFail"),nnz(status14=="BothFail"), ...
    nnz(status14=="Unresolved"));

if all(status14=="Pass")
    fprintf('组合路径共同的绳距下界 = %.6f mm，阈值 = %.6f mm。\n', ...
        min(gapBound14),gapFloor);
    fprintf('组合路径共同的向外投影下界 = %.6f mm。\n',min(outBound14));
else
    disp(mixedPaths35(status14~="Pass", ...
        {'StartPose','EndPose','Status','FailFraction', ...
         'SphereFailCable','FailPairI','FailPairJ'}));
end

[~,idx] = min(minGap14);
disp('已检查组合路径中，中点绳距最小的位置：');
disp(mixedPaths35(idx,{'StartPose','EndPose','MinCheckedGap_mm', ...
    'CableI','CableJ','PathFraction'}));

%% 15. C4-1 / 35 mm：核对 539 个评估位姿与连续路径端点的关系

%% 15.1 比较三类路径的端点集合
nEval15 = size(P_eval,1);
ids15 = (1:nEval15)';

translationIDs = unique([edges(:,1); edges(:,2)]);
rotationIDs    = unique(rotEdges(:));
mixedIDs       = unique(mixedEdges(:));
anyPathIDs     = unique([translationIDs; rotationIDs; mixedIDs]);

pathsSummary15 = table( ...
    ["Translation"; "Rotation"; "Mixed"; "Union"], ...
    [size(edges,1); size(rotEdges,1); size(mixedEdges,1); ...
    size(edges,1)+size(rotEdges,1)+size(mixedEdges,1)], ...
    [numel(translationIDs); numel(rotationIDs); ...
    numel(mixedIDs); numel(anyPathIDs)], ...
    'VariableNames',{'Motion','Paths','DistinctEndpointIDs'});
disp(pathsSummary15);

sameEndpoints15 = isequal(translationIDs,rotationIDs) && ...
    isequal(rotationIDs,mixedIDs);
fprintf('三类路径的端点编号集合完全一致：%d（1=是，0=否）。\n', ...
    sameEndpoints15);

%% 15.2 将全部评估位姿与组合路径端点比较
% 与前面建路径时使用相同的分组精度。
posKey15 = round(P_eval,9);
rotKey15 = round(reshape(R_eval,9,nEval15).',12);
poseKey15 = [posKey15, rotKey15];

isMixedEndpoint = ismember(ids15,mixedIDs);
samePose = ismember(poseKey15,poseKey15(mixedIDs,:),'rows');
samePos  = ismember(posKey15,posKey15(mixedIDs,:),'rows');
sameRot  = ismember(rotKey15,rotKey15(mixedIDs,:),'rows');

% 五类互斥，覆盖全部输入行。
class15 = strings(nEval15,1);
class15(isMixedEndpoint) = "MixedEndpoint";
class15(~isMixedEndpoint & samePose) = "DuplicateOfEndpoint";
class15(~samePose & samePos) = "KnownPosition_OtherOrientation";
class15(~samePose & ~samePos & sameRot) = "OtherPosition_KnownOrientation";
class15(~samePose & ~samePos & ~sameRot) = "OtherPosition_OtherOrientation";
assert(all(class15 ~= ""),'有位姿尚未归类。');

labels15 = ["MixedEndpoint"; "DuplicateOfEndpoint"; ...
    "KnownPosition_OtherOrientation"; "OtherPosition_KnownOrientation"; ...
    "OtherPosition_OtherOrientation"];

counts15 = zeros(numel(labels15),1);
for k = 1:numel(labels15)
    counts15(k) = nnz(class15 == labels15(k));
end
coverage15 = table(labels15,counts15, ...
    'VariableNames',{'RelationToMixedEndpoints','PoseCount'});
disp(coverage15);

%% 15.3 查看连续路径端点与其余离散样本的空间范围
extraIDs15 = ids15(~isMixedEndpoint);
sets15 = {mixedIDs, extraIDs15};
names15 = ["组合路径端点"; "其余评估位姿"];

for k = 1:2
    ids = sets15{k};
    if isempty(ids)
        continue
    end
    xyz = P_eval(ids,:);
    fprintf('\n%s：%d 行，%d 个不同球心，%d 个不同姿态。\n', ...
        char(names15(k)),numel(ids), ...
        size(unique(posKey15(ids,:),'rows'),1), ...
        size(unique(rotKey15(ids,:),'rows'),1));
    fprintf('  球心最小 [x y z] = [%g %g %g] mm\n',min(xyz,[],1));
    fprintf('  球心最大 [x y z] = [%g %g %g] mm\n',max(xyz,[],1));
end

% 保留逐位姿结果，可通过 PoseID 回查。
poseCoverage35 = table(ids15,P_eval(:,1),P_eval(:,2),P_eval(:,3), ...
    class15,ismember(ids15,anyPathIDs), ...
    'VariableNames',{'PoseID','X_mm','Y_mm','Z_mm', ...
    'RelationToMixedEndpoints','UsedByAnyPath'});

%% 16.1 为每个额外样本选择一个邻近的规则网格端点
gridIDs16 = mixedIDs(:);       % 第 15 节确认的 189 个规则端点
extraIDs16 = extraIDs15(:);    % 350 个额外评估位姿
numExtra16 = numel(extraIDs16);

assert(numel(gridIDs16) == 189 && numExtra16 == 350, ...
    '端点数量与第 15 节结果不符。');

nearestGrid16 = zeros(numExtra16,1);
translation16 = zeros(numExtra16,1);
rotation16 = zeros(numExtra16,1);
score16 = zeros(numExtra16,1);

for j = 1:numExtra16
    target = extraIDs16(j);
    Rt = R_eval(:,:,target);
    distances = vecnorm(P_eval(gridIDs16,:) - P_eval(target,:),2,2);
    angles = zeros(numel(gridIDs16),1);

    for k = 1:numel(gridIDs16)
        Q = R_eval(:,:,gridIDs16(k)).' * Rt;
        axisSin = 0.5 * [Q(3,2)-Q(2,3);
            Q(1,3)-Q(3,1);
            Q(2,1)-Q(1,2)];
        cosTheta = max(-1,min(1,(trace(Q)-1)/2));
        angles(k) = atan2(norm(axisSin),cosTheta);
    end

    scores = distances + 2*rb*sin(angles/2);
    [score16(j),kBest] = min(scores);

    nearestGrid16(j) = gridIDs16(kBest);
    translation16(j) = distances(kBest);
    rotation16(j) = rad2deg(angles(kBest));
end

bridgeEdges35 = [nearestGrid16, extraIDs16];
assert(numel(unique(bridgeEdges35(:,2))) == 350, ...
    '部分额外样本缺少连接路径。');

bridgeDesign35 = table(nearestGrid16,extraIDs16,translation16, ...
    rotation16,score16,'VariableNames', ...
    {'StartPose','EndPose','Translation_mm','Rotation_deg','Score_mm'});

fprintf('新增路径 %d 条，使用 %d 个不同网格起点，覆盖 %d 个额外样本。\n', ...
    height(bridgeDesign35),numel(unique(nearestGrid16)),numExtra16);
fprintf('球心平移范围：%.4f 至 %.4f mm。\n', ...
    min(translation16),max(translation16));
fprintf('最短旋转角范围：%.4f 至 %.4f deg。\n', ...
    min(rotation16),max(rotation16));

%% 14.2 检查每条组合路径-copied
numBridge35 = size(bridgeEdges35,1);
pairs14 = nchoosek(1:6,2);
maxDepth14 = 12;

status14 = strings(numBridge35,1);
gapBound14 = nan(numBridge35,1);
outBound14 = nan(numBridge35,1);
minGap14 = inf(numBridge35,1);
gapPair14 = zeros(numBridge35,2);
gapAt14 = nan(numBridge35,1);
failAt14 = nan(numBridge35,1);
failCable14 = nan(numBridge35,1);
failPair14 = nan(numBridge35,2);

for e = 1:numBridge35
    q0 = bridgeEdges35(e,1);
    q1 = bridgeEdges35(e,2);
    P0 = P_eval(q0,:);
    dp = P_eval(q1,:) - P0;
    travel = norm(dp);
    R0 = R_eval(:,:,q0);
    R1 = R_eval(:,:,q1);

    % 最短轴角旋转，与第 13 节一致。
    Q = R0.'*R1;
    axisSin = 0.5*[Q(3,2)-Q(2,3);
                   Q(1,3)-Q(3,1);
                   Q(2,1)-Q(1,2)];
    sinTheta = norm(axisSin);
    cosTheta = max(-1,min(1,(trace(Q)-1)/2));
    assert(sinTheta > 1e-12, ...
        'Pose %d 到 %d 的旋转轴不明确，请核对端点。',q0,q1);
    theta = atan2(sinTheta,cosTheta);
    v = axisSin/sinTheta;
    K = [0,-v(3),v(2); v(3),0,-v(1); -v(2),v(1),0];
    K2 = K*K;
    assert(norm(R0*(eye(3)+sin(theta)*K+(1-cos(theta))*K2)-R1, ...
        'fro') < 1e-8,'旋转插值终点不符。');

    pending = [0,1,0];       % [子段起点比例，终点比例，细分深度]
    acceptedGap = inf;
    acceptedOut = inf;
    unresolved = false;
    status14(e) = "Pass";

    while ~isempty(pending)
        part = pending(end,:);
        pending(end,:) = [];
        a = part(1); b = part(2); depth = part(3);
        mid = (a+b)/2;

        Pmid = P0 + mid*dp;
        phi = mid*theta;
        Rmid = R0*(eye(3)+sin(phi)*K+(1-cos(phi))*K2);
        s = (Rmid*r35.').';
        Bmid = Pmid+s;

        outMid = sum((s/rb).*(A35-Pmid),2)-rb;
        gaps = zeros(size(pairs14,1),1);
        for k = 1:size(pairs14,1)
            i = pairs14(k,1);
            j = pairs14(k,2);
            gaps(k) = B3_1_segment_distance_3d_2026_11_02( ...
                Bmid(i,:),A35(i,:),Bmid(j,:),A35(j,:));
        end
        assert(all(isfinite([outMid;gaps])),'几何计算产生非有限值。');

        [dMid,kPair] = min(gaps);
        [gMid,kCable] = min(outMid);
        if dMid < minGap14(e)
            minGap14(e) = dMid;
            gapPair14(e,:) = pairs14(kPair,:);
            gapAt14(e) = mid;
        end

        % 记录实际观测到的违反条件及其位置。
        if gMid < 0 || dMid < gapFloor
            failAt14(e) = mid;
            if gMid < 0
                failCable14(e) = kCable;
                status14(e) = "SphereFail";
            end
            if dMid < gapFloor
                failPair14(e,:) = pairs14(kPair,:);
                status14(e) = "CableFail";
                if gMid < 0
                    status14(e) = "BothFail";
                end
            end
            break
        end

        % 从中点推导整段下界，同时计入平移和旋转。
        h = (b-a)*travel/2;
        c = 2*sin((b-a)*theta/4);
        lowerGap = dMid - 2*(h+rb*c);
        lowerOut = min(outMid - h - vecnorm(A35-Pmid,2,2)*c);

        if lowerGap >= gapFloor && lowerOut >= 0
            acceptedGap = min(acceptedGap,lowerGap);
            acceptedOut = min(acceptedOut,lowerOut);
        elseif depth < maxDepth14
            pending = [pending; a,mid,depth+1; mid,b,depth+1]; %#ok<AGROW>
        else
            unresolved = true;
        end
    end

    if status14(e) == "Pass"
        if unresolved
            status14(e) = "Unresolved";
        else
            gapBound14(e) = acceptedGap;
            outBound14(e) = acceptedOut;
        end
    end
end

%% 14.3 汇总，与第 12、13 节使用相同的指标-copied
bridgePaths35 = table(bridgeEdges35(:,1),bridgeEdges35(:,2),status14, ...
    gapBound14,outBound14,minGap14,gapPair14(:,1),gapPair14(:,2), ...
    gapAt14,failAt14,failCable14,failPair14(:,1),failPair14(:,2), ...
    'VariableNames',{'StartPose','EndPose','Status','GapLowerBound_mm', ...
    'OutProjectionLowerBound_mm','MinCheckedGap_mm','CableI','CableJ', ...
    'PathFraction','FailFraction','SphereFailCable','FailPairI','FailPairJ'});

%% 16.3 核对并显示新增路径结果
Tbridge = bridgePaths35;

assert(height(Tbridge) == height(bridgeDesign35) && height(Tbridge) == 350, ...
    '新增路径结果表的行数与设计表不符。');
assert(isequal(Tbridge.StartPose, bridgeDesign35.StartPose) && ...
       isequal(Tbridge.EndPose,   bridgeDesign35.EndPose), ...
    '新增路径的端点编号或顺序与设计表不符。');

fprintf('新增路径：Pass %d/%d，SphereFail %d，CableFail %d，BothFail %d，Unresolved %d。\n', ...
    nnz(Tbridge.Status=="Pass"), height(Tbridge), ...
    nnz(Tbridge.Status=="SphereFail"), nnz(Tbridge.Status=="CableFail"), ...
    nnz(Tbridge.Status=="BothFail"), nnz(Tbridge.Status=="Unresolved"));

[~,iClosest] = min(Tbridge.MinCheckedGap_mm);
disp('新增路径中，已检查中点绳距最小的位置：');
disp(Tbridge(iClosest, {'StartPose','EndPose','MinCheckedGap_mm', ...
    'CableI','CableJ','PathFraction'}));

%% 16.4 核对端点覆盖，并比较两批同步平移与旋转路径
assert(isequal(bridgePaths35.StartPose,bridgeDesign35.StartPose) && ...
    isequal(bridgePaths35.EndPose,bridgeDesign35.EndPose), ...
    '路径结果与端点设计表顺序不一致。');

bridgePaths35.Translation_mm = bridgeDesign35.Translation_mm;
bridgePaths35.Rotation_deg = bridgeDesign35.Rotation_deg;

allEndpointIDs35 = unique([mixedEdges(:); bridgeEdges35(:)]);
fprintf('两批路径合计涉及端点：%d / %d 个评估位姿。\n', ...
    numel(allEndpointIDs35),size(P_eval,1));

if all(bridgePaths35.Status == "Pass")
    fprintf('350 条新增路径全部通过。\n');
    fprintf('新增路径共同绳距下界：%.6f mm；阈值：%.6f mm。\n', ...
        min(bridgePaths35.GapLowerBound_mm),gapFloor);
    fprintf('新增路径共同向外投影下界：%.6f mm。\n', ...
        min(bridgePaths35.OutProjectionLowerBound_mm));

    [~,iClosest] = min(bridgePaths35.MinCheckedGap_mm);
    disp('新增路径中，实际检查到的最近绳对及其运动位置：');
    disp(bridgePaths35(iClosest,{'StartPose','EndPose','Translation_mm', ...
        'Rotation_deg','MinCheckedGap_mm','CableI','CableJ','PathFraction'}));
end