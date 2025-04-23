clc; clear; close all;

%% Parâmetros físicos
m = 0.035;         % massa [kg]
g = 9.81;          % gravidade [m/s^2]
d = 0.108;           % coeficiente de drag
theta_deg = 10;    % ângulo de cruzeiro [graus]
theta = deg2rad(theta_deg);

%% Matrizes auxiliares
I3 = eye(3); Z3 = zeros(3);
drag_term = -(1 + 1/m) * d * I3;

% Derivadas ∂v/∂λ para OP.1 (hover)
G_hover = g * [0  1  0;
              -1  0  0;
               0  0  0];

% Derivadas ∂v/∂λ para OP.2 (cruzeiro)
G_cruise = g * [ 0           -cos(theta)  0;
                 0           0           0;
                 0          -sin(theta)  0];

%% Montar matriz A para OP.1
A_OP1 = [Z3, I3, Z3, Z3;
         Z3, drag_term, G_hover, Z3;
         Z3, Z3, Z3, I3;
         Z3, Z3, Z3, Z3];

%% Montar matriz A para OP.2
A_OP2 = [Z3, I3, Z3, Z3;
         Z3, drag_term, G_cruise, Z3;
         Z3, Z3, Z3, I3;
         Z3, Z3, Z3, Z3];

%% Calcular autovalores e autovetores
[V_OP1, D_OP1] = eig(A_OP1);
[V_OP2, D_OP2] = eig(A_OP2);
eig_OP1 = diag(D_OP1);
eig_OP2 = diag(D_OP2);

%% Plot dos autovalores no plano complexo
figure;
plot(real(eig_OP1), imag(eig_OP1), 'bx', 'MarkerSize', 8, 'DisplayName', 'Hover (OP1)'); hold on;
plot(real(eig_OP2), imag(eig_OP2), 'ro', 'MarkerSize', 8, 'DisplayName', 'Cruzeiro (OP2)');
xline(0, '--k'); grid on; axis equal;
xlabel('Parte Real'); ylabel('Parte Imaginária');
title('Autovalores dos Modelos Linearizados');
legend('Location', 'best');

%% Análise dos modos com decomposição física
disp('--- Análise dos Autovalores com Decomposição Física ---');
analisar_modos(D_OP1, V_OP1, 'Hover (OP1)');
analisar_modos(D_OP2, V_OP2, 'Cruzeiro (OP2)');

%% Função auxiliar
function analisar_modos(D, V, nome)
    fprintf('\n>>> %s <<<\n', nome);
    lambdas = diag(D);
    for i = 1:length(lambdas)
        lambda = lambdas(i);
        v = V(:,i);

        % Decompor autovetor nos 4 grupos: [p; v; λ; ω]
        p   = v(1:3);
        vlin = v(4:6);
        lambda_angles = v(7:9);
        omega = v(10:12);

        % Energia relativa por grupo
        E_p   = norm(p)^2;
        E_v   = norm(vlin)^2;
        E_ang = norm(lambda_angles)^2;
        E_omg = norm(omega)^2;
        E_total = E_p + E_v + E_ang + E_omg;

        perc = 100 * [E_p, E_v, E_ang, E_omg] / E_total;
        [~, idx] = max(perc);
        switch idx
            case 1, tipo = 'Posição (p)';
            case 2, tipo = 'Velocidade (v)';
            case 3, tipo = 'Orientação (λ)';
            case 4, tipo = 'Veloc. Angular (ω)';
        end

        % Estabilidade
        if abs(imag(lambda)) < 1e-6
            if real(lambda) < 0
                estabilidade = 'Real Estável';
            elseif real(lambda) > 0
                estabilidade = 'Real Instável';
            else
                estabilidade = 'Integrador';
            end
        else
            if real(lambda) < 0
                estabilidade = 'Complexo Estável';
            elseif real(lambda) > 0
                estabilidade = 'Complexo Instável';
            else
                estabilidade = 'Oscilação Não Amortecida';
            end
        end

        % Imprimir resultado
        fprintf('  λ_%2d = %+7.4f %+7.4fi → %-22s | Modo dominante: %-16s [%.1f%%]\n', ...
            i, real(lambda), imag(lambda), estabilidade, tipo, perc(idx));
    end
end
