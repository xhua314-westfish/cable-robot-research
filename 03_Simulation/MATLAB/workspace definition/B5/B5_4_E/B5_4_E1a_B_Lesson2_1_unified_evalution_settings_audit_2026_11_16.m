
%% B5.4 E1a-B Lesson 2.1
% Unified Evaluation Settings Audit
%
% 研究问题：
% 六组配置是否使用统一的评价判据？
%
% 注意：本节只检查判据，不进行优化。

clear; clc;

%% Step 1 — 读取统一评价数据

data = load( ...
    'B5_4_unified_evaluation_baseline.mat');

settings = data.settings;

config_ids = [2 4 6 8 12 17];

%% Step 2 — 检查基础数值判据

fprintf('\n--- Common Evaluation Settings ---\n');

fprintf('Balloon radius: %.4f mm\n', ...
    settings.rb);

fprintf('Sphere tolerance: %.3e mm^2\n', ...
    settings.sphere_tol);

fprintf('Contact tolerance: %.3e mm\n', ...
    settings.contact_tol);

fprintf('Rank relative tolerance: %.3e\n', ...
    settings.rank_relative_tol);

% 六根Cable一共有15对可能接触组合
assert(size(settings.cable_pairs,1)==15);

% 检查Jacobian缩放
expected_scale = diag( ...
    [1 1 1 ...
    1/settings.rb ...
    1/settings.rb ...
    1/settings.rb]);

assert(norm(settings.H_scale- ...
    expected_scale,'fro')<1e-12);

fprintf('Jacobian scaling: PASS\n');

%% Step 3 — 检查六组Core资格

N_pose = size(data.P_all,1);

assert(N_pose==189);

for j = 1:numel(config_ids)

    id = config_ids(j);

    result = data.new_results{id};

    % 所有Core姿态几何通过
    geometry_pass = all( ...
        result.geometry_safe);

    % 所有Core姿态Jacobian满秩
    rank_pass = all( ...
        result.rank_all==6);

    assert(geometry_pass);
    assert(rank_pass);

    fprintf('Config %d: Geometry PASS, Rank PASS\n', ...
        id);

end

%% Step 4 — 保存统一评价设置

% 复制配置，不修改原始数据
common_settings = settings;

% 标记当前共同开发位姿
common_settings.dev_pose_count = N_pose;

% 硬约束与排序指标必须分开
common_settings.require_full_rank = true;
common_settings.require_geometry = true;

% 当前尚未确定真实物理安全距离
common_settings.physical_clearance_verified = false;

save('B5_4_E1a_B_common_settings.mat', ...
    'common_settings','config_ids');

fprintf('\nUnified settings audit: PASS\n');
