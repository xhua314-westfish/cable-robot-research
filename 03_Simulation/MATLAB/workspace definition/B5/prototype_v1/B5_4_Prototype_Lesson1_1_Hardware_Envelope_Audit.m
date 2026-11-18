%% Prototype V1 - Lesson 1.1
% Hardware Envelope and Cable Stroke Audit (NO component assumptions)
%
% Four frozen, actual E2 designs:
% 1) C2-2 Repaired M
% 2) C4-1 E2 M
% 3) C8-16 E2 M
% 4) C12 E2 M
%
% Reports actual geometry in saved .mat:
%  - A_i's along-rail position t_i and distance to rail ends
%  - 15 Attachment pair distances (minimum per design)
%  - center-to-center cable lengths on all 539 development poses
%  - cable stroke = max L - min L (development set only)
%  - theoretical spool turns for illustrative effective radii
%
% IMPORTANT:
%  * 539 development poses are NOT a continuous-workspace guarantee.
%  * L = norm(A - B) is the in-workspace segment only. External routing,
%    guide pulleys, fixed lead length and wrap are NOT included.
%  * Illustrative spool radii are NOT selected motor/reel models.
%  * Geometry and installation envelope are not yet mechanically approved.
%
% Put this file in the B5_4 working folder and run it.
clear; clc; close all;

%% 1. Files and configuration sources
assert(isfile('B5_4_E2_539pose_verification.mat'), ...
    'Missing B5_4_E2_539pose_verification.mat');
assert(isfile('B5_4_E2_C2_C4_targeted_repair.mat'), ...
    'Missing B5_4_E2_C2_C4_targeted_repair.mat');
assert(isfile('B5_4_E2_sequential_optimisation.mat'), ...
    'Missing B5_4_E2_sequential_optimisation.mat');

v = load('B5_4_E2_539pose_verification.mat');
rep = load('B5_4_E2_C2_C4_targeted_repair.mat');
e2 = load('B5_4_E2_sequential_optimisation.mat');

rail_file = 'B5_3_12rail_geometry_baseline.mat';
if ~isfile(rail_file)
    rail_file = fullfile(fileparts(pwd),'B5_3',rail_file);
end
assert(isfile(rail_file),'Cannot locate B5_3 rail geometry.');
rails = load(rail_file,'rail_start','rail_end');
rail_start = rails.rail_start;
rail_end = rails.rail_end;
assert(isequal(size(rail_start),[12 3]));
assert(isequal(size(rail_end),[12 3]));

P_all = v.P_eval;
R_all = v.R_eval;
assert(isequal(size(P_all),[539 3]));
assert(isequal(size(R_all),[3 3 539]));

names = ["C2-2 Repaired M"; "C4-1 E2 M"; ...
         "C8-16 E2 M"; "C12 E2 M"];
source_design = ["E1b C2-2";"E1b C4-1";"E1b C8-16";"E1a C12"];
N = 4;

%% 2. Load the exact final A, r; recover rail IDs from E2 source
C = cell(N,1);
for d = 1:N
    idx_meta = find(string(e2.T_optimisation.DesignName) == source_design(d) & ...
        string(e2.T_optimisation.TrackName) == "MarginPreservingSensing");
    assert(numel(idx_meta)==1,'Expected unique Track M metadata for %s',names(d));
    meta = e2.optimised_designs{idx_meta};
    assert(isfield(meta,'rail_ids'),'Missing rail_ids for %s',names(d));

    if d==1
        assert(numel(rep.repaired_designs)>=2);
        rr = rep.repaired_designs{2};
        assert(rr.best_found && string(rr.track)=="MarginPreservingSensing");
        A = rr.A_fixed;
        r = rr.r_repaired;
    else
        idx = find(string(v.T_verification.Design)==source_design(d) & ...
            string(v.T_verification.Track)=="MarginPreservingSensing");
        assert(numel(idx)==1,'Missing unique E2 verification design for %s',names(d));
        assert(v.T_verification.FullEligible(idx), ...
            'Chosen E2 design not 539-development-eligible: %s',names(d));
        A = v.designs{idx}.A;
        r = v.designs{idx}.r;
    end
    assert(isequal(size(A),[6 3]) && isequal(size(r),[6 3]));
    assert(norm(A-meta.A_fixed,'fro')<1e-7,'Anchor mismatch: %s',names(d));
    C{d} = struct('name',names(d),'A',A,'r',r, ...
        'rail_ids',meta.rail_ids(:));
end

%% 3. Audit the anchors and all pairwise attachment separations
anchor_name = strings(24,1); cable_id=zeros(24,1); rail_id=zeros(24,1);
rail_t=nan(24,1); end_clearance=nan(24,1); rail_length=nan(24,1);
A_X=nan(24,1); A_Y=nan(24,1); A_Z=nan(24,1);
pair_design = strings(60,1); pair_c1=zeros(60,1); pair_c2=zeros(60,1);
chord_mm=nan(60,1);

for d=1:N
    cfg=C{d};
    for i=1:6
        k=(d-1)*6+i;
        rid=cfg.rail_ids(i);
        assert(rid>=1 && rid<=12 && rid==floor(rid));
        S=rail_start(rid,:); E=rail_end(rid,:); ray=E-S;
        t=dot(cfg.A(i,:)-S,ray)/dot(ray,ray);
        A_rebuilt=S+t*ray;
        assert(norm(A_rebuilt-cfg.A(i,:))<1e-6, ...
            'Anchor not on assigned rail in design %s, cable C%d',names(d),i);
        assert(t>=-1e-8 && t<=1+1e-8, ...
            'Anchor outside physical rail %d in %s C%d',rid,names(d),i);
        rail_len=norm(ray);
        anchor_name(k)=names(d); cable_id(k)=i; rail_id(k)=rid;
        rail_t(k)=t; rail_length(k)=rail_len;
        end_clearance(k)=min(max(t,0),max(1-t,0))*rail_len;
        A_X(k)=cfg.A(i,1); A_Y(k)=cfg.A(i,2); A_Z(k)=cfg.A(i,3);
    end
    pp=nchoosek(1:6,2);
    for j=1:size(pp,1)
        k=(d-1)*15+j;
        pair_design(k)=names(d); pair_c1(k)=pp(j,1);
        pair_c2(k)=pp(j,2);
        chord_mm(k)=norm(cfg.r(pp(j,1),:)-cfg.r(pp(j,2),:));
    end
end

T_anchor=table(anchor_name,cable_id,rail_id,rail_t,rail_length,...
    end_clearance,A_X,A_Y,A_Z, ...
    'VariableNames',{'Design','CableID','RailID','t','RailLength_mm', ...
    'MinDistanceToRailEnd_mm','AX_mm','AY_mm','AZ_mm'});
T_attachment=table(pair_design,pair_c1,pair_c2,chord_mm,...
    'VariableNames',{'Design','CableA','CableB','AttachmentChord_mm'});

%% 4. Evaluate lengths per cable on all saved 539 poses
% Illustrative spool effective radii only; NOT procurement specs.
spool_radii_mm=[10 15 20];
Design=strings(24,1); CableID=zeros(24,1); Lmin=nan(24,1);
Lmax=nan(24,1); Lref=nan(24,1); Stroke=nan(24,1);
Turns_R10=nan(24,1);Turns_R15=nan(24,1);Turns_R20=nan(24,1);
all_lengths = cell(N,1);
for d=1:N
    cfg=C{d};
    L=zeros(539,6);
    for p=1:539
        % Body-frame attachments rotated into world frame
        B=(R_all(:,:,p)*cfg.r')'+P_all(p,:);
        L(p,:)=vecnorm(cfg.A-B,2,2)';
    end
    assert(all(L(:)>0),'Non-positive cable length');
    all_lengths{d}=L;
    B_ref=cfg.r;  % Reference pose P=0, R=I
    L_ref=vecnorm(cfg.A-B_ref,2,2);
    for i=1:6
        k=(d-1)*6+i;
        Design(k)=names(d);CableID(k)=i;
        Lmin(k)=min(L(:,i)); Lmax(k)=max(L(:,i));
        Lref(k)=L_ref(i);
        Stroke(k)=Lmax(k)-Lmin(k);
        Turns_R10(k)=Stroke(k)/(2*pi*spool_radii_mm(1));
        Turns_R15(k)=Stroke(k)/(2*pi*spool_radii_mm(2));
        Turns_R20(k)=Stroke(k)/(2*pi*spool_radii_mm(3));
    end
end
T_cable=table(Design,CableID,Lref,Lmin,Lmax,Stroke,...
    Turns_R10,Turns_R15,Turns_R20, ...
    'VariableNames',{'Design','CableID','ReferenceLength_mm', ...
    'DevMinLength_mm','DevMaxLength_mm','DevStroke_mm', ...
    'TurnsIfReelR10','TurnsIfReelR15','TurnsIfReelR20'});

%% 5. Design-level engineering decision summary
DesignName=names;
MinRailEnd_mm=nan(N,1);ClosestAnchorCable=zeros(N,1);
MinAttachmentChord_mm=nan(N,1);ClosestAttachmentPair=strings(N,1);
MaxStroke_mm=nan(N,1);MaxStrokeCable=zeros(N,1);
MaxAbsoluteLength_mm=nan(N,1);
for d=1:N
    ia=(d-1)*6+(1:6); ip=(d-1)*15+(1:15);
    [MinRailEnd_mm(d),ix]=min(end_clearance(ia));
    ClosestAnchorCable(d)=ix;
    [MinAttachmentChord_mm(d),jx]=min(chord_mm(ip));
    ClosestAttachmentPair(d)=sprintf('C%d-C%d', ...
        pair_c1(ip(jx)),pair_c2(ip(jx)));
    [MaxStroke_mm(d),kx]=max(Stroke(ia));
    MaxStrokeCable(d)=kx;
    MaxAbsoluteLength_mm(d)=max(Lmax(ia));
end
T_summary=table(DesignName,MinRailEnd_mm,ClosestAnchorCable, ...
    MinAttachmentChord_mm,ClosestAttachmentPair, ...
    MaxStroke_mm,MaxStrokeCable,MaxAbsoluteLength_mm);

fprintf('\n=== Prototype V1 Hardware Envelope Audit ===\n');
disp(T_summary);
fprintf('\n=== Per-anchor rail-end audit ===\n');
disp(T_anchor(:,{'Design','CableID','RailID','t','MinDistanceToRailEnd_mm'}));
fprintf('\n=== Per-cable development travel ===\n');
disp(T_cable(:,{'Design','CableID','DevMinLength_mm', ...
    'DevMaxLength_mm','DevStroke_mm'}));

%% 6. Figures and outputs
out_dir=fullfile(pwd,'B5_4_Prototype_Hardware_Audit');
if ~isfolder(out_dir);mkdir(out_dir);end
writetable(T_anchor,fullfile(out_dir,'V1_anchor_rail_end_distances.csv'));
writetable(T_attachment,fullfile(out_dir,'V1_attachment_pair_chords.csv'));
writetable(T_cable,fullfile(out_dir,'V1_cable_length_strokes_539.csv'));
writetable(T_summary,fullfile(out_dir,'V1_hardware_envelope_summary.csv'));
save(fullfile(out_dir,'V1_hardware_envelope_audit.mat'), ...
    'T_anchor','T_attachment','T_cable','T_summary','all_lengths', ...
    'names','spool_radii_mm');

fig=figure('Color','w','Name','V1 Cable Stroke and Rail-End Distance', ...
    'Position',[100 100 1200 560]);
tiledlayout(fig,1,2,'Padding','compact','TileSpacing','compact');
nexttile;
bar(reshape(Stroke,6,4));
xticks(1:6);xticklabels(compose('C%d',1:6));
xlabel('Cable');ylabel('Development-set stroke (mm)');
title('Cable length variation across 539 poses');
legend(cellstr(names),'Location','best');grid on;
nexttile;
bar(MinRailEnd_mm);
xticks(1:4);xticklabels(names);xtickangle(15);
ylabel('Nearest rail-end distance (mm)');
title('Minimum available end clearance per design');grid on;
exportgraphics(fig,fullfile(out_dir,'V1_hardware_envelope_comparison.png'), ...
    'Resolution',240);
savefig(fig,fullfile(out_dir,'V1_hardware_envelope_comparison.fig'));

fprintf('\nPASS: Geometry and 539-pose cable travel analysed.\n');
fprintf('Output folder: %s\n',out_dir);
fprintf(['Reminder: Choose hardware only after confirming pulley geometry, ' ...
    'mount footprints, connector dimensions and motor/encoder accuracy.\n']);
