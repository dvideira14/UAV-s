function x_dot = drone_nonlinear_model_completo(t, x, p)
    % Estado
    pos = x(1:3);
    vel = x(4:6);
    ang = x(7:9);
    omg = x(10:12);

    % Velocidades angulares dos motores
    w1 = p.w1; w2 = p.w2; w3 = p.w3; w4 = p.w4;

    % Thrusts individuais
    T1 = p.cT * w1^2;
    T2 = p.cT * w2^2;
    T3 = p.cT * w3^2;
    T4 = p.cT * w4^2;

    % Força total de propulsão
    fp = [0; 0; T1 + T2 + T3 + T4];

    % Torque total de propulsão
    L = p.L;
    cQ = p.cQ;
    np = [  L*sin(pi/4)*(w4^2 - w1^2) + L*sin(3*pi/4)*(w3^2 - w2^2);
            L*cos(pi/4)*(w4^2 - w1^2) + L*cos(3*pi/4)*(w3^2 - w2^2);
            cQ * (w1^2 - w2^2 + w3^2 - w4^2) ];

    % Dinâmica
    R = Euler2R(ang);
    Q = Euler2Q(ang);
    fg = p.m * p.g * R' * [0; 0; -1];

    pos_dot = R * vel;
    vel_dot = -skew(omg) * vel + (1/p.m)*(fp + p.fa .* vel.^2 + fg);
    ang_dot = Q * omg;
    omg_dot = -inv(p.J) * skew(omg) * p.J * omg + inv(p.J) * np;

    x_dot = [pos_dot; vel_dot; ang_dot; omg_dot];
end
