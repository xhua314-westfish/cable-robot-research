clear;
clc;

% platform position
platform = [0.5, 0.5];

% platform rotation
theta = deg2rad(90);

% attachment point in local coordinate
attachmentlocal = [-0.125, 0];

% rotation matrix 
r = [cos(theta), -sin(theta);
    sin(theta), cos(theta)];

% transform attachment point to world coordinate 
attachmentworld = platform + r * attachmentlocal;

disp(attachmentworld);



