%% B5.3 Lesson 2.2
% Mechanical Interface Definition
%
% Research Question:
% How should rail carriage positions and
% effective cable exit points be represented?
%
% Objectives:
% 1. Load the verified twelve-rail geometry
% 2. Define mechanical interface parameters
% 3. Separate known geometry from unknown hardware
% 4. Verify the ideal fixed-anchor approximation
% 5. Test potential shared-corner conflicts
% 6. Save a reusable mechanical interface baseline
%
% IMPORTANT:
% No real pulley sizes or installation tolerances
% have been measured yet.

clear; clc; close all;

%% Step 1: Load B5.3 Lesson 2.1 results

load('B5_3_12rail_geometry_baseline.mat', ...
    'rail_start','rail_end','rail_axis', ...
    'rail_length','A_rail_unique', ...
    'candidate_rail_membership', ...
    'Lg','Wg','Hg','rb');

N_rails = size(rail_start,1);

assert(N_rails==12);
assert(size(A_rail_unique,1)==44);

fprintf('\n--- Mechanical Interface Definition ---\n');
fprintf('Loaded rails: %d\n',N_rails);

%% Step 2: Define current modelling assumptions
% 当前模型只描述一个理想固定Anchor。
%
% 尚未确定真实滑轮类型、位置偏移、
% Cable绕轮长度和实际滑块尺寸。
%
% 因此用NaN表示未知的数值参数。
% 不应该把NaN替换为未经依据的工程数值。

mechanical = struct();

mechanical.model_version = ...
    'B5.3-L2.2-Ideal-Rail-Interface';

mechanical.N_rails = N_rails;

mechanical.rail_start = rail_start;
mechanical.rail_end = rail_end;
mechanical.rail_axis = rail_axis;

mechanical.guide_type = "TBD";

mechanical.mount_rotation = nan(3,3);

mechanical.pulley_offset_mm = nan(1,3);

mechanical.exit_offset_mm = nan(1,3);

mechanical.carriage_size_mm = nan(1,3);

mechanical.rail_end_margin_mm = NaN;

mechanical.cable_diameter_mm = NaN;

mechanical.connector_size_mm = nan(1,3);

mechanical.measurement_zero_offset_mm = NaN;

% 当前阶段采用的明确建模假设
mechanical.ideal_anchor_assumption = true;

% 实际机械净空尚未验证
mechanical.hardware_clearance_verified = false;

% 实际滑轮出线点尚未标定
mechanical.effective_exit_calibrated = false;

%% Step 3: Demonstrate rail parameterisation
% 这里只做参数化测试，
% 不代表正式选择了某个Cable的安装位置。
%
% 例如：在R1上选择t=0.35。

example_rail_id = 1;
example_t = 0.35;

E0 = rail_start(example_rail_id,:);
E1 = rail_end(example_rail_id,:);

% 滑块参考位置C
C_example = E0 + example_t*(E1-E0);

fprintf('\n--- Example Carriage Position ---\n');

fprintf('Rail ID: R%d\n',example_rail_id);

fprintf('Rail parameter t: %.2f\n',example_t);

fprintf('Carriage C [mm]: [%.3f %.3f %.3f]\n', ...
    C_example);

% 验证参数位置位于对应导轨
assert(example_t>=0 && example_t<=1);

% 反算线段参数并检查点是否在导轨上
rail_vector = E1-E0;

t_recovered = ...
    dot(C_example-E0,rail_vector) / ...
    dot(rail_vector,rail_vector);

C_recovered = E0+t_recovered*rail_vector;

assert(abs(t_recovered-example_t)<1e-10);
assert(norm(C_recovered-C_example)<1e-10);

%% Step 4: Separate carriage and effective exit
%
% 定义：
% C     = Carriage reference point
% O     = Pulley centre
% A_eff = Effective cable exit point
%
% 在真实系统中：
% O = C + mount_rotation*pulley_offset
%
% 对固定导向点：
% A_eff = C + mount_rotation*exit_offset
%
% 当前偏移未知，不能数值计算真实O和A_eff。

O_actual = nan(1,3);
A_eff_actual = nan(1,3);

% 为保留历史B1-B5.2运动学模型，
% 单独定义理想近似下的有效Anchor。
A_eff_ideal = C_example;

fprintf('\n--- Anchor Model ---\n');
fprintf('Ideal effective anchor = carriage position.\n');
fprintf('Actual pulley centre: TBD\n');
fprintf('Actual cable exit point: TBD\n');

assert(all(isnan(O_actual)));
assert(all(isnan(A_eff_actual)));

%% Step 5: Shared-corner mechanical conflict check
%
% 一个长方体角点可以同时属于三条导轨。
%
% 例如R1、R5、R9在同一个角点相交。
%
% 现在检查这些公共角点的几何重合关系。
%
% 这不是实际滑块碰撞检查，
% 因为滑块和连接件尺寸仍未知。

membership_count = ...
    sum(candidate_rail_membership,2);

corner_ids = find(membership_count==3);

assert(numel(corner_ids)==8);

fprintf('\n--- Shared Corner Rail Membership ---\n');

for k = 1:numel(corner_ids)

    id = corner_ids(k);

    point = A_rail_unique(id,:);

    rail_ids = find( ...
        candidate_rail_membership(id,:));

    fprintf( ...
        'Corner %d: [%g %g %g], Rails %s\n', ...
        k,point(1),point(2),point(3), ...
        mat2str(rail_ids));

    assert(numel(rail_ids)==3);

end

%% Step 6: Demonstrate point versus hardware separation
%
% 假设两个不同导轨上的滑块
% 位于同一个角点附近。
%
% 为了说明几何关系，
% 这里仅用已有的导轨参数t取两个数学点。
% 不假设滑块的真实大小。

% R1: 接近其起点
C1 = rail_start(1,:) + 0.02 * ...
    (rail_end(1,:)-rail_start(1,:));

% R5: 接近其起点
C2 = rail_start(5,:) + 0.02 * ...
    (rail_end(5,:)-rail_start(5,:));

point_distance = norm(C1-C2);

fprintf('\n--- Two Carriages Near Shared Corner ---\n');

fprintf('C1 on R1: [%.2f %.2f %.2f] mm\n',C1);
fprintf('C2 on R5: [%.2f %.2f %.2f] mm\n',C2);

fprintf('Point separation: %.4f mm\n',point_distance);

% 检查两个数学点不重合
assert(point_distance>0);

% 但没有滑块尺寸，不能证明无机械碰撞
fprintf('Hardware collision status: UNKNOWN\n');


%% Step 7: Define measurement-model status

measurement_model = struct();

% 第一版直线Cable模型
measurement_model.type = ...
    "Ideal straight cable";

measurement_model.anchor_reference = ...
    "Fixed effective exit point";

measurement_model.pulley_wrap_model = ...
    "Not implemented";

measurement_model.length_zero_model = ...
    "TBD calibration";

measurement_model.cable_elasticity_model = ...
    "Not implemented";

measurement_model.validated_hardware = false;

%% Step 8: Print parameter status

parameter_names = [
    "Rail geometry";
    "Carriage rail parameter";
    "Mount rotation";
    "Pulley centre offset";
    "Effective exit offset";
    "Carriage envelope";
    "Rail end exclusion";
    "Cable diameter";
    "Measurement zero offset"
    ];

parameter_status = [
    "Defined";
    "Defined";
    "TBD";
    "TBD";
    "TBD";
    "TBD";
    "TBD";
    "TBD";
    "TBD"
    ];

T_parameters = table( ...
    parameter_names,parameter_status, ...
    'VariableNames',{'Parameter','Status'});

fprintf('\n--- Mechanical Parameter Status ---\n');
disp(T_parameters);

%% Step 9: Save model for subsequent lessons

save('B5_3_mechanical_interface_baseline.mat', ...
    'mechanical','measurement_model', ...
    'T_parameters', ...
    'C_example','A_eff_ideal', ...
    'corner_ids','C1','C2','point_distance');

fprintf('\nB5.3 Lesson 2.2 completed.\n');

fprintf('Saved: B5_3_mechanical_interface_baseline.mat\n');

