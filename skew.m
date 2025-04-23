function S = skew(v)
% Gera a matriz antissimétrica (skew-symmetric) de um vetor 3x1
% Entrada:
%   v - vetor 3x1
% Saída:
%   S - matriz 3x3 tal que S*w = cross(v, w)

S = [   0   -v(3)  v(2);
      v(3)   0   -v(1);
     -v(2)  v(1)   0 ];
end
