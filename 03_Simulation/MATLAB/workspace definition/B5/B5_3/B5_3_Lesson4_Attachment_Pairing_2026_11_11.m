
%% B5.3 Lesson 4
% Attachment Selection and Cable Pairing
%
% Research Question:
% Can the 18 twelve-rail anchor layouts form
% geometrically feasible six-cable configurations?
%
% Objectives:
% 1. Generate 100 spherical attachment candidates
% 2. Generate 5 attachment sets per anchor layout
% 3. Enumerate all 720 pairing permutations
% 4. Check reference-pose cable-sphere interference
% 5. Check reference-pose cable-cable interference
% 6. Verify scaled Jacobian rank and singular values
% 7. Save the best reference-pose configuration
%    for each anchor layout
%
% IMPORTANT:
% This is PRELIMINARY REFERENCE-POSE SCREENING.
% Core multi-pose checks come in B5.3 Lesson 5.
%
% Units: mm, radians for local rotation increments

clear; clc; close all;
rng(42);

%% Step 1: Load the 18 anchor layouts

load('B5_3_12rail_anchor_families.mat', ...
    'anchor_configs','family_names', ...
    'rail_start','rail_end','rb');

N_layout = numel(anchor_configs);
n_cables = 6;

assert(N_layout==18);

% 使用之前验证过的有限线段距离函数
assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2, ...
    'B3 cable-distance function not found.');

fprintf('\n--- B5.3 Lesson 4 ---\n');
fprintf('Anchor layouts loaded: %d\n',N_layout);

%% Step 2: Generate 100 Fibonacci sphere candidates
%
% 使用确定性的Fibonacci Sphere采样。
% 附着点全部位于半径为rb的球面上。
%
% 这些点只是初始离散候选位置，
% 后续仍可在球面上连续调整。

N_attachment = 100;

k = (0:N_attachment-1)';

z = 1 - 2*(k+0.5)/N_attachment;

theta = pi*(3-sqrt(5))*k;

radial = sqrt(max(0,1-z.^2));

r_candidates = rb * [
    radial.*cos(theta), ...
    radial.*sin(theta), ...
    z
];

% 检查球面半径误差
radius_error = max(abs( ...
    vecnorm(r_candidates,2,2)-rb));

assert(radius_error<1e-10);

fprintf('Attachment candidates: %d\n',N_attachment);
fprintf('Maximum radius error: %.3e mm\n',radius_error);

%% Step 3: Define screening parameters

N_sets = 5;

% 所有六点Attachment配对排列
pairing_list = perms(1:6);
% 对每组六点集枚举 \(6!=720\) 种 Pairing。

N_pairings = size(pairing_list,1);

assert(N_pairings==720);

% B5.2数值容差
sphere_tol = 1e-9;     % mm^2
contact_tol = 1e-6;    % mm

% 数值Rank判据的相对容差
rank_relative_tol = 1e-10;

% 初始Attachment候选方向范围
%
% 用cos(angle)选择非径向方向：
% 0.25 < cos(angle) < 0.90
%
% 这只是本次探索性采样策略，
% 不是实际机械出线角度限制。
% 真正的球面穿透判据将在后面单独检查。
min_cos = 0.25;
max_cos = 0.90;

% 六根Cable的15对组合
cable_pairs = nchoosek(1:6,2);

%% Step 4: Initialise result storage

% 每组Anchor布局最终保留一个候选
% 若没有找到合格配置，则found=false。
empty_result = struct( ...
    'found',false, ...
    'family_id',NaN, ...
    'anchor_layout_id',NaN, ...
    'rail_ids',[], ...
    't',[], ...
    'A',[], ...
    'r',[], ...
    'attachment_indices',[], ...
    'pairing',[], ...
    'sigma_min',NaN, ...
    'kappa',NaN, ...
    'min_cable_distance',NaN, ...
    'min_attachment_spacing',NaN);

best_configs = repmat(empty_result,N_layout,1);

% 统计每一步通过的候选数
counts = zeros(N_layout,4);

% 列：
% 1 TotalPairings
% 2 SpherePassed
% 3 CablePassed
% 4 FullRankPassed

%% Step 5: Search each anchor layout

for c = 1:N_layout

    current = anchor_configs(c);

    A = current.A;

    fprintf('\n====================================\n');
    fprintf('Anchor layout %d / %d\n',c,N_layout);
    fprintf('%s\n',current.family_name);
    fprintf('====================================\n');

    % 验证Anchor仍然属于指定导轨
    for i = 1:6

        rid = current.rail_ids(i);
        ti = current.t(i);

        expected_A = rail_start(rid,:) + ...
            ti*(rail_end(rid,:)-rail_start(rid,:));

        assert(norm(A(i,:)-expected_A)<1e-9);

    end

    % 每个Anchor的方向单位向量
    anchor_unit = A ./ vecnorm(A,2,2);

    %% Step 6: Build candidate pools
    %
    % 对每根Anchor，选择与它具有适当夹角的
    % Attachment候选点。
    %
    % 不直接采用径向最短连接，
    % 避免旋转测量灵敏度过低。
    %
    % 这里只决定六个候选集合的来源，
    % 真正Pairing仍会独立枚举。

    candidate_pools = cell(6,1);

    r_unit = r_candidates/rb;

    for i = 1:6

        cos_angles = r_unit*anchor_unit(i,:)';

        pool = find( ...
            cos_angles>min_cos & ...
            cos_angles<max_cos);

        assert(~isempty(pool), ...
            'Attachment candidate pool is empty.');

        candidate_pools{i} = pool;

    end

    %% Step 7: Generate several attachment sets

    for s = 1:N_sets

        % 从每根Anchor的候选区域抽取一个点
        % 但必须保证最终六个Attachment不重复。
        %
        % 这六点组成一个固定点集。
        % 随后的720种Pairing使用同一六点集。

        selected = zeros(6,1);
        used_indices = [];

        for i = 1:6

            available = setdiff( ...
                candidate_pools{i},used_indices);

            assert(~isempty(available));

            pick = available( ...
                randi(numel(available)));

            selected(i) = pick;

            used_indices(end+1) = pick;

        end

        % 此时形成固定的六个Attachment坐标
        r_set = r_candidates(selected,:);

        assert(numel(unique(selected))==6);

        %% Step 8: Enumerate all 720 pairings

        for p = 1:N_pairings

            counts(c,1) = counts(c,1)+1;

            permutation = pairing_list(p,:);

            % 第i个Anchor连接到：
            % r_set(permutation(i),:)
            r = r_set(permutation,:);

            % 参考姿态：
            % P=[0,0,0], R=I
            B = r;

            D = A-B;

            % 排除Cable退化
            L = vecnorm(D,2,2);

            if any(L<=1e-9)
                continue;
            end

            %% 8.1 Cable-sphere screening

            outward_dot = sum(r.*D,2);

            if any(outward_dot < -sphere_tol)
                continue;
            end

            counts(c,2) = counts(c,2)+1;

            %% 8.2 Cable-cable screening

            min_distance = inf;
            cable_contact = false;

            for j = 1:15

                i1 = cable_pairs(j,1);
                i2 = cable_pairs(j,2);

                dij = ...
                    B3_1_segment_distance_3d_2026_11_02( ...
                        B(i1,:),A(i1,:), ...
                        B(i2,:),A(i2,:));

                min_distance = min(min_distance,dij);

                if dij<=contact_tol
                    cable_contact = true;
                    break;
                end

            end

            if cable_contact
                continue;
            end

            counts(c,3) = counts(c,3)+1;

            %% 8.3 Measurement Jacobian

            % u_i: Attachment指向Anchor
            u = D./L;

            H = zeros(6,6);

            for i = 1:6

                % B4约定：
                % H_i = [-u_i, cross(u_i,r_i)]
                H(i,:) = [ ...
                    -u(i,:), ...
                    cross(u(i,:),r(i,:)) ...
                ];

            end

            % 与之前B4/B5保持相同缩放
            scale = diag( ...
                [1 1 1 1/rb 1/rb 1/rb]);

            Hs = H*scale;

            singular_values = svd(Hs);

            sigma_min = singular_values(end);

            % 使用相对数值判据检查Rank
            if sigma_min <= ...
                    rank_relative_tol*singular_values(1)
                continue;
            end

            counts(c,4) = counts(c,4)+1;

            kappa = singular_values(1)/sigma_min;

            %% 8.4 Attachment spacing

            attachment_pairs = nchoosek(1:6,2);

            attachment_distances = zeros(15,1);

            for j = 1:15

                i1 = attachment_pairs(j,1);
                i2 = attachment_pairs(j,2);

                attachment_distances(j) = ...
                    norm(r(i1,:)-r(i2,:));

            end

            min_attachment_spacing = ...
                min(attachment_distances);

            %% 8.5 Keep best reference candidate
            %
            % 只有几何通过且Rank为6的配置
            % 才允许参加reference sigma_min比较。
            %
            % 注意：这不是多姿态最优配置。

            if ~best_configs(c).found || ...
                    sigma_min>best_configs(c).sigma_min

                best_configs(c).found = true;

                best_configs(c).family_id = ...
                    current.family_id;

                best_configs(c).anchor_layout_id = c;

                best_configs(c).rail_ids = ...
                    current.rail_ids;

                best_configs(c).t = current.t;

                best_configs(c).A = A;
                best_configs(c).r = r;

                best_configs(c).attachment_indices = ...
                    selected;

                best_configs(c).pairing = permutation;

                best_configs(c).sigma_min = sigma_min;
                best_configs(c).kappa = kappa;

                best_configs(c).min_cable_distance = ...
                    min_distance;

                best_configs(c).min_attachment_spacing = ...
                    min_attachment_spacing;

            end

        end
    end

    %% Step 9: Print current layout result

    fprintf('Pairings tested: %d\n',counts(c,1));

    fprintf('Sphere passing: %d\n',counts(c,2));

    fprintf('Cable-cable passing: %d\n',counts(c,3));

    fprintf('Full-rank passing: %d\n',counts(c,4));

    if best_configs(c).found

        fprintf('Best reference sigma_min: %.6f\n', ...
            best_configs(c).sigma_min);

        fprintf('Best reference kappa: %.6f\n', ...
            best_configs(c).kappa);

        fprintf('Minimum cable distance: %.3f mm\n', ...
            best_configs(c).min_cable_distance);

        fprintf('Selected pairing: %s\n', ...
            mat2str(best_configs(c).pairing));

    else

        fprintf('No feasible reference configuration found.\n');

    end

end

%% Step 10: Build comparison table

ConfigID = (1:N_layout)';

Family = strings(N_layout,1);

Found = false(N_layout,1);

BestSigmaMin = nan(N_layout,1);
BestKappa = nan(N_layout,1);
MinCableDistance = nan(N_layout,1);

for c = 1:N_layout

    Family(c) = string( ...
        anchor_configs(c).family_name);

    Found(c) = best_configs(c).found;

    if Found(c)

        BestSigmaMin(c) = ...
            best_configs(c).sigma_min;

        BestKappa(c) = ...
            best_configs(c).kappa;

        MinCableDistance(c) = ...
            best_configs(c).min_cable_distance;

    end

end

T_results = table( ...
    ConfigID,Family,Found, ...
    counts(:,1),counts(:,2), ...
    counts(:,3),counts(:,4), ...
    BestSigmaMin,BestKappa, ...
    MinCableDistance, ...
    'VariableNames', ...
    {'ConfigID','Family','Found', ...
     'TotalPairings','SpherePass', ...
     'CablePass','RankPass', ...
     'SigmaMin','Kappa', ...
     'MinCableDistance_mm'});

fprintf('\n--- B5.3 Lesson 4 Summary ---\n');
disp(T_results);

fprintf('Reference-feasible layouts: %d / %d\n', ...
    sum(Found),N_layout);

%% Step 11: Consistency checks

assert(all(counts(:,1)==N_sets*720));

assert(all(counts(:,4)<=counts(:,3)));

assert(all(counts(:,3)<=counts(:,2)));

assert(all(counts(:,2)<=counts(:,1)));

for c = find(Found)'

    b = best_configs(c);

    % 确认Anchor仍在对应Rail上
    for i = 1:6

        rid = b.rail_ids(i);

        A_expected = rail_start(rid,:) + ...
            b.t(i)*(rail_end(rid,:)-rail_start(rid,:));

        assert(norm(b.A(i,:)-A_expected)<1e-9);

    end

    % Attachment仍在球面
    assert(max(abs(vecnorm(b.r,2,2)-rb))<1e-10);

    % 六个Attachment互不重合
    assert(b.min_attachment_spacing>0);

end

%% Step 12: Save complete results

save('B5_3_initial_six_cable_configurations.mat', ...
    'anchor_configs','best_configs', ...
    'r_candidates','pairing_list', ...
    'T_results','counts','family_names', ...
    'sphere_tol','contact_tol', ...
    'N_sets','min_cos','max_cos','rb');

fprintf('\nB5.3 Lesson 4 completed.\n');

fprintf('Saved: B5_3_initial_six_cable_configurations.mat\n');
