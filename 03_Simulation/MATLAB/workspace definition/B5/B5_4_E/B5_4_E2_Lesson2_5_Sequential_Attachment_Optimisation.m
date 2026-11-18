
%% B5.4 E2 Lesson 2.5
% Two-Track Sequential Attachment Optimisation
%
% Research Question:
% 依次调整六个Attachment的球面位置，
% 能否提高worst-case sensing？
%
% Track S:
%   最大化Core worst sigma_min
%   满足Geometry、Rank、Cable clearance、
%   Attachment spacing
%
% Track M:
%   与Track S相同
%   额外要求最小Core outward angle
%   不低于E2原始Baseline
%
% 固定：
%   Anchor A
%   Rail Assignment
%   Cable Pairing
%
% 变量：
%   六个Attachment的位置 r_i
%
% 预算：
%   4 Designs x 2 Tracks x 192 Trials
%   = 1536次完整Core评价
%
% 本节只使用Core 189执行优化。
% 不使用539-pose数据接受或拒绝候选。

clear; clc; close all;

%% Step 1 — 加载Baseline和优化协议

data = load( ...
    'B5_4_E2_attachment_baselines.mat');

base = load( ...
    'B5_4_unified_evaluation_baseline.mat');

p = load( ...
    'B5_4_E2_optimisation_protocol.mat');

% 精确读取此前使用的Cable clearance约束
e1a_protocol = load( ...
    'B5_4_E1a_B_optimisation_protocol.mat');

e2_baselines = data.e2_baselines;

settings = base.settings;
P_all = base.P_all;
R_all = base.R_all;

protocol = p.protocol;

Design = string( ...
    data.T_attachment.Design);

tracks = protocol.tracks(:);

rb = settings.rb;

clearance_floor = ...
    e1a_protocol.protocol.clearance_floor_mm;

assert(numel(e2_baselines)==4);
assert(numel(tracks)==2);

assert(size(P_all,1)==189);

assert(abs( ...
    clearance_floor- ...
    protocol.clearance_floor_mm)<1e-6);

assert(exist( ...
    'B3_1_segment_distance_3d_2026_11_02', ...
    'file')==2);

%% Step 2 — 设置搜索参数

% 两轮，每轮6个Cable、16个扰动
sweep_amplitudes = { ...
    [2 5], ...
    [1 2.5]};

beta_values = protocol.directions_deg;

N_design = numel(e2_baselines);
N_track = numel(tracks);
N_sweep = numel(sweep_amplitudes);

N_cable = 6;

N_per_sweep = ...
    N_cable*2*numel(beta_values);

N_per_track = N_per_sweep*N_sweep;

assert(N_sweep==2);
assert(N_per_sweep==96);
assert(N_per_track==192);

N_runs = N_design*N_track;

assert(N_runs*N_per_track==1536);

improve_tol = protocol.improvement_tol;

fprintf('\n--- E2 Sequential Optimisation ---\n');

fprintf('Designs: %d\n',N_design);
fprintf('Tracks: %d\n',N_track);

fprintf('Trials per Track: %d\n', ...
    N_per_track);

fprintf('Total Trials: %d\n', ...
    N_runs*N_per_track);

fprintf('Core poses: %d\n',size(P_all,1));

%% Step 3 — 初始化结果

N_rows = N_runs;

DesignName = strings(N_rows,1);
TrackName = strings(N_rows,1);

BaselineSigma = nan(N_rows,1);
FinalSigma = nan(N_rows,1);

BaselineAngle_deg = nan(N_rows,1);
FinalAngle_deg = nan(N_rows,1);

BaselineDistance_mm = nan(N_rows,1);
FinalDistance_mm = nan(N_rows,1);

BaselineChord_mm = nan(N_rows,1);
FinalChord_mm = nan(N_rows,1);

ImprovementPercent = nan(N_rows,1);

GeometryPass = zeros(N_rows,1);
RankPass = zeros(N_rows,1);

TrialCount = zeros(N_rows,1);
AcceptedChanges = zeros(N_rows,1);

% 保存每条Track最终的完整设计
optimised_designs = cell(N_rows,1);

% 保存每一次扰动的记录
search_history = cell(N_rows,1);

run_id = 0;

%% Step 4 — 遍历四组设计

for d = 1:N_design

    cfg = e2_baselines{d};

    A = cfg.A_fixed;
    r0 = cfg.r_initial;

    assert(isequal(size(A),[6 3]));
    assert(isequal(size(r0),[6 3]));

    % 原始Attachment间距
    spacing_floor = ...
        minimum_attachment_chord(r0);

    %% 4.1 评价本设计的原始Core指标

    initial = evaluate_attachment_design( ...
        A,r0,P_all,R_all, ...
        settings,clearance_floor);

    assert(initial.geometry_pass==189);
    assert(initial.rank_pass==189);
    assert(initial.clearance_ok);

    assert(abs( ...
        initial.min_chord-spacing_floor)<1e-8);

    % Track M固定使用原设计的Core最小角
    baseline_angle = initial.min_angle;

    %% Step 5 — 两条Track分别独立运行

    for track_id = 1:N_track

        run_id = run_id+1;

        track_name = tracks(track_id);

        DesignName(run_id) = Design(d);
        TrackName(run_id) = track_name;

        % 两条Track都从相同的原始Attachment出发
        current_r = r0;
        current = initial;

        trial_count = 0;
        accepted_changes = 0;

        % 保存每次搜索的完整记录
        % 列定义：
        % 1 Trial
        % 2 Sweep
        % 3 Cable
        % 4 Alpha_deg
        % 5 Beta_deg
        % 6 GeometryPass
        % 7 RankPass
        % 8 MinAngle_deg
        % 9 MinCableDistance_mm
        % 10 MinAttachmentChord_mm
        % 11 Sigma (不合格时NaN)
        % 12 BaseFeasible
        % 13 TrackFeasible
        % 14 Improved
        H = nan(N_per_track,14);

        fprintf('\n============================\n');

        fprintf('%s | %s\n', ...
            Design(d),track_name);

        fprintf('Initial sigma: %.6f\n', ...
            initial.sigma);

        fprintf('Baseline angle: %.6f deg\n', ...
            baseline_angle);

        fprintf('Attachment spacing floor: %.4f mm\n', ...
            spacing_floor);

        %% Step 6 — 两轮顺序搜索

        for sweep = 1:N_sweep

            alphas = sweep_amplitudes{sweep};

            fprintf('\nSweep %d\n',sweep);

            %% Step 6.1 — 顺序优化六个Attachment

            for cable_id = 1:6

                % 当前Cable扫描开始时冻结整个r
                scan_start_r = current_r;

                % 当前Cable所在球面的法向
                n = scan_start_r(cable_id,:)'/rb;

                n = n/norm(n);

                %% Step 6.2 — 构建局部切平面

                if abs(dot(n,[0;0;1]))<0.9

                    reference_axis = [0;0;1];

                else

                    reference_axis = [1;0;0];

                end

                e1 = cross(reference_axis,n);
                e1 = e1/norm(e1);

                e2 = cross(n,e1);
                e2 = e2/norm(e2);

                assert(abs(dot(n,e1))<1e-10);
                assert(abs(dot(n,e2))<1e-10);

                %% Step 6.3 — 当前Cable的最佳结果

                best_r = scan_start_r;
                best = current;

                %% Step 6.4 — 遍历2x8个切向移动

                for ia = 1:numel(alphas)

                    alpha = alphas(ia);

                    for ib = 1:numel(beta_values)

                        beta = beta_values(ib);

                        % 切向单位方向
                        v = cosd(beta)*e1 + ...
                            sind(beta)*e2;

                        % 球面上的新Attachment
                        r_new = rb*( ...
                            cosd(alpha)*n + ...
                            sind(alpha)*v);

                        % 每次只更改当前Cable
                        r_trial = scan_start_r;

                        r_trial(cable_id,:) = r_new';

                        %% Step 6.5 — 确保所有点位于球面

                        radius_error = max(abs( ...
                            vecnorm(r_trial,2,2)-rb));

                        assert(radius_error<1e-8);

                        %% Step 6.6 — 完整Core评价

                        trial = evaluate_attachment_design( ...
                            A,r_trial,P_all,R_all, ...
                            settings,clearance_floor);

                        trial_count = trial_count+1;

                        % Attachment spacing:
                        % 不低于此设计原本的最小距离
                        spacing_ok = ...
                            trial.min_chord>= ...
                            spacing_floor-1e-8;

                        % 两Track共同的基本资格
                        base_feasible = ...
                            trial.feasible && spacing_ok;

                        %% Step 6.7 — Track资格判定

                        if track_id==1

                            % Track S
                            track_feasible = ...
                                base_feasible;

                        else

                            % Track M
                            % 不允许低于原始Core最小出线角
                            track_feasible = ...
                                base_feasible && ...
                                trial.min_angle>= ...
                                baseline_angle-1e-8;

                        end

                        %% Step 6.8 — 决定是否改善

                        improved = false;

                        % 只有合格方案才比较sigma
                        if track_feasible && ...
                                trial.sigma> ...
                                best.sigma+improve_tol

                            improved = true;

                            best = trial;
                            best_r = r_trial;

                        end

                        %% Step 6.9 — 保存本次记录

                        H(trial_count,:) = [ ...
                            trial_count, ...
                            sweep, ...
                            cable_id, ...
                            alpha, ...
                            beta, ...
                            trial.geometry_pass, ...
                            trial.rank_pass, ...
                            trial.min_angle, ...
                            trial.min_cable_distance, ...
                            trial.min_chord, ...
                            trial.sigma, ...
                            double(base_feasible), ...
                            double(track_feasible), ...
                            double(improved)];

                    end

                end

                %% Step 6.10 — 接受该Cable最佳调整

                if norm(best_r-current_r,'fro')>1e-10

                    current_r = best_r;
                    current = best;

                    accepted_changes = ...
                        accepted_changes+1;

                end

            end

        end

        %% Step 7 — 验证优化后的配置

        assert(trial_count==N_per_track);

        assert(current.geometry_pass==189);
        assert(current.rank_pass==189);
        assert(current.clearance_ok);

        assert(current.min_chord>= ...
            spacing_floor-1e-8);

        if track_id==2

            assert(current.min_angle>= ...
                baseline_angle-1e-8);

        end

        % sensing不能比初始基准差
        assert(current.sigma>= ...
            initial.sigma-improve_tol);

        % 所有Attachment仍在原球面
        assert(max(abs( ...
            vecnorm(current_r,2,2)-rb))<1e-8);

        %% Step 8 — 汇总结果

        BaselineSigma(run_id) = initial.sigma;
        FinalSigma(run_id) = current.sigma;

        BaselineAngle_deg(run_id) = ...
            baseline_angle;

        FinalAngle_deg(run_id) = ...
            current.min_angle;

        BaselineDistance_mm(run_id) = ...
            initial.min_cable_distance;

        FinalDistance_mm(run_id) = ...
            current.min_cable_distance;

        BaselineChord_mm(run_id) = ...
            initial.min_chord;

        FinalChord_mm(run_id) = ...
            current.min_chord;

        ImprovementPercent(run_id) = ...
            100*(current.sigma/initial.sigma-1);

        GeometryPass(run_id) = ...
            current.geometry_pass;

        RankPass(run_id) = current.rank_pass;

        TrialCount(run_id) = trial_count;

        AcceptedChanges(run_id) = ...
            accepted_changes;

        %% Step 9 — 保存完整设计

        out = struct();

        out.name = Design(d);
        out.track = track_name;

        out.A_fixed = A;

        out.r_initial = r0;
        out.r_final = current_r;

        out.rail_ids = cfg.rail_ids;
        out.t_fixed = cfg.t_fixed;

        out.pairing_history = ...
            cfg.pairing_history;

        out.spacing_floor_mm = spacing_floor;
        out.baseline_angle_deg = baseline_angle;

        out.initial = initial;
        out.final = current;

        optimised_designs{run_id} = out;

        search_history{run_id} = H;

        fprintf('\nFinal sigma: %.6f\n', ...
            current.sigma);

        fprintf('Improvement: %.2f %%\n', ...
            ImprovementPercent(run_id));

        fprintf('Final outward angle: %.6f deg\n', ...
            current.min_angle);

        fprintf('Final Cable distance: %.4f mm\n', ...
            current.min_cable_distance);

        fprintf('Final Attachment chord: %.4f mm\n', ...
            current.min_chord);

        fprintf('Accepted changes: %d\n', ...
            accepted_changes);

    end

end

%% Step 10 — 创建最终汇总表

T_optimisation = table( ...
    DesignName,TrackName, ...
    BaselineSigma,FinalSigma, ...
    ImprovementPercent, ...
    BaselineAngle_deg,FinalAngle_deg, ...
    BaselineDistance_mm,FinalDistance_mm, ...
    BaselineChord_mm,FinalChord_mm, ...
    GeometryPass,RankPass, ...
    TrialCount,AcceptedChanges);

fprintf('\n====================================\n');
fprintf('E2 Sequential Optimisation Results\n');
fprintf('====================================\n');

disp(T_optimisation);

%% Step 11 — 搜索预算回归检查

assert(run_id==8);

assert(all(TrialCount==192));

assert(sum(TrialCount)==1536);

assert(all(GeometryPass==189));
assert(all(RankPass==189));

assert(all(FinalSigma>= ...
    BaselineSigma-improve_tol));

fprintf('\n--- E2 Summary ---\n');

fprintf('Completed tracks: %d\n',run_id);

fprintf('Total candidate evaluations: %d\n', ...
    sum(TrialCount));

fprintf('PASS: Geometry and Rank verified.\n');

fprintf('PASS: Equal search budget verified.\n');

%% Step 12 — 保存数据

save( ...
    'B5_4_E2_sequential_optimisation.mat', ...
    'T_optimisation', ...
    'optimised_designs', ...
    'search_history', ...
    'protocol','sweep_amplitudes', ...
    'beta_values','clearance_floor');

writetable(T_optimisation, ...
    'B5_4_E2_sequential_optimisation.csv');

fprintf('\nE2 Lesson 2.5 completed.\n');

%% ================================================
% Local Function 1 — Attachment最小弦长
%% ================================================

function dmin = minimum_attachment_chord(r)

    pairs = nchoosek(1:6,2);

    dmin = inf;

    for j = 1:size(pairs,1)

        i = pairs(j,1);
        k = pairs(j,2);

        dmin = min( ...
            dmin,norm(r(i,:)-r(k,:)));

    end

end

%% ================================================
% Local Function 2 — Core Geometry & Sensing
%% ================================================

function g = evaluate_attachment_design( ...
    A,r,P_all,R_all,settings,clearance_floor)

    N = size(P_all,1);

    pairs = settings.cable_pairs;

    geometry_pass = 0;
    rank_pass = 0;

    min_angle = inf;
    min_cable_distance = inf;

    worst_sigma = inf;

    for pose_id = 1:N

        P = P_all(pose_id,:);
        R = R_all(:,:,pose_id);

        % Attachment世界方向和坐标
        S = (R*r')';
        B = S+P;

        % Attachment -> Anchor
        D = A-B;
        L = vecnorm(D,2,2);

        if any(L<=1e-9)
            % 退化Cable视为几何失败
            continue;
        end

        %% Cable–Sphere

        outward_dot = sum(S.*D,2);

        s = outward_dot./(settings.rb*L);

        s = max(-1,min(1,s));

        angle = asind(s);

        min_angle = min( ...
            min_angle,min(angle));

        sphere_ok = all( ...
            outward_dot>=-settings.sphere_tol);

        %% Cable–Cable

        cable_ok = true;

        for j = 1:size(pairs,1)

            i1 = pairs(j,1);
            i2 = pairs(j,2);

            dij = ...
                B3_1_segment_distance_3d_2026_11_02( ...
                B(i1,:),A(i1,:), ...
                B(i2,:),A(i2,:));

            min_cable_distance = min( ...
                min_cable_distance,dij);

            if dij<=settings.contact_tol
                cable_ok = false;
            end

        end

        geometry_ok = sphere_ok && cable_ok;

        if geometry_ok
            geometry_pass = geometry_pass+1;
        end

        %% Scaled Jacobian

        u = D./L;

        H = zeros(6,6);

        for i = 1:6

            H(i,:) = [ ...
                -u(i,:), ...
                cross(u(i,:),S(i,:))];

        end

        Hs = H*settings.H_scale;

        sv = svd(Hs);

        rankH = sum( ...
            sv>settings.rank_relative_tol*sv(1));

        if geometry_ok && rankH==6
            rank_pass = rank_pass+1;
        end

        worst_sigma = min(worst_sigma,sv(end));

    end

    %% Core完整资格

    clearance_ok = ...
        min_cable_distance>= ...
        clearance_floor-1e-8;

    feasible = ...
        geometry_pass==N && ...
        rank_pass==N && ...
        clearance_ok;

    % 计算Attachment最小弦长
    min_chord = minimum_attachment_chord(r);

    % 不合格配置的Sigma不参加排名
    if ~feasible
        worst_sigma = NaN;
    end

    %% 返回结果

    g = struct();

    g.geometry_pass = geometry_pass;
    g.rank_pass = rank_pass;

    g.min_angle = min_angle;

    g.min_cable_distance = ...
        min_cable_distance;

    g.min_chord = min_chord;

    g.clearance_ok = clearance_ok;
    g.feasible = feasible;

    g.sigma = worst_sigma;

end
