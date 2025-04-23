% Parâmetros físicos
Jx = 8.06e-6;
Jy = 9.71e-6;
Jz = 1.41e-6;
m  = 0.035;
g  = 9.81;

% Funções de transferência (TFs)

% 1. G_{n_x,phi}(s) = 1 / (Jx * s^2)
num1 = [1];
den1 = [Jx 0 0];
G1 = tf(num1, den1);

% 2. G_{phi,p_y}(s) = -g / s^2
num2 = [-g];
den2 = [1 0 0];
G2 = tf(num2, den2);

% 3. G_{n_y,theta}(s) = 1 / (Jy * s^2)
num3 = [1];
den3 = [Jy 0 0];
G3 = tf(num3, den3);

% 4. G_{theta,p_x}(s) = g / s^2
num4 = [g];
den4 = [1 0 0];
G4 = tf(num4, den4);

% 5. G_{n_z,psi}(s) = 1 / (Jz * s^2)
num5 = [1];
den5 = [Jz 0 0];
G5 = tf(num5, den5);

% 6. G_{T,p_z}(s) = 1 / (m * s^2)
num6 = [1];
den6 = [m 0 0];
G6 = tf(num6, den6);

% Converter para espaço de estados (State-Space)
sys1 = ss(G1);
sys2 = ss(G2);
sys3 = ss(G3);
sys4 = ss(G4);
sys5 = ss(G5);
sys6 = ss(G6);

% (Opcional) Mostrar os sistemas
disp('Sistema 1: phi / n_x'), sys1
disp('Sistema 2: p_y / phi'), sys2
disp('Sistema 3: theta / n_y'), sys3
disp('Sistema 4: p_x / theta'), sys4
disp('Sistema 5: psi / n_z'), sys5
disp('Sistema 6: p_z / T'), sys6
