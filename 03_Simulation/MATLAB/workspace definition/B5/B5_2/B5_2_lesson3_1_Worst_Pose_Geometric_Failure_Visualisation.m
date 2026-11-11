%% B5.2 Lesson 3.1 - Revised
% Worst-Pose Geometric Failure Visualisation
%
% Research Question:
% Where and how do the detected geometric failures occur?
%
% Objectives:
% 1. Visualise Original B cable 5-6 contact
% 2. Visualise F1 cable-sphere interference
% 3. Clearly label pose position and orientation
% 4. Highlight failed cables only
% 5. Show outward normal and actual cable direction
% 6. Add legend: red means failed
%
% Units: mm

clear; clc; close all;

%% Step 1: Load previous results

load('B5_2_failure_diagnosis.mat', ...
    'diagnosis','geometry_results', ...
    'P_all','R_all','angles_deg', ...
    'orientation_id','cable_pairs', ...
    'sphere_tol','contact_tol');

% 要显示的两个配置：
% 1 = Original B
% 3 = F1 - Six-Face Distributed
config_ids = [1 3];

% 用于画球
[Xs,Ys,Zs] = sphere(60);

% 所有正常cable统一用灰色
normal_cable_color = [0.45 0.45 0.45];

% 失败cable统一用红色
failed_cable_color = [0.90 0.15 0.10];

% Anchor和Attachment标记颜色
anchor_color = [0.10 0.10 0.10];
attachment_color = [0.15 0.35 0.80];

% outward normal 用绿色
normal_vec_color = [0.10 0.65 0.10];

% actual exit direction 用红色虚线箭头
exit_vec_color = [0.90 0.15 0.10];

% body axes 颜色
body_x_color = [0.85 0.20 0.20];
body_y_color = [0.20 0.65 0.20];
body_z_color = [0.20 0.35 0.90];

fig = figure( ...
    'Color','w', ...
    'Name','B5.2 Worst-Pose Diagnosis - Revised', ...
    'Position',[100 100 1550 700]);

%% Step 2: Loop over two selected cases

for m = 1:2

    config_id = config_ids(m);

    g = geometry_results{config_id};
    d = diagnosis{config_id};

    A = g.A;
    r = g.r;

    % 球半径
    rb = mean(vecnorm(r,2,2));

    %% Step 3: Select pose

    if config_id == 1
        % Original B: 显示最坏Cable contact姿态
        pose_id = d.worst_pair_pose;
        plot_title = 'Original B - Cable Contact';
    else
        % F1: 显示最坏Cable-sphere姿态
        pose_id = d.worst_sphere_pose;
        plot_title = 'F1 - Cable-Sphere Interference';
    end

    % 当前球心位置和旋转矩阵
    P = P_all(pose_id,:);
    R = R_all(:,:,pose_id);

    % 当前姿态的欧拉角标签
    current_angles = angles_deg(orientation_id(pose_id),:);

    % attachment向量（球心 -> attachment）
    S = (R*r')';

    % 世界坐标attachment
    B = S + P;

    % cable向量（attachment -> anchor）
    D = A - B;

    % 当前姿态下每根cable的点积
    outward_dot = sum(S.*D,2);

    % 当前姿态下是否有sphere failure
    sphere_failed = outward_dot < -sphere_tol;

    % 当前姿态下15组距离
    pair_distances = g.distances(pose_id,:);

    % 当前姿态下接触的cable pairs
    bad_pair_ids = find(pair_distances <= contact_tol);

    % 需要高亮的cable
    highlighted = sphere_failed;

    for j = bad_pair_ids
        pair = cable_pairs(j,:);
        highlighted(pair) = true;
    end

    %% Step 4: Create subplot

    subplot(1,2,m);
    hold on;

    % 球体
    surf( ...
        rb*Xs + P(1), ...
        rb*Ys + P(2), ...
        rb*Zs + P(3), ...
        'FaceColor',[0.55 0.78 0.95], ...
        'FaceAlpha',0.18, ...
        'EdgeColor','none', ...
        'HandleVisibility','off');

    % 球心 P
    scatter3(P(1),P(2),P(3),120,'k','p','filled', ...
        'HandleVisibility','off');
    text(P(1)+6,P(2)+6,P(3)+6,'P', ...
        'FontSize',11,'FontWeight','bold','Color','k');

    %% Step 5: Draw rotated body axes
    axis_len = 35;

    xb = R(:,1)' * axis_len;
    yb = R(:,2)' * axis_len;
    zb = R(:,3)' * axis_len;

    quiver3(P(1),P(2),P(3),xb(1),xb(2),xb(3),0, ...
        'Color',body_x_color,'LineWidth',2,'MaxHeadSize',0.8, ...
        'HandleVisibility','off');
    quiver3(P(1),P(2),P(3),yb(1),yb(2),yb(3),0, ...
        'Color',body_y_color,'LineWidth',2,'MaxHeadSize',0.8, ...
        'HandleVisibility','off');
    quiver3(P(1),P(2),P(3),zb(1),zb(2),zb(3),0, ...
        'Color',body_z_color,'LineWidth',2,'MaxHeadSize',0.8, ...
        'HandleVisibility','off');

    text(P(1)+xb(1),P(2)+xb(2),P(3)+xb(3),'x_b', ...
        'Color',body_x_color,'FontSize',10,'FontWeight','bold');
    text(P(1)+yb(1),P(2)+yb(2),P(3)+yb(3),'y_b', ...
        'Color',body_y_color,'FontSize',10,'FontWeight','bold');
    text(P(1)+zb(1),P(2)+zb(2),P(3)+zb(3),'z_b', ...
        'Color',body_z_color,'FontSize',10,'FontWeight','bold');

    %% Step 6: Draw cables, anchors, attachments

    for i = 1:6

        Ai = A(i,:);
        Bi = B(i,:);

        if highlighted(i)
            cable_color = failed_cable_color;
            cable_width = 3.5;
            label_color = failed_cable_color;
        else
            cable_color = normal_cable_color;
            cable_width = 2.0;
            label_color = [0.15 0.15 0.15];
        end

        % cable线段
        plot3( ...
            [Ai(1),Bi(1)], ...
            [Ai(2),Bi(2)], ...
            [Ai(3),Bi(3)], ...
            '-', ...
            'Color',cable_color, ...
            'LineWidth',cable_width, ...
            'HandleVisibility','off');

        % Anchor
        scatter3(Ai(1),Ai(2),Ai(3),58,anchor_color,'o','filled', ...
            'HandleVisibility','off');

        % Attachment
        if highlighted(i)
            att_color = failed_cable_color;
        else
            att_color = attachment_color;
        end

        scatter3(Bi(1),Bi(2),Bi(3),60,att_color,'d','filled', ...
            'HandleVisibility','off');

        % Anchor编号
        text(Ai(1)+5,Ai(2)+5,Ai(3)+5, ...
            sprintf('A%d',i), ...
            'FontSize',10, ...
            'FontWeight','bold', ...
            'Color',label_color);

        % Attachment编号
        text(Bi(1)+3,Bi(2)+3,Bi(3)+3, ...
            sprintf('B%d',i), ...
            'FontSize',10, ...
            'Color',label_color);

        % Cable编号（中点）
        mid = (Ai+Bi)/2;
        text(mid(1),mid(2),mid(3), ...
            sprintf('C%d',i), ...
            'FontSize',11, ...
            'FontWeight','bold', ...
            'Color',label_color, ...
            'BackgroundColor','w', ...
            'Margin',1);

        %% Step 7: If cable-sphere failure, draw two direction arrows
        if sphere_failed(i)

            % outward normal方向（attachment -> outward）
            nvec = S(i,:) / norm(S(i,:));

            % cable实际出线方向（attachment -> anchor）
            dvec = D(i,:) / norm(D(i,:));

            arrow_len = 28;

            % outward normal：绿色箭头
            quiver3(Bi(1),Bi(2),Bi(3), ...
                arrow_len*nvec(1), ...
                arrow_len*nvec(2), ...
                arrow_len*nvec(3), ...
                0, ...
                'Color',normal_vec_color, ...
                'LineWidth',2.2, ...
                'MaxHeadSize',0.8, ...
                'HandleVisibility','off');

            % actual cable exit direction：红色箭头
            quiver3(Bi(1),Bi(2),Bi(3), ...
                arrow_len*dvec(1), ...
                arrow_len*dvec(2), ...
                arrow_len*dvec(3), ...
                0, ...
                'Color',exit_vec_color, ...
                'LineStyle','--', ...
                'LineWidth',2.2, ...
                'MaxHeadSize',0.8, ...
                'HandleVisibility','off');

            % 标注g_i
            text(Bi(1)+8,Bi(2)-8,Bi(3)+8, ...
                sprintf('g_%d=%.1f',i,outward_dot(i)), ...
                'Color',failed_cable_color, ...
                'FontSize',9, ...
                'FontWeight','bold');
        end
    end

    %% Step 8: Show additional failure info inside the plot

    info_text = {
        sprintf('Pose ID: %d',pose_id)
        sprintf('P = [%g, %g, %g] mm',P(1),P(2),P(3))
        sprintf('[roll pitch yaw] = [%g, %g, %g] deg', ...
            current_angles(1),current_angles(2),current_angles(3))
        };

    if config_id == 1
        info_text{end+1} = 'Failure: Cable-Cable contact';
        info_text{end+1} = 'Failed pair: C5-C6';
    else
        failed_ids = find(sphere_failed);
        info_text{end+1} = 'Failure: Cable-Sphere interference';
        info_text{end+1} = sprintf('Failed cable(s): %s',mat2str(failed_ids));
    end

    


    % 在图内放置文本框
    text(-400,120,70,info_text, ...
        'FontSize',10, ...
        'BackgroundColor','w', ...
        'EdgeColor',[0.6 0.6 0.6], ...
        'Margin',6);

    %% Step 9: Axis settings

    title(plot_title,'FontSize',14,'FontWeight','bold');

    xlabel('X - Length (mm)');
    ylabel('Y - Width (mm)');
    zlabel('Z - Height (mm)');

    axis equal;
    grid on;
    view(35,25);

    xlim([-160 160]);
    ylim([-170 170]);
    zlim([-180 180]);

    set(gca,'FontSize',10);

    hold off;
end

%% Step 10: Add legend (figure-level meaning)

subplot(1,2,1);
hold on;

h1 = plot3(NaN,NaN,NaN,'-','Color',normal_cable_color,'LineWidth',2);
h2 = plot3(NaN,NaN,NaN,'-','Color',failed_cable_color,'LineWidth',3.5);
h3 = scatter3(NaN,NaN,NaN,120,'k','p','filled');
h4 = plot3(NaN,NaN,NaN,'-','Color',normal_vec_color,'LineWidth',2.2);
h5 = plot3(NaN,NaN,NaN,'--','Color',exit_vec_color,'LineWidth',2.2);

legend([h1,h2,h3,h4,h5], ...
    {'Normal cable','Failed cable (red)','Balloon centre P', ...
     'Outward normal','Actual cable exit direction'}, ...
    'Location','southoutside', ...
    'FontSize',9);

hold off;

%% Step 11: Print summary in Command Window

for m = 1:2

    config_id = config_ids(m);
    d = diagnosis{config_id};
    g = geometry_results{config_id};

    if config_id == 1
        pose_id = d.worst_pair_pose;
        fprintf('\n--- Original B - Cable Contact ---\n');
    else
        pose_id = d.worst_sphere_pose;
        fprintf('\n--- F1 - Cable-Sphere Interference ---\n');
    end

    P = P_all(pose_id,:);
    R = R_all(:,:,pose_id);
    S = (R*g.r')';
    B = S + P;
    D = g.A - B;

    outward_dot = sum(S.*D,2);
    sphere_failed = outward_dot < -sphere_tol;

    pair_distances = g.distances(pose_id,:);
    bad_pair_ids = find(pair_distances <= contact_tol);

    fprintf('Pose index: %d\n',pose_id);
    fprintf('Position [mm]: [%g %g %g]\n',P(1),P(2),P(3));
    fprintf('Orientation [roll pitch yaw] [deg]: [%g %g %g]\n', ...
        angles_deg(orientation_id(pose_id),1), ...
        angles_deg(orientation_id(pose_id),2), ...
        angles_deg(orientation_id(pose_id),3));

    fprintf('Failed sphere cables: ');
    fprintf('%d ',find(sphere_failed));
    fprintf('\n');

    fprintf('Contact cable pairs:\n');
    for j = bad_pair_ids
        pair = cable_pairs(j,:);
        fprintf('Cable %d - Cable %d: %.8f mm\n', ...
            pair(1),pair(2),pair_distances(j));
    end
end

%% Step 12: Save figure

exportgraphics(fig, ...
    'B5_2_worst_pose_comparison_revised.png', ...
    'Resolution',300);

fprintf('\nRevised worst-pose visualisation completed.\n');
fprintf('Figure saved: B5_2_worst_pose_comparison_revised.png\n');