clc;clear;
close all;

%% lesson4 - workspace and sensing analysis
%
% 4.1 geometric workspace
% 4.2 tension and wrench workspace
% 4.3 workspace and sensing quality

%% ============================================================
% 1. Robot Geometry
% =============================================================

% fixed anchor points in world coordinates
% A = [-2 2 2 -2;
%     3 3 -1 -1];
A = [0 1 1 0;
    0 0 1 1]; % follow lesson3 parameters

% cable attachment points in platform-local coordinates
% r = [-0.5   0.5   0.5  -0.5;
%       0.5   0.5  -0.5  -0.5];
r = [-0.125 0.125 0.125 -0.125;
    0.0 0.0 0.0 0.0
    ]; % follow lesson3 parameters


%% ============================================================
% 2. Robot / Physical Parameters
% =============================================================

% cable limits
L_min = 0.1;
L_max = 5;

% cable tension limits
T_min = 1;
T_max = 80; % follow lesson3 parameters

% external wrench
w_ext = [0; -2; 0]; % follow lesson3 parameters

%% ============================================================
% 3. Configuration Space
% =============================================================

% platform position
x_range = -0.2: 0.02 : 1.2;
y_range = -0.2: 0.02 : 1.2;

% platform orientation
theta_range_deg = -30: 2.5: 30;

% number of grid points
nx = length(x_range);
ny = length(y_range);
ntheta = length(theta_range_deg);

%% ============================================================
% 4. Preallocate Result Arrays
% =============================================================

% lesson 4.1 
geometric_feasible = false(ny, nx, ntheta);
% the result can be true when it meets requirements
% the order in plot is y, and then is x

% lesson 4.2
% tension / wrench feasibility 
tension_feasible = false(ny, nx, ntheta);

% lesson4.3
% sensitivity 
Sx_map = nan(ny, nx, ntheta);
% nan is 0 matrix, initialize matrix
Sy_map = nan(ny, nx, ntheta);
Stheta_map = nan(ny, nx, ntheta);

% measurement-pattern similarity
Cxy_map = nan(ny, nx, ntheta);
Cxtheta_map = nan(ny, nx, ntheta);
Cytheta_map = nan(ny, nx, ntheta);

% singular values 
sigma_max_map = nan(ny, nx, ntheta);
sigma_mid_map = nan(ny, nx, ntheta);
sigma_min_map = nan(ny, nx, ntheta);

% condition number
condition_map = nan(ny,nx,ntheta);

%% ============================================================
% 5. Main Configuration Loop
% =============================================================

for itheta = 1 : ntheta

    % current orientation in degrees
    theta_deg = theta_range_deg(itheta);

    % covert degrees to radians
    theta = deg2rad(theta_deg);

    %--------
    % rotation matrix
    R = [cos(theta) -sin(theta);
        sin(theta) cos(theta)];

    % loop through y 
    for iy = 1: ny
        
        % current y position
        y = y_range(iy);

        % loop through x
        for ix = 1 : nx

            % current x position
            x = x_range(ix);

            % current platform configuration
            P = [x; y];
            
            % Platform attachment points
            B = P + R * r;  % B is 2×4

            % cable vectors
            D = A - B;      % D is 2×4

            % cable lengths
            L = vecnorm(D, 2, 1);
        
            %% =================================================
            % Lesson 4.1 - Geometric Feasibility
            % ==================================================

            geometric_feasible(iy, ix, itheta) = all( ...
                L >= L_min & L <= L_max);

            if ~geometric_feasible(iy, ix, itheta)
                
                % 只要当前点不满足上面的条件，就换一个点，
                % 下面的计算就不用执行
                continue;
            end

            % cable unit vectors
            u = D ./ L;

            %% --------------
            % jacobian
            %----------------
            J = zeros(3, 4);
            for i = 1: 4
                
                % transitional part
                J(1, i) = u(1, i);
                J(2, i) = u(2, i);

                % rotational part
                ri = B(:, i) - P;
                J(3, i) = ri(1) * u(2, i) - ri(2) * u(1, i);
               
            end
            
            %% =================================================
            % Lesson 4.2 - Tension / Wrench Feasibility
            % ==================================================

            % cable wrench matrix 

            A_wrench = J;

            
            % -------------------------------------------------
            % Linear programming problem
            % -------------------------------------------------
            
            f = ones(4, 1);
            % find one matrix solution 

            % equality constraint:
            % A_wrench * T = -w_ext
            Aeq = A_wrench;
            beq = -w_ext;

            % tension lower and upper 
            lb = T_min*ones(4,1);
            ub = T_max*ones(4,1);

            % Suppress linprog output
            options = optimoptions('linprog', 'Display','none');
            % 以防每一个都输出

            % solve feasibility problem
            [~, ~, exitflag] = linprog(f, [], [], ...
                Aeq, beq, lb, ub, options);

            % exitflag = 1 means a feasible solution was found
            tension_feasible(iy, ix, itheta) = (exitflag == 1);

            %% =================================================
            % Lesson 4.3 - Sensing Quality
            % ==================================================
            
            % measurement jacobian
            Jm = J';

            %% --------------
            % measurement pattern
            % x_motion pattern
            sx = Jm(:, 1);

            % y_motion pattern
            sy = Jm(:, 2);

            % theta_motion pattern
            stheta = Jm(:, 3);

            %% ----------------
            % sensivity 
            Sx_map(iy, ix, itheta) = norm(sx);
            Sy_map(iy, ix, itheta) = norm(sy);
            Stheta_map(iy, ix, itheta) = norm(stheta);

            %% -------------------------------------------------
            % Measurement-pattern similarity
            % -------------------------------------------------

            Cxy_map(iy, ix, itheta) = dot(sx, sy) / (norm(sx) * norm(sy));
            Cxtheta_map(iy, ix, itheta) = dot(sx, stheta) / (norm(sx) * norm(stheta));
            Cytheta_map(iy, ix, itheta) = dot(sy, stheta) / (norm(sy) * norm(stheta));
            % dot(a, b) = a^T * B 

            %% -------------------------------------------------
            % Singular values decomposition
            % -------------------------------------------------

            % Jm = U*S*V'
            singular_values = svd(Jm);

            sigma_max_map(iy, ix, itheta) = singular_values(1);
            sigma_mid_map(iy, ix, itheta) = singular_values(2);
            sigma_min_map(iy, ix, itheta) = singular_values(3);

            %% -------------------------------------------------
            % Condition number
            % -------------------------------------------------
            
            if singular_values(3) > 1e-10
                condition_map(iy, ix, itheta) = (singular_values(1) ...
                    / singular_values(3));
            else
                condition_map(iy, ix, itheta) = Inf;

            end
        end
    end

end

%% ============================================================
% 6. Combined Workspace Classification
% ============================================================

% Classification:
%
% 0 = geometrically infeasible
% 1 = geometrically feasible
%     but tension infeasible
% 2 = tension feasible

combined_workspace = zeros(ny, nx, ntheta);

for itheta = 1 : ntheta

    % Geometrically and Tension feasible
    combined_workspace(:,:,itheta) = ...
        2 * double(tension_feasible(:,:,itheta)) + ...
        double( ...
        geometric_feasible(:,:,itheta) & ...
        ~tension_feasible(:,:,itheta) );
        % ~表示取反 张力不可行 
        % true → 1 false → 0 
end

%% ============================================================
% 7. Select Orientation Slices for Visualization
% =============================================================

% We do not need to plot every 5-degree slice.
%
% Use three representative configurations:

plot_theta_deg = [-15 -5 0 5];

% Find their indices(上面角度的索引)
plot_theta_indices = zeros(size(plot_theta_deg));

for k = 1: length(plot_theta_deg)

    [~,plot_theta_indices(k)] = ...
        min(abs(theta_range_deg - plot_theta_deg(k)));
    % MATLAB 中 min 函数返回两个值：
    % 第一个是最小值本身，第二个是最小值所在的位置（索引）
    % 用整个角度数组减去当前要找的角度，算出差值。
end


%% ============================================================
% 8. Figure 1 - Geometric Workspace
% =============================================================

figure('Position', [100, 100, 1000, 800]); % 调大画布防止拥挤

for k = 1: length(plot_theta_indices)

    itheta = plot_theta_indices(k);

    subplot(2, 2, k);

    imagesc( ...
    x_range, y_range, ...
    geometric_feasible(:, :, itheta));

    axis xy equal tight;
    hold on;

    % 绘制 4 个固定锚点和框架外框，让图更专业
    plot([A(1,:) A(1,1)], [A(2,:) A(2,1)], 'r--', 'LineWidth', 1.5); % 红色虚线框
    plot(A(1,:), A(2,:), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % 锚点位置
    hold off;

    xlabel('x (m)');
    ylabel('y (m)');

    title("\theta = " + theta_range_deg(itheta) + "^\circ", ...
    'Interpreter', 'tex');

    colorbar;
end

% 统一添加顶部大标题
sgtitle('Geometric Workspace', 'FontSize', 14, 'FontWeight', 'bold');

%% ============================================================
% 9. Figure 2 - Tension Feasible Workspace
% =============================================================

figure('Position', [100, 100, 1000, 800]); % 调大画布防止拥挤

for k = 1:length(plot_theta_indices)

    itheta = plot_theta_indices(k);

    subplot(2, 2, k);

    imagesc(x_range, y_range, ...
    tension_feasible(:, :, itheta));

    axis xy equal tight;
    hold on;

    % 绘制 4 个固定锚点和框架外框，让图更专业
    plot([A(1,:) A(1,1)], [A(2,:) A(2,1)], 'r--', 'LineWidth', 1.5); % 红色虚线框
    plot(A(1,:), A(2,:), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % 锚点位置
    hold off;

    xlabel('x (m)'); 
    ylabel('y (m)');

    title("\theta = " + theta_range_deg(itheta) + "^\circ", ...
        'Interpreter', 'tex');

    colorbar;
end

sgtitle('Tension Feasible Workspace', 'FontSize', 14, ...
'FontWeight', 'bold');



%% ============================================================
% 10. Figure 3 - Combined Workspace
% =============================================================

figure('Position', [100, 100, 1000, 800]); % 调大画布防止拥挤

for k = 1:length(plot_theta_indices)

    itheta = plot_theta_indices(k);

    subplot(2, 2, k);

    imagesc(x_range, y_range, ...
    combined_workspace(:, :, itheta));

    axis xy equal tight;
    hold on;

    % 绘制 4 个固定锚点和框架外框，让图更专业
    plot([A(1,:) A(1,1)], [A(2,:) A(2,1)], 'r--', 'LineWidth', 1.5); % 红色虚线框
    plot(A(1,:), A(2,:), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % 锚点位置
    hold off;

    xlabel('x (m)'); 
    ylabel('y (m)');

    title("\theta = " + theta_range_deg(itheta) + "^\circ", ...
        'Interpreter', 'tex');

    colorbar;
end

sgtitle('Combined Workspace', 'FontSize', 14, ...
    'FontWeight', 'bold');


%% ============================================================
% 11. Figure 4 - Minimum Singular Value
% =============================================================

figure('Position', [100, 100, 1000, 800]); % 调大画布防止拥挤

for k = 1:length(plot_theta_indices)

    itheta = plot_theta_indices(k);

    subplot(2, 2, k);

    imagesc(x_range, y_range, ...
        sigma_min_map(:, :, itheta));

    axis xy equal tight;
    hold on;

    % 绘制 4 个固定锚点和框架外框，让图更专业
    plot([A(1,:) A(1,1)], [A(2,:) A(2,1)], 'r--', 'LineWidth', 1.5); % 红色虚线框
    plot(A(1,:), A(2,:), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % 锚点位置
    hold off;

    xlabel('x (m)'); 
    ylabel('y (m)');

    title("\theta = " + theta_range_deg(itheta) + "^\circ", ...
        'Interpreter', 'tex');

    colorbar;
end

sgtitle('sigma_{min}', 'FontSize', 14, ...
    'FontWeight', 'bold');

%% ============================================================
% 12. Figure 5 - Condition Number
% =============================================================

figure('Position', [100, 100, 1000, 800]); % 调大画布防止拥挤

for k = 1:length(plot_theta_indices)

    itheta = plot_theta_indices(k);

    subplot(2, 2, k);

    data = condition_map(:, :, itheta);

    % Remove infinite values from display

    data(~isfinite(data)) = NaN;

    imagesc(x_range, y_range, ...
        data);

    axis xy equal tight;
    hold on;

    % 绘制 4 个固定锚点和框架外框，让图更专业
    plot([A(1,:) A(1,1)], [A(2,:) A(2,1)], 'r--', 'LineWidth', 1.5); % 红色虚线框
    plot(A(1,:), A(2,:), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % 锚点位置
    hold off;

    xlabel('x (m)'); 
    ylabel('y (m)');

    title("\theta = " + theta_range_deg(itheta) + "^\circ", ...
        'Interpreter', 'tex');

    colorbar;
end

sgtitle('Condition Number', 'FontSize', 14, ...
    'FontWeight', 'bold');


%% ============================================================
% 13. Example Sensing Analysis at q = [0,0,0]
% =============================================================

% Find the grid index closest to x = 0, y = 0, theta = 0

[~,ix0] = min(abs(x_range - 0));

[~,iy0] = min(abs(y_range - 0));

[~,itheta0] = min(abs(theta_range_deg - 0));


% Display results

fprintf('\n');
fprintf('============================================\n');
fprintf('Example Configuration\n');
fprintf('============================================\n');

fprintf('x     = %.2f m\n',x_range(ix0));

fprintf('y     = %.2f m\n',y_range(iy0));

fprintf('theta = %.2f deg\n',...
    theta_range_deg(itheta0));


fprintf('\n');

fprintf('Geometric feasible: %d\n',...
    geometric_feasible(iy0,ix0,itheta0));

fprintf('Tension feasible:   %d\n',...
    tension_feasible(iy0,ix0,itheta0));


fprintf('\n');

fprintf('Sx     = %.4f\n',...
    Sx_map(iy0,ix0,itheta0));

fprintf('Sy     = %.4f\n',...
    Sy_map(iy0,ix0,itheta0));

fprintf('Stheta = %.4f\n',...
    Stheta_map(iy0,ix0,itheta0));


fprintf('\n');

fprintf('Cxy      = %.4f\n',...
    Cxy_map(iy0,ix0,itheta0));

fprintf('CxTheta  = %.4f\n',...
    Cxtheta_map(iy0,ix0,itheta0));

fprintf('CyTheta  = %.4f\n',...
    Cytheta_map(iy0,ix0,itheta0));


fprintf('\n');

fprintf('sigma_max = %.4f\n',...
    sigma_max_map(iy0,ix0,itheta0));

fprintf('sigma_mid = %.4f\n',...
    sigma_mid_map(iy0,ix0,itheta0));

fprintf('sigma_min = %.4f\n',...
    sigma_min_map(iy0,ix0,itheta0));

fprintf('condition = %.4e\n',...
    condition_map(iy0,ix0,itheta0));


fprintf('============================================\n');