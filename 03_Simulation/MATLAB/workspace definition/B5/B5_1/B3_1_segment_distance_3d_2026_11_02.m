function dist = B3_1_segment_distance_3d_2026_11_02(P1,Q1,P2,Q2)
% Minimum distance between two finite 3D segments.
% P1-Q1: segment 1
% P2-Q2: segment 2
% Inputs: 3-element vectors in mm
% Output: minimum distance in mm
% 计算两根cable之间的距离 

P1=P1(:); Q1=Q1(:);
P2=P2(:); Q2=Q2(:);
%P1(:)等操作将输入的坐标统一转化为列向量

u=Q1-P1;
%线段 1（钢索 1）的方向向量
v=Q2-P2;
%线段 2（钢索 2）的方向向量
w=P1-P2;
% 连接线段 2 起点到线段 1 起点的相对向量

a=dot(u,u);
% 线段1长度的平方 ||u||^2
b=dot(u,v);
% 方向向量的点积 u · v
c=dot(v,v);
d=dot(u,w);
e=dot(v,w);

eps2=1e-12;

% Handle degenerate segments
if a<eps2 && c<eps2
    % 两条线段都缩成了一个点 -> 直接求点对点距离
    dist=norm(P1-P2);
    return;
elseif a<eps2
    % 线段1退化为一个点 -> 计算该点到线段2的最短距离
    t=max(0,min(1,dot(P1-P2,v)/c));
    dist=norm(P1-(P2+t*v));
    return;
elseif c<eps2
    % 线段2退化为一个点 -> 计算该点到线段1的最短距离
    s=max(0,min(1,-d/a));
    dist=norm((P1+s*u)-P2);
    return;
end

% Candidate distances from endpoints
s1=max(0,min(1,-d/a));
%线段 2 的起点 $P_2$ 投影到线段 1（$P_1 Q_1$）上的最近点参数 $s_1$

s2=max(0,min(1,(b-d)/a));
%线段 2 的终点 $Q_2$ 投影到线段 1（$P_1 Q_1$）上的最近点参数 $s_2$
t1=max(0,min(1,e/c));
%线段 1 的起点 $P_1$ 投影到线段 2（$P_2 Q_2$）上的最近点参数 $t_1$
t2=max(0,min(1,(e+b)/c));

distances=[
    norm((P1+s1*u)-P2);
    norm((P1+s2*u)-Q2);
    norm(P1-(P2+t1*v));
    norm(Q1-(P2+t2*v))
    ];

% Check interior-to-interior closest points
den=a*c-b*b;

if den>1e-12*a*c
    s=(b*e-c*d)/den;
    t=(a*e-b*d)/den;

    if s>=0 && s<=1 && t>=0 && t<=1
        % 只有当算出的 s 和 t 同时满足 0 ≤ s ≤ 1$ 且 0 ≤ t ≤ 1 时，
        % 说明这两条无限长直线的公垂线切点刚好落在两根有限长钢索的内部。
        distances(end+1)=norm((P1+s*u)-(P2+t*v));
    end
end

dist=min(distances);

end