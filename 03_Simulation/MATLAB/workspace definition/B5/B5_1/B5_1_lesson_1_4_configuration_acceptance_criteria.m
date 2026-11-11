%% B5.1 Lesson 1.4
% Configuration Acceptance Criteria - Baseline Evaluation
%
% Research Question:
% How should six-cable configurations be evaluated?
%
% Goal:
% Compare Original B and Modified B' using
% identical metrics at the reference pose.
%

clear; clc; close all;

%% Step 1: Load existing configuration

load('B2_experiment_B_results.mat','resultB');

A = resultB.A;
r_B = resultB.r;

% Modified B' only changes cable pairing
r_Bprime = r_B;
r_Bprime([5,6],:) = r_Bprime([6,5],:);

% Store both configurations
config_names = {'Original B','Modified Bprime'};
attachments = {r_B,r_Bprime};

% Balloon radius and reference pose
rb = 50.8266;
P = [0 0 0];
R = eye(3);

% Scaling convention consistent with B4
scale = diag([1 1 1 1/rb 1/rb 1/rb]);

n = 6;

%% Step 2: Prepare result storage

% Each row will represent one configuration
results = zeros(2,6);

%% Step 3: Evaluate Original B and B'

for k = 1:2

    r = attachments{k};

    %% 3.1 Anchor and attachment distances

    dA = [];
    dr = [];

    for i = 1:n
        for j = i+1:n

            dA(end+1) = norm(A(i,:)-A(j,:));

            dr(end+1) = norm(r(i,:)-r(j,:));

        end
    end

    min_dA = min(dA);
    min_dr = min(dr);

    %% 3.2 Build measurement Jacobian

    H = zeros(6,6);
    U = zeros(6,3);

    for i = 1:n

        % Attachment in world coordinates
        s_i = (R*r(i,:)')';

        B_i = P + s_i;

        % Cable vector: attachment to anchor
        D_i = A(i,:) - B_i;

        % Cable length and unit direction
        L_i = norm(D_i);
        u_i = D_i/L_i;

        U(i,:) = u_i;

        % Translation sensitivity
        H(i,1:3) = -u_i;

        % Rotation sensitivity
        H(i,4:6) = cross(u_i,s_i);

    end

    %% 3.3 Direction similarity

    % Absolute cosine similarity
    S = abs(U*U');

    % Exclude diagonal elements
    S(1:n+1:end) = NaN;

    max_similarity = max(S(:),[],'omitnan');

    %% 3.4 Scaled Jacobian metrics

    Hs = H*scale;

    singular_values = svd(Hs);

    sigma_min = min(singular_values);

    condition_number = cond(Hs);

    jacobian_rank = rank(Hs);

    %% 3.5 Store results

    results(k,:) = [
        min_dA, ...
        min_dr, ...
        max_similarity, ...
        jacobian_rank, ...
        sigma_min, ...
        condition_number
        ];

end

%% Step 4: Print comparison table

T = array2table(results, ...
    'VariableNames', ...
    {'Min_Anchor_Distance', ...
    'Min_Attachment_Distance', ...
    'Max_Direction_Similarity', ...
    'Jacobian_Rank', ...
    'Sigma_Min', ...
    'Condition_Number'});

T.Configuration = string(config_names(:));

T = movevars(T,'Configuration','Before',1);

disp('--- B5.1 Configuration Evaluation ---');
disp(T);

%% Step 5: Interpretation reminder

fprintf('\nImportant:\n');

fprintf('All metrics above are evaluated at P=[0,0,0], R=I.\n');

fprintf('They do not establish Core Workspace feasibility.\n');

fprintf('Multi-pose geometry and sensing tests come next.\n');