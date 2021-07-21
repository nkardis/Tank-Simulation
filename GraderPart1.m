% Constants
e_SS = 70 * 10 ^ -6;
g = 9.81;
Patm = 101325;
rho_water = 998;
mu_water = 1.0 * 10 ^ -3;

% Part 1
Q = 200 / 60000;
D1 = 0.150;
e_D1 = e_SS / D1;
L1 = 25;
A_150 = (pi * D1 ^ 2) / 4;
v_150 = Q / A_150;
sum_K1 = 2.5;

Re_150 = ReynoldsNumber(v_150, D1, rho_water, mu_water);
f_150 = FanningFrictionFactor(Re_150, e_D1);
h_pipe2 = (2 * f_150 * L1 * v_150 ^ 2) / (D1 * g);
h_fit2 = (sum_K1 / (2 * g)) * v_150 ^ 2;

P2 = rho_water * g * ((0 - v_150 ^ 2) / (2 * g) + (15) - (h_pipe2 + h_fit2)) + Patm;

% Part 2
Q2 = Q/2;
D2 = 0.075;
L2 = 8;
L3 = 100 + L2;
e_D2 = e_SS / D2;
v2_150 = Q2 / A_150;
Re2_150 = ReynoldsNumber(v2_150, D1, rho_water, mu_water);
f2_150 = FanningFrictionFactor(Re2_150, e_D1);
Kred = Kreducer(Re2_150, f2_150, D1, D2);
sum_K3 = 0.17 + 1;
sum_K4 = 0.17 + 1 + 0.75;

A_75 = (pi * D2 ^ 2) / 4;
v_75 = Q2 / A_75;
Re_75 = ReynoldsNumber(v_75, D2, rho_water, mu_water);
f_75 = FanningFrictionFactor(Re_75, e_D2);

h_pipe3 = (2 * f_75 * L2 * v_75 ^ 2) / (D2 * g);
h_pipe4 = (2 * f_75 * L3 * v_75 ^ 2) / (D2 * g);

h_fit3 = (Kred / (2 * g)) * v2_150 ^ 2 + (sum_K3 / (2 * g)) * v_75 ^ 2;
h_fit4 = (Kred / (2 * g)) * v2_150 ^ 2 + (sum_K4 / (2 * g)) * v_75 ^ 2;

P3 = rho_water * g * ((v2_150 ^ 2 - v_75 ^ 2) / (2 * g) + (8) - (h_pipe3 + h_fit3)) + P2;
P4 = rho_water * g * ((v2_150 ^ 2 - v_75 ^ 2) / (2 * g) + (8) - (h_pipe4 + h_fit4)) + P2;

function F_f = FanningFrictionFactor(Re, e_D)

    if Re < 2100
        F_f = 16/Re;
    else
        F_f = (-1.737*log(0.0269*(e_D) - (2.185/Re)*log(0.269*(e_D)+(14.5/Re))))^-2;
    end

end

function Re = ReynoldsNumber(V, D, rho, mu)
    
    Re = (rho*V*D)/mu;

end

function Kred = Kreducer(Re, f_F, D1, D2)
    if Re < 2500
        Kred = (1.2 + 160 / Re) * ((D1/D2) ^ 4 - 1);
    else
        Kred = (0.6 + 0.48 * f_F) * (D1 / D2) ^ 2 * ((D1 / D2) ^ 2 - 1);
    end
end

function Kexp = Kexpander(Re, f_F, D1, D2)
    if Re < 4000
        Kexp = 2 * (1 - (D1 / D2) ^ 4);
    else
        Kexp = (1 + 0.8 * f_F) * (1 - (D1 / D2) ^ 2) ^ 2;
    end
end


        
