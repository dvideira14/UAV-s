% Check for Prerequisite Variables
if ~exist('dataX','var') || ~exist('dataY','var') || ~exist('dataZ','var')
    error('iddata objects dataX, dataY, or dataZ not found. Run data preparation first.');
end
if ~exist('tf1','var') || ~exist('tf2','var') || ~exist('tf3','var')
    error('Identified models tf1, tf2, or tf3 not found. Export them from the ident tool to the workspace.');
end

% Define Fit Percentages (Manually obtained from 'ident')
fitPercent_x = 15.6;
fitPercent_y = 44.5;
fitPercent_z = 0.0; % Or -4.11e-11 if preferred
fprintf('Fit percentages manually set.\n');

% Rename models
sys_tf_est_x = tf1; sys_tf_est_x.Name = 'Identified G_theta_px';
sys_tf_est_y = tf2; sys_tf_est_y.Name = 'Identified G_phi_py';
sys_tf_est_z = tf3; sys_tf_est_z.Name = 'Identified G_T_pz (Null)';

% Extract Detrended Data and Ts 

% X-Axis
output_px_detrend_x = dataX.OutputData;
input_theta_detrend_x = dataX.InputData;
Ts_x = dataX.Ts;
time_x = (0:length(output_px_detrend_x)-1)' * Ts_x + dataX.Tstart;

% Y-Axis
output_py_detrend_y = dataY.OutputData;
input_phi_detrend_y = dataY.InputData;
Ts_y = dataY.Ts;
time_y = (0:length(output_py_detrend_y)-1)' * Ts_y + dataY.Tstart;

% Z-Axis
output_pz_detrend_z = dataZ.OutputData;
input_T_total_detrend_z = dataZ.InputData;
Ts_z = dataZ.Ts;
time_z = (0:length(output_pz_detrend_z)-1)' * Ts_z + dataZ.Tstart;
fprintf('Data extracted.\n\n');

% Define Theoretical Models 
m = 0.035;         % Mass [kg]
g = 9.81;          % Gravity [m/s^2]
Dz_report = 0.108; % Drag coefficient 
s = tf('s');

% Theoretical G_theta_px (Simplified)
G_theta_px_theory = -g / s^2; G_theta_px_theory.Name = 'Theoretical Simplified G_theta_px';

% Theoretical G_phi_py (Simplified)
G_phi_py_theory = g / s^2;    G_phi_py_theory.Name = 'Theoretical Simplified G_phi_py';

% Theoretical G_T_pz (Including Drag)
G_T_pz_theory = 1 / (m*s^2 + Dz_report*s); G_T_pz_theory.Name = 'Theoretical G_T_pz (with Drag)';
fprintf('Theoretical models defined.\n\n');

% Comparison and Plotting
% X-Axis Comparison 
figure('Name', 'Section 2.4: Model Comparison - X-Axis');
y_sim_ident_x = lsim(sys_tf_est_x, input_theta_detrend_x, time_x - time_x(1));
y_sim_theory_x = lsim(G_theta_px_theory, input_theta_detrend_x, time_x - time_x(1));
plot(time_x, output_px_detrend_x, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Measured Data (px detrended)');
hold on;
plot(time_x, y_sim_ident_x, 'b--', 'LineWidth', 1, 'DisplayName', sprintf('Identified Model (Fit %.1f%%)', fitPercent_x));
plot(time_x, y_sim_theory_x, 'r:', 'LineWidth', 1, 'DisplayName', 'Theoretical Model (-g/s^2)');
hold off;
grid on; xlabel('Time (s)'); ylabel('px Detrended (m)');
title('Model Comparison - X-Axis (Longitudinal)'); legend('Location', 'best');
fprintf('X-Axis plot generated.\n');

% Y-Axis Comparison 
figure('Name', 'Section 2.4: Model Comparison - Y-Axis');
y_sim_ident_y = lsim(sys_tf_est_y, input_phi_detrend_y, time_y - time_y(1));
y_sim_theory_y = lsim(G_phi_py_theory, input_phi_detrend_y, time_y - time_y(1));
plot(time_y, output_py_detrend_y, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Measured Data (py detrended)');
hold on;
plot(time_y, y_sim_ident_y, 'b--', 'LineWidth', 1, 'DisplayName', sprintf('Identified Model (Fit %.1f%%)', fitPercent_y));
plot(time_y, y_sim_theory_y, 'r:', 'LineWidth', 1, 'DisplayName', 'Theoretical Model (g/s^2)');
hold off;
grid on; xlabel('Time (s)'); ylabel('py Detrended (m)');
title('Model Comparison - Y-Axis (Lateral)'); legend('Location', 'best');
fprintf('Y-Axis plot generated.\n');

% Z-Axis Comparison
figure('Name', 'Section 2.4: Model Comparison - Z-Axis');
y_sim_ident_z = lsim(sys_tf_est_z, input_T_total_detrend_z, time_z - time_z(1));
y_sim_theory_z = lsim(G_T_pz_theory, input_T_total_detrend_z, time_z - time_z(1));
plot(time_z, output_pz_detrend_z, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Measured Data (pz detrended)');
hold on;
plot(time_z, y_sim_ident_z, 'b--', 'LineWidth', 1, 'DisplayName', sprintf('Identified Model (Fit %.1f%%)', fitPercent_z));
plot(time_z, y_sim_theory_z, 'r:', 'LineWidth', 1, 'DisplayName', 'Theoretical Model (with Drag)');
hold off;
grid on; xlabel('Time (s)'); ylabel('pz Detrended (m)');
title('Model Comparison - Z-Axis (Vertical)'); legend('Location', 'best');
fprintf('Z-Axis plot generated.\n\n');
