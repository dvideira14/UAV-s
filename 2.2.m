csvfilename = '2024-04-04_log07.csv';
array = dlmread(csvfilename, ',', 1, 0);

% Extrair dados conforme o script
time_full = array(:,1)'*1e-3; % Tempo em segundos
pos_full = array(:,2:4)';    % Posição [px; py; pz] (3xN)
vel_full = array(:,5:7)';    % Velocidade [vx; vy; vz] (3xN)
lbd_full = array(:,8:10)'*pi/180; % Ângulos Euler [roll; pitch; yaw] em rad (3xN)
om_full = array(:,11:13)'*pi/180; % Velocidade angular [p; q; r] em rad/s (3xN)
% pos_ref = array(:,14:16)'; % Não necessário para 2.2
% yaw_ref = array(:,17)'; % Não necessário para 2.2
motors_full = array(:,18:21)'; % Sinais dos motores [m1; m2; m3; m4] (4xN), provavelmente PWM 0-65535

% Corrigir tempo inicial (opcional, mas bom para plots)
t = time_full - time_full(1);
% --- Fim: Adaptado de crazyflie_show_usdlog.m ---
% --- Dataset 1: Eixo X (Longitudinal) [2s a 5s] ---
t_start_x = 2; t_end_x = 5;
idx_x = (t >= t_start_x) & (t <= t_end_x);
time_x = t(idx_x);
input_theta = lbd_full(2, idx_x); % Input: Pitch angle (linha 2 de lbd_full)
output_px = pos_full(1, idx_x);   % Output: Position x (linha 1 de pos_full)

% --- Dataset 2: Eixo Y (Lateral) [6s a 9s] ---
t_start_y = 6; t_end_y = 9;
idx_y = (t >= t_start_y) & (t <= t_end_y);
time_y = t(idx_y);
input_phi = lbd_full(1, idx_y);   % Input: Roll angle (linha 1 de lbd_full)
output_py = pos_full(2, idx_y);   % Output: Position y (linha 2 de pos_full)

% --- Dataset 3: Eixo Z (Vertical) [10s a 13s] ---
t_start_z = 10; t_end_z = 13;
idx_z = (t >= t_start_z) & (t <= t_end_z);
time_z = t(idx_z);
% Input: Aproximação do Thrust Total pela soma dos sinais dos motores
input_T_total = sum(motors_full(:, idx_z), 1); % Soma as 4 linhas (motores) para cada instante
output_pz = pos_full(3, idx_z);     % Output: Drone height (linha 3 de pos_full)
% --- Plotagem Refinada para Alínea 2.2 ---
figure('Name', 'Alínea 2.2: Relação Input-Output Experimental');

% Gráfico para Dataset X (Gtheta,px)
ax1 = subplot(3, 1, 1); % Guarda o handle do eixo
yyaxis left;
plot(time_x, output_px, '-');
ylabel('Posição X, p_x (m)');
ylim_px = get(gca,'YLim'); % Guarda limites para consistência
hold on; grid on;

yyaxis right;
plot(time_x, input_theta, '-');
ylabel('Pitch, \theta (rad)');
ylim_theta = get(gca,'YLim'); % Guarda limites
hold off;
xlabel('Tempo (s)');
title('Dataset X [2s-5s]: Input \theta vs Output p_x');
legend('p_x', '\theta', 'Location', 'best');
% Ajustar limites se necessário para melhor visualização
yyaxis left; ylim(ax1, ylim_px);
yyaxis right; ylim(ax1, ylim_theta);

% Gráfico para Dataset Y (Gphi,py)
ax2 = subplot(3, 1, 2);
yyaxis left;
plot(time_y, output_py, '-');
ylabel('Posição Y, p_y (m)');
ylim_py = get(gca,'YLim');
hold on; grid on;

yyaxis right;
plot(time_y, input_phi, '-');
ylabel('Roll, \phi (rad)');
ylim_phi = get(gca,'YLim');
hold off;
xlabel('Tempo (s)');
title('Dataset Y [6s-9s]: Input \phi vs Output p_y');
legend('p_y', '\phi', 'Location', 'best');
yyaxis left; ylim(ax2, ylim_py);
yyaxis right; ylim(ax2, ylim_phi);


% Gráfico para Dataset Z (GT,pz)
ax3 = subplot(3, 1, 3);
yyaxis left;
plot(time_z, output_pz, '-');
ylabel('Altitude Z, p_z (m)');
ylim_pz = get(gca,'YLim');
hold on; grid on;

yyaxis right;
plot(time_z, input_T_total, '-');
ylabel({'Aprox. Thrust Total', '(Soma Sinais Motores)'}); % Unidade PWM somada
ylim_T = get(gca,'YLim');
hold off;
xlabel('Tempo (s)');
title('Dataset Z [10s-13s]: Input T_{total} vs Output p_z');
legend('p_z', 'T_{total}', 'Location', 'best');
yyaxis left; ylim(ax3, ylim_pz);
yyaxis right; ylim(ax3, ylim_T);

% Ajustar layout geral
sgtitle('Alínea 2.2: Visualização das Relações Input-Output por Eixo');
