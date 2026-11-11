%% B5.2 Lesson 3.2
% Five-Configuration Larger-Benchmark Comparison
%
% Research Question:
% How do the five candidate configurations perform
% under the larger benchmark workspace?
%
% Objectives:
% 1. Re-test Original B, Bprime, F1, F2, F3
% 2. Use the larger benchmark: +/-50 mm, +/-10 deg
% 3. Compare geometry passing counts
% 4. Compare Core vs Larger Benchmark
% 5. Save results for B5.2 final summary
%
% IMPORTANT:
% This lesson evaluates geometry only.
% No sensing-quality evaluation in this step.

clear; clc; close all;

%% Step 1: Load configuration data and previous Core results

% 读取Original B
load('B2_experiment_B_results.mat','resultB');

% 读取F1/F2/F3的最佳配置
load('B5_1_geometry_constrained_pairing.mat', ...
    'best_configs','family_names','rb');

% 读取Core结果，方便后续比较
load('B5_2_five_config_core_geometry.mat', ...
    'result_table','geometry_results');

% 检查B3线段距离函数
assert(exist('B3_1_segment_distance_3d_2026_11_02','file')==2, ...
    'B3 segment-distance function not found.');

%% Step 2: Build the same five configurations

config_names = {
    'Original B';
    'Modified Bprime';
    'F1 - Six-Face Distributed';
    'F2 - Opposite/Layered';
    'F3 - Asymmetric'
    };

N_config = numel(config_names);
n_cables = 6;

configs = cell(N_config,1);

% Original B
configs{1}.A = resultB.A;
configs{1}.r = resultB.r;

% Modified Bprime：交换Attachment 5和6
configs{2}.A = resultB.A;
r_Bprime = resultB.r;
r_Bprime([5 6],:) = r_Bprime([6 5],:);
configs{2}.r = r_Bprime;

% F1, F2, F3
for k = 1:3
    assert(~isempty(best_configs{k}), ...
        'Family F%d has no feasible saved pairing.',k);

    configs{k+2}.A = best_configs{k}.A;
    configs{k+2}.r = best_configs{k}.r;
end

% 基本尺寸检查
for k = 1:N_config
    assert(isequal(size(configs{k}.A),[6 3]));
    assert(isequal(size(configs{k}.r),[6 3]));

    radius_error = max(abs(vecnorm(configs{k}.r,2,2)-rb));
    assert(radius_error < 1e-4);
end

fprintf('Five configurations loaded successfully.\n');

%% Step 3: Build larger benchmark poses

% Larger benchmark translations
p_values = [-50 0 50];

[X,Y,Z] = ndgrid(p_values,p_values,p_values);
P_samples = [X(:),Y(:),Z(:)];

% Larger benchmark orientation cases
angles_deg = [
    0   0   0;
    10   0   0;
    -10   0   0;
    0  10   0;
    0 -10   0;
    0   0  10;
    0   0 -10
    ];

N_position = size(P_samples,1);
N_rotation = size(angles_deg,1);
N_pose = N_position * N_rotation;

assert(N_position == 27);
assert(N_rotation == 7);
assert(N_pose == 189);

P_all = zeros(N_pose,3);
R_all = zeros(3,3,N_pose);
position_id = zeros(N_pose,1);
orientation_id = zeros(N_pose,1);

idx = 0;

for i = 1:N_position
    for j = 1:N_rotation

        idx = idx + 1;
        P_all(idx,:) = P_samples(i,:);

        roll  = deg2rad(angles_deg(j,1));
        pitch = deg2rad(angles_deg(j,2));
        yaw   = deg2rad(angles_deg(j,3));

        Rx = [
            1 0 0;
            0 cos(roll) -sin(roll);
            0 sin(roll)  cos(roll)
            ];

        Ry = [
            cos(pitch) 0 sin(pitch);
            0 1 0;
            -sin(pitch) 0 cos(pitch)
            ];

        Rz = [
            cos(yaw) -sin(yaw) 0;
            sin(yaw)  cos(yaw) 0;
            0 0 1
            ];

        % 与B3.2保持一致：ZYX
        R = Rz * Ry * Rx;

        assert(norm(R'*R-eye(3),'fro') < 1e-10);
        assert(abs(det(R)-1) < 1e-10);

        R_all(:,:,idx) = R;
        position_id(idx) = i;
        orientation_id(idx) = j;

    end
end

fprintf('Larger benchmark poses generated: %d\n',idx);

%% Step 4: Define geometry criteria

sphere_tol = 1e-9;
contact_tol = 1e-6;

cable_pairs = nchoosek(1:n_cables,2);
N_pairs = size(cable_pairs,1);

assert(N_pairs == 15);

benchmark_results = cell(N_config,1);

% summary columns:
% [SpherePass, CablePass, GeometryPass, MinCableDistance]
summary = zeros(N_config,4);

for c = 1 : N_config

    fprintf('\n====================================\n');
    fprintf('%s\n',config_names{c});
    fprintf('====================================\n');

    A = configs{c}.A;
    r = configs{c}.r;

    sphere_safe = false(N_pose,1);
    cable_safe = false(N_pose,1);
    geometry_safe = false(N_pose,1);

    outward_safe = false(N_pose,n_cables);
    distances = zeros(N_pose,N_pairs);

    for k = 1:N_pose

        P = P_all(k,:);
        R = R_all(:,:,k);

        % 球心到attachment的向量
        S = (R*r')';

        % 世界坐标attachment
        B = S + P;

        % cable向量
        D = A - B;

        L = vecnorm(D,2,2);
        assert(all(L > 1e-9));

        %% 5.1 Cable-sphere check
        outward_dot = sum(S.*D,2);

        outward_safe(k,:) = (outward_dot >= -sphere_tol)';
        sphere_safe(k) = all(outward_safe(k,:));

        %% 5.2 Cable-cable check
        for j = 1:N_pairs
            i1 = cable_pairs(j,1);
            i2 = cable_pairs(j,2);

            distances(k,j) = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                B(i1,:),A(i1,:), ...
                B(i2,:),A(i2,:));
        end

        cable_safe(k) = all(distances(k,:) > contact_tol);

        %% 5.3 Combined geometry check
        geometry_safe(k) = sphere_safe(k) && cable_safe(k);

    end

    N_sphere = sum(sphere_safe);
    N_cable = sum(cable_safe);
    N_geometry = sum(geometry_safe);
    min_cable_distance = min(distances(:));

    fprintf('Sphere passing: %d / %d\n',N_sphere,N_pose);
    fprintf('Cable-cable passing: %d / %d\n',N_cable,N_pose);
    fprintf('Combined geometry passing: %d / %d\n',N_geometry,N_pose);
    fprintf('Minimum cable distance: %.6f mm\n',min_cable_distance);

    benchmark_results{c}.name = config_names{c};
    benchmark_results{c}.A = A;
    benchmark_results{c}.r = r;
    benchmark_results{c}.sphere_safe = sphere_safe;
    benchmark_results{c}.cable_safe = cable_safe;
    benchmark_results{c}.geometry_safe = geometry_safe;
    benchmark_results{c}.outward_safe = outward_safe;
    benchmark_results{c}.distances = distances;
    benchmark_results{c}.N_sphere = N_sphere;
    benchmark_results{c}.N_cable = N_cable;
    benchmark_results{c}.N_geometry = N_geometry;
    benchmark_results{c}.min_cable_distance = min_cable_distance;

    summary(c,:) = [N_sphere, N_cable, N_geometry, min_cable_distance];
end

%% Step 6: Create benchmark result table

benchmark_table = table( ...
    string(config_names), ...
    summary(:,1), ...
    summary(:,2), ...
    summary(:,3), ...
    100*summary(:,3)/N_pose, ...
    summary(:,4), ...
    'VariableNames', ...
    {'Configuration', ...
    'SpherePass', ...
    'CablePass', ...
    'GeometryPass', ...
    'GeometryPercent', ...
    'MinCableDistance_mm'});

disp(' ');
disp('--- B5.2 Larger Benchmark Geometry Comparison ---');
disp(benchmark_table);

%% Step 7: Compare Core vs Larger Benchmark
core_geometry_pass = zeros(N_config,1);

for c = 1:N_config
    core_geometry_pass(c) = geometry_results{c}.N_geometry;
end

benchmark_geometry_pass = summary(:,3);

comparison_table = table( ...
    string(config_names), ...
    core_geometry_pass, ...
    benchmark_geometry_pass, ...
    100*core_geometry_pass/189, ...
    100*benchmark_geometry_pass/189, ...
    'VariableNames', ...
    {'Configuration', ...
    'CoreGeometryPass', ...
    'BenchmarkGeometryPass', ...
    'CorePercent', ...
    'BenchmarkPercent'});

disp(' ');
disp('--- Core vs Larger Benchmark Comparison ---');
disp(comparison_table);

%% Step 8: Numerical consistency checks

for c = 1:N_config

    b = benchmark_results{c};

    assert(isequal(size(b.distances),[189 15]));
    assert(isequal(size(b.outward_safe),[189 6]));

    assert(all(isfinite(b.distances(:))));
    assert(all(b.distances(:) >= 0));

    assert(isequal(b.geometry_safe, ...
        b.sphere_safe & b.cable_safe));

    assert(b.N_geometry <= b.N_sphere);
    assert(b.N_geometry <= b.N_cable);

end

fprintf('\nAll larger-benchmark numerical checks passed.\n');

%% Step 9: Plot 1 - Larger benchmark geometry pass

figure('Color','w','Name','B5.2 Larger Benchmark Results');

bar(benchmark_geometry_pass);

xticks(1:N_config);
xticklabels({'B','Bprime','F1','F2','F3'});

xlabel('Configuration');
ylabel('Geometry Passing Poses');
title('B5.2 - Larger Benchmark Geometry Comparison');

ylim([0 189]);
grid on;

for c = 1:N_config
    text(c,benchmark_geometry_pass(c)+4, ...
        sprintf('%d/189',benchmark_geometry_pass(c)), ...
        'HorizontalAlignment','center', ...
        'FontSize',10);
end

%% Step 10: Plot 2 - Core vs Benchmark comparison

figure('Color','w','Name','B5.2 Core vs Benchmark');

bar([core_geometry_pass benchmark_geometry_pass]);

xticks(1:N_config);
xticklabels({'B','Bprime','F1','F2','F3'});

xlabel('Configuration');
ylabel('Geometry Passing Poses');
title('B5.2 - Core vs Larger Benchmark');

legend({'Core (\pm20 mm, \pm5^o)', ...
    'Benchmark (\pm50 mm, \pm10^o)'}, ...
    'Location','best');

ylim([0 189]);
grid on;

%% Step 11: Save results

save('B5_2_larger_benchmark_geometry.mat', ...
    'benchmark_results','benchmark_table', ...
    'comparison_table', ...
    'config_names','P_all','R_all', ...
    'position_id','orientation_id', ...
    'angles_deg','cable_pairs', ...
    'sphere_tol','contact_tol','rb');

fprintf('B5.2 larger benchmark results saved.\n');
