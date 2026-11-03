%% B4.1 - Lesson 1
% Analytical Measurement Jacobian Verification
% Numerical verification using central finite differences

clear; clc; close all;

%% 1. Load existing configurations

load('B1_geometry_baseline.mat','geometry');
load('B2_6cable_experiment_A.mat','config6');
load('B2_experiment_B_results.mat','resultB');
load('B3_2_results.mat','B3_2_results');

A_data = {config6.A, resultB.A};
r_data = {config6.r, resultB.r};

names = {'Experiment A','Experiment B'};

rb = geometry.balloon_radius;

%% 2. Select reference pose from B3.2
% 选择零点/标准位姿（P ≈ [0,0,0]^T，姿态 ID 为 1）作为基准（Reference Pose），
% 可以在最典型、最有代表性的标准状态下检验公式推导与代码实现的准确性。

P_all = B3_2_results.P_all;
R_pose = B3_2_results.R_pose;

reference_idx = find( ...
    all(abs(P_all)<1e-12,2) & ...
    B3_2_results.orientation_id==1);
% 寻找位置等于坐标原点 [0, 0, 0] 的采样点。
% P_samples 是一个对称分布的 3 * 3 * 3 = 27 点三维网格。
% 按线型存储顺序，坐标原点 [0,0,0] 恰好位于正中心，即第 14 个采样点（k = 14）。
% 对应内层循环的 j = 1（即第 1 组旋转角 [0, 0, 0] 度，即零旋转矩阵 R = I

% reference_idx = (14 - 1) * 7 + 1 = 92
% 计算公式参考B3.2代码

assert(numel(reference_idx)==1);

P = P_all(reference_idx,:).';
R = R_pose(:,:,reference_idx);

fprintf('\n--- B4.1 Lesson 1 ---\n');
fprintf('Reference pose index: %d\n',reference_idx);

%% 3. Define finite-difference step sizes

h_translation = 1e-4; % mm
h_rotation = 1e-6;    % rad

%% 4. Evaluate both configurations

for c = 1 : 2
    
    A = A_data{c};
    r = r_data{c};
    
    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r),[6 3]));

    %% 4.1 Analytical Jacobian

    B_world = (R*r.' + P).';

    D = A - B_world;
    L = vecnorm(D,2,2);
    U = D ./ L;

    H_analytical = zeros(6,6);

    for i = 1:6

        u = U(i,:).';
        s = R*r(i,:).';

        H_analytical(i,:) = ...
            [-u.', cross(u,s).'];

    end

    %% 4.2 Numerical Jacobian
    
    H_numerical = zeros(6,6);

    for j = 1: 6
        % 这里J表示六个自由度

        P_plus = P;
        P_minus = P;

        R_plus = R;
        R_minus = R;

        if j <= 3
            %j < 3（平移维度）

            % Translation perturbation (mm)
            h = h_translation;

            P_plus(j) = P_plus(j) + h;
            P_minus(j) = P_minus(j) - h;

        else
            % 其他三个自由度 

            % World-frame rotation perturbation (rad)
            h = h_rotation;

            rot_axis = zeros(3,1);
            rot_axis(j-3) = 1;
            %当 j = 4 时（j-3 = 1），axis = [1; 0; 0]，代表绕 X 轴微旋转。
            % j = 5, 就是绕Y轴旋转 。。。

            % Skew-symmetric matrix
            K = [
                0       -rot_axis(3)  rot_axis(2);
                rot_axis(3)  0       -rot_axis(1);
                -rot_axis(2)  rot_axis(1)  0
                ];

            % Left-multiplicative rotation
            R_plus = expm(h*K)*R;
            R_minus = expm(-h*K)*R;

        end

        % Cable lengths for positive perturbation
        B_plus = (R_plus*r.' + P_plus).';
        L_plus = vecnorm(A-B_plus,2,2);

        % Cable lengths for negative perturbation
        B_minus = (R_minus*r.' + P_minus).';
        L_minus = vecnorm(A-B_minus,2,2);

        % Central finite difference
        H_numerical(:,j) = ...
            (L_plus-L_minus)/(2*h);
    end

    %% 4.3 Compare analytical and numerical results

    H_error = H_analytical - H_numerical;

    max_error = max(abs(H_error(:)));

    fprintf('\n%s\n',names{c});

    fprintf('Analytical Jacobian:\n');
    disp(H_analytical);

    fprintf('Numerical Jacobian:\n');
    disp(H_numerical);

    fprintf('Maximum absolute Jacobian error: %.3e\n', ...
        max_error);

    assert(max_error<1e-6, ...
        'Jacobian verification failed.');
    %% 4.4 Local rank and scaled conditioning

    H_scaled = H_analytical * ...
        diag([1 1 1 1/rb 1/rb 1/rb]);

    fprintf('Jacobian rank: %d\n', ...
        rank(H_analytical));

    fprintf('Scaled sigma_min: %.6f\n', ...
        min(svd(H_scaled)));

    fprintf('Scaled condition number: %.4f\n', ...
        cond(H_scaled));

    fprintf('Jacobian verification passed.\n');

end

fprintf('\nB4.1 Lesson 1 completed.\n');

%% B4.1 - Lesson 2
% Jacobian Evaluation Across 189 Poses

%% 5. Load 189-pose data

P_all = B3_2_results.P_all;
R_pose = B3_2_results.R_pose;

geometry_safe_A = B3_2_results.geometry_safe_A(:);
geometry_safe_B = B3_2_results.geometry_safe_B(:);

N_poses = size(P_all,1);
assert(N_poses == 189);

% Existing configuration arrays from Lesson 1:
% A_data = {config6.A, resultB.A};
% r_data = {config6.r, resultB.r};
% rb = geometry.balloon_radius;

%% 6. Initialise results

rank_all = zeros(N_poses,2);
sigma_min_all = zeros(N_poses,2);
condition_all = zeros(N_poses,2);

% Retain full Jacobians for later covariance analysis
H_all = zeros(6,6,N_poses,2);
Hs_all = zeros(6,6,N_poses,2);
% 都是四维矩阵 意思是
% 6根cable 6个自由度 位姿点的个数 试验的类型

%% 7. Evaluate Jacobian at each pose

for c = 1:2

    A = A_data{c};
    r = r_data{c};

    for k = 1:N_poses

        P = P_all(k,:).';
        R = R_pose(:,:,k);

        % Attachment locations in world frame
        B_world = (R*r.' + P).';

        % Cable vectors and lengths
        D = A - B_world;
        L = vecnorm(D,2,2);

        assert(all(L > 0));

        U = D ./ L;

        % Measurement Jacobian
        H = zeros(6,6);

        for i = 1:6

            u = U(i,:).';
            s = R*r(i,:).';

            H(i,:) = ...
                [-u.', cross(u,s).'];

        end

        % Characteristic-length scaling
        S = diag([1 1 1 1/rb 1/rb 1/rb]);
        Hs = H*S;
        
        H_all(:,:,k,c) = H;
        Hs_all(:,:,k,c) = Hs;

        % Singular values of scaled Jacobian
        sv = svd(Hs);

        sigma_min_all(k,c) = sv(end);
        condition_all(k,c) = cond(Hs);

        % Numerical rank of scaled Jacobian
        rank_all(k,c) = rank(Hs);
    end

end

fprintf('\n--- B4.1 Lesson 2 ---\n');

%% 8. Full-rank statistics

fprintf('\nRank statistics across 189 poses:\n');

for c = 1:2

    full_rank_count = sum(rank_all(:,c)==6);

    fprintf('%s: %d / %d full rank\n', ...
        names{c},full_rank_count,N_poses);

end

%% 9. Evaluate all sampled poses

fprintf('\nAll-pose sensing metrics:\n');

for c = 1:2

    fprintf('\n%s\n',names{c});

    fprintf('Minimum sigma_min: %.6f\n', ...
        min(sigma_min_all(:,c)));

    fprintf('Median sigma_min: %.6f\n', ...
        median(sigma_min_all(:,c)));

    fprintf('Maximum condition number: %.4f\n', ...
        max(condition_all(:,c)));

    fprintf('Median condition number: %.4f\n', ...
        median(condition_all(:,c)));
end

%% 10. Evaluate geometrically feasible subsets

safe_data = {geometry_safe_A,geometry_safe_B};

fprintf('\nGeometrically feasible subset:\n');

for c = 1:2

    valid = safe_data{c};

    fprintf('\n%s\n',names{c});
    fprintf('Feasible poses: %d\n',sum(valid));

    if any(valid)

        fprintf('Full-rank feasible poses: %d\n', ...
            sum(rank_all(valid,c)==6));

        fprintf('Minimum sigma_min: %.6f\n', ...
            min(sigma_min_all(valid,c)));

        fprintf('Median sigma_min: %.6f\n', ...
            median(sigma_min_all(valid,c)));

        fprintf('Maximum condition number: %.4f\n', ...
            max(condition_all(valid,c)));

        fprintf('Median condition number: %.4f\n', ...
            median(condition_all(valid,c)));

    else

        fprintf('No geometrically feasible poses.\n');

    end
end

%% 11. Reference-pose regression test

reference_idx = find( ...
    all(abs(P_all)<1e-12,2) & ...
    B3_2_results.orientation_id==1);

assert(numel(reference_idx)==1);

fprintf('\nReference-pose regression:\n');

for c = 1:2

    fprintf('%s: sigma_min = %.6f, kappa = %.4f\n', ...
        names{c}, ...
        sigma_min_all(reference_idx,c), ...
        condition_all(reference_idx,c));

end

assert(abs(condition_all(reference_idx,1)- ...
    3.5759)<1e-3);

assert(abs(condition_all(reference_idx,2)- ...
    3.2365)<1e-3);

fprintf('Reference-pose regression passed.\n');

%% 12. Save Lesson 2 results

B4_1_results.P_all = P_all;
B4_1_results.R_pose = R_pose;

B4_1_results.rank_all = rank_all;
B4_1_results.sigma_min_all = sigma_min_all;
B4_1_results.condition_all = condition_all;

B4_1_results.H_all = H_all;
B4_1_results.Hs_all = Hs_all;

B4_1_results.geometry_safe_A = geometry_safe_A;
B4_1_results.geometry_safe_B = geometry_safe_B;

B4_1_results.rb = rb;

save('B4_1_results.mat','B4_1_results');

fprintf('\nLesson 2 completed.\n');

%% B4.1 - Lesson 3
% Worst-case sensing and common feasible poses

%% 13. Find weakest geometrically feasible poses

fprintf('\n--- B4.1 Lesson 3 ---\n');

safe_data = {geometry_safe_A, geometry_safe_B};

for c = 1:2

    valid_idx = find(safe_data{c});

    % Weakest sigma_min among feasible poses
    [worst_sigma, local_idx] = ...
        min(sigma_min_all(valid_idx,c));
    % MATLAB 中的 min 函数支持双返回值语法 [val, idx] = min(...)
    % 返回数值本身和这个数值所在的索引 
    
    worst_idx = valid_idx(local_idx);

    % Get the corresponding scaled Jacobian
    Hs = Hs_all(:,:,worst_idx,c);

    % Singular value decomposition
    [~,Sigma,V] = svd(Hs);
    % ~：代表忽略第 1 个返回值（左奇异矩阵 U），因为这里不需要它
    % V（右奇异矩阵）：它的每一列都是位姿空间（3 个平移 + 3 个旋转）中的一个正交方向向量，代表系统不同的运动模式。

    % Right singular vector: weakest pose direction
    weakest_direction = V(:,end);
    % MATLAB 的 svd 默认将奇异值从大到小排列，
    % 所以矩阵 {V} 的最后一列正好对应最小的奇异值 sigma_min。

    % Convert scaled rotation components to radians
    delta_q = [
        weakest_direction(1:3);
        weakest_direction(4:6)/rb
    ];
    % 而 delta_q 代表实际空间中气球的具体运动（例如：平移了多少毫米、旋转了多少弧度）。
    % 前 3 项：平移部分，保持不变 (mm)
    % 后 3 项：除以气球半径 rb，还原为真实旋转角 (rad)

    fprintf('\n%s\n',names{c});

    fprintf('Worst feasible pose index: %d\n',worst_idx);
    fprintf('Position [mm]:\n');
    disp(P_all(worst_idx,:));

    fprintf('Orientation [roll pitch yaw] [deg]:\n');
    disp(B3_2_results.angles( ...
        B3_2_results.orientation_id(worst_idx),:));

    fprintf('Worst sigma_min: %.6f\n',worst_sigma);

    fprintf('Condition number at this pose: %.4f\n', ...
        condition_all(worst_idx,c));

    fprintf('Weakest scaled pose direction:\n');
    disp(weakest_direction.');

    fprintf('Equivalent local pose direction:\n');
    fprintf('Translation [mm]:\n');
    disp(delta_q(1:3).');

    fprintf('World-frame rotation [deg]:\n');
    disp(rad2deg(delta_q(4:6)).');

    % SVD identity verification
    assert(abs( ...
        norm(Hs*weakest_direction)-Sigma(end,end)) ...
        < 1e-10);
end

%% 14. Find common geometrically feasible poses

% 第 14 和 15 节的核心任务，就是找出实验 A 和实验 B 共同满足几何安全条件（可行位姿）的"交集"，
% 并在相同的位姿基准下进行配对对比。这不仅能保证对比的公平性，
% 更为后续缆绳构型与锚点位置的优化提供了明确的指标与方向。

common_safe = geometry_safe_A & geometry_safe_B;
N_common = sum(common_safe);

fprintf('\nCommon geometric feasibility:\n');

fprintf('Both A and B feasible: %d / 189 poses\n', ...
    N_common);

%% 15. Paired sensing comparison

if N_common > 0

    sigma_A_common = sigma_min_all(common_safe,1);
    sigma_B_common = sigma_min_all(common_safe,2);

    kappa_A_common = condition_all(common_safe,1);
    kappa_B_common = condition_all(common_safe,2);

    fprintf('\nOn identical feasible poses:\n');

    fprintf('Median sigma_min A: %.6f\n', ...
        median(sigma_A_common));

    fprintf('Median sigma_min B: %.6f\n', ...
        median(sigma_B_common));

    fprintf('Median condition A: %.4f\n', ...
        median(kappa_A_common));

    fprintf('Median condition B: %.4f\n', ...
        median(kappa_B_common));

    fprintf('\nPaired comparisons:\n');

    fprintf('B has higher sigma_min: %d / %d\n', ...
        sum(sigma_B_common > sigma_A_common),N_common);

    fprintf('B has lower condition number: %d / %d\n', ...
        sum(kappa_B_common < kappa_A_common),N_common);

else

    fprintf(['No common feasible poses found. ' ...
        'Direct feasible-pose pairing is unavailable.\n']);

end

%% 16. Save additional results

B4_1_results.common_safe = common_safe;
B4_1_results.N_common = N_common;

save('B4_1_results.mat','B4_1_results');

fprintf('\nLesson 3 completed.\n');

%% B4.1 - Lesson 4
% Local Pose Covariance from Cable-Length Noise

%% 17. Define hypothetical measurement noise

sigma_L = 0.1;  % mm, assumed standard deviation

% Covariance of six independent length sensors
Sigma_L = sigma_L^2 * eye(6);

% q_scaled = [P; rb*delta_theta]
% q_physical = [P; delta_theta]
S = diag([1 1 1 1/rb 1/rb 1/rb]);

%% 18. Initialise uncertainty results
position_uncertainty = zeros(N_poses,2);
orientation_uncertainty = zeros(N_poses,2);

% Covariance of [translation(mm); rotation(rad)]
Cov_all = zeros(6,6,N_poses,2);

%% 19. Calculate covariance at every pose
% 将cov协方差矩阵还原成带有信息的jacobian矩阵 这样可以得到具体的位置信息 

for c = 1:2

    for k = 1:N_poses

        Hs = Hs_all(:,:,k,c);

        % Singular Value Decomposition
        % 1. SVD 分解提取雅可比矩阵的灵敏度（奇异值）
        [U,SV,V] = svd(Hs);
        singular_values = diag(SV);

        % Full-rank assumption
        assert(all(singular_values > 1e-12));
        %如果所有 6 个奇异值都严格大于 0，
        % 则 rank({H}_s) = 6$，即矩阵满秩（Full Rank）、非奇异（Non-singular）且可逆。

        % Covariance in scaled pose coordinates
        % 2. 将雅可比灵敏度转换为无量纲姿态协方差
        % 在"缩放坐标系"下计算的协方差矩阵（为了消除平移和旋转的尺度差异）。
        Cov_scaled = V * ...
            diag(sigma_L^2 ./ singular_values.^2) ...
            * V.';

        % Convert to physical coordinates
        % 3. 物理尺度还原：乘以缩放矩阵 S，将无量纲转化为物理单位 (mm 和 rad)
        % Position: mm
        % Rotation: rad
        % 把数学推导中的"无量纲协方差矩阵"，
        % 转换为具有实际物理单位的"位置不确定度（单位：mm）"和"姿态不确定度（单位：°）
        Cov_q = S * Cov_scaled * S.';

        Cov_all(:,:,k,c) = Cov_q;

        % 3D position uncertainty (RMS norm)
        % 4. 提取 3D 位置不确定性 (单位：mm)
        Cov_position = Cov_q(1:3,1:3);
        % Cov_q 是一个 $6 * 6$ 的矩阵，它的每个元素表示两个变量之间的协方差

        position_uncertainty(k,c) = ...
            sqrt(trace(Cov_position));

        % 3D local orientation uncertainty (RMS norm)
        % 5. 提取 3D 姿态不确定性 (单位：deg)
        Cov_rotation = Cov_q(4:6,4:6);

        orientation_uncertainty(k,c) = ...
            rad2deg(sqrt(trace(Cov_rotation)));

    end

end

fprintf('\n--- B4.1 Lesson 4 ---\n');
fprintf('Assumed cable noise SD: %.3f mm\n',sigma_L);

%% 20. Report geometrically feasible subsets

safe_data = {geometry_safe_A,geometry_safe_B};

for c = 1:2
    valid = safe_data{c};

    fprintf('\n%s - Geometrically feasible subset\n', ...
        names{c});

    fprintf('Feasible poses: %d\n',sum(valid));

    fprintf('Median position uncertainty: %.4f mm\n', ...
        median(position_uncertainty(valid,c)));

    fprintf('Worst position uncertainty: %.4f mm\n', ...
        max(position_uncertainty(valid,c)));

    fprintf('Median orientation uncertainty: %.4f deg\n', ...
        median(orientation_uncertainty(valid,c)));

    fprintf('Worst orientation uncertainty: %.4f deg\n', ...
        max(orientation_uncertainty(valid,c)));

end

%% 21. Compare on identical feasible poses

common_safe = geometry_safe_A & geometry_safe_B;

assert(sum(common_safe)==19);

fprintf('\nCommon feasible subset: %d poses\n', ...
    sum(common_safe));

fprintf('\nMedian position uncertainty:\n');
fprintf('A: %.4f mm\n', ...
    median(position_uncertainty(common_safe,1)));
fprintf('B: %.4f mm\n', ...
    median(position_uncertainty(common_safe,2)));

fprintf('\nMedian orientation uncertainty:\n');
fprintf('A: %.4f deg\n', ...
    median(orientation_uncertainty(common_safe,1)));
fprintf('B: %.4f deg\n', ...
    median(orientation_uncertainty(common_safe,2)));

fprintf('\nPaired uncertainty comparison:\n');

fprintf('B lower position uncertainty: %d / %d\n', ...
    sum(position_uncertainty(common_safe,2) < ...
    position_uncertainty(common_safe,1)), ...
    sum(common_safe));

fprintf('B lower orientation uncertainty: %d / %d\n', ...
    sum(orientation_uncertainty(common_safe,2) < ...
    orientation_uncertainty(common_safe,1)), ...
    sum(common_safe));
%% 22. Verify covariance at reference pose

for c = 1:2

    H = H_all(:,:,reference_idx,c);
    Cov_q = Cov_all(:,:,reference_idx,c);

    % For square, nonsingular H and equal noise covariance:
    % H * Cov_q * H' = Sigma_L
    residual = norm( ...
        H*Cov_q*H.' - Sigma_L,'fro');

    fprintf('\n%s covariance residual: %.3e\n', ...
        names{c},residual);

    assert(residual < 1e-8);

end

fprintf('Reference covariance verification passed.\n');

%% 23. Save results

B4_1_results.Cov_all = Cov_all;
B4_1_results.position_uncertainty = ...
    position_uncertainty;

B4_1_results.orientation_uncertainty = ...
    orientation_uncertainty;

B4_1_results.sigma_L = sigma_L;

save('B4_1_results.mat','B4_1_results');

fprintf('\nLesson 4 completed.\n');



%% ============================================================
% B4.1 - Lesson 5
% Integrated Geometric Feasibility and Sensing Quality
%
% Inputs: Results from B3.2 and B4.1 Lessons 1-4
%
% Outputs:
% 1. Integrated comparison table
% 2. Paired comparison table
% 3. Geometric failure diagnosis
% 4. Sensing-quality boxcharts
% 5. Paired uncertainty scatter plots
% 6. Updated B4_1_results.mat
%
% Note:
% Do not change Experiment A/B geometry in this lesson.
%% ============================================================

fprintf('\n--- B4.1 Lesson 5 ---\n');

%% 24. Verify input data

N_total = size(P_all,1);

assert(N_total == 189);
assert(isequal(size(sigma_min_all),[189 2]));
assert(isequal(size(condition_all),[189 2]));
assert(isequal(size(position_uncertainty),[189 2]));
assert(isequal(size(orientation_uncertainty),[189 2]));

safe_A = geometry_safe_A(:);
safe_B = geometry_safe_B(:);

common_safe = safe_A & safe_B;

nA = sum(safe_A);
nB = sum(safe_B);
nCommon = sum(common_safe);

assert(nA == 40);
assert(nB == 105);
assert(nCommon == 19);

% Confirm results agree with B3.2
assert(isequal(safe_A, ...
    B3_2_results.geometry_safe_A(:)));

assert(isequal(safe_B, ...
    B3_2_results.geometry_safe_B(:)));

% Numerical data checks
all_metrics = [
    sigma_min_all(:);
    condition_all(:);
    position_uncertainty(:);
    orientation_uncertainty(:)
];

assert(all(isfinite(all_metrics)));
assert(all(all_metrics > 0));

fprintf('Input verification passed.\n');

%% 25. Integrated comparison table

configuration = {'Experiment A';'Experiment B'};

feasible_poses = [nA;nB];

geometric_pass_percent = ...
    100 * feasible_poses / N_total;

median_sigma = [
    median(sigma_min_all(safe_A,1));
    median(sigma_min_all(safe_B,2))
];

min_sigma = [
    min(sigma_min_all(safe_A,1));
    min(sigma_min_all(safe_B,2))
];

median_kappa = [
    median(condition_all(safe_A,1));
    median(condition_all(safe_B,2))
];

max_kappa = [
    max(condition_all(safe_A,1));
    max(condition_all(safe_B,2))
];

median_position = [
    median(position_uncertainty(safe_A,1));
    median(position_uncertainty(safe_B,2))
];

worst_position = [
    max(position_uncertainty(safe_A,1));
    max(position_uncertainty(safe_B,2))
];

median_orientation = [
    median(orientation_uncertainty(safe_A,1));
    median(orientation_uncertainty(safe_B,2))
];

worst_orientation = [
    max(orientation_uncertainty(safe_A,1));
    max(orientation_uncertainty(safe_B,2))
];

integrated_table = table( ...
    configuration, ...
    feasible_poses, ...
    geometric_pass_percent, ...
    min_sigma, ...
    median_sigma, ...
    median_kappa, ...
    max_kappa, ...
    median_position, ...
    worst_position, ...
    median_orientation, ...
    worst_orientation, ...
    'VariableNames',{ ...
    'Configuration', ...
    'Feasible_Poses', ...
    'Geometric_Pass_Percent', ...
    'Min_SigmaMin', ...
    'Median_SigmaMin', ...
    'Median_Kappa', ...
    'Max_Kappa', ...
    'Median_Position_mm', ...
    'Worst_Position_mm', ...
    'Median_Orientation_deg', ...
    'Worst_Orientation_deg'});

fprintf('\nIntegrated B4.1 Comparison:\n');
disp(integrated_table);

%% 26. Paired comparison on common feasible poses

common_idx = find(common_safe);

A_sigma = sigma_min_all(common_idx,1);
B_sigma = sigma_min_all(common_idx,2);

A_kappa = condition_all(common_idx,1);
B_kappa = condition_all(common_idx,2);

A_pos = position_uncertainty(common_idx,1);
B_pos = position_uncertainty(common_idx,2);

A_ori = orientation_uncertainty(common_idx,1);
B_ori = orientation_uncertainty(common_idx,2);

metric_names = {
    'Higher sigma_min';
    'Lower condition number';
    'Lower position uncertainty';
    'Lower orientation uncertainty'
};

B_better_count = [
    sum(B_sigma > A_sigma);
    sum(B_kappa < A_kappa);
    sum(B_pos < A_pos);
    sum(B_ori < A_ori)
];

paired_table = table( ...
    metric_names, ...
    B_better_count, ...
    repmat(nCommon,4,1), ...
    'VariableNames', ...
    {'Metric','B_Better','Common_Poses'});

fprintf('\nPaired comparison on common poses:\n');
disp(paired_table);

fprintf('\nCommon-pose median uncertainty:\n');

fprintf('Position A: %.4f mm\n',median(A_pos));
fprintf('Position B: %.4f mm\n',median(B_pos));

fprintf('Orientation A: %.4f deg\n',median(A_ori));
fprintf('Orientation B: %.4f deg\n',median(B_ori));

%% 27. Geometric failure diagnosis

sphere_pass_A = B3_2_results.safe_sphere_A(:);
sphere_pass_B = B3_2_results.safe_sphere_B(:);

contact_A = B3_2_results.contact_A(:);
contact_B = B3_2_results.contact_B(:);

% Reconstruct combined feasibility
assert(isequal(safe_A, ...
    sphere_pass_A & ~contact_A));

assert(isequal(safe_B, ...
    sphere_pass_B & ~contact_B));

failure_table = table( ...
    configuration, ...
    [sum(~sphere_pass_A);sum(~sphere_pass_B)], ...
    [sum(contact_A);sum(contact_B)], ...
    [sum(~safe_A);sum(~safe_B)], ...
    'VariableNames', ...
    {'Configuration', ...
     'Sphere_Fail_Poses', ...
     'Cable_Contact_Poses', ...
     'Combined_Fail_Poses'});

fprintf('\nGeometric Failure Diagnosis:\n');
disp(failure_table);

% Identify Cable Pair 5-6 contact cases for B
pairs = B3_2_results.pairs;

pair56_idx = find( ...
    pairs(:,1)==5 & pairs(:,2)==6);

assert(numel(pair56_idx)==1);

contact56 = B3_2_results.distance_B( ...
    :,pair56_idx) <= 1e-6;

fprintf('Experiment B Cable 5-6 contacts: %d\n', ...
    sum(contact56));

assert(sum(contact56)==81);

%% 28. Figure 1 - Sensing quality distributions

figure('Color','w','Position',[100 100 1250 820]);

tiledlayout(2,2, ...
    'Padding','compact', ...
    'TileSpacing','compact');

metric_data = {
    sigma_min_all;
    condition_all;
    position_uncertainty;
    orientation_uncertainty
};

metric_titles = {
    'Scaled Minimum Singular Value';
    'Scaled Condition Number';
    'Predicted 3D Position Uncertainty';
    'Predicted 3D Orientation Uncertainty'
};

metric_labels = {
    'Minimum Singular Value';
    'Condition Number';
    'Position Uncertainty (mm)';
    'Orientation Uncertainty (deg)'
};

for m = 1:4

    nexttile;
    hold on;

    current_metric = metric_data{m};

    valuesA = current_metric(safe_A,1);
    valuesB = current_metric(safe_B,2);

    boxchart(ones(nA,1),valuesA, ...
        'BoxFaceColor',[0.25 0.45 0.80]);

    boxchart(2*ones(nB,1),valuesB, ...
        'BoxFaceColor',[0.15 0.65 0.45]);

    set(gca, ...
        'XTick',[1 2], ...
        'XTickLabel',{'A (n=40)','B (n=105)'});

    xlim([0.5 2.5]);

    ylabel(metric_labels{m});
    title(metric_titles{m});

    % Log scale for skewed positive metrics
    if m >= 2
        set(gca,'YScale','log');
    end

    grid on;
    box on;

end

sgtitle( ...
    'B4.1 - Sensing Quality on Each Feasible Subset');

exportgraphics(gcf, ...
    'B4_1_sensing_quality_final.png', ...
    'Resolution',250);

%% 29. Figure 2 - Paired uncertainty comparison

figure('Color','w','Position',[150 150 1100 480]);

tiledlayout(1,2, ...
    'Padding','compact', ...
    'TileSpacing','compact');

paired_A = {A_pos,A_ori};
paired_B = {B_pos,B_ori};

paired_titles = {
    'Position Uncertainty';
    'Orientation Uncertainty'
};

paired_units = {'mm','deg'};

for m = 1:2

    nexttile;
    hold on;

    x = paired_A{m};
    y = paired_B{m};

    % Shared axis bounds
    lower_bound = min([x;y])*0.8;
    upper_bound = max([x;y])*1.2;

    % Equality line
    plot( ...
        [lower_bound upper_bound], ...
        [lower_bound upper_bound], ...
        'k--','LineWidth',1.4);

    % One point = one common feasible pose
    scatter(x,y,55, ...
        [0.15 0.60 0.45],'filled');

    set(gca,'XScale','log','YScale','log');

    xlim([lower_bound upper_bound]);
    ylim([lower_bound upper_bound]);

    % Avoid MATLAB variable/function name conflicts
    pbaspect([1 1 1]);

    xlabel(sprintf( ...
        'Experiment A (%s)',paired_units{m}));

    ylabel(sprintf( ...
        'Experiment B (%s)',paired_units{m}));

    title(paired_titles{m});

    grid on;
    box on;

end

sgtitle( ...
    'B4.1 - Paired Comparison at 19 Common Feasible Poses');

exportgraphics(gcf, ...
    'B4_1_common_pose_uncertainty_final.png', ...
    'Resolution',250);

fprintf('\nFinal figures exported.\n');

%% 30. Final numerical verification

assert(B_better_count(1)==18);
assert(B_better_count(2)==18);
assert(B_better_count(3)==19);
assert(B_better_count(4)==18);

assert(sum(~sphere_pass_A)==149);
assert(sum(~sphere_pass_B)==3);

assert(sum(contact_A)==0);
assert(sum(contact_B)==81);

fprintf('\nAll B4.1 synthesis checks passed.\n');

%% 31. Save final results

B4_1_results.integrated_table = integrated_table;
B4_1_results.paired_table = paired_table;
B4_1_results.failure_table = failure_table;

B4_1_results.common_safe = common_safe;
B4_1_results.common_idx = common_idx;

B4_1_results.B_better_count = B_better_count;
B4_1_results.N_common = nCommon;

save('B4_1_results.mat','B4_1_results');

fprintf('\nB4.1 Lesson 5 completed.\n');
