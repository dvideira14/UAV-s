clear; clc; close all;

fprintf('Data setting for System Identification Tool...\n');

% Data upload
csvfilename = '2024-04-04_log07.csv';
if ~isfile(csvfilename)
    error('Ficheiro CSV não encontrado: %s', csvfilename);
end
array = dlmread(csvfilename, ',', 1, 0);

time_full = array(:,1)'*1e-3;
pos_full = array(:,2:4)';
lbd_full = array(:,8:10)'*pi/180;
motors_full = array(:,18:21)';
t = time_full - time_full(1);

% --- Dados para o Eixo X [2s, 5s] ---
t_start_x = 2; t_end_x = 5;
idx_x = (t >= t_start_x) & (t <= t_end_x);
time_x = t(idx_x);
input_theta_raw = lbd_full(2, idx_x)';
output_px_raw = pos_full(1, idx_x)';
Ts_x = mean(diff(time_x));
input_theta_detrend_x = detrend(input_theta_raw, 0);
output_px_detrend_x = detrend(output_px_raw, 0);
fprintf('Variáveis criadas para Eixo X: time_x, input_theta_detrend_x, output_px_detrend_x, Ts_x\n');

% --- Dados para o Eixo Y [6s, 9s] ---
t_start_y = 6; t_end_y = 9;
idx_y = (t >= t_start_y) & (t <= t_end_y);
time_y = t(idx_y);
input_phi_raw = lbd_full(1, idx_y)';
output_py_raw = pos_full(2, idx_y)';
Ts_y = mean(diff(time_y));
input_phi_detrend_y = detrend(input_phi_raw, 0);
output_py_detrend_y = detrend(output_py_raw, 0);
fprintf('Variáveis criadas para Eixo Y: time_y, input_phi_detrend_y, output_py_detrend_y, Ts_y\n');

% --- Dados para o Eixo Z [10s, 13s] ---
t_start_z = 10; t_end_z = 13;
idx_z = (t >= t_start_z) & (t <= t_end_z);
time_z = t(idx_z);
input_T_total_raw = sum(motors_full(:, idx_z), 1)';
output_pz_raw = pos_full(3, idx_z)';
Ts_z = mean(diff(time_z));
input_T_total_detrend_z = detrend(input_T_total_raw, 0);
output_pz_detrend_z = detrend(output_pz_raw, 0);
fprintf('Variáveis criadas para Eixo Z: time_z, input_T_total_detrend_z, output_pz_detrend_z, Ts_z\n');

fprintf('\nDados preparados. Abrir System Identification Tool ao escrever "ident".\n');
