% B5.1 Lesson 2.3.1
% Anchor Configuration Families
%
% Research Question:
% How can six anchors be distributed across
% the engineering boundary?
%
% Goal:
% Generate three representative anchor layouts:
% F1 - Six-face distributed
% F2 - Opposite-face / layered
% F3 - Asymmetric distribution

clear; clc; close all;
rng(42);  % 固定随机种子，保证结果可复现

%% Step 1: Load expanded anchor candidates

load('B5_1_anchor_candidates.mat','A98','Lg','Wg','Hg');

half_box = [Lg Wg Hg]/2;

% 六个边界面的名称
face_names = {'+X','-X','+Y','-Y','+Z','-Z'};

% 每列对应一个边界面
% 每行对应一个候选 anchor
face_masks = [
    A98(:,1)== half_box(1), ...
    A98(:,1)==-half_box(1), ...
    A98(:,2)== half_box(2), ...
    A98(:,2)==-half_box(2), ...
    A98(:,3)== half_box(3), ...
    A98(:,3)==-half_box(3)
    ];

%% Step 2: Identify face-interior candidates

% 如果一个点同时属于两个面或三个面，
% 说明它在边缘或角点上。
%
% 本节只使用恰好属于一个面的点，
% 便于控制每种配置家族的分布。

face_count = sum(face_masks,2);

interior_mask = face_count == 1;

% 排除棱边和角点
face_masks = face_masks & interior_mask;

fprintf('Face-interior candidates: %d\n', ...
    sum(interior_mask));

% 每个面应该有 3x3 = 9 个内部候选点
assert(all(sum(face_masks,1)==9));

%% Step 3: Define three configuration families

% 面编号:
% 1 = +X
% 2 = -X
% 3 = +Y
% 4 = -Y
% 5 = +Z
% 6 = -Z

% F1: 六面分布
F1 = [1 2 3 4 5 6];

% F2: 上下分层 + 两个侧面
F2 = [5 5 6 6 1 2];

% F3: 非对称集中
F3 = [5 5 5 3 3 2];

% 保存配置家族规则
family_rules = {F1,F2,F3};

family_names = {
    'F1 - Six-Face Distributed';
    'F2 - Opposite/Layered';
    'F3 - Asymmetric'
    };

%% Step 4: Generate six anchors for each family

% 每个 cell 存储一组 6x3 anchor 坐标
A_families = cell(3,1);

for k = 1:3

    % 当前配置家族要求的六个面
    rule = family_rules{k};

    % 存储选中的候选点编号
    selected_indices = zeros(6,1);

    for i = 1:6
        
        % 当前需要选择的边界面
        face_id = rule(i);

        % 找出该面所有可用候选点
        candidates = find(face_masks(:,face_id));

        % 已选择过的点不能重复使用
        candidates = setdiff( ...
            candidates,selected_indices(1:i-1));

        % 随机选择一个候选点
        selected_indices(i) = ...
            candidates(randi(numel(candidates)));
    end

    % 提取最终六个 Anchor 的三维坐标
    A_families{k} = A98(selected_indices,:);

    % 检查没有重复 Anchor
    assert(size(unique(A_families{k},'rows'),1)==6);
end

%% Step 5: Calculate minimum anchor spacing

for k = 1:3
    A = A_families{k};

    min_distance = inf;

    for i = 1:6
        for j = i+1:6

            d = norm(A(i,:)-A(j,:));

            min_distance = min(min_distance,d);
        end
    end  

    fprintf('\n%s\n',family_names{k});

    fprintf('Minimum anchor distance: %.4f mm\n', ...
        min_distance);

    % 输出六个 Anchor 的坐标及其所在面
    T = array2table(A, ...
        'VariableNames',{'X','Y','Z'});

    T.Face = string(face_names(family_rules{k}'))';

    disp(T);
end

%% Step 6: Visualise configuration families

figure('Color','w');

for k = 1:3

    subplot(1,3,k);

    A = A_families{k};

    scatter3(A(:,1),A(:,2),A(:,3), ...
        75,'filled');

    hold on;

    % 为六个 Anchor 标记编号
    for i = 1:6
        text(A(i,1),A(i,2),A(i,3), ...
            sprintf('  A%d',i), ...
            'FontSize',10);
    end

    xlabel('X - Length (mm)');
    ylabel('Y - Width (mm)');
    zlabel('Z - Height (mm)');

    title(family_names{k});

    xlim([-140 140]);
    ylim([-150 150]);
    zlim([-160 160]);

    axis equal;
    grid on;
    view(3);

    hold off;

end

%% Step 7: Save results

% 保存三种布局，供下一节使用
save('B5_1_configuration_families.mat', ...
    'A_families','family_rules', ...
    'family_names','face_names');

fprintf('\nThree anchor families generated.\n');