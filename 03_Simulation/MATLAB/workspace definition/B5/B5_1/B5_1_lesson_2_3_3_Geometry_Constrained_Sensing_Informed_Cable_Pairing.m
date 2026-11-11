%% B5.1 Lesson 2.3.3 - Revised
% Geometry-Constrained Sensing-Informed Cable Pairing
%
% Research Question:
% Can cable pairing improve sensing quality while
% satisfying geometric feasibility at the reference pose?
%
% Objectives:
% 1. Enumerate 720 pairing permutations per family
% 2. Check cable-sphere interference
% 3. Check cable-cable interference
% 4. Check Jacobian rank
% 5. Maximise minimum scaled singular value
% 6. Compare original and selected pairings
%
% IMPORTANT:
% Only reference pose P=[0 0 0], R=I is tested.
% Multi-pose evaluation belongs to B5.2.

clear; clc; close all;

%% Step 1: Load initial complete configurations

load('B5_1_initial_6cable_configurations.mat', ...
    'C_families','family_names','rb');

% 确认B3已有距离函数能够被MATLAB找到
assert(exist('B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'Please add the existing B3 distance function to path.');

n = 6;
N_family = numel(C_families);

% 参考姿态
P = [0 0 0];
R = eye(3);

% 生成全部6!种一对一配对
pairings = perms(1:n);
N_pairings = size(pairings,1);

% 15组Cable配对，用于干涉检查
cable_pairs = nchoosek(1:n,2);

% 与B4保持一致的Jacobian缩放
scale = diag([1 1 1 1/rb 1/rb 1/rb]);

%% Step 2: Define numerical tolerances
% B3.2使用的Cable-sphere数值容差
% 点积的单位是mm^2
sphere_tol = 1e-9;

% B3.2使用的Cable-cable数值接触阈值
% 单位为mm
contact_tol = 1e-6;

% 保存每个Family的最佳配置
best_configs = cell(N_family,1);

% 汇总结果，每个Family一行
summary = zeros(N_family,8);

%% Step 3: Evaluate each configuration family

for k = 1:N_family
    A = C_families{k}.A;

    % 固定当前Family的六个Attachment物理位置
    r_set = C_families{k}.r;

    assert(isequal(size(A),[6,3]));
    assert(isequal(size(r_set),[6,3]));

    % 记录每道筛选通过的数量
    count_sphere = 0;
    count_geometry = 0;
    count_rank = 0;

    % 最佳最小奇异值
    best_sigma = -inf;

    % 最佳配对序号
    best_pairing = [];

    % 最佳Condition Number及Cable间距
    best_kappa = NaN;
    best_clearance = NaN;

    % 记录原始配对是否通过几何检查
    original_geometry_pass = false;

    % 原始参考姿态Sensing结果
    original_sigma = NaN;
    original_kappa = NaN;

    %% Step 4: Enumerate all pairing permutations

    for p = 1:N_pairings

        % 当前的Anchor-Attachment对应关系
        pairing = pairings(p,:);

        % 根据当前排列重新连接六根Cable
        r = r_set(pairing,:);

        % 世界坐标下的Attachment
        B = (R*r.' + P.').';

        % 从Attachment指向Anchor的Cable向量
        D = A-B;

        % 每根Cable的长度
        L = vecnorm(D,2,2);

        % 排除退化长度
        if any(L <= 1e-9)
            continue;
        end

        %% Filter 1: Cable-sphere interference

        % 气球中心到Attachment的向量
        S = (R*r.').';

        % Cable向量与球体外法线方向的点积
        outward_dot = sum(S.*D,2);

        % 与B3.2相同的球面穿透判据
        sphere_pass = all(outward_dot >= -sphere_tol);

        if ~sphere_pass
            continue;
        end

        count_sphere = count_sphere+1;

        %% Filter 2: Cable-cable interference

        % 默认当前Pairing没有Cable接触
        contact_found = false;

        % 记录当前配对中最小的Cable距离
        min_cable_distance = inf;

        for j = 1:size(cable_pairs,1)

            i1 = cable_pairs(j,1);
            i2 = cable_pairs(j,2);

            % 复用B3已验证的有限线段距离函数
            dist = B3_1_segment_distance_3d_2026_11_02( ...
                B(i1,:),A(i1,:), ...
                B(i2,:),A(i2,:));

            % 更新15组Cable中的最小距离
            min_cable_distance = min( ...
                min_cable_distance,dist);

            % 当前采用理想零厚度Cable接触阈值
            if dist <= contact_tol
                contact_found = true;
                break;
            end
        end

        if contact_found
            continue;
        end

        count_geometry = count_geometry+1;

        %% Filter 3: Jacobian and sensing quality
        
        H = zeros(6,6);

        % Cable单位方向向量
        U = D ./ L;

        for i = 1:n

            % 平移灵敏度
            H(i,1:3) = -U(i,:);

            % 旋转灵敏度
            H(i,4:6) = cross(U(i,:),S(i,:));

        end

        % 缩放Jacobian
        Hs = H*scale;

        % 计算奇异值
        sv = svd(Hs);

        % 检查完整六自由度局部可辨识性
        if rank(Hs)<6
            continue;
        end

        count_rank = count_rank+1;

        sigma_min = min(sv);
        kappa = max(sv)/sigma_min;

        %% Step 5: Record original pairing

        % 原始配对为[1 2 3 4 5 6]
        if isequal(pairing,1:n)

            original_geometry_pass = true;
            original_sigma = sigma_min;
            original_kappa = kappa;

        end
        
        %% Step 6: Select best feasible pairing

        % 主要目标：最大化最小奇异值
        if sigma_min > best_sigma

            best_sigma = sigma_min;
            best_pairing = pairing;

            best_kappa = kappa;
            best_clearance = min_cable_distance;

        end
    end

    %% Step 7: Report current Family

    fprintf('\n===================================\n');
    fprintf('%s\n',family_names{k});
    fprintf('===================================\n');

    fprintf('Total pairings: %d\n',N_pairings);

    fprintf('Sphere passing: %d\n',count_sphere);

    fprintf('Full geometry passing: %d\n',count_geometry);

    fprintf('Full-rank geometry passing: %d\n',count_rank);

    % 单独计算原始配置的Sensing指标用于比较
    % 即使原始配对几何不合格，也保留其诊断值
    H0 = zeros(6,6);

    r0 = r_set;

    D0 = A-r0;
    L0 = vecnorm(D0,2,2);

    U0 = D0./L0;

    for i = 1:n

        H0(i,1:3) = -U0(i,:);

        H0(i,4:6) = cross(U0(i,:),r0(i,:));

    end

    Hs0 = H0*scale;

    sv0 = svd(Hs0);

    original_sigma = min(sv0);
    original_kappa = cond(Hs0);

    fprintf('\nOriginal pairing:\n');
    fprintf('Geometry pass: %d\n',original_geometry_pass);

    fprintf('Sigma_min: %.6f\n',original_sigma);
    fprintf('Kappa: %.6f\n',original_kappa);

    %% Step 8: Store best configuration

    if isempty(best_pairing)

        fprintf('\nNo feasible full-rank pairing found.\n');

        best_configs{k} = [];

        % 即使失败，也保留失败数量
        summary(k,:) = [
            N_pairings,count_sphere,count_geometry, ...
            count_rank,NaN,NaN,NaN, ...
            double(original_geometry_pass)
            ];

        continue;

    end

    % 保存几何可行且参考姿态Sensing最好的配对
    best_configs{k}.A = A;
    best_configs{k}.r = r_set(best_pairing,:);
    best_configs{k}.pairing = best_pairing;
    best_configs{k}.sigma_min = best_sigma;
    best_configs{k}.kappa = best_kappa;
    best_configs{k}.min_cable_distance = best_clearance;

    fprintf('\nBest feasible pairing: ');
    fprintf('%d ',best_pairing);
    fprintf('\n');

    fprintf('Best sigma_min: %.6f\n',best_sigma);
    fprintf('Best kappa: %.6f\n',best_kappa);

    fprintf('Minimum cable distance: %.6f mm\n', ...
        best_clearance);

    summary(k,:) = [
        N_pairings,count_sphere,count_geometry, ...
        count_rank,best_sigma,best_kappa, ...
        best_clearance,double(original_geometry_pass)
        ];
end

%% Step 9: Compare the three families

result_table = array2table(summary, ...
    'VariableNames', ...
    {'Total','SpherePass','GeometryPass', ...
    'RankPass','BestSigmaMin','BestKappa', ...
    'MinCableDistance','OriginalGeometryPass'});

result_table.Family = string(family_names(:));

result_table = movevars(result_table, ...
    'Family','Before',1);

disp('--- Geometry-Constrained Pairing Summary ---');
disp(result_table);

%% Step 10: Numerical consistency checks

% 通过完整几何检查的数量不能超过Sphere通过数量
assert(all(summary(:,3)<=summary(:,2)));

% 满秩通过数量不能超过完整几何通过数量
assert(all(summary(:,4)<=summary(:,3)));

% 全部数量不能超过720
assert(all(summary(:,2)<=N_pairings));

fprintf('\nNumerical count checks passed.\n');

%% Step 11: Save results

save('B5_1_geometry_constrained_pairing.mat', ...
    'best_configs','result_table', ...
    'C_families','family_names', ...
    'sphere_tol','contact_tol','rb');

fprintf('Geometry-constrained pairing results saved.\n');

%% Step 12: Visualise best pairing configurations
% 新增部分
%
% 目标：
% 1. 同时展示F1、F2、F3最佳配对
% 2. 每根Cable用不同颜色
% 3. Anchor标注A1-A6
% 4. Attachment标注B1-B6
% 5. Cable中间标注C1-C6
% 6. 标明原始Attachment编号r_i
%
% B_i：最终Cable i的Attachment世界坐标
% r_j：配对之前的原始Attachment编号

% 为六根Cable指定固定颜色
% 三个Family采用同样的编号颜色
cable_colors = lines(n);

% 创建完整的三列布局
fig = figure( ...
    'Color','w', ...
    'Name','B5.1 Best Cable Pairing Comparison', ...
    'Position',[100 100 1650 650]);

% 半透明球体，用于显示参考姿态
[Xs,Ys,Zs] = sphere(50);

% 用于图形标注的偏移量
% 单位mm，防止标签与散点完全重合
anchor_offset = [5 5 5];
attach_offset = [3 3 3];
cable_offset = [3 -3 3];

for k = 1:N_family

    subplot(1,N_family,k);
    hold on;

    % 若当前Family不存在最佳配置则跳过
    if isempty(best_configs{k})

        title(sprintf('%s - No Feasible Pairing', ...
            family_names{k}));

        axis off;
        continue;

    end

    % 获取最佳配置
    config = best_configs{k};

    A = config.A;
    r = config.r;

    pairing = config.pairing;

    % 参考姿态：P=[0 0 0], R=I
    B = (R*r.' + P.').';

    %% 12.1 Draw rigid spherical balloon

    % 球体只是几何参考模型
    % 不表示真实柔性气球已经得到验证
    hSphere = surf( ...
        rb*Xs+P(1), ...
        rb*Ys+P(2), ...
        rb*Zs+P(3), ...
        'FaceColor',[0.45 0.75 0.95], ...
        'FaceAlpha',0.12, ...
        'EdgeColor','none', ...
        'HandleVisibility','off');

    %% 12.2 Draw every cable and both endpoints

    for i = 1:n

        % 第i根Cable的颜色
        color_i = cable_colors(i,:);

        % 当前Cable的两个端点
        Ai = A(i,:);
        Bi = B(i,:);

        % 画Cable有限线段
        plot3( ...
            [Ai(1) Bi(1)], ...
            [Ai(2) Bi(2)], ...
            [Ai(3) Bi(3)], ...
            '-', ...
            'Color',color_i, ...
            'LineWidth',2.0, ...
            'HandleVisibility','off');

        % Anchor标记：圆形
        scatter3( ...
            Ai(1),Ai(2),Ai(3), ...
            65,color_i,'o','filled', ...
            'MarkerEdgeColor',[0.15 0.15 0.15], ...
            'HandleVisibility','off');

        % Attachment标记：菱形
        scatter3( ...
            Bi(1),Bi(2),Bi(3), ...
            65,color_i,'d','filled', ...
            'MarkerEdgeColor',[0.15 0.15 0.15], ...
            'HandleVisibility','off');

        %% 12.3 Label Anchor

        text( ...
            Ai(1)+anchor_offset(1), ...
            Ai(2)+anchor_offset(2), ...
            Ai(3)+anchor_offset(3), ...
            sprintf('A%d',i), ...
            'FontSize',10, ...
            'FontWeight','bold', ...
            'Color',color_i, ...
            'Clipping','off');

        %% 12.4 Label Attachment

        % pairing(i)表示当前Cable使用的
        % 原始Attachment编号
        original_r_id = pairing(i);

        % B_i表示当前Cable i的Attachment端点
        % 括号中显示原始r编号
        attachment_label = sprintf( ...
            'B%d (r%d)',i,original_r_id);

        text( ...
            Bi(1)+attach_offset(1), ...
            Bi(2)+attach_offset(2), ...
            Bi(3)+attach_offset(3), ...
            attachment_label, ...
            'FontSize',8, ...
            'Color',color_i, ...
            'Clipping','off');

        %% 12.5 Label Cable

        % 在Cable中点附近标注编号
        midpoint = (Ai+Bi)/2;

        text( ...
            midpoint(1)+cable_offset(1), ...
            midpoint(2)+cable_offset(2), ...
            midpoint(3)+cable_offset(3), ...
            sprintf('C%d',i), ...
            'FontSize',10, ...
            'FontWeight','bold', ...
            'Color',color_i, ...
            'BackgroundColor','w', ...
            'Margin',1, ...
            'Clipping','off');

    end

    %% 12.6 Configure axes

    xlabel('X - Length (mm)');
    ylabel('Y - Width (mm)');
    zlabel('Z - Height (mm)');

    % 把配置名称及主要Sensing指标放在标题
    title({
        char(family_names{k}), ...
        sprintf('\\sigma_{min}=%.4f, \\kappa=%.2f', ...
        config.sigma_min,config.kappa)
    },'FontSize',11);

    axis equal;
    grid on;
    view(35,25);

    % 统一三个Family的边界范围
    % 比例一致，便于横向比较
    xlim([-160 160]);
    ylim([-170 170]);
    zlim([-180 180]);

    set(gca,'FontSize',9);

    hold off;

end

%% Step 13: Add legend for endpoint types
% 使用一个单独的小型Legend
% 颜色表示Cable编号
% 圆形表示Anchor
% 菱形表示Attachment

figure(fig);

% 在第一幅子图中添加简洁Legend
subplot(1,N_family,1);
hold on;

% 使用NaN创建仅用于图例的对象
hAnchor = plot3(NaN,NaN,NaN,'o', ...
    'MarkerFaceColor',[0.3 0.3 0.3], ...
    'MarkerEdgeColor',[0.3 0.3 0.3], ...
    'LineStyle','none');

hAttachment = plot3(NaN,NaN,NaN,'d', ...
    'MarkerFaceColor',[0.3 0.3 0.3], ...
    'MarkerEdgeColor',[0.3 0.3 0.3], ...
    'LineStyle','none');

hCable = plot3(NaN,NaN,NaN,'-', ...
    'Color',[0.3 0.3 0.3], ...
    'LineWidth',2);

legend( ...
    [hAnchor,hAttachment,hCable], ...
    {'Anchor A_i','Attachment B_i','Cable C_i'}, ...
    'Location','best', ...
    'FontSize',8);

hold off;

%% Step 14: Export figure

% 导出三种最佳配对的比较图
exportgraphics(fig, ...
    'B5_1_best_pairing_comparison.png', ...
    'Resolution',300);

fprintf('\nBest pairing visualisation completed.\n');
fprintf('Figure saved: B5_1_best_pairing_comparison.png\n');