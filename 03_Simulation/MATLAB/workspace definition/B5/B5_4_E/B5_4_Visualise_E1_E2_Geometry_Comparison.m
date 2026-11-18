%% B5.4 - Four families, three real historical stages (FIXED)
% MATLAB native interactive 3D: 4 windows, 3 INDEPENDENT axes each.
% Based on B2.2.3 plot3/surf/scatter3 style.
% Important: Stage 1 is read from ORIGINAL B5.3 MAT, not rounded manual coordinates.
% Stage 2: C2/C4/C8 from E1b; C12 from E1a (actual parent of E2 C12).
% Stage 3: E2 MarginPreservingSensing; C2 uses repaired M.
% No re-optimisation, no invented placeholders.
% Run from B5_4 directory containing B5_4_*.mat.

clear; clc; close all;
workdir = pwd;

%% 1) Load verified historical files
original_path = fullfile(fileparts(workdir),'B5_3', ...
    'B5_3_initial_six_cable_configurations.mat');
if ~isfile(original_path)
    original_path = fullfile(workdir, ...
        'B5_3_initial_six_cable_configurations.mat');
end
assert(isfile(original_path), 'Missing original B5.3 configuration MAT.');
orig = load(original_path,'best_configs','rb');

unified = load('B5_4_unified_evaluation_baseline.mat', ...
    'settings','new_results');
e1a = load('B5_4_E1a_B_fair_sequential_results.mat','results');
e1b = load('B5_4_E1b_position_reoptimisation.mat', ...
    'T_optimisation','optimised_candidates');
verify = load('B5_4_E2_539pose_verification.mat', ...
    'T_verification','designs');
repair = load('B5_4_E2_C2_C4_targeted_repair.mat', ...
    'repaired_designs','T_diagnosis');
rb = unified.settings.rb;
assert(abs(rb-orig.rb)<1e-8, 'Balloon radius mismatch.');

%% 2) Build four traceable three-stage lineages
ids = [2 4 8 12];
candidate_ids = [2 1 16 NaN];
families = cell(4,3);
for f = 1:4
    id = ids(f);
    src = orig.best_configs(id);
    assert(src.found, 'Original C%d not found.', id);
    families{f,1} = stage_from_source( ...
        src.A,src.r,src.rail_ids,sprintf('C%d',id), ...
        'Original B5.3 configuration','Core 189',NaN,NaN);
    % original Core score and cable gap from saved unified evaluation
    old_metrics = unified.new_results{id};
    families{f,1}.sigma = min(old_metrics.sigma_min_all);
    families{f,1}.gap = min(old_metrics.distances(:));

    if id == 12
        % IMPORTANT: E2 C12 is descended from E1a C12, NOT E1b C12-40.
        idx = find([e1a.results.config_id]==12);
        assert(numel(idx)==1);
        d = e1a.results(idx);
        A2=d.A_optimised; r2=d.r; rails2=d.rail_ids;
        stage2_name='E1a C12';
        verify_name='E1a C12';
    else
        idx = find(e1b.T_optimisation.ConfigID==id & ...
            e1b.T_optimisation.CandidateID==candidate_ids(f));
        assert(numel(idx)==1,'Missing E1b C%d/%d.',id,candidate_ids(f));
        d=e1b.optimised_candidates{idx};
        A2=d.A_final; r2=d.r; rails2=d.rail_ids;
        stage2_name=sprintf('E1b C%d-%d',id,candidate_ids(f));
        verify_name=stage2_name;
    end
    row2 = find(string(verify.T_verification.Design)==string(verify_name) & ...
        string(verify.T_verification.Track)=="Baseline");
    assert(numel(row2)==1, 'Missing stage 2 verification for C%d.',id);
    families{f,2}=stage_from_source(A2,r2,rails2,stage2_name, ...
        'Anchor-only optimisation','Development 539', ...
        verify.T_verification.Worst539Sigma(row2), ...
        verify.T_verification.MinCableDistance_mm(row2));

    if id==2
        % This repair was generated from the E1b C2-2 configuration.
        match=find(cellfun(@(s) isstruct(s) && ...
            string(s.track)=="MarginPreservingSensing",repair.repaired_designs));
        assert(numel(match)==1);
        r3data=repair.repaired_designs{match};
        assert(r3data.best_found);
        A3=r3data.A_fixed;
        r3=r3data.r_repaired;
        name3='E2 C2-2 Repaired M';
        sigma3=r3data.best_sigma;
        % Derive the documented minimum gap from the winning repair row
        rr=repair.T_diagnosis;
        candidates=find(string(rr.Track)=="MarginPreservingSensing" & ...
            rr.FullEligible & abs(rr.Worst539Sigma-sigma3)<1e-7);
        assert(~isempty(candidates),'Cannot trace repaired C2-2 gap.');
        gap3=rr.MinCableDistance_mm(candidates(1));
    else
        row3=find(string(verify.T_verification.Design)==string(verify_name) & ...
            string(verify.T_verification.Track)=="MarginPreservingSensing");
        assert(numel(row3)==1,'Missing stage 3 verification C%d.',id);
        stage3data=verify.designs{row3};
        A3=stage3data.A;
        r3=stage3data.r;
        name3=sprintf('E2 %s M',regexprep(stage2_name,'^E1[ab] ',''));
        sigma3=verify.T_verification.Worst539Sigma(row3);
        gap3=verify.T_verification.MinCableDistance_mm(row3);
        assert(norm(stage3data.r_baseline-r2,'fro')<1e-8, ...
            'C%d stage 2-to-stage 3 attachment lineage mismatch.',id);
    end
    families{f,3}=stage_from_source(A3,r3,rails2,name3, ...
        'Attachment-only optimisation','Development 539',sigma3,gap3);

    % Strict lineage checks: stage1 -> stage2 fixes attachments;
    % stage2 -> stage3 fixes anchors. Never silently plot unrelated branches.
    assert(norm(families{f,1}.r-families{f,2}.r,'fro')<1e-8, ...
        'C%d: stages 1 and 2 do not keep attachment points fixed.',id);
    assert(norm(families{f,2}.A-families{f,3}.A,'fro')<1e-8, ...
        'C%d: stages 2 and 3 do not keep anchors fixed.',id);
    for s=1:3
        assert(all(size(families{f,s}.A)==[6 3]));
        assert(all(size(families{f,s}.r)==[6 3]));
        assert(max(abs(vecnorm(families{f,s}.r,2,2)-rb))<1e-7);
    end
end

%% 3) Render four independent MATLAB figures
% Layout fix:
%  - Each axes has a dedicated equal-width rectangle (no tiledlayout overflow).
%  - The 3D model is zoomed OUT inside that rectangle.
%  - Titles have their own top band and never overlap the plots.
%  - All cameras remain independent: NO linkprop / linkaxes.
[Xs,Ys,Zs]=sphere(40);
colors = [0.00 0.42 0.90;0.96 0.37 0.09;0.92 0.64 0.04; ...
          0.55 0.14 0.85;0.12 0.66 0.25;0.00 0.70 0.81];
output_dir=fullfile(workdir,'B5_4_Three_Stage_Visualisation');
if ~exist(output_dir,'dir'), mkdir(output_dir); end

% Figure layout, all values are normalized fractions.
left_margin=0.025;
right_margin=0.025;
column_gap=0.025;
column_width=(1-left_margin-right_margin-2*column_gap)/3;
axis_bottom=0.115;
axis_height=0.715;

for f=1:4
    fig=figure('Color','w', ...
        'Name',sprintf('C%d | Three-stage geometry',ids(f)), ...
        'NumberTitle','off', ...
        'Position',[55+25*f 65+20*f 1800 750], ...
        'ToolBar','figure','MenuBar','figure', ...
        'Renderer','opengl');

    % Separate headline band; axes titles do not compete with it.
    annotation(fig,'textbox',[0.04 0.945 0.92 0.04], ...
        'String',sprintf('C%d  |  Original  >  Anchor-only  >  Attachment-only',ids(f)), ...
        'EdgeColor','none','HorizontalAlignment','center', ...
        'FontSize',16,'FontWeight','bold','Interpreter','none');

    for s=1:3
        left=left_margin+(s-1)*(column_width+column_gap);
        ax=axes('Parent',fig, ...
            'Units','normalized', ...
            'Position',[left axis_bottom column_width axis_height]);
        hold(ax,'on');
        c=families{f,s};

        % B2.2.3 style: frame, sphere, six color-coded cables.
        draw_frame(ax,140,150,160);
        surf(ax,rb*Xs,rb*Ys,rb*Zs, ...
            'FaceColor',[.25 .55 .90],'FaceAlpha',.22, ...
            'EdgeColor','none','HitTest','off');
        for i=1:6
            h=plot3(ax,[c.A(i,1) c.r(i,1)], ...
                [c.A(i,2) c.r(i,2)],[c.A(i,3) c.r(i,3)], ...
                'Color',colors(i,:),'LineWidth',2.0);
            h.UserData=struct('Type','Cable','ID',i,'Version',c.version, ...
                'A',c.A(i,:),'B',c.r(i,:), ...
                'Length',norm(c.A(i,:)-c.r(i,:)));
            t=.43+.06*mod(i,3);
            q=(1-t)*c.r(i,:)+t*c.A(i,:);
            text(ax,q(1),q(2),q(3),sprintf('C%d',i), ...
                'FontSize',9,'FontWeight','bold', ...
                'Color',colors(i,:),'BackgroundColor','w', ...
                'HitTest','off');
            hA=plot3(ax,c.A(i,1),c.A(i,2),c.A(i,3),'o', ...
                'MarkerSize',7,'MarkerFaceColor',[.95 .4 .1], ...
                'MarkerEdgeColor','k','LineStyle','none');
            hA.UserData=struct('Type','Anchor','ID',i, ...
                'Version',c.version,'RailID',c.rail_ids(i), ...
                'Coord',c.A(i,:));
            hB=plot3(ax,c.r(i,1),c.r(i,2),c.r(i,3),'d', ...
                'MarkerSize',7,'MarkerFaceColor',[.1 .65 .3], ...
                'MarkerEdgeColor','k','LineStyle','none');
            hB.UserData=struct('Type','Attachment','ID',i, ...
                'Version',c.version,'Coord',c.r(i,:));
            text(ax,c.A(i,1)+3,c.A(i,2)+3,c.A(i,3)+3, ...
                sprintf('A%d/R%d',i,c.rail_ids(i)), ...
                'FontSize',8,'FontWeight','bold','HitTest','off');
            text(ax,c.r(i,1)+3,c.r(i,2)+3,c.r(i,3)+3, ...
                sprintf('B%d',i),'FontSize',8,'Color',[0 .4 .1], ...
                'FontWeight','bold','HitTest','off');
        end
        plot3(ax,0,0,0,'k+','MarkerSize',10,'LineWidth',1.5, ...
            'HitTest','off');

        % Each stage's title remains inside its own reserved panel.
        title(ax,{c.version,c.stage, ...
            sprintf('%s: sigma=%.4f, gap=%.2f mm', ...
            c.metric_scope,c.sigma,c.gap)}, ...
            'FontSize',10,'FontWeight','normal', ...
            'Interpreter','none');
        xlabel(ax,'X (mm)'); ylabel(ax,'Y (mm)'); zlabel(ax,'Z (mm)');

        % Expand the numeric axes around the actual 280x300x320 mm frame.
        % This is VIEW PADDING only and does not change geometry.
        axis(ax,'equal');
        xlim(ax,[-210 210]);
        ylim(ax,[-225 225]);
        zlim(ax,[-240 240]);
        view(ax,35,25);
        axis(ax,'vis3d');
        grid(ax,'on'); box(ax,'on');
        set(ax,'Projection','orthographic','FontSize',9, ...
            'Clipping','on');

        % Critical: zoom OUT in camera space while preserving axis equality.
        % Compared with old layout, each complete frame fits inside its
        % one-third panel and remains independently rotatable/zoomable.
        camzoom(ax,0.85);
        hold(ax,'off');
    end

    % Native MATLAB interactive modes, cameras are NOT linked.
    dc=datacursormode(fig); dc.Enable='off';
    dc.SnapToDataVertex='on'; dc.DisplayStyle='datatip';
    dc.UpdateFcn=@custom_datatip;
    rotate3d(fig,'on');
    drawnow;

    savefig(fig,fullfile(output_dir, ...
        sprintf('C%d_three_stages.fig',ids(f))));
    exportgraphics(fig,fullfile(output_dir, ...
        sprintf('C%d_three_stages.png',ids(f))), ...
        'Resolution',220);
end
fprintf('\nPASS: Four windows, three separated and independently interactive 3D plots.\n');
fprintf('Saved to: %s\n',output_dir);

%% ---------- Local functions ----------
function c=stage_from_source(A,r,rail_ids,version,stage,scope,sigma,gap)
    c=struct('A',A,'r',r,'rail_ids',rail_ids(:)', ...
        'version',char(version),'stage',char(stage), ...
        'metric_scope',char(scope),'sigma',sigma,'gap',gap);
end

function draw_frame(ax,hx,hy,hz)
    V=[-hx -hy -hz;hx -hy -hz;hx hy -hz;-hx hy -hz; ...
        -hx -hy hz;hx -hy hz;hx hy hz;-hx hy hz];
    E=[1 2;2 3;3 4;4 1;5 6;6 7;7 8;8 5;1 5;2 6;3 7;4 8];
    for k=1:12
        h=plot3(ax,V(E(k,:),1),V(E(k,:),2),V(E(k,:),3), ...
            'k-','LineWidth',.8);
        h.HitTest='off';
    end
end

function txt=custom_datatip(~,event)
    p=event.Position;
    target=event.Target;
    txt={sprintf('X: %.4f mm',p(1)),sprintf('Y: %.4f mm',p(2)), ...
        sprintf('Z: %.4f mm',p(3))};
    if ~isprop(target,'UserData'),return;end
    u=target.UserData;
    if ~isstruct(u) || ~isfield(u,'Type'),return;end
    switch u.Type
        case 'Anchor'
            txt=[{sprintf('Anchor A%d | R%d',u.ID,u.RailID)}, ...
                {sprintf('Version: %s',u.Version)}, ...
                {sprintf('X: %.4f mm',u.Coord(1))}, ...
                {sprintf('Y: %.4f mm',u.Coord(2))}, ...
                {sprintf('Z: %.4f mm',u.Coord(3))}];
        case 'Attachment'
            txt=[{sprintf('Attachment B%d',u.ID)}, ...
                {sprintf('Version: %s',u.Version)}, ...
                {sprintf('X: %.4f mm',u.Coord(1))}, ...
                {sprintf('Y: %.4f mm',u.Coord(2))}, ...
                {sprintf('Z: %.4f mm',u.Coord(3))}];
        case 'Cable'
            txt=[{sprintf('Cable C%d | %s',u.ID,u.Version)}, ...
                {sprintf('Click X/Y/Z: %.2f, %.2f, %.2f mm',p)}, ...
                {sprintf('Length: %.4f mm',u.Length)}, ...
                {sprintf('A: [%.2f %.2f %.2f]',u.A)}, ...
                {sprintf('B: [%.2f %.2f %.2f]',u.B)}];
    end
end
