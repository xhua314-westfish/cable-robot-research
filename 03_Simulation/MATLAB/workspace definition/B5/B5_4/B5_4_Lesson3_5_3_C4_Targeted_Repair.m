%% B5.4 Lesson 3.5.3
% Cable 4 Failure Diagnosis and Targeted Repair
%
% 研究问题：
% 能否仅调整C4在R8上的Anchor位置，
% 修复新增Pose164中的Cable-Sphere干涉？
%
% 严格控制变量：
% 仅改变t4
% 固定其他t、Rail ID、Attachment和Pairing
%
% 验证集合：189 + 150 + 200 = 539 poses
% 不重新生成随机姿态

clear; clc; close all;

%% Step 1: Load historical data

load('B5_4_unified_evaluation_baseline.mat', ...
    'best_configs','P_all','R_all','settings');

load('B5_4_E1a_Config2_robustness_verification.mat', ...
    'P_test','R_test','rail_ids');

load('B5_4_E1a_C1_repair_robustness.mat', ...
    'P_new','R_new','angles_new_deg', ...
    't_designs');

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end');

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

% 第三行：Sensing t1=0.375
t0 = t_designs(3,:);
r = best_configs(2).r;

rail_ids = rail_ids(:)';

assert(rail_ids(4)==8);
assert(abs(t0(1)-0.375)<1e-10);

% 三组姿态严格按历史顺序合并
P_eval = [P_all; P_test; P_new];
R_eval = cat(3,R_all,R_test,R_new);

assert(size(P_eval,1)==539);

% 新增200姿态中的Pose164
% 合并后的索引为189+150+164
target_id = 189+150+164;

fprintf('\n--- B5.4 Lesson 3.5.3 ---\n');
fprintf('Baseline t: %s\n',mat2str(t0,6));
fprintf('Target Pose ID (new set): 164\n');
fprintf('Target P: %s mm\n', ...
    mat2str(P_eval(target_id,:),6));
fprintf('Target RPY: %s deg\n', ...
    mat2str(angles_new_deg(164,:),6));

%% Step 2: Reproduce current failure

A0 = build_anchor_positions( ...
    t0,rail_ids,rail_start,rail_end);

base = evaluate_pose_set( ...
    A0,r,P_eval,R_eval,settings);

assert(sum(base.geometry_safe(1:339))==339);
assert(sum(base.geometry_safe(340:end))==199);

fprintf('\n--- Original C4 Failure ---\n');
fprintf('C4 Anchor: %s mm\n',mat2str(A0(4,:),6));

fprintf('Pose164 C4 outward dot: %.6f mm^2\n', ...
    base.outward_dot(target_id,4));

fprintf('Pose164 C4 angle margin: %.6f deg\n', ...
    base.angle_margin_deg(target_id,4));

fprintf('Failed sphere cables: %s\n', ...
    mat2str(find( ...
    base.outward_dot(target_id,:) < ...
    -settings.sphere_tol)));

%% Step 3: Identify previous installation failure
%
% 使用Sensing t1=0.375。
% 分别移动六根Cable，t偏移为±0.005。
%
% 这里不重新优化，只定位失效来源。

delta_t = 0.005;

fprintf('\n--- Installation Perturbation Diagnosis ---\n');

for i = 1:6

    for direction = [-1 1]

        trial_t = t0;
        trial_t(i) = trial_t(i)+direction*delta_t;

        if any(trial_t<0 | trial_t>1)

            fprintf('C%d dt=%+.3f : OFF-RAIL\n', ...
                i,direction*delta_t);
            continue;
        end

        A = build_anchor_positions( ...
            trial_t,rail_ids,rail_start,rail_end);

        % 安装扰动沿用历史339姿态测试
        g = evaluate_pose_set( ...
            A,r,P_eval(1:339,:), ...
            R_eval(:,:,1:339),settings);

        n_pass = sum(g.geometry_safe & g.rank_all==6);

        if n_pass<339

            bad_ids = find( ...
                ~g.geometry_safe | g.rank_all~=6);

            fprintf('C%d dt=%+.3f : %d/339 FAILED\n', ...
                i,direction*delta_t,n_pass);

            fprintf('  Failed poses: %s\n', ...
                mat2str(bad_ids'));

        end

    end
end

%% Step 4: Scan C4 along Rail R8
%
% 为避免只测少数几个点：
% 先在当前t4附近做较密集扫描。
%
% 范围是探索性设置，不是硬件公差。
% 未通过的候选也全部保留记录。

t4_values = unique([ ...
    0.40:0.01:0.65, t0(4)]);

N = numel(t4_values);

CorePass = zeros(N,1);
OldOffgridPass = zeros(N,1);
NewOffgridPass = zeros(N,1);
Rank6Pass = zeros(N,1);

TargetC4Dot_mm2 = zeros(N,1);
MinOutwardAngle_deg = zeros(N,1);
MinC4Angle_deg = zeros(N,1);

MinCableDistance_mm = zeros(N,1);
WorstSigma = nan(N,1);

JointEligible = false(N,1);

fprintf('\n--- C4 Position Scan ---\n');

for j = 1:N

    t = t0;
    t(4) = t4_values(j);

    A = build_anchor_positions( ...
        t,rail_ids,rail_start,rail_end);

    g = evaluate_pose_set( ...
        A,r,P_eval,R_eval,settings);

    CorePass(j) = sum(g.geometry_safe(1:189));

    OldOffgridPass(j) = ...
        sum(g.geometry_safe(190:339));

    NewOffgridPass(j) = ...
        sum(g.geometry_safe(340:end));

    Rank6Pass(j) = sum( ...
        g.geometry_safe & g.rank_all==6);

    TargetC4Dot_mm2(j) = ...
        g.outward_dot(target_id,4);

    MinOutwardAngle_deg(j) = ...
        min(g.angle_margin_deg(:));

    MinC4Angle_deg(j) = ...
        min(g.angle_margin_deg(:,4));

    MinCableDistance_mm(j) = ...
        min(g.distances(:));

    JointEligible(j) = ...
        CorePass(j)==189 && ...
        OldOffgridPass(j)==150 && ...
        NewOffgridPass(j)==200 && ...
        Rank6Pass(j)==539;

    if JointEligible(j)
        WorstSigma(j) = min(g.sigma_min_all);
    end

    fprintf([ ...
        't4=%.5f | %3d/%3d/%3d | ' ...
        'g4(164)=%+9.3f | angle=%+7.3f | ' ...
        'sigma=%8.5f\n'], ...
        t(4),CorePass(j), ...
        OldOffgridPass(j),NewOffgridPass(j), ...
        TargetC4Dot_mm2(j), ...
        MinC4Angle_deg(j),WorstSigma(j));

end

%% Step 5: Summary table

T_scan = table( ...
    t4_values(:),CorePass, ...
    OldOffgridPass,NewOffgridPass, ...
    Rank6Pass,TargetC4Dot_mm2, ...
    MinC4Angle_deg,MinOutwardAngle_deg, ...
    MinCableDistance_mm,WorstSigma, ...
    JointEligible, ...
    'VariableNames',{ ...
    'T4','CorePass','OldOffgridPass', ...
    'NewOffgridPass','Rank6Pass', ...
    'TargetC4Dot_mm2','MinC4Angle_deg', ...
    'MinOutwardAngle_deg', ...
    'MinCableDistance_mm','WorstSigma', ...
    'JointEligible'});

disp(' ');
disp('--- C4 Targeted Repair Summary ---');
disp(T_scan);

%% Step 6: Identify promising candidates
%
% 仅从539/539且Rank6的方案中筛选。
% 不宣称这是全局最优。

eligible_ids = find(JointEligible);

fprintf('\n--- Joint-Eligible C4 Candidates ---\n');

if isempty(eligible_ids)

    fprintf('No complete repair found in this scan.\n');

else

    disp(T_scan(eligible_ids,:));

    [~,idx] = max(WorstSigma(eligible_ids));
    best_sensing_id = eligible_ids(idx);

    fprintf('\nBest sampled sensing t4: %.6f\n', ...
        t4_values(best_sensing_id));

    fprintf('Worst sigma: %.6f\n', ...
        WorstSigma(best_sensing_id));

    fprintf('Minimum outward angle: %.6f deg\n', ...
        MinOutwardAngle_deg(best_sensing_id));

end

%% Step 7: Plot failure and sensing

figure('Color','w', ...
    'Name','B5.4 C4 Targeted Repair', ...
    'Position',[100 100 1150 800]);

tiledlayout(3,1,'TileSpacing','compact');

nexttile;
plot(t4_values,NewOffgridPass, ...
    '-o','LineWidth',1.5);

yline(200,'--k','Full Pass', ...
    'HandleVisibility','off');

xline(t0(4),'--r','Baseline', ...
    'HandleVisibility','off');

ylabel('Passing poses / 200');
title('New Off-grid Geometry');
grid on;

nexttile;
plot(t4_values,TargetC4Dot_mm2, ...
    '-o','LineWidth',1.5);

yline(0,'--k','Tangency', ...
    'HandleVisibility','off');

xline(t0(4),'--r', ...
    'HandleVisibility','off');

ylabel('Outward Dot (mm^2)');
title('Cable 4 at New Pose 164');
grid on;

nexttile;
plot(t4_values,WorstSigma, ...
    '-o','LineWidth',1.5);

xlabel('Absolute Rail Parameter t4');
ylabel('Worst Scaled sigma_{min}');
title('Sensing: 539-Pose Eligible Candidates');
grid on;

%% Step 8: Save experiment

save('B5_4_E1a_C4_targeted_repair.mat', ...
    'T_scan','t4_values','t0','r', ...
    'rail_ids','settings','eligible_ids', ...
    'P_eval','R_eval','target_id');

fprintf('\nB5.4 Lesson 3.5.3 completed.\n');

%% ========================================
% Local function 1: Build six anchors
%% ========================================
function A = build_anchor_positions( ...
    t,rail_ids,rail_start,rail_end)

    A = zeros(6,3);

    for i = 1:6

        id = rail_ids(i);

        A(i,:) = rail_start(id,:) + ...
            t(i)*(rail_end(id,:)-rail_start(id,:));

    end

end

%% ========================================
% Local function 2: Complete evaluation
%% ========================================
function g = evaluate_pose_set( ...
    A,r,P_all,R_all,settings)

    N = size(P_all,1);
    pairs = settings.cable_pairs;

    geometry_safe = false(N,1);
    rank_all = zeros(N,1);

    sigma_min_all = zeros(N,1);

    outward_dot = zeros(N,6);
    angle_margin_deg = zeros(N,6);

    distances = zeros(N,15);

    for k = 1:N

        P = P_all(k,:);
        R = R_all(:,:,k);

        S = (R*r')';
        B = S+P;
        D = A-B;

        L = vecnorm(D,2,2);
        assert(all(L>1e-9));

        %% Cable-Sphere

        dot_values = sum(S.*D,2);

        outward_dot(k,:) = dot_values';

        % 正值代表相对切向朝外，
        % 负值代表向内出线。
        %
        % angle_margin = asin(dot/(rb*L))
        % 使用deg作为角度裕量单位。

        sine_margin = dot_values ./ ...
            (settings.rb*L);

        sine_margin = max(-1,min(1,sine_margin));

        angle_margin_deg(k,:) = ...
            asind(sine_margin)';

        sphere_ok = all( ...
            dot_values>=-settings.sphere_tol);

        %% Cable-Cable

        cable_ok = true;

        for j = 1:15

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                    B(i1,:),A(i1,:), ...
                    B(i2,:),A(i2,:));

            distances(k,j) = dij;

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        geometry_safe(k) = sphere_ok && cable_ok;

        %% Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))
            ];

        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        sigma_min_all(k) = sv(end);

        rank_all(k) = sum( ...
            sv>settings.rank_relative_tol*sv(1));

    end

    g = struct();

    g.geometry_safe = geometry_safe;
    g.rank_all = rank_all;

    g.sigma_min_all = sigma_min_all;
    g.outward_dot = outward_dot;
    g.angle_margin_deg = angle_margin_deg;

    g.distances = distances;

end