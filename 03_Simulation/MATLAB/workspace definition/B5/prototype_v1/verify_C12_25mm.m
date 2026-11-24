function report = verify_C12_25mm(result)

% 从扫描结果提取全精度坐标；与 C4 使用相同的路径定义。
V = load(fullfile(fileparts(mfilename('fullpath')),'B5_4_E2_539pose_verification.mat'),'P_eval','R_eval','clearance_floor');
P_eval=V.P_eval; R_eval=V.R_eval; gapFloor=V.clearance_floor;
row=result.best(result.best.Offset_mm==25 & result.best.AxisID==2,:);
assert(height(row)==1 && row.Pass && row.BIndex==41);
A=result.A; r=result.r; A(6,:)=row.A6_mm; r(6,:)=row.B6_mm;
assert(norm(A(6,:)-[140 -115 -160])<1e-6);
rb=norm(r(6,:));
sigma=zeros(size(P_eval,1),1);
for q=1:numel(sigma)
    s=(R_eval(:,:,q)*r.').';
    D=A-(s+P_eval(q,:)); u=D./vecnorm(D,2,2);
    values=svd([-u,cross(u,s,2)/rb]); sigma(q)=values(end);
end
assert(abs(min(sigma)-row.WorstSigma)<1e-8 && abs(min(sigma)-0.509012)<1e-6,'所选配置的离散灵敏度未复现。');
%% 12. C12 / 新增25 mm：相同姿态下，相邻位置之间的连续平移检查
% 模型沿用第 9 节：刚性球、固定锚点、连接点到锚点之间为直线绳。
% 输入：A, r, rb, P_eval, R_eval, gapFloor

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
    s = (R * r.').';
    normals = s / rb;

    % 固定姿态直线平移时，向外投影的最小值一定出现在端点。
    proj0 = sum(normals .* (A - (s + p0)),2);
    proj1 = sum(normals .* (A - (s + P_eval(q1,:))),2);
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
            gaps(k) = segGap( ...
                Bmid(i,:), A(i,:), Bmid(j,:), A(j,:));
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

%% 13. C12 / 新增25 mm：固定球心的连续旋转检查

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

    anchorRadius = vecnorm(A-P,2,2);
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
        s = (Rmid*r.').';
        Bmid = P+s;

        % 六根绳的向外投影，单位 mm。负值表示从连接点朝球内出发。
        normals = s/rb;
        outMid = sum(normals .* (A-P),2) - rb;

        gaps = zeros(size(pairs13,1),1);
        for k = 1:size(pairs13,1)
            i = pairs13(k,1);
            j = pairs13(k,2);
            gaps(k) = segGap( ...
                Bmid(i,:),A(i,:),Bmid(j,:),A(j,:));
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

%% 14. C12 / 新增25 mm：相邻位置之间的同步平移 + 旋转
% 前置变量：edges, posGroup, P_eval, R_eval, A, r, rb, gapFloor

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

%% 16.1 为每个额外样本选择一个邻近的规则网格端点
gridIDs16 = usedPoses(:);       % 第 15 节确认的 189 个规则端点
extraIDs16 = setdiff((1:size(P_eval,1)).',usedPoses);    % 350 个额外评估位姿
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


gridEdges = mixedEdges;
mixedEdges = [gridEdges; bridgeEdges35];
numMixed = size(mixedEdges,1);
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
        s = (Rmid*r.').';
        Bmid = Pmid+s;

        outMid = sum((s/rb).*(A-Pmid),2)-rb;
        gaps = zeros(size(pairs14,1),1);
        for k = 1:size(pairs14,1)
            i = pairs14(k,1);
            j = pairs14(k,2);
            gaps(k) = segGap( ...
                Bmid(i,:),A(i,:),Bmid(j,:),A(j,:));
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
        lowerOut = min(outMid - h - vecnorm(A-Pmid,2,2)*c);

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


blocks={paths35,rotPaths35,mixedPaths35(1:size(gridEdges,1),:),mixedPaths35(size(gridEdges,1)+1:end,:)};
total=cellfun(@height,blocks(:)); assert(isequal(total,[378;567;2268;350]));
passed=zeros(4,1); unresolved=zeros(4,1); lower=nan(4,1);
for k=1:4
    T=blocks{k}; passed(k)=nnz(T.Status=="Pass"); unresolved(k)=nnz(T.Status=="Unresolved");
    if passed(k)==height(T), lower(k)=min(T.GapLowerBound_mm); end
    if passed(k)<height(T), disp(T(T.Status~="Pass",:)); end
end
summary=table(["平移";"旋转";"网格组合";"额外样本连接"],total,passed,unresolved,lower, ...
 'VariableNames',{'Motion','Total','Pass','Unresolved','GuaranteedGap_mm'});
disp(summary);
report=struct('summary',summary,'paths',{blocks},'selected',row);
end

function d = segGap(a,b,c,e)
% 有限线段最近距离：比较四个端点到对面线段，以及两条直线的内部最近点。
u = b-a; v = e-c; w = a-c;
U = dot(u,u); V = dot(v,v); assert(U>0 && V>0);
clip = @(x) max(0,min(1,x));
d = min([norm(w-clip(dot(w,v)/V)*v), ...
    norm(b-c-clip(dot(b-c,v)/V)*v), ...
    norm(c-a-clip(dot(c-a,u)/U)*u),norm(e-a-clip(dot(e-a,u)/U)*u)]);
n = cross(u,v); den = dot(n,n);
if den>0
    s = dot(cross(c-a,v),n)/den; t = dot(cross(c-a,u),n)/den;
    if s>=0 && s<=1 && t>=0 && t<=1, d = min(d,norm(w+s*u-t*v)); end
end
end
