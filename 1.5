% Final nonlinear model simulation of the drone 
close all
clear all

% Constantes físicas
g = 9.81; % Gravidade
m = 0.035; % Massa do drone
z = 0.025; % Altura do drone
L = 0.0457;
ro = 1.225; % Densidade do ar at sea level
x = 0.052;
y = 0.04625;
d = 0.045; % Diâmetro das hélices
r = 0.029; % Braço
kT= 0.2025; % Constante de Thrust
cT = kT*ro*(((2*r)^4)/3600); % Coeficiente de Thrust
kQ = 0.11; % Constante de Torque
cQ = kQ*ro*(((2*r)^5)/3600); % Coeficiente de Torque
Axy = x*y;
Ayz = y*z;
Azx = z*x;
T = m*g*1.15 % Thrust com valor ligeiramente acima do peso
Q1 = (cQ/cT)*T
Q2 = -(cQ/cT)*T
Q3 = (cQ/cT)*T
Q4 = -(cQ/cT)*T

J = diag([1/12*m*(y^2+z^2), 1/12*m*(x^2+z^2), 1/12*m*(x^2+y^2)]);

% Matriz de arrasto 
Dx = 0.108; Dy = 0.108; Dz = 0.108;
D = diag([Dx, Dy, Dz]);
zI = [0; 0; -1];

% Posições dos rotores
p1 = [L*cos(45);-L*sin(45);0];
p2 = [-L*cos(135);-L*sin(135);0];
p3 = [-L*cos(135);L*sin(135);0];
p4 = [L*cos(45);L*sin(45);0];

% Thrust inicial 
T1 = T/4; T2 = T/4; T3 = T/4; T4 = T/4;

np = [  L*sin(pi/4)*(T4 - T1) + L*sin(3*pi/4)*(T3 - T2);
        L*cos(pi/4)*(T4 - T1) + L*cos(3*pi/4)*(T3 - T2);
        Q1+Q2+Q3+Q4 ];
fp = [0; 0; T1+T2+T3+T4];

% Parâmetros da simulação
nx = 12;
Dt = 0.01;
t = 0:Dt:25; 

Tt = [cT cT cT cT;
     -L*sin(45)*cT -L*sin(135)*cT L*sin(135)*cT L*sin(45)*cT;
     -L*cos(45)*cT L*cos(135)*cT L*cos(135)*cT -L*cos(45)*cT;
      cQ -cQ cQ -cQ];
u_static = Tt;

% Estado inicial
x0 = zeros(nx, 1);
x = zeros(nx, length(t));
x(:,1) = x0;

% Guardar u (control input) ao longo do tempo
u = zeros(4, length(t));

for k = 1:length(t)-1
    p = x(1:3,k);
    v = x(4:6,k);
    lbd = x(7:9,k);
    om = x(10:12,k);

    R = Euler2R(lbd);
    Q = Euler2Q(lbd);

% Lógica para manter voo estacionário após 10 metros
    if x(3,k) >= 10
        fp = [0; 0; m*g];
        np = [0; 0; 0];
    else
        fp = [0; 0; T];
        np = [0; 0; 0];
    end


    fg = m*g*R'*zI;
    fa = -D*v;

    p_dot = R*v;
    v_dot = -skew(om)*v + (1/m)*(fp + fa + fg);
    lbd_dot = Q*om;
    om_dot = -inv(J)*skew(om)*J*om + inv(J)*np;

    x_dot = [p_dot; v_dot; lbd_dot; om_dot];
    x(:,k+1) = x(:,k) + Dt * x_dot;

    % Guardar "u" real aplicado neste instante (usamos thrust total e torque)
    u(:,k) = [fp(3); np];
end

% Corrigir último valor de u para evitar salto para zero
u(:,end) = u(:,end-1);

% Visualizar
printFigs = 0;
example_name = 'P1-1.1.5';
vehicle3d_show_data(t, x, u, 0, [printFigs example_name], 1);
