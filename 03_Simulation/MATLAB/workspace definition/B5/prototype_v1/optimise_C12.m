function result = optimise_C12()
% C12 六绳优化：先扫描 A6，再调整 B6，最后比较安装退让与灵敏度。
% 将本文件放在 C4 使用的 539 位姿 MAT 旁边，运行 result = optimise_C12;
% 仅需 MATLAB 基础函数。本函数在自己的工作区运行。
root = fileparts(mfilename('fullpath'));
V = load(fullfile(root,'B5_4_E2_539pose_verification.mat'));
T = V.T_verification;
id = find(string(T.Design)=="E1a C12" & string(T.Track)=="MarginPreservingSensing");
assert(isscalar(id) && T.FullEligible(id),'未找到唯一且已通过验证的 C12 M 配置。');
cfg = V.designs{id}; A = cfg.A; r = cfg.r;
P = V.P_eval; R = V.R_eval; floorGap = V.clearance_floor;
assert(isequal(size(P),[539 3]) && isequal(size(R),[3 3 539]));
rb = norm(r(6,:)); assert(max(abs(vecnorm(r,2,2)-rb))<1e-6);
% 先定位 A6 所在的有限导轨，再从实际位置向轨内移动。
a6 = A(6,:); tol = 1e-5;
fprintf('原始 A6 = [%.9f %.9f %.9f] mm。\n',a6);
railFile = fullfile(root,'B5_3_12rail_geometry_baseline.mat');
if ~isfile(railFile)
    railFile = fullfile(fileparts(root),'B5_3','B5_3_12rail_geometry_baseline.mat');
end
eFile = fullfile(root,'B5_4_E2_sequential_optimisation.mat');
if isfile(railFile)
    G = load(railFile,'rail_start','rail_end');
    starts = G.rail_start; ends = G.rail_end;
else
    % 缺少导轨文件时按项目框架尺寸重建 12 条边，仅用几何定位。
    [x,y,z] = ndgrid([-140 140],[-150 150],[-160 160]);
    vertices = [x(:),y(:),z(:)]; pairsV = nchoosek(1:8,2);
    starts = vertices(pairsV(:,1),:); ends = vertices(pairsV(:,2),:);
    keep = sum(starts~=ends,2)==1; starts = starts(keep,:); ends = ends(keep,:);
end
vRail = ends-starts;
len = vecnorm(vRail,2,2); assert(all(len>0));
unit = vRail./len;
along = sum((a6-starts).*unit,2);
nearest = starts+min(max(along,0),len).*unit;
residual = vecnorm(nearest-a6,2,2);
rails = find(residual<=tol);
if isfile(eFile) && isfile(railFile)
    E = load(eFile); j = find(string(E.T_optimisation.DesignName)=="E1a C12" & ...
        string(E.T_optimisation.TrackName)=="MarginPreservingSensing");
    assert(isscalar(j)); src = E.optimised_designs{j}; rid = src.rail_ids(6);
    assert(ismember(rid,rails),'A6 与 E2 指定导轨不一致，最近轨残差 %.9g mm。',min(residual));
    rails = rid; fprintf('使用原始 Rail %d。\n',rid);
end
assert(~isempty(rails),'A6 距最近框架导轨 %.9g mm，请核对框架坐标和导轨文件。',min(residual));
axesToScan = []; directionByAxis = zeros(3); startMargin = nan(3,1);
roomToMiddle = nan(3,1);
for rid = rails(:).'
    ax = find(abs(unit(rid,:))>tol); assert(isscalar(ax),'预期轴向导轨。');
    direction = unit(rid,:);
    if along(rid)>len(rid)/2, direction = -direction; end
    axesToScan(end+1) = ax;
    directionByAxis(ax,:) = direction;
    startMargin(ax) = min(norm(a6-starts(rid,:)),norm(a6-ends(rid,:)));
    roomToMiddle(ax) = abs(along(rid)-len(rid)/2);
    fprintf('轴 %d，向内方向 [%+g %+g %+g]，原始端距 %.6f mm。\n', ...
        ax,direction,startMargin(ax));
end

%% 一、生成候选；第一个 B6 就是原始点，提供只动 A6 的对照。
offsets = 0:5:40;
arc = [0; repelem([2;4;6],16)];
bearing = [0; repmat((0:22.5:337.5)',3,1)];
n = r(6,:)/rb;
[~,k] = min(abs(n)); ref = eye(3);
t = ref(k,:)-n(k)*n; t = t/norm(t); t2 = cross(n,t);
candidates = rb*(cosd(arc).*n + sind(arc).*(cosd(bearing).*t+sind(bearing).*t2));
candidates(1,:) = r(6,:);
% B1、B5 均固定。该弦长需与后续实际接头尺寸比较。
d15 = norm(r(1,:)-r(5,:));
fprintf('B1–B5 安装点中心距 %.6f mm。\n',d15);

%% 二、缓存前五根绳：端点、Jacobian 行、出球角和十对固定绳距。
N = size(P,1); pairs = nchoosek(1:5,2);
B = zeros(5,3,N); H = zeros(5,6,N);
fixedGap = inf; fixedAngle = 90;
for q = 1:N
    s = (R(:,:,q)*r(1:5,:).').'; B(:,:,q) = P(q,:)+s;
    D = A(1:5,:)-B(:,:,q); u = D./vecnorm(D,2,2);
    H(:,:,q) = [-u,cross(u,s,2)/rb];
    fixedAngle = min(fixedAngle,min(asind(max(-1,min(1,sum(u.*s,2)/rb)))));
    for pair = pairs.'
        i = pair(1); j = pair(2);
        fixedGap = min(fixedGap,segGap(A(i,:),B(i,:,q),A(j,:),B(j,:,q)));
    end
end

%% 三、每个设计用同一批位姿打分。先算最差灵敏度，再检查几何。
rows = zeros(numel(axesToScan)*numel(offsets)*numel(arc),10); row = 0;
for ax = axesToScan(:).'
    direction = directionByAxis(ax,:);
    for offset = offsets(offsets <= roomToMiddle(ax)+tol)
        anchor = A(6,:) + offset*direction;
        for j = 1:numel(arc)
            worst = inf; pose = 0; gap = fixedGap; angle = fixedAngle;
            for q = 1:N
                s = (R(:,:,q)*candidates(j,:).').'; b = P(q,:)+s;
                u = (anchor-b)/norm(anchor-b);
                sv = svd([H(:,:,q); -u,cross(u,s)/rb]);
                if sv(end)<worst, worst = sv(end); pose = q; end
                angle = min(angle,asind(max(-1,min(1,dot(u,s)/rb))));
                for i = 1:5
                    gap = min(gap,segGap(anchor,b,A(i,:),B(i,:,q)));
                end
            end
            row = row+1;
            rows(row,:) = [ax offset j arc(j) bearing(j) worst pose gap angle ...
                (gap>=floorGap && angle>=0 && worst>1e-9)];
        end
        fprintf('轴 %d，退让 %g mm 完成。\n',ax,offset);
    end
end
scan = array2table(rows(1:row,:),'VariableNames',{'AxisID','Offset_mm','BIndex','Arc_deg', ...
    'Bearing_deg','WorstSigma','WorstPose','MinGap_mm','MinOutAngle_deg','Pass'});
scan.Pass = logical(scan.Pass);
anchorOnly = scan(scan.BIndex==1,:);
assert(all(anchorOnly.Pass(anchorOnly.Offset_mm==0)),'原始 C12 未复现几何通过，请检查输入。');

%% 四、逐方向、逐退让选最佳可行 B6，同时给出只动 A6 的对照。
valid = sortrows(scan(scan.Pass,:),{'AxisID','Offset_mm','WorstSigma','BIndex'}, ...
    {'ascend','ascend','descend','ascend'});
[~,first] = unique(valid(:,{'AxisID','Offset_mm'}),'rows','stable');
best = valid(first,:);
[~,base] = ismember(best(:,{'AxisID','Offset_mm'}),anchorOnly(:,{'AxisID','Offset_mm'}),'rows');
best.AnchorOnlySigma = anchorOnly.WorstSigma(base);
best.AnchorOnlyPass = anchorOnly.Pass(base);
best.Gain_pct = 100*(best.WorstSigma./best.AnchorOnlySigma-1);
best.A6_mm = repmat(A(6,:),height(best),1);
for k = 1:height(best)
    ax = best.AxisID(k);
    best.A6_mm(k,:) = a6 + directionByAxis(ax,:)*best.Offset_mm(k);
end
best.EndMargin_mm = startMargin(best.AxisID) + best.Offset_mm;
best.B6_mm = candidates(best.BIndex,:);
disp(best);
figure('Color','w'); tiledlayout(1,numel(axesToScan));
for ax = axesToScan(:).'
    nexttile; hold on; grid on;
    a = anchorOnly(anchorOnly.AxisID==ax,:); b = best(best.AxisID==ax,:);
    plot(a.Offset_mm,a.WorstSigma,'o--','DisplayName','Original B6');
    plot(b.Offset_mm,b.WorstSigma,'s-','DisplayName','Best feasible B6');
    plot(a.Offset_mm(~a.Pass),a.WorstSigma(~a.Pass),'rx','DisplayName','Original B6 infeasible');
    xlabel('Additional A6 shift (mm)'); ylabel('Worst scaled sigma min');
    names = ["X","Y","Z"]; title(names(ax)); legend('Location','best');
end
result = struct('scan',scan,'anchorOnly',anchorOnly,'best',best,'A',A,'r',r, ...
    'B1B5_mm',d15,'clearanceFloor_mm',floorGap);
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
