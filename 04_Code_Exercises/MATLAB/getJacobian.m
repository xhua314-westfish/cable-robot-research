
function J = getJacobian(q)
%% fixed function points
A = [-2  2  2 -2;
    3  3 -1 -1];

%% Local platform attachment points
r = [-0.5  0.5  0.5 -0.5;
    0.5  0.5 -0.5 -0.5];

%% Platform configuration
x = q(1);
y = q(2);
theta = q(3);

P = [x; y];

%% Rotation matrix
R = [cos(theta) -sin(theta);
    sin(theta)  cos(theta)];

%% Attachment points in world frame
B = P + R*r;

%% Cable vectors
D = A - B; % D is 2 * 4;

%% Cable lengths
L = vecnorm(D,2,1)'; % L is 4 * 1

%% cable unit vectors
u = D ./ L'; 

%% Cable-length Jacobian
J = zeros(3, 4);

for i = 1: 4

    % transitional part
    J(1, i) = -u(1, i);
    J(2, i) = -u(2, i);

    % rotational part
    ri = B(:, i) - P;
    J(3, i) = -(ri(1) * u(2, i) - ri(2) * u(1, i));

    % 这里注意全部有负号 

end

end