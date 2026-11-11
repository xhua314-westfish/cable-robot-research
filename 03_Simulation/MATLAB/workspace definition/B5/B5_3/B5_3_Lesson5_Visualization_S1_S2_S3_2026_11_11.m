%% B5.3 - Final Three-Family Configuration Visualisation
% Selected: Config 2 (S1), Config 12 (S2), Config 17 (S3)
%
% Purpose:
% 1. Compare one Core-eligible configuration from each family.
% 2. Visualise all six cables, anchors A1-A6, attachments B1-B6.
% 3. Show assigned rail ID for each anchor.
% 4. Annotate reference-pose and Core multi-pose metrics separately.
%
% All dimensions in mm. This visualises the reference pose only.
% Core metrics are loaded from B5.3 Lesson 5, NOT calculated from
% the reference-pose figure.
%
% Prerequisites:
% B5_3_initial_six_cable_configurations.mat
% B5_3_early_multipose_screening.mat
% B5_3_12rail_geometry_baseline.mat

clear; clc; close all;

%% Step 1 - Load previously verified configurations/results
load('B5_3_initial_six_cable_configurations.mat', 'best_configs', 'rb');
load('B5_3_early_multipose_screening.mat', 'screening', 'T_results', 'P_all', 'R_all', 'orientation_id');
load('B5_3_12rail_geometry_baseline.mat', 'rail_start', 'rail_end');

selected_ids = [2 12 17];
selected_families = {'S1 - Layered', 'S2 - Distributed', 'S3 - Asymmetric'};
n_cables = 6;
assert(numel(best_configs)==18 && numel(screening)==18);
assert(size(rail_start,1)==12 && size(rail_end,1)==12);

ref_id = find(all(P_all==0,2) & orientation_id==1);
assert(isscalar(ref_id), 'Reference pose must occur exactly once.');

% Only visualise three configurations that passed the SAME Core set
for j = 1:numel(selected_ids)
    c = selected_ids(j);
    assert(best_configs(c).found, 'Selected configuration is not available.');
    assert(sum(screening{c}.geometry_safe)==189, 'Not Core geometry eligible.');
    assert(all(screening{c}.rank_all==6), 'Not full rank over Core.');
    assert(best_configs(c).family_id==j, 'Family/ID correspondence changed.');
end

%% Step 2 - Style shared by all three panels
% Each cable has a stable colour C1...C6 across S1/S2/S3.
cable_colors = lines(6);
frame_color = [0.78 0.81 0.84];
anchor_color = [0.08 0.10 0.13];
balloon_color = [0.60 0.81 0.94];
[Xs,Ys,Zs] = sphere(42);

fig = figure('Color','w', ...
    'Name','B5.3 - S1, S2, S3 Core-Eligible Six-Cable Configurations', ...
    'Position',[60 70 1700 760]);
tl = tiledlayout(fig,1,3,'TileSpacing','compact','Padding','compact');

a = gobjects(3,1);
legend_handles = gobjects(8,1);

%% Step 3 - Plot each selected configuration at P=0, R=I
for j = 1:3
    c = selected_ids(j);
    cfg = best_configs(c);
    g = screening{c};
    A = cfg.A;                    % 6 x 3 anchor coordinates
    r = cfg.r;                    % 6 x 3 body-frame attachment coordinates
    P = P_all(ref_id,:);
    R = R_all(:,:,ref_id);
    B = (R*r')' + P;              % 6 x 3 world attachment coordinates

    a(j) = nexttile(tl,j);
    ax = a(j);
    hold(ax,'on');

    % Reference frame (all 12 rails): thin/light grey
    for rid = 1:12
        e0 = rail_start(rid,:);
        e1 = rail_end(rid,:);
        plot3(ax,[e0(1) e1(1)], [e0(2) e1(2)], [e0(3) e1(3)], ...
            '-', 'Color',frame_color, 'LineWidth',0.9, 'HandleVisibility','off');
    end

    % Light-blue balloon, so the attachment positions remain visible
    surf(ax,rb*Xs+P(1), rb*Ys+P(2), rb*Zs+P(3), ...
        'FaceColor',balloon_color, 'FaceAlpha',0.15, ...
        'EdgeColor','none','HandleVisibility','off');
    plot3(ax,P(1),P(2),P(3),'k+', 'MarkerSize',10,'LineWidth',1.5, ...
        'HandleVisibility','off');
    text(ax,P(1)+5,P(2)+5,P(3)-7,'P', ...
        'Color',anchor_color,'FontSize',10,'FontWeight','bold');

    % Six cables. A_i <--> B_i defines the actual pairing (not permutation index).
    for i = 1:n_cables
        Ai = A(i,:);
        Bi = B(i,:);
        color_i = cable_colors(i,:);
        h = plot3(ax,[Bi(1),Ai(1)], [Bi(2),Ai(2)], [Bi(3),Ai(3)], ...
            '-', 'Color',color_i, 'LineWidth',2.5);
        if j==1
            legend_handles(i) = h;
        else
            h.HandleVisibility = 'off';
        end

        % Anchor: black circle. Attachment: coloured diamond.
        ha = scatter3(ax,Ai(1),Ai(2),Ai(3),45,anchor_color,'o','filled');
        hb = scatter3(ax,Bi(1),Bi(2),Bi(3),54,color_i,'d','filled');
        ha.HandleVisibility='off';
        hb.HandleVisibility='off';
        if j==1 && i==1
            legend_handles(7) = scatter3(ax,NaN,NaN,NaN,45,anchor_color,'o','filled');
            legend_handles(8) = scatter3(ax,NaN,NaN,NaN,54,[0.25 0.40 0.75],'d','filled');
        end

        % Show true installed rail for every anchor
        text(ax,Ai(1)+5,Ai(2)+5,Ai(3)+5, ...
            sprintf('A%d / R%d',i,cfg.rail_ids(i)), ...
            'FontSize',8, 'Color',anchor_color, ...
            'FontWeight','bold', 'BackgroundColor','w','Margin',0.5);
        text(ax,Bi(1)+3,Bi(2)+3,Bi(3)+3,sprintf('B%d',i), ...
            'FontSize',8,'Color',color_i,'FontWeight','bold');

        % Offset cable ID away from attachment/endpoints to reduce overlap
        mid = Bi + 0.60*(Ai-Bi);
        text(ax,mid(1),mid(2),mid(3),sprintf('C%d',i), ...
            'FontSize',9,'FontWeight','bold','Color',color_i, ...
            'BackgroundColor','w','Margin',1);
    end

    % Clearly separate reference and multi-pose values in titles
    dmin_core = min(g.distances(:));
    min_sigma_core = min(g.sigma_min_all(g.geometry_safe));
    max_kappa_core = max(g.kappa_all(g.geometry_safe));
    ref_sigma = cfg.sigma_min;
    geometry_count = sum(g.geometry_safe);

    title(ax,{sprintf('%s | Config %d',selected_families{j},c), ...
        sprintf('Core: %d/189 | min sigma = %.4f | max kappa = %.3f', ...
            geometry_count,min_sigma_core,max_kappa_core), ...
        sprintf('Core min cable distance = %.2f mm | Ref sigma = %.4f', ...
            dmin_core,ref_sigma)}, ...
        'FontSize',11,'FontWeight','bold');

    xlabel(ax,'X - Length (mm)');
    ylabel(ax,'Y - Width (mm)');
    zlabel(ax,'Z - Height (mm)');
    axis(ax,'equal'); grid(ax,'on'); view(ax,36,23);
    xlim(ax,[-165 165]); ylim(ax,[-175 175]); zlim(ax,[-185 185]);
    set(ax,'FontSize',9);
    hold(ax,'off');

    fprintf('\n%s | Config %d\n',selected_families{j},c);
    fprintf('  Core geometry / rank-6: %d/189, %d/189\n', ...
        geometry_count, sum(g.rank_all(g.geometry_safe)==6));
    fprintf('  Worst Core sigma_min: %.6f\n',min_sigma_core);
    fprintf('  Worst Core kappa: %.6f\n',max_kappa_core);
    fprintf('  Minimum Core cable distance: %.4f mm\n',dmin_core);
    fprintf('  Rail assignment: %s\n',mat2str(cfg.rail_ids));
    fprintf('  Pairing: %s\n',mat2str(cfg.pairing));
end

% Place the shared legend below the panels, outside data and titles.
legend_labels = {'Cable 1','Cable 2','Cable 3', ...
    'Cable 4','Cable 5','Cable 6', ...
    'Anchor A_i (black circle)','Attachment B_i (diamond)'};
lgd = legend(a(1),legend_handles,legend_labels, ...
    'Orientation','horizontal','NumColumns',4,'FontSize',9);
lgd.Layout.Tile = 'south';

% Use exportgraphics so saved image includes the whole tiled layout.
exportgraphics(fig, ...
    'B5_3_Selected_S1_S2_S3_Configurations.png', ...
    'Resolution',250);
savefig(fig,'B5_3_Selected_S1_S2_S3_Configurations.fig');

fprintf('\nB5.3 three-family visualisation completed.\n');
fprintf('Saved PNG and editable FIG to the current MATLAB folder.\n');
