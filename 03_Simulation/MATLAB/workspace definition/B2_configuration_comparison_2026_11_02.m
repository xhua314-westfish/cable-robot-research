
%% B2.2.3 Configuration Comparison
clear; clc; close all;

%% 1. Load geometry and results
load('B1_geometry_baseline.mat','geometry');
load('B2_6cable_experiment_A.mat','config6');
load('B2_experiment_B_results.mat','resultB');

rb = geometry.balloon_radius;
Lg = geometry.Lg;
Wg = geometry.Wg;
Hg = geometry.Hg;

P = [0;0;0];
R = eye(3);

%% 2. Reconstruct original baseline
A0 = [
    140 0 0;
    -140 0 0;
    0 150 0;
    0 -150 0;
    0 0 160;
    0 0 -160
    ];

directions = [
    0  1  1;
    0 -1  1;
    1  0 -1;
    -1  0 -1;
    1  1  0;
    -1 -1  0
    ];

directions = directions ./ vecnorm(directions,2,2);
r_target = rb*directions;

r0 = zeros(6,3);
for i = 1:6
    distance = vecnorm( ...
        geometry.attachment_candidates_body-r_target(i,:),2,2);
    [~,idx] = min(distance);
    r0(i,:) = geometry.attachment_candidates_body(idx,:);
end

%% 3. Store three configurations
A_all = {A0, config6.A, resultB.A};
r_all = {r0, config6.r, resultB.r};

names = {'Baseline','Experiment A','Experiment B'};

%% 4. Sphere geometry
[Xs,Ys,Zs] = sphere(40);

Xs = rb*Xs;
Ys = rb*Ys;
Zs = rb*Zs;

%% 5. Compare 3D configurations
figure('Color','w','Position',[100 100 1500 500]);
tiledlayout(1,3,'Padding','compact');

for k = 1:3
    nexttile;
    hold on;

    A = A_all{k};
    r = r_all{k};

    B = (R*r.'+P).';

    % Gastric boundary edges
    hx = Lg/2; hy = Wg/2; hz = Hg/2;

    V = [
        -hx -hy -hz;
        hx -hy -hz;
        hx  hy -hz;
        -hx  hy -hz;
        -hx -hy  hz;
        hx -hy  hz;
        hx  hy  hz;
        -hx  hy  hz
        ];

    E = [
        1 2;2 3;3 4;4 1;
        5 6;6 7;7 8;8 5;
        1 5;2 6;3 7;4 8
        ];

    for e = 1:size(E,1)
        ids = E(e,:);
        plot3(V(ids,1),V(ids,2),V(ids,3), ...
            'k-','LineWidth',0.8);
    end

    surf(Xs,Ys,Zs, ...
        'FaceColor',[0.25 0.55 0.9], ...
        'FaceAlpha',0.22, ...
        'EdgeColor','none');

    % Draw six cables
    for i = 1:6
        plot3([A(i,1),B(i,1)], ...
            [A(i,2),B(i,2)], ...
            [A(i,3),B(i,3)], ...
            'Color',[0.35 0.35 0.35], ...
            'LineWidth',1.6);
    end

    scatter3(A(:,1),A(:,2),A(:,3), ...
        48,[0.95 0.4 0.1],'filled');

    scatter3(B(:,1),B(:,2),B(:,3), ...
        45,[0.1 0.65 0.3],'filled');

    title(names{k});
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    axis equal;
    xlim([-140 140]);
    ylim([-150 150]);
    zlim([-160 160]);
    view(35,25);
    grid on;
end

sgtitle('B2.2: Six-Cable Configuration Comparison');