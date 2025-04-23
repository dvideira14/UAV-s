function R = Euler2R(lbd)
    % Implementação da sua matriz de rotação ZYX (ou outra convenção)
    phi = lbd(1); theta = lbd(2); psi = lbd(3); % Exemplo de ordem Roll, Pitch, Yaw
    Rx = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
    Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
    Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
    R = Rz*Ry*Rx; % Ordem ZYX
end