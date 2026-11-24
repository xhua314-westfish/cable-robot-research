function plot_C4_1_35mm()
% C4-1 selected configuration. All coordinates in mm, P = 0 and R = I.
A = [-140 -150 -138.666667; 105 150 -160; 7.777778 -150 160;
     -28 150 160; 140 -150 76.444444; -140 150 -131.555556];
B = [10.121012 -36.235726 -34.174267; -4.021046 38.219193 -33.263610;
     35.686490 -6.538763 35.595818; -17.795663 1.582216 47.583130;
     33.744269 -37.876707 -3.165848; -14.675664 47.367023 11.150485];
Aold = [140 150 -160];
Bold = [-2.0004 34.8994 -36.8968]; % Original B2 as printed by MATLAB
rb = mean(vecnorm(B,2,2));
assert(max(abs(vecnorm(B,2,2)-rb)) < 1e-5);
assert(abs(norm(A(2,:)-Aold)-35) < 1e-6);
assert(abs(norm(B(2,:)-Bold)-5.3201) < 1e-4);

fig = figure('Color','w','Name','C4-1 / 35 mm','Position',[80 80 1200 700]);
layout = tiledlayout(fig,2,3,'TileSpacing','compact','Padding','compact');
ax = nexttile(layout,1,[2 2]);
hold(ax,'on');
% Connect vertices differing in exactly one coordinate to obtain 12 rails.
[x,y,z] = ndgrid([-140 140],[-150 150],[-160 160]);
V = [x(:),y(:),z(:)];
for i = 1:8
    for j = i+1:8
        if nnz(V(i,:) ~= V(j,:)) == 1
            segment(ax,V(i,:),V(j,:),[.68 .70 .72],1);
        end
    end
end
[x,y,z] = sphere(64);
surf(ax,rb*x,rb*y,rb*z,'EdgeColor','none','FaceColor',[.46 .77 .85], ...
    'FaceAlpha',.25);
colors = lines(6);
colors(2,:) = [.83 .22 .04];
for i = 1:6
    col = colors(i,:);
    segment(ax,A(i,:),B(i,:),col,1.6+(i==2));
    mark(ax,A(i,:),'s',col);
    mark(ax,B(i,:),'o',col);
    label(ax,.95*A(i,:),sprintf('A%d',i),col);
    label(ax,1.12*B(i,:),sprintf('B%d',i),col);
    label(ax,.55*A(i,:)+.45*B(i,:),sprintf('C%d',i),col);
end
formatAxes(ax);
title(ax,{'C4-1 | 35 mm setback','Reference pose: P = [0 0 0] mm, roll / pitch / yaw = 0 deg'});
view(ax,38,23);
g1 = plot3(ax,NaN,NaN,NaN,'ks','MarkerFaceColor','k');
g2 = plot3(ax,NaN,NaN,NaN,'ko','MarkerFaceColor','k');
legend(ax,[g1 g2],{'Frame anchor','Balloon attachment'},'Location','northwest');

% Detail 1: actual Rail 6 direction, with a short part of each cable.
ar = nexttile(layout,3);
hold(ar,'on');
segment(ar,[90 150 -160],Aold,[.65 .67 .69],4);
segment(ar,Aold,Aold+.12*(Bold-Aold),[.45 .45 .45],1.5,'--');
segment(ar,A(2,:),A(2,:)+.12*(B(2,:)-A(2,:)),colors(2,:),2);
mark(ar,Aold,'s',[.45 .45 .45]); mark(ar,A(2,:),'s',colors(2,:));
label(ar,Aold+[0 0 2],'Original',[.3 .3 .3]);
label(ar,A(2,:)+[0 0 2],'Selected',colors(2,:));
formatAxes(ar); view(ar,0,0); xlim(ar,[88 152]); % X-Z elevation
title(ar,'A2 | 35 mm along Rail 6');

% Detail 2: local sphere patch and great-circle arc from old to new B2.
ab = nexttile(layout,6);
hold(ab,'on');
u = Bold/norm(Bold); v = B(2,:)/norm(B(2,:));
ang = acos(max(-1,min(1,dot(u,v))));
t = (v-dot(u,v)*u); t = t/norm(t);
w = cross(u,t);
[a,b] = meshgrid(linspace(-5,10,40),linspace(-6,6,32));
patchPoints = rb*u + a(:)*t + b(:)*w;
patchPoints = rb*patchPoints./vecnorm(patchPoints,2,2);
surf(ab,reshape(patchPoints(:,1),size(a)),reshape(patchPoints(:,2),size(a)), ...
    reshape(patchPoints(:,3),size(a)),'EdgeColor','none','FaceAlpha',.25, ...
    'FaceColor',[.46 .77 .85]);
phi = linspace(0,ang,50)';
arc = rb*(cos(phi)*u+sin(phi)*t);
plot3(ab,arc(:,1),arc(:,2),arc(:,3),'Color',colors(2,:),'LineWidth',2);
mark(ab,Bold,'o',[.45 .45 .45]); mark(ab,B(2,:),'o',colors(2,:));
label(ab,Bold+w,'Original',[.3 .3 .3]);
label(ab,B(2,:)+w,'Selected',colors(2,:));
formatAxes(ab); view(ab,u); camup(ab,w);
title(ab,{'B2 | 6 deg on sphere','Chord = 5.3201 mm'});
rotate3d(fig,'on');
end

function segment(ax,p,q,col,width,style)
if nargin < 6, style = '-'; end
d = [p;q];
plot3(ax,d(:,1),d(:,2),d(:,3),style,'Color',col,'LineWidth',width);
end

function mark(ax,p,symbol,col)
plot3(ax,p(1),p(2),p(3),symbol,'MarkerSize',6,'Color',col,'MarkerFaceColor',col);
end

function label(ax,p,str,col)
text(ax,p(1),p(2),p(3),[' ' str],'Color',col,'FontWeight','bold');
end

function formatAxes(ax)
axis(ax,'equal'); grid(ax,'on'); box(ax,'on');
xlabel(ax,'X (mm)'); ylabel(ax,'Y (mm)'); zlabel(ax,'Z (mm)');
end
