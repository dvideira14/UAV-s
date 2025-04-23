function dxdt = drone_dynamics_ode(t, x, params)
    % Desempacotar estados
    p = x(1:3);
    v = x(4:6);
    lbd = x(7:9); % Assume phi, theta, psi (Verificar ordem!)
    om = x(10:12);

    % Desempacotar parâmetros
    m = params.m;
    g = params.g;
    J = params.J;
    J_inv = params.J_inv;
    D_drag = params.D_drag;
    fp = params.fp; % Força constante
    np = params.np; % Momento constante

    % Calcular Matriz de Rotação e Transformação Angular (Exemplo ZYX)
    % Certifique-se que estas funções correspondem à sua convenção
    R = Euler2R(lbd); % Rotação de Corpo para Inercial
    Q = Euler2Q(lbd); % Transformação de omega para lbd_dot

    % Calcular Forças
    zI = [0; 0; -1]; % Z inercial aponta para baixo (convenção g positivo)
    fg = m*g*R'*zI; % Força gravítica no referencial do corpo
    fa = -D_drag*v; % Força de arrasto no referencial do corpo

    % Calcular Derivadas
    p_dot = R*v;                                     % Derivada da posição
    v_dot = -skew(om)*v + (1/m)*(fp + fa + fg);      % Derivada da velocidade linear (corpo)
    lbd_dot = Q*om;                                  % Derivada dos ângulos de Euler
    om_dot = -J_inv*skew(om)*J*om + J_inv*np; % Derivada da velocidade angular (corpo)

    % Empacotar derivadas
    dxdt = [p_dot; v_dot; lbd_dot; om_dot];
end