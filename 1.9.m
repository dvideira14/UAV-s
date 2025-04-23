clc;
clear;

%% Parameters
m = 0.035;              % Mass [kg]
g = 9.81;               % Gravity [m/s^2]
d = 0.108;                % Drag coefficient (assumed)
I3 = eye(3);
Z3 = zeros(3);
D = d * I3;

% Inertia matrix (example)
J = diag([8.06e-6, 9.71e-6, 1.41e-6]);
J_inv = inv(J);

%% Gravitational coupling matrix - Hover mode
M_hover = [ 0 1 0;
           -1 0 0;
            0 0 0 ];

%% A matrix - Hover
A_hover = [ Z3    I3        Z3         Z3;
            Z3 -((1+1/m)*D) g*M_hover  Z3;
            Z3    Z3        Z3         I3;
            Z3    Z3        Z3         Z3 ];

%% Input and Output matrices
B = [ zeros(3,1), zeros(3,3);
      [0; 0; 1]/m, zeros(3,3);
      zeros(3,1), zeros(3,3);
      zeros(3,1), J_inv ];
  
C = eye(12);

%% --- HOVER MODE ANALYSIS ---
fprintf('--- HOVER MODE ---\n');

% Eigenvalues
eig_hover = eig(A_hover);
disp('Eigenvalues (Hover):');
disp(eig_hover);

% Jordan form
[J_hover, ~] = jordan(A_hover);
disp('Jordan Matrix (Hover):');
disp(J_hover);

% Controllability & Observability
Co_hover = ctrb(A_hover, B);
Ob_hover = obsv(A_hover, C);

fprintf('Rank of controllability matrix (Hover): %d (out of 12)\n', rank(Co_hover));
fprintf('Rank of observability matrix (Hover): %d (out of 12)\n', rank(Ob_hover));

%% ----------------------
%% Horizontal Flight Mode
theta = deg2rad(10); % 10 degrees tilt
cos_theta = cos(theta);
sin_theta = sin(theta);

% Modified gravity projection
M_flight = [ 0          g * cos_theta   0;
             0          0               0;
             0         -g * sin_theta   0 ];

A_flight = A_hover;
A_flight(4:6, 7:9) = M_flight;

%% --- FLIGHT MODE ANALYSIS ---
fprintf('\n--- HORIZONTAL FLIGHT MODE ---\n');

% Eigenvalues
eig_flight = eig(A_flight);
disp('Eigenvalues (Flight):');
disp(eig_flight);

% Jordan form
[J_flight, ~] = jordan(A_flight);
disp('Jordan Matrix (Flight):');
disp(J_flight);

% Controllability & Observability
Co_flight = ctrb(A_flight, B);
Ob_flight = obsv(A_flight, C);

fprintf('Rank of controllability matrix (Flight): %d (out of 12)\n', rank(Co_flight));
fprintf('Rank of observability matrix (Flight): %d (out of 12)\n', rank(Ob_flight));
