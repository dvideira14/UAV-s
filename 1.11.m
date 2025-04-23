clc;
clear;
s = tf('s');

% Vertical loop
G_pz_T = 28.57 / s^2;
figure;
rlocus(G_pz_T);
title('Root Locus of G_{T,p_z}(s) = 28.57/s^2');

% Lateral loop
G_py_phi = 9.81 / s^2;
figure;
rlocus(G_py_phi);
title('Root Locus of G_{\phi,p_y}(s) = 9.81/s^2');
