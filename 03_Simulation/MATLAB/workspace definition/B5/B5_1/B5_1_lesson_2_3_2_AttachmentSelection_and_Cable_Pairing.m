%% B5.1 Lesson 2.3.2
% Attachment Selection and Cable Pairing
%
% Research Question:
% How can attachments be paired with anchors
% to construct initial six-cable configurations?
%
% Goal:
% 1. Use three existing anchor families
% 2. Select six attachment points per family
% 3. Avoid duplicate and closely spaced attachments
% 4. Avoid inward-pointing and nearly radial cables
% 5. Evaluate reference-pose Jacobian metrics
%
% Important:
% These are INITIAL candidate configurations.
% Multi-pose collision and clearance are NOT checked.
%

clear; clc; close all;
rng(42);

%% Step 1: Load previous candidate datasets

load('B5_1_configuration_families.mat', ...
    'A_families','family_names');

load('B5_1_attachment_candidates.mat', ...
    'r100','rb');

% 共有三个 Anchor Families
N_family = numel(A_families);

% 每组有六根 Cable
n = 6;

%% Step 2: Define provisional selection parameters

% Attachment之间的最小三维距离
% 这里只是初步筛选参数，尚非机械设计标准
min_attachment_spacing = 20;  % mm

% Cable出线方向与球面外法线之间的余弦
min_outward_cos = 0.2;
max_outward_cos = 0.9;

% 目标出线余弦，仅用于候选排序
target_outward_cos = 0.6;

% 保存三组完整配置
C_families = cell(N_family,1);

%% Step 3: Select attachments for each family

for k = 1:N_family

     A = A_families{k};

     % 存储六个选中的 Attachment
     r_selected = zeros(n,3);

     % 防止重复选中同一个 Fibonacci 候选点
     used = false(size(r100,1),1);

     for i = 1:n

         % 当前 Cable 的 Anchor
         Ai = A(i,:);

         % 计算当前 Anchor 指向所有候选 Attachment
         % 的 Cable 向量
         D = Ai - r100;

         % 各候选 Cable 长度
         L = vecnorm(D,2,2);

         % 单位出线方向
         U = D ./ L;

         % 球面 Attachment 的外法线方向
         normals = r100 / rb;

         % Cable方向与外法线之间的余弦
         outward_cos = sum(U.*normals,2);

         % 初始出线方向筛选
         valid = ...
             outward_cos >= min_outward_cos & ...
             outward_cos <= max_outward_cos & ...
             ~used;

         % 与已选 Attachment 检查最小距离
         if i > 1
             for j = 1:i-1

                 distances = vecnorm( ...
                     r100-r_selected(j,:),2,2);

                 valid = valid & ...
                     distances >= min_attachment_spacing;
             end
         end

         % 得到当前 Anchor 可用的候选 Attachment
         candidate_ids = find(valid);

         % 如果没有满足条件的点，停止并报告
         assert(~isempty(candidate_ids), ...
             'No valid attachment for Family %d Cable %d', ...
             k,i);

         % 选择出线角度最接近目标值的点
         errors = abs( ...
             outward_cos(candidate_ids)-target_outward_cos);

         [~,best_local] = min(errors);

         selected_id = candidate_ids(best_local);

         % 保存该根 Cable 的 Attachment
         r_selected(i,:) = r100(selected_id,:);

         % 标记该候选点已被使用
         used(selected_id) = true;
     end

     %% Step 4: Verify selected points
     % 检查六个 Attachment 均位于球面
     assert(all( ...
         abs(vecnorm(r_selected,2,2)-rb)<1e-9));

     % 检查没有重复 Attachment
     assert(size(unique(r_selected,'rows'),1)==n);

     % 保存六个 Anchor-Attachment 对
     C_families{k}.A = A;
     C_families{k}.r = r_selected;
     
end

%% Step 5: Evaluate reference-pose Jacobian

% 与B4使用相同的特征长度缩放
scale = diag([1 1 1 1/rb 1/rb 1/rb]);

for k = 1:N_family

    A = C_families{k}.A;
    r = C_families{k}.r;

    H = zeros(6,6);

    % 参考姿态：P=0, R=I
    for i = 1:n

        s_i = r(i,:);

        D_i = A(i,:) - s_i;

        L_i = norm(D_i);

        u_i = D_i / L_i;

        % 长度对平移的灵敏度
        H(i,1:3) = -u_i;

        % 长度对旋转的灵敏度
        H(i,4:6) = cross(u_i,s_i);
    end

    % 缩放 Jacobian
    Hs = H*scale;

    % 奇异值分解
    sv = svd(Hs);

    fprintf('\n--- %s ---\n',family_names{k});

    fprintf('Jacobian rank: %d\n',rank(Hs));

    fprintf('Minimum singular value: %.6f\n',min(sv));

    fprintf('Condition number: %.6f\n',cond(Hs));

    % 打印 Cable 的 Anchor 与 Attachment 配对
    T = table((1:n)',A,r, ...
        'VariableNames', ...
        {'Cable','Anchor','Attachment'});

    disp(T);

end

%% Step 6: Visualise three complete configurations

figure('Color','w');

[Xs,Ys,Zs] = sphere(40);

for k = 1:N_family

    subplot(1,3,k);
    hold on;

    % 绘制半透明的球形气球
    surf(rb*Xs,rb*Ys,rb*Zs, ...
        'FaceAlpha',0.08, ...
        'EdgeColor','none');

    A = C_families{k}.A;
    r = C_families{k}.r;

    for i = 1:n

        % 绘制Anchor
        scatter3(A(i,1),A(i,2),A(i,3), ...
            55,'filled');

        % 绘制Attachment
        scatter3(r(i,1),r(i,2),r(i,3), ...
            40,'filled');

        % 绘制第i根Cable
        plot3([A(i,1),r(i,1)], ...
            [A(i,2),r(i,2)], ...
            [A(i,3),r(i,3)], ...
            'LineWidth',1.5);

        % 标记Cable编号
        mid = (A(i,:)+r(i,:))/2;

        text(mid(1),mid(2),mid(3), ...
            sprintf('C%d',i), ...
            'FontSize',9);

    end

    title(family_names{k});

    xlabel('X - Length (mm)');
    ylabel('Y - Width (mm)');
    zlabel('Z - Height (mm)');

    axis equal;
    grid on;
    view(3);

    hold off;

end

%% Step 7: Save configurations

save('B5_1_initial_6cable_configurations.mat', ...
    'C_families','family_names', ...
    'min_attachment_spacing', ...
    'min_outward_cos','max_outward_cos', ...
    'target_outward_cos','rb');

fprintf('\nInitial six-cable configurations saved.\n');