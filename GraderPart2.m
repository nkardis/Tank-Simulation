t = 0:1:300;

% Pre allocate memory
h = zeros(1, length(t));

% Create Figure
tiledlayout(2,1)
ax1 = nexttile;
ax2 = nexttile;

% Assume: 
% The tank is cylindrical vol = pi * r ^ 2 * h
% Minor Losses are ignored
% Flow is incompressable
% Tank is 10m tall
% Max height of water in the tank is 8m so it doesn't overflow
% Additionally, we don't want the tank to be empty, so minimum
% height is 1m. Radius is 4m. Let the starting height is 3m
% The pump is on to begin with.

h_min = 3; %[m]
h_max = 8; %[m]

vol_start =  pi * 4^2 * h_min;
vol_curr = vol_start;

r = 4;

% Pumps should be required to pump more in than out. If it was slower, the tank could run out of water

Qout = 4; % [m^3/0.01s]
Qin = 1.5 * Qout; % [m^3/0.01s]

pump_symbol_radius = 1;
l = linspace(0, 2*pi);
bool_Pump = 1;
bool_Exit = 0;

% Prints tank to Plot 1
hold(ax1, "on")   
axis(ax1,[-16 16 0 10]);

for k = 1 : length(t)
    h(k) = vol_curr / (pi * r ^ 2);
    
    % Tank plot 1
    text(ax1, -13, 8, sprintf("t = %.4f s", t(k)), 'FontSize', 12);
    patch(ax1, [-4 -4 4 4], [0 h(k) h(k) 0], 'b');
    patch(ax1, [-4 -4 4 4], [10 h(k) h(k) 10], 'w');
    
    % If the current height of the tank is less that the minimum height
    % Draw the "Pump" side of the simulation
    if h(k) <= h_min
        
        patch(ax1, [-16 -16 -4 -4], [1 2 2 1], 'b');
        patch(ax1, pump_symbol_radius * cos(l) - 10, pump_symbol_radius * sin(l) + 1.5, 'y');
        patch(ax1, [4 4 16 16], [1 2 2 1], 'w');
         
        patch(ax1, [10 10 14 14], [3 5 5 3], 'w', 'LineStyle', 'none');
        text(ax1, 10, 4, "Exit Off", 'FontSize', 12);
        patch(ax1, [-11 -11 -4.5 -4.5], [3 5 5 3], 'w', 'LineStyle', 'none');
        text(ax1, -10, 4,"Pump On", 'FontSize', 12);
        
    end
    
    % If the current height of the tank is greater than or equal to the max
    % height. Draw the "Exit" side of the simulation
    if h(k) >= h_max
        
        patch(ax1, [4 4 16 16], [1 2 2 1], 'b');
        patch(ax1, [-16 -16 -4 -4], [1 2 2 1], 'w');
        patch(ax1, pump_symbol_radius * cos(l) - 10, pump_symbol_radius * sin(l) + 1.5, 'w');
        
        patch(ax1, [-11 -11 -4.5 -4.5], [3 5 5 3], 'w', 'LineStyle', 'none');
        text(ax1, -10, 4,"Pump Off", 'FontSize', 12);
        patch(ax1, [10 10 14 14], [3 5 5 3], 'w', 'LineStyle', 'none');
        text(ax1, 10, 4, "Exit On", 'FontSize', 12);
        
    end
    
    % Plot 2
    hold(ax2, "on")
    grid(ax2, "on")
    plot(ax2, t(1:k), h(1:k), '-r')
    axis(ax2, [0 300 0 10]);
    
    hold on
    grid on
    
    pause(0.05);
    
    % Draws rectangle over timer on Plot 1 so there is no text overlap
    patch(ax1, [-14 -14 -5 -5], [6 10 10 6], 'w', 'LineStyle', 'none');
    
    if h(k) > h_max && bool_Pump == 1
        bool_Pump = 0;
        bool_Exit = 1;
    end
    
    if h(k) < h_min && bool_Exit == 1
        bool_Pump = 1;
        bool_Exit = 0;
    end
    
    % Delta Q equations to add or subtract volume from tank depending on
    % if the tank or the exit is on.
    if bool_Pump == 1
        vol_curr = vol_curr + Qin;
    else
        vol_curr = vol_curr - Qout;
    end
end
