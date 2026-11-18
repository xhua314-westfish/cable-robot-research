
%% Prototype V1 - M1.4
% Guide Angular Envelope Analysis
%
% 目的：
% 将每根Cable在539个开发位姿下的三维方向变化
% 分解为两个局部方向角。
%
% 输出：
% 1. 每根Cable的水平角范围
% 2. 每根Cable的竖直角范围
% 3. 相对于参考方向的最大空间偏角
% 4. 24根Cable的角度需求表
%
% 注意：
% 当前角度不是实际Swivel Pulley关节角。
% 也不能直接作为采购件的通过标准。

clear; clc; close all;

%% Step 1. 加载数据

V = load('B5_4_E2_539pose_verification.mat');

repair = load( ...
    'B5_4_E2_C2_C4_targeted_repair.mat');

P = V.P_eval;
Rraw = V.R_eval;

% 平移统一为 N x 3
if size(P,2)~=3 && size(P,1)==3
    P = P.';
end

assert(size(P,2)==3);

Npose = size(P,1);

% 旋转统一为 3 x 3 x N
if iscell(Rraw)

    R = zeros(3,3,Npose);

    assert(numel(Rraw)==Npose);

    for k=1:Npose
        R(:,:,k)=Rraw{k};
    end

else

    R = Rraw;

end

assert(size(R,1)==3 && ...
       size(R,2)==3 && ...
       size(R,3)==Npose);

%% Step 2. 读取四组真实配置

names = [
    "C2-2 Repaired M"
    "C4-1 E2 M"
    "C8-16 E2 M"
    "C12 E2 M"
];

parents = [
    "E1b C2-2"
    "E1b C4-1"
    "E1b C8-16"
    "E1a C12"
];

A_all = cell(4,1);
r_all = cell(4,1);

% C2的最终设计为定向修复后的M版本
matches = [];

for j=1:numel(repair.repaired_designs)

    item = repair.repaired_designs{j};

    if isempty(item) || ~isstruct(item)
        continue;
    end

    if isfield(item,'track') && ...
       string(item.track)=="MarginPreservingSensing" && ...
       isfield(item,'best_found') && ...
       item.best_found

        matches(end+1)=j;

    end

end

assert(numel(matches)==1, ...
    '无法唯一确定C2-2 Repaired M。');

item = repair.repaired_designs{matches};

A_all{1} = item.A_fixed;
r_all{1} = item.r_repaired;

% C4、C8、C12从E2验证数据读取
for d=2:4

    idx=find( ...
        string(V.T_verification.Design)==parents(d) & ...
        string(V.T_verification.Track)== ...
        "MarginPreservingSensing");

    assert(numel(idx)==1);

    item=V.designs{idx};

    A_all{d}=item.A;
    r_all{d}=item.r;

end

%% Step 3. 初始化结果

Nrow=24;

Design=strings(Nrow,1);
CableID=zeros(Nrow,1);

YawMin_deg=zeros(Nrow,1);
YawMax_deg=zeros(Nrow,1);
YawRange_deg=zeros(Nrow,1);

PitchMin_deg=zeros(Nrow,1);
PitchMax_deg=zeros(Nrow,1);
PitchRange_deg=zeros(Nrow,1);

MaxConeAngle_deg=zeros(Nrow,1);

% 用于显示局部方向角
all_angles=cell(Nrow,1);

row=0;

%% Step 4. 逐根Cable建立局部坐标系

for d=1:4

    A=A_all{d};
    r=r_all{d};

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    for i=1:6

        row=row+1;

        % 参考姿态：
        % 球体中心位于原点，旋转为单位阵
        v0=r(i,:)-A(i,:);

        e3=v0(:)/norm(v0);

        % 尽量使用世界Z轴建立局部坐标系
        helper=[0;0;1];

        % 如果参考Cable几乎平行世界Z轴，
        % 改用世界Y轴避免叉积接近零。
        if abs(dot(e3,helper))>0.95
            helper=[0;1;0];
        end

        % 建立局部正交基
        e1=cross(helper,e3);
        e1=e1/norm(e1);

        e2=cross(e3,e1);
        e2=e2/norm(e2);

        yaw=zeros(Npose,1);
        pitch=zeros(Npose,1);
        cone=zeros(Npose,1);

        %% Step 4.1. 遍历539个位姿

        for k=1:Npose

            % Attachment世界坐标
            B=P(k,:) + ...
                (R(:,:,k)*r(i,:).').';

            % 从Anchor指向Attachment
            v=B-A(i,:);

            u=v(:)/norm(v);

            % 将Cable方向投影到局部坐标系
            ux=dot(u,e1);
            uy=dot(u,e2);
            uz=dot(u,e3);

            % 水平和竖直局部偏角
            yaw(k)=atan2d(ux,uz);

            pitch(k)=atan2d( ...
                uy,hypot(ux,uz));

            % 与参考Cable方向的空间夹角
            c=max(-1,min(1,dot(u,e3)));

            cone(k)=acosd(c);

        end

        %% Step 4.2. 记录角度范围

        Design(row)=names(d);
        CableID(row)=i;

        YawMin_deg(row)=min(yaw);
        YawMax_deg(row)=max(yaw);

        YawRange_deg(row)= ...
            max(yaw)-min(yaw);

        PitchMin_deg(row)=min(pitch);
        PitchMax_deg(row)=max(pitch);

        PitchRange_deg(row)= ...
            max(pitch)-min(pitch);

        MaxConeAngle_deg(row)=max(cone);

        all_angles{row}=[yaw,pitch];

    end

end

%% Step 5. 输出角度需求表

T=table( ...
    Design,CableID, ...
    YawMin_deg,YawMax_deg,YawRange_deg, ...
    PitchMin_deg,PitchMax_deg,PitchRange_deg, ...
    MaxConeAngle_deg);

fprintf('\n=== M1.4 Guide Angular Envelope ===\n');

disp(T);

%% Step 6. 每组设计的最大需求

fprintf('\n=== Maximum Angular Requirements ===\n');

for d=1:4

    ids=find(Design==names(d));

    [yaw_span,j1]=max(YawRange_deg(ids));
    [pitch_span,j2]=max(PitchRange_deg(ids));
    [cone_max,j3]=max(MaxConeAngle_deg(ids));

    fprintf('\n%s\n',names(d));

    fprintf('Largest yaw range: %.3f deg, Cable %d\n', ...
        yaw_span,CableID(ids(j1)));

    fprintf('Largest pitch range: %.3f deg, Cable %d\n', ...
        pitch_span,CableID(ids(j2)));

    fprintf('Largest reference cone angle: %.3f deg, Cable %d\n', ...
        cone_max,CableID(ids(j3)));

end

%% Step 7. 绘制每个配置中空间偏角最大的Cable

figure('Color','w', ...
    'Position',[100 100 1100 760]);

tl=tiledlayout(2,2, ...
    'Padding','compact', ...
    'TileSpacing','compact');

for d=1:4

    ids=find(Design==names(d));

    % 选取该配置的最大空间偏角Cable
    [~,local]=max(MaxConeAngle_deg(ids));

    row_id=ids(local);

    ang=all_angles{row_id};

    ax=nexttile(tl,d);

    scatter(ax,ang(:,1),ang(:,2), ...
        12,'filled', ...
        'MarkerFaceAlpha',0.40);

    hold(ax,'on');

    plot(ax,0,0,'r+', ...
        'MarkerSize',11,'LineWidth',1.5);

    xlabel(ax,'Local yaw (deg)');
    ylabel(ax,'Local pitch (deg)');

    title(ax,sprintf( ...
        '%s | C%d', ...
        names(d),CableID(row_id)));

    grid(ax,'on');

    axis(ax,'equal');

    hold(ax,'off');

end

title(tl, ...
    'Guide Direction Envelope - 539 Development Poses');

%% Step 8. 保存结果

output_dir='Prototype_M1_4_Output';

if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

writetable(T,fullfile(output_dir, ...
    'M1_4_Guide_Angular_Envelope.csv'));

save(fullfile(output_dir, ...
    'M1_4_Guide_Angular_Envelope.mat'), ...
    'T','all_angles','names','Npose');

exportgraphics(gcf,fullfile(output_dir, ...
    'M1_4_Guide_Angular_Envelope.png'), ...
    'Resolution',300);

fprintf('\nM1.4 angular envelope analysis completed.\n');
