
function L = forwardKinematics(q)

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

end