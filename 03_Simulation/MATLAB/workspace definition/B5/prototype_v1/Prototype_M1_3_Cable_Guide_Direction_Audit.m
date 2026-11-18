
%% Prototype V1 - M1.3
% Cable Guide Direction Audit
%
% 目的：
% 使用539个开发位姿，分析每根Cable的出线方向变化。
%
% 重点回答：
% 1. Cable相对于参考姿态最大偏转多少度？
% 2. 是否存在合适的固定滑轮平面？
% 3. 该平面下最大侧向出线角是多少？
%
% 注意：
% 本节不判断滑轮是否真正脱槽。
% 不引入人为规定的滑轮容许角度。
% 不修改任何Anchor/Attachment坐标。

clear; clc; close all;

%% Step 1 - 加载真实E2配置与开发位姿

V = load('B5_4_E2_539pose_verification.mat');

repair = load( ...
    'B5_4_E2_C2_C4_targeted_repair.mat');

assert(isfield(V,'P_eval'));
assert(isfield(V,'R_eval'));
assert(isfield(V,'T_verification'));
assert(isfield(V,'designs'));

P = V.P_eval;
Rraw = V.R_eval;

% 统一平移数据为 N x 3
if size(P,2) ~= 3 && size(P,1)==3
    P = P.';
end

assert(size(P,2)==3, ...
    'P_eval必须是N x 3或3 x N。');

Npose = size(P,1);

% 统一旋转数据为3 x 3 x N
if iscell(Rraw)

    assert(numel(Rraw)==Npose);

    R = zeros(3,3,Npose);

    for k=1:Npose
        R(:,:,k)=Rraw{k};
    end

elseif ndims(Rraw)==3

    R=Rraw;

elseif isequal(size(Rraw),[3 3]) && Npose==1

    R=reshape(Rraw,3,3,1);

else

    error('R_eval格式未识别。');

end

assert(size(R,1)==3 && ...
       size(R,2)==3 && ...
       size(R,3)==Npose);

fprintf('\nDevelopment poses: %d\n',Npose);

%% Step 2 - 读取四组最终设计

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

% C2读取定向修复后的最终设计
found = [];

for j=1:numel(repair.repaired_designs)

    item=repair.repaired_designs{j};

    if isempty(item) || ~isstruct(item)
        continue;
    end

    if isfield(item,'track') && ...
       string(item.track)=="MarginPreservingSensing" ...
       && isfield(item,'best_found') ...
       && item.best_found

        found=[found j];

    end

end

assert(numel(found)==1, ...
    '无法唯一找到C2 Repaired M。');

C2=repair.repaired_designs{found};

A_all{1}=C2.A_fixed;
r_all{1}=C2.r_repaired;

% 其余设计从E2验证文件读取
for d=2:4

    idx=find( ...
        string(V.T_verification.Design)==parents(d) & ...
        string(V.T_verification.Track)== ...
        "MarginPreservingSensing");

    assert(numel(idx)==1, ...
        '找不到唯一E2设计：%s',names(d));

    item=V.designs{idx};

    A_all{d}=item.A;
    r_all{d}=item.r;

end

%% Step 3 - 初始化结果

Design = strings(24,1);
CableID = zeros(24,1);

MaxReferenceAngle_deg = zeros(24,1);
RMSPlaneAngle_deg = zeros(24,1);
MaxPlaneAngle_deg = zeros(24,1);

WorstPoseID = zeros(24,1);

% 保存最佳拟合平面法向量
PlaneNormal = zeros(24,3);

row=0;

%% Step 4 - 逐个配置、逐根Cable分析

for d=1:4

    A=A_all{d};
    r=r_all{d};

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    for i=1:6

        row=row+1;

        %% 4.1 计算539位姿下的Cable方向

        U=zeros(Npose,3);

        for k=1:Npose

            % Attachment的世界坐标
            B=P(k,:) + (R(:,:,k)*r(i,:).').';

            % 从Anchor指向Attachment
            v=B-A(i,:);

            L=norm(v);

            assert(L>1e-9, ...
                'Cable长度异常。');

            U(k,:)=v/L;

        end

        %% 4.2 计算参考位姿方向

        % 球体中心位于原点，姿态为单位阵
        B_ref=r(i,:);

        v_ref=B_ref-A(i,:);

        u_ref=v_ref/norm(v_ref);

        % 与参考方向的夹角
        cosang=U*u_ref.';

        cosang=max(-1,min(1,cosang));

        ref_angles=acosd(cosang);

        MaxReferenceAngle_deg(row)=max(ref_angles);

        %% 4.3 拟合最佳均方固定滑轮平面

        % 平面经过方向空间的原点。
        % 找到使 sum((U*n)^2) 最小的法向量n。
        %
        % 该方法最小化平方侧向分量，
        % 并不保证最大偏角最小。

        C=(U.'*U)/Npose;

        [V_eig,D_eig]=eig(C);

        eig_values=diag(D_eig);

        [~,ind]=min(eig_values);

        n=V_eig(:,ind);

        n=n/norm(n);

        PlaneNormal(row,:)=n.';

        %% 4.4 计算偏离固定滑轮平面的角度

        side_component=abs(U*n);

        side_component=max(0,min(1,side_component));

        plane_angles=asind(side_component);

        RMSPlaneAngle_deg(row)= ...
            sqrt(mean(plane_angles.^2));

        [max_angle,worst_idx]=max(plane_angles);

        MaxPlaneAngle_deg(row)=max_angle;

        WorstPoseID(row)=worst_idx;

        Design(row)=names(d);
        CableID(row)=i;

    end

end

%% Step 5 - 输出结果

T=table( ...
    Design,CableID, ...
    MaxReferenceAngle_deg, ...
    RMSPlaneAngle_deg, ...
    MaxPlaneAngle_deg, ...
    WorstPoseID, ...
    PlaneNormal(:,1), ...
    PlaneNormal(:,2), ...
    PlaneNormal(:,3), ...
    'VariableNames',{ ...
    'Design','CableID', ...
    'MaxReferenceAngle_deg', ...
    'RMSPlaneAngle_deg', ...
    'MaxPlaneAngle_deg', ...
    'WorstPoseID', ...
    'PlaneNormal_X', ...
    'PlaneNormal_Y', ...
    'PlaneNormal_Z'});

fprintf('\n=== M1.3 Guide Direction Audit ===\n');

disp(T);

%% Step 6 - 找到每组最不适合固定滑轮的Cable

fprintf('\n=== Worst Fixed-Plane Cable per Design ===\n');

for d=1:4

    ids=find(Design==names(d));

    [val,local_idx]= ...
        max(MaxPlaneAngle_deg(ids));

    id=ids(local_idx);

    fprintf( ...
        '%s: Cable %d, max plane deviation %.3f deg, pose %d\n', ...
        names(d),CableID(id),val,WorstPoseID(id));

end

%% Step 7 - 四组设计横向比较

angle_grid=zeros(4,6);

for d=1:4

    for i=1:6

        idx=find(Design==names(d) & CableID==i);

        angle_grid(d,i)=MaxPlaneAngle_deg(idx);

    end

end

figure('Color','w', ...
    'Position',[100 100 1000 430]);

imagesc(angle_grid);

colorbar;

colormap(parula);

xticks(1:6);

xticklabels( ...
    {'C1','C2','C3','C4','C5','C6'});

yticks(1:4);

yticklabels(cellstr(names));

xlabel('Cable ID');

ylabel('Configuration');

title( ...
    'Maximum Out-of-Plane Cable Angle (539 Development Poses)');

% 在每个格子显示角度数值
for d=1:4

    for i=1:6

        text(i,d, ...
            sprintf('%.1f°',angle_grid(d,i)), ...
            'HorizontalAlignment','center', ...
            'Color','k', ...
            'FontWeight','bold');

    end

end

%% Step 8 - 保存结果

output_dir='Prototype_M1_3_Output';

if ~exist(output_dir,'dir')
    mkdir(output_dir);
end

writetable(T,fullfile(output_dir, ...
    'M1_3_Guide_Direction_Audit.csv'));

save(fullfile(output_dir, ...
    'M1_3_Guide_Direction_Audit.mat'), ...
    'T','angle_grid','names','Npose');

exportgraphics(gcf,fullfile(output_dir, ...
    'M1_3_Guide_Direction_Heatmap.png'), ...
    'Resolution',300);

fprintf('\nM1.3 direction audit completed.\n');
fprintf('Results saved to: %s\n',output_dir);
