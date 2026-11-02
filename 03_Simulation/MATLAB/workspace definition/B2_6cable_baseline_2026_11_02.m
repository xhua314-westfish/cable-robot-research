%% B2.1 - Initial Six-Cable Configuration
clear; clc; close all;

%% 1. Load B1 geometry
load('B1_geometry_baseline.mat','geometry');

A_candidates = geometry.anchor_candidates;
r_candidates = geometry.attachment_candidates_body;
rb = geometry.balloon_radius;

%% 2. Choose six anchor face centres (mm)
A_target = [
    140    0    0;
    -140    0    0;
    0  150    0;
    0 -150    0;
    0    0  160;
    0    0 -160
    ];

% Verify anchors belong to B1 candidate set
assert(all(ismember(A_target,A_candidates,'rows')));
% 校验某个条件表达式是否为真（true）。
% 如果条件满足，程序继续向下执行；如果条件不满足（false），程序将立即中断运行并抛出错误信息。

A6 = A_target;

%% 3. Define six desired attachment directions
directions = [
    0  1  1;
    0 -1  1;
    1  0 -1;
    -1  0 -1;
    1  1  0;
    -1 -1  0
    ];

directions = directions ./ vecnorm(directions,2,2);
%例如第一行 [0, 1, 1] 的长度为 sqrt{0^2 + 1^2 + 1^2} = \sqrt{2} \approx 1.414。
r_target = rb * directions;
%标量 r_b（气球半径，如 50.83 mm）与 6 * 3 的单位方向向量矩阵相乘。

% Match each target to the nearest B1 candidate
r6 = zeros(6,3);
attachment_idx = zeros(6,1);


for i = 1:6
    distances = vecnorm(r_candidates-r_target(i,:),2,2);
    [~,idx] = min(distances);
    attachment_idx(i) = idx;
    r6(i,:) = r_candidates(idx,:);
    % 你指定了一个方向 [0, 1, 1]，归一化成单位向量后乘以半径 r_b，
    % 得到了球面上理论上最完美、最理想的挂钩位置。
    % 但我们上一步选定了40个点 
    % 现在比较这40个点 究竟哪个点离r_target最近
    % 最近的那个点就是r_candidate
end

assert(numel(unique(attachment_idx))==6);

%% 4. Calculate cable lengths at initial pose
P = [0;0;0];
R = eye(3);

B6 = (R*r6.' + P).';

D = A6-B6;
L = vecnorm(D,2,2);
U = D./L;

%% 5. Construct measurement Jacobian
H = zeros(6,6);

for i = 1:6
    u = U(i,:).';
    s = (R*r6(i,:).').';

    H(i,:) = [-u.', cross(u,s.').'];
end

% Scaled Jacobian: rotation measured as
% characteristic surface displacement (mm)
H_scaled = H * diag([1 1 1 1/rb 1/rb 1/rb]);
% diag([1 1 1 1/rb 1/rb 1/rb]) 生成一个 $6 * 6$ 的对角矩阵
% H_scaled 含义： 缆绳长度变化量 (mm) / 气球表面点的物理位移量 (mm)

svals = svd(H_scaled);
% 奇异值分解（Singular Value Decomposition）。
% $6 * 6$ 的矩阵 $H_scaled}}$ 进行奇异值分解后，MATLAB 会返回一个按降序排列的 6 维列向量 svals：
% 如果在 6 维空间中给气球施加一个"单位大小的表面位移"，在不同方向上引起的"6 根缆绳总长度变化"是不同的。

fprintf('\n--- B2.1 Initial Six-Cable Baseline ---\n');
fprintf('Number of cables: %d\n',size(A6,1));
fprintf('Jacobian rank: %d\n',rank(H));
fprintf('Scaled minimum singular value: %.6f\n',min(svals));
% 系统在最不敏感（最差）方向上的几何灵敏度
% 若 $sigma_min ≈ 0$：说明存在某种特定的气球运动（运动死角/奇异姿态），几乎不会引起任何缆绳长度发生变化。
% 这种情况下，算法无法根据传感器测得的缆绳长度反算气球姿态。
% $sigma_min$ 越大越好：代表即使在系统最弱的运动方向上，气球稍微动一下，缆绳长度也会产生可被传感器清晰捕捉到的显著变化，
% 说明系统不存在奇异死角，可观测性极佳。

fprintf('Scaled condition number: %.3f\n',cond(H_scaled));
% condition number 缩放后的条件数
% kappa = sigma_max / sigma_min 
% 物理含义：评估系统在 6 个自由度上的各向同性（Isotropy / 各向均衡度）与数值抗噪能力。
% 理想最优值：$kappa = 1.0$。此时矩阵为完全的正交各向同性状态，
% 代表气球向任何方向（上下左右前后、旋转）移动相同距离时，缆绳长度的变化幅度完全一致。
% $kappa$ 越小（越接近 1）越好：说明系统在各个方向的测量精度非常均匀。
% $kappa 远大于 10 或达到上百：说明系统在某些方向极度敏感，而在另一些方向极度钝感。
% 传感器传入的微小测长误差（噪音），会在解算气球姿态时被放大 $\kappa$ 倍，导致姿态估计严重失真。

fprintf('Cable lengths (mm):\n');
disp(L.');

%% 6. Basic checks
assert(all(L>0),'Invalid cable length.');
assert(all(abs(vecnorm(r6,2,2)-rb)<1e-8));

%% B2.2 Experiment A
% Fixed anchors, optimise attachment selection
% Random search, initial pose only

rng(42);  % Reproducible results

N_trials = 20000;
N_cables = 6;

best_cond = inf;
% 无穷大 无论后续算出的第一个有效条件数 current_cond 是多少，
% 条件判断 if current_cond < best_cond 都能必定成立，从而把第一个有效解记录下来。
best_r = [];
best_H = [];
best_lengths = [];

valid_count = 0;

% Baseline metric
baseline_cond = cond(H_scaled);
baseline_smin = min(svd(H_scaled));

for k = 1:N_trials
    % Randomly select six unique attachments
    idx = randperm(size(r_candidates,1),N_cables);
    r_test = r_candidates(idx,:);

    % World-frame attachment positions
    B_test = (R*r_test.' + P).';

    % Cable vectors and lengths
    D_test = A6-B_test;
    L_test = vecnorm(D_test,2,2);

    if any(L_test < 1e-8)
        continue;
    end

    % Outward routing check
    outward = sum(D_test.*(B_test-P.'),2);

    if any(outward < -1e-8)
        continue;
        % 只要有任意一根缆绳是向内走/发生干涉的，就淘汰这种配置
    end

    % Build measurement Jacobian
    U_test = D_test./L_test;
    H_test = zeros(6,6);

    for i = 1:6
        u = U_test(i,:).';
        s = R*r_test(i,:).';

        H_test(i,:) = ...
            [-u.', cross(u,s).'];
    end

    % Dimensionless/scaled pose increment:
    % [translation(mm); rb*rotation(rad)]
    S = diag([1 1 1 1/rb 1/rb 1/rb]);
    Hs_test = H_test*S;

    if rank(Hs_test) < 6
        continue;
    end

    valid_count = valid_count+1;

    current_cond = cond(Hs_test);

    if current_cond < best_cond
        best_cond = current_cond;
        best_r = r_test;
        best_H = Hs_test;
        best_lengths = L_test;
    end
end

%% Compare results
fprintf('\n--- B2.2 Experiment A ---\n');
fprintf('Total trials: %d\n',N_trials);
fprintf('Valid configurations: %d\n',valid_count);

fprintf('\nBaseline condition number: %.3f\n', ...
    baseline_cond);

fprintf('Best condition number: %.3f\n',best_cond);

fprintf('Baseline sigma_min: %.6f\n', ...
    baseline_smin);

if isempty(best_r)
    warning('No valid configuration found.');
else
    fprintf('Best sigma_min: %.6f\n', ...
        min(svd(best_H)));

    fprintf('\nSelected attachment coordinates (mm):\n');
    disp(best_r);

    fprintf('Cable lengths (mm):\n');
    disp(best_lengths.');
end


%% B2.2.1 Verify selected configuration

if ~isempty(best_r)

    % Reconstruct best geometry
    B_best = (R*best_r.' + P).';
    D_best = A6-B_best;
    L_best = vecnorm(D_best,2,2);
    U_best = D_best./L_best;

    H_best = zeros(6,6);
    moment_sensitivity = zeros(6,1);
    outward_values = zeros(6,1);

    for i = 1:6
        u = U_best(i,:).';
        s = R*best_r(i,:).';

        H_best(i,:) = [-u.',cross(u,s).'];

        moment_sensitivity(i) = norm(cross(u,s));
        outward_values(i) = dot(D_best(i,:).',s);
    end

    Hs_best = H_best * ...
        diag([1 1 1 1/rb 1/rb 1/rb]);

    fprintf('\n--- Best Configuration Verification ---\n');
    fprintf('Jacobian rank: %d\n',rank(H_best));
    fprintf('Scaled condition number: %.4f\n',cond(Hs_best));

    fprintf('\nRotation sensitivity per cable (mm):\n');
    disp(moment_sensitivity.');

    fprintf('Outward routing test values (mm^2):\n');
    disp(outward_values.');

    assert(all(outward_values >= -1e-8), ...
        'Some cables enter the balloon.');

    % Save the best configuration
    config6.A = A6;
    config6.r = best_r;
    config6.H = H_best;
    config6.condition = cond(Hs_best);
    config6.sigma_min = min(svd(Hs_best));

    save('B2_6cable_experiment_A.mat','config6');

end
