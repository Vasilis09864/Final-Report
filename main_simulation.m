%% 
define_constants;
mpopt = mpoption('verbose', 0, 'out.all', 0); %removes other unwanted outputs
mpc = loadcase(case24_ieee_rts);


mpc.branch(:, 6) = mpc.branch(:, 6) * 1.2; 

loadfactor_08 = 0.8;
loadfactor_06 = 0.6;
loadfactor_04 = 0.4;
demand_factor = 1.1;

mpc108 = mpc;
mpc106 = mpc;
mpc104 = mpc;
mpc210 = mpc;
mpc208 = mpc;
mpc206 = mpc;
mpc204 = mpc;

mpc3 = mpc;


mpc310 = mpc3;
mpc308 = mpc3;
mpc306 = mpc3;
mpc304 = mpc3;




Pd_Orig = mpc.bus(:, 3);
Qd_Orig = mpc.bus(:, 4);


results_cycle1_10 = runopf(mpc, mpopt);
check_line_upgrades(results_cycle1_10, 'c1');

mpc108.bus(:, 3) = Pd_Orig * loadfactor_08; % Adjust active power demand
mpc108.bus(:, 4) = Qd_Orig * loadfactor_08; % Adjust reactive power demand

results_cycle1_08 = runopf(mpc108, mpopt);

mpc106.bus(:, 3) = Pd_Orig * loadfactor_06;
mpc106.bus(:, 4) = Qd_Orig * loadfactor_06;

results_cycle1_06 = runopf(mpc106, mpopt);

mpc104.bus(:, 3) = Pd_Orig * loadfactor_04; 
mpc104.bus(:, 4) = Qd_Orig * loadfactor_04; 

results_cycle1_04 = runopf(mpc104, mpopt);

mpc210.bus(:, 3) = Pd_Orig * demand_factor;
mpc210.bus(:, 4) = Qd_Orig * demand_factor;

results_cycle2_10 = runopf(mpc210, mpopt);
check_line_upgrades(results_cycle2_10, 'c2');

mpc208.bus(:, 3) = Pd_Orig * demand_factor * loadfactor_08;
mpc208.bus(:, 4) = Qd_Orig * demand_factor * loadfactor_08;

results_cycle2_08 = runopf(mpc208, mpopt);

mpc206.bus(:, 3) = Pd_Orig * demand_factor * loadfactor_06;
mpc206.bus(:, 4) = Qd_Orig * demand_factor * loadfactor_06;

results_cycle2_06 = runopf(mpc206, mpopt);

mpc204.bus(:, 3) = Pd_Orig * demand_factor * loadfactor_04; 
mpc204.bus(:, 4) = Qd_Orig * demand_factor * loadfactor_04;

results_cycle2_04 = runopf(mpc204, mpopt);

mpc310.bus(:,3) = Pd_Orig * demand_factor * demand_factor;
mpc310.bus(:,4) = Qd_Orig * demand_factor * demand_factor;

results_cycle3_10 = runopf(mpc310, mpopt);

mpc308.bus(:,3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc308.bus(:,4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08 = runopf(mpc308, mpopt);

mpc306.bus(:,3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc306.bus(:,4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06 = runopf(mpc306, mpopt);

mpc304.bus(:,3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04;
mpc304.bus(:,4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04 = runopf(mpc304, mpopt);

LDC1 = (((results_cycle1_10.f * 43800 * 0.2) + (results_cycle1_08.f * 43800 * 0.3) + (results_cycle1_06.f * 43800 * 0.3) + (results_cycle1_04.f * 43800 * 0.2)) * 0.72)/10^9;
LDC2 = (((results_cycle2_10.f * 43800 * 0.2) + (results_cycle2_08.f * 43800 * 0.3) + (results_cycle2_06.f * 43800 * 0.3) + (results_cycle2_04.f * 43800 * 0.2)) * 0.72)/10^9;
LDC3 = (((results_cycle3_10.f * 43800 * 0.2) + (results_cycle3_08.f * 43800 * 0.3) + (results_cycle3_06.f * 43800 * 0.3) + (results_cycle3_04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 1 in billions of pounds = ', num2str(LDC1)]);
disp(['cost of cycle 2 in billions of pounds = ', num2str(LDC2)]);
disp(['cost of cycle 3 in billions of pounds = ', num2str(LDC3)]);


Total_Maximum_Generation1 = sum(mpc.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand1 = sum(mpc.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation1 < Total_Peak_Demand1 * 1.05
    disp('Increased generation in cycle 1 is required.');
else
    disp('Generation in cycle 1 is OK.');
end

% CYCLE 2: Generation vs Demand Check
Total_Maximum_Generation2 = sum(mpc210.gen(:,9)); % Sums Pmax of all generation units
Total_Peak_Demand2 = sum(mpc210.bus(:,3)); % Sums Pd of all loads

% Checking if peak demand exceeds generation capacity
if Total_Maximum_Generation2 < Total_Peak_Demand2 * 1.05 
    disp('Increased generation in cycle 2 is required.'); 
else
    disp('Generation in cycle 2 is OK.');
end

Total_Maximum_Generation3 = sum(mpc310.gen(:,9)); 
Total_Peak_Demand3 = sum(mpc310.bus(:,3)); 

if Total_Maximum_Generation3 < Total_Peak_Demand3 * 1.05 
    disp('Increased generation in cycle 3 is required.');
else
    disp('Generation in cycle 3 is OK.');
end

%---------------------------------------------------------------------------------------------------

% %CYCLE 3-WIND

%---------------------------------------------------------------------------------------------------

mpc3_wind = mpc310;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_wind.gen = [mpc3_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_wind.gencost = [mpc3_wind.gencost; wind_cost_row];

new_wind_unit = [15, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_wind.gen = [mpc3_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_wind.gencost = [mpc3_wind.gencost; wind_cost_row];

mpc3_wind10 = mpc3_wind;
mpc3_wind08 = mpc3_wind;
mpc3_wind06 = mpc3_wind;
mpc3_wind04 = mpc3_wind; 

mpc3_wind10.bus(:, 3) = Pd_Orig * demand_factor * demand_factor;
mpc3_wind10.bus(:, 4) = Qd_Orig * demand_factor * demand_factor;

results_cycle3_10_wind = runopf(mpc3_wind10, mpopt);
check_line_upgrades(results_cycle3_10_wind, '3W');


mpc3_wind08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3_wind08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08_wind = runopf(mpc3_wind08, mpopt);


mpc3_wind06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3_wind06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_wind = runopf(mpc3_wind06, mpopt);


mpc3_wind04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3_wind04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_wind = runopf(mpc3_wind04, mpopt);

LDC3_wind = (((results_cycle3_10_wind.f * 43800 * 0.2) + (results_cycle3_08_wind.f * 43800 * 0.3) + (results_cycle3_06_wind.f * 43800 * 0.3) + (results_cycle3_04_wind.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_wind in billions of pounds = ', num2str(LDC3_wind)]);

Total_Maximum_Generation3_wind = sum(mpc3_wind10.gen(:,9)); 
Total_Peak_Demand3_wind = sum(mpc3_wind10.bus(:,3)); 

if Total_Maximum_Generation3_wind < Total_Peak_Demand3_wind * 1.05 
    disp('Increased generation in cycle 3_wind is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 3-WIND+SOLAR

%---------------------------------------------------------------------------------------------------

mpc3_wind_plus_solar = mpc310;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_wind_plus_solar.gen = [mpc3_wind_plus_solar.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_wind_plus_solar.gencost = [mpc3_wind_plus_solar.gencost; wind_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_wind_plus_solar.gen = [mpc3_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_wind_plus_solar.gencost = [mpc3_wind_plus_solar.gencost; solar_cost_row];


new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_wind_plus_solar.gen = [mpc3_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_wind_plus_solar.gencost = [mpc3_wind_plus_solar.gencost; solar_cost_row];

mpc3WS10 = mpc3_wind_plus_solar;
mpc3WS08 = mpc3_wind_plus_solar;
mpc3WS06= mpc3_wind_plus_solar;
mpc3WS04 = mpc3_wind_plus_solar; 
mpc3WS10.bus(:, 3) = Pd_Orig * demand_factor * demand_factor;
mpc3WS10.bus(:, 4) = Qd_Orig * demand_factor * demand_factor;

results_cycle3_10_WS = runopf(mpc3WS10, mpopt);
check_line_upgrades(results_cycle3_10_WS, '3WS');

mpc3WS08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3WS08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08_WS = runopf(mpc3WS08, mpopt);

mpc3WS06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3WS06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_WS = runopf(mpc3WS06, mpopt);

mpc3WS04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3WS04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_WS = runopf(mpc3WS04, mpopt);

LDC3_WS = (((results_cycle3_10_WS.f * 43800 * 0.2) + (results_cycle3_08_WS.f * 43800 * 0.3) + (results_cycle3_06_WS.f * 43800 * 0.3) + (results_cycle3_04_WS.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_wind+solar in billions of pounds = ', num2str(LDC3_WS)]);

Total_Maximum_Generation3_WS = sum(mpc3WS10.gen(:,9)); 
Total_Peak_Demand3_WS = sum(mpc3WS10.bus(:,3)); 

if Total_Maximum_Generation3_WS < Total_Peak_Demand3_WS * 1.05 
    disp('Increased generation in cycle 3_wind+solar is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 3-CCGT

%---------------------------------------------------------------------------------------------------

mpc3_CCGT = mpc310;

new_CCGT_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_CCGT.gen = [mpc3_CCGT.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc3_CCGT.gencost = [mpc3_CCGT.gencost; CCGT_cost_row];

mpc3_CCGT10 = mpc3_CCGT;
mpc3_CCGT08 = mpc3_CCGT;
mpc3_CCGT06 = mpc3_CCGT;
mpc3_CCGT04 = mpc3_CCGT; 

mpc3_CCGT10.bus(:, 3) = Pd_Orig * demand_factor * demand_factor;
mpc3_CCGT10.bus(:, 4) = Qd_Orig * demand_factor * demand_factor;

results_cycle3_10_CCGT = runopf(mpc3_CCGT10, mpopt);
check_line_upgrades(results_cycle3_10_CCGT, '3C');

mpc3_CCGT08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3_CCGT08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08_CCGT = runopf(mpc3_CCGT08, mpopt);

mpc3_CCGT06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3_CCGT06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_CCGT = runopf(mpc3_CCGT06, mpopt);

mpc3_CCGT04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3_CCGT04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_CCGT = runopf(mpc3_CCGT04, mpopt);

LDC3_CCGT = (((results_cycle3_10_CCGT.f * 43800 * 0.2) + (results_cycle3_08_CCGT.f * 43800 * 0.3) + (results_cycle3_06_CCGT.f * 43800 * 0.3) + (results_cycle3_04_CCGT.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_CCGT in billions of pounds = ', num2str(LDC3_CCGT)]);

Total_Maximum_Generation3_CCGT = sum(mpc3_CCGT10.gen(:,9)); 
Total_Peak_Demand3_CCGT = sum(mpc3_CCGT10.bus(:,3));

if Total_Maximum_Generation3_CCGT < Total_Peak_Demand3_CCGT * 1.05 
    disp('Increased generation in cycle 3_CCGT is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 3-SOLAR

%---------------------------------------------------------------------------------------------------


mpc3_solar = mpc310;

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_solar.gen = [mpc3_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_solar.gencost = [mpc3_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_solar.gen = [mpc3_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_solar.gencost = [mpc3_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_solar.gen = [mpc3_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_solar.gencost = [mpc3_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_solar.gen = [mpc3_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_solar.gencost = [mpc3_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_solar.gen = [mpc3_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_solar.gencost = [mpc3_solar.gencost; solar_cost_row];

mpc3_solar10 = mpc3_solar;
mpc3_solar08 = mpc3_solar;
mpc3_solar06= mpc3_solar;
mpc3_solar04 = mpc3_solar;

mpc3_solar10.bus(:, 3) = Pd_Orig * demand_factor * demand_factor;
mpc3_solar10.bus(:, 4) = Qd_Orig * demand_factor * demand_factor;

results_cycle3_10_solar = runopf(mpc3_solar10, mpopt);
check_line_upgrades(results_cycle3_10_solar, '3S');

mpc3_solar08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3_solar08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08_solar = runopf(mpc3_solar08, mpopt);

mpc3_solar06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3_solar06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_solar = runopf(mpc3_solar06, mpopt);

mpc3_solar04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3_solar04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_solar = runopf(mpc3_solar04, mpopt);

LDC3_solar = (((results_cycle3_10_solar.f * 43800 * 0.2) + (results_cycle3_08_solar.f * 43800 * 0.3) + (results_cycle3_06_solar.f * 43800 * 0.3) + (results_cycle3_04_solar.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_solar in billions of pounds = ', num2str(LDC3_solar)]);

Total_Maximum_Generation3_solar = sum(mpc3_solar10.gen(:,9)); 
Total_Peak_Demand3_solar = sum(mpc3_solar10.bus(:,3)); 

if Total_Maximum_Generation3_solar < Total_Peak_Demand3_solar * 1.05 
    disp('Increased generation in cycle 3_solar is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 3-NUCLEAR

%---------------------------------------------------------------------------------------------------

mpc3_nuclear = mpc310;
mpc3_nuclear.branch(23, 6) = mpc3_nuclear.branch(23, 6) * 2; 
mpc3_nuclear.branch(29, 6) = mpc3_nuclear.branch(29, 6) * 2; 


reactor_1 = [16, 0, 0, 200, -50, 1.05, 100, 1, 800, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_nuclear.gen = [mpc3_nuclear.gen; reactor_1];

reactor_2 = [16, 0, 0, 200, -50, 1.05, 100, 1, 800, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_nuclear.gen = [mpc3_nuclear.gen; reactor_2];

nuc_cost_row = [2, 1500, 0, 3, 0, 4, 510]; 
mpc3_nuclear.gencost = [mpc3_nuclear.gencost; nuc_cost_row; nuc_cost_row];

mpc3_nuclear10 = mpc3_nuclear;
mpc3_nuclear08 = mpc3_nuclear;
mpc3_nuclear06 = mpc3_nuclear;
mpc3_nuclear04 = mpc3_nuclear; 

mpc3_nuclear10.bus(:, 3) = Pd_Orig * demand_factor * demand_factor;
mpc3_nuclear10.bus(:, 4) = Qd_Orig * demand_factor * demand_factor;

results_cycle3_10_nuclear = runopf(mpc3_nuclear10, mpopt);
check_line_upgrades(results_cycle3_10_nuclear, '3N');

mpc3_nuclear08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3_nuclear08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08_nuclear = runopf(mpc3_nuclear08, mpopt);

mpc3_nuclear06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3_nuclear06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_nuclear = runopf(mpc3_nuclear06, mpopt);

mpc3_nuclear04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3_nuclear04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_nuclear = runopf(mpc3_nuclear04, mpopt);

LDC3_nuclear = (((results_cycle3_10_nuclear.f * 43800 * 0.2) + (results_cycle3_08_nuclear.f * 43800 * 0.3) + (results_cycle3_06_nuclear.f * 43800 * 0.3) + (results_cycle3_04_nuclear.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_nuclear in billions of pounds = ', num2str(LDC3_nuclear)]);


Total_Maximum_Generation3_nuclear = sum(mpc3_nuclear10.gen(:,9));
Total_Peak_Demand3_nuclear = sum(mpc3_nuclear10.bus(:,3)); 
if Total_Maximum_Generation3_nuclear < Total_Peak_Demand3_nuclear * 1.05 
    disp('Increased generation in cycle 3_nuclear is required.');
end




%---------------------------------------------------------------------------------------------------


%CYCLE 4 


%---------------------------------------------------------------------------------------------------

%CYCLE 4-WIND+SOLAR+SOLAR

%---------------------------------------------------------------------------------------------------

mpc4_wind_plus_solar = mpc3_wind_plus_solar;

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind_plus_solar.gen = [mpc4_wind_plus_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind_plus_solar.gencost = [mpc4_wind_plus_solar.gencost; solar_cost_row];

mpc4WSS10 = mpc4_wind_plus_solar;
mpc4WSS08 = mpc4_wind_plus_solar;
mpc4WSS06= mpc4_wind_plus_solar;
mpc4WSS04 = mpc4_wind_plus_solar; 
mpc4WSS10.bus(:, 3) = Pd_Orig * demand_factor^3;
mpc4WSS10.bus(:, 4) = Qd_Orig * demand_factor^3;

results_cycle4_10_WSS = runopf(mpc4WSS10, mpopt);
check_line_upgrades(results_cycle4_10_WSS, '4WSS');

mpc4WSS08.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4WSS08.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle4_08_WSS = runopf(mpc4WSS08, mpopt);

mpc4WSS06.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_06;
mpc4WSS06.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle4_06_WSS = runopf(mpc4WSS06, mpopt);

mpc4WSS04.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_04; 
mpc4WSS04.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle4_04_WSS = runopf(mpc4WSS04, mpopt);

LDC4_WSS = (((results_cycle4_10_WSS.f * 43800 * 0.2) + (results_cycle4_08_WSS.f * 43800 * 0.3) + (results_cycle4_06_WSS.f * 43800 * 0.3) + (results_cycle4_04_WSS.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_wind+solar+solar in billions of pounds = ', num2str(LDC4_WSS)]);


Total_Maximum_Generation4_WSS = sum(mpc4WSS10.gen(:,9));
Total_Peak_Demand4_WSS = sum(mpc4WSS10.bus(:,3)); 
if Total_Maximum_Generation4_WSS < Total_Peak_Demand4_WSS * 1.05 
    disp('Increased generation in cycle 4_wind+solar+solar is required.');
end

%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------

%CYCLE 4-WIND+SOLAR+WIND

%---------------------------------------------------------------------------------------------------

mpc4_WSW = mpc3_wind_plus_solar;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_WSW.gen = [mpc4_WSW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_WSW.gencost = [mpc4_WSW.gencost; wind_cost_row];

new_wind_unit = [15, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_WSW.gen = [mpc4_WSW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_WSW.gencost = [mpc4_WSW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_WSW.gen = [mpc4_WSW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_WSW.gencost = [mpc4_WSW.gencost; wind_cost_row];


mpc4WSW10 = mpc4_WSW;
mpc4WSW08 = mpc4_WSW;
mpc4WSW06= mpc4_WSW;
mpc4WSW04 = mpc4_WSW; 

mpc4WSW10.bus(:, 3) = Pd_Orig * demand_factor^3;
mpc4WSW10.bus(:, 4) = Qd_Orig * demand_factor^3;

results_cycle4_10_WSW = runopf(mpc4WSW10, mpopt);
check_line_upgrades(results_cycle4_10_WSW, '4WSW');

mpc4WSW08.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4WSW08.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle4_08_WSW = runopf(mpc4WSW08, mpopt);

mpc4WSW06.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_06;
mpc4WSW06.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle4_06_WSW = runopf(mpc4WSW06, mpopt);

mpc4WSW04.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_04; 
mpc4WSW04.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle4_04_WSW = runopf(mpc4WSW04, mpopt);

LDC4_WSW = (((results_cycle4_10_WSW.f * 43800 * 0.2) + (results_cycle4_08_WSW.f * 43800 * 0.3) + (results_cycle4_06_WSW.f * 43800 * 0.3) + (results_cycle4_04_WSW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_wind+solar+wind in billions of pounds = ', num2str(LDC4_WSW)]);


Total_Maximum_Generation4_WSW = sum(mpc4WSW10.gen(:,9)); 
Total_Peak_Demand4_WSW = sum(mpc4WSW10.bus(:,3)); 
if Total_Maximum_Generation4_WSW < Total_Peak_Demand4_WSW * 1.05
    disp('Increased generation in cycle 4_wind+solar+wind is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 4-WIND+SOLAR+CCGT

%---------------------------------------------------------------------------------------------------

mpc4_WSG = mpc3_wind_plus_solar;

new_CCGT_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_WSG.gen = [mpc4_WSG.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc4_WSG.gencost = [mpc4_WSG.gencost; CCGT_cost_row];



mpc4WSG10 = mpc4_WSG;
mpc4WSG08 = mpc4_WSG;
mpc4WSG06= mpc4_WSG;
mpc4WSG04 = mpc4_WSG; 

mpc4WSG10.bus(:, 3) = Pd_Orig * demand_factor^3;
mpc4WSG10.bus(:, 4) = Qd_Orig * demand_factor^3;

results_cycle4_10_WSG = runopf(mpc4WSG10, mpopt);
check_line_upgrades(results_cycle4_10_WSG, '4WSC');

mpc4WSG08.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4WSG08.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle4_08_WSG = runopf(mpc4WSG08, mpopt);

mpc4WSG06.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_06;
mpc4WSG06.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle4_06_WSG = runopf(mpc4WSG06, mpopt);

mpc4WSG04.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_04; 
mpc4WSG04.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle4_04_WSG = runopf(mpc4WSG04, mpopt);


LDC4_WSG = (((results_cycle4_10_WSG.f * 43800 * 0.2) + (results_cycle4_08_WSG.f * 43800 * 0.3) + (results_cycle4_06_WSG.f * 43800 * 0.3) + (results_cycle4_04_WSG.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_wind+solar+CCGT in billions of pounds = ', num2str(LDC4_WSG)]);


Total_Maximum_Generation4_WSG = sum(mpc4WSG10.gen(:,9));
Total_Peak_Demand4_WSG = sum(mpc4WSG10.bus(:,3));

if Total_Maximum_Generation4_WSG < Total_Peak_Demand4_WSG * 1.05 
    disp('Increased generation in cycle 4_wind+solar+CCGT is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 4-WIND

%---------------------------------------------------------------------------------------------------
mpc4_wind = mpc3_wind;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind.gen = [mpc4_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind.gencost = [mpc4_wind.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_wind.gen = [mpc4_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_wind.gencost = [mpc4_wind.gencost; wind_cost_row];

mpc4_wind10 = mpc4_wind;
mpc4_wind08 = mpc4_wind;
mpc4_wind06 = mpc4_wind;
mpc4_wind04 = mpc4_wind; 

mpc4_wind10.bus(:, 3) = Pd_Orig * demand_factor^3;
mpc4_wind10.bus(:, 4) = Qd_Orig * demand_factor^3;

results_cycle4_10_wind = runopf(mpc4_wind10, mpopt);
check_line_upgrades(results_cycle4_10_wind, '4W');

mpc4_wind08.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4_wind08.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle4_08_wind = runopf(mpc4_wind08, mpopt);


mpc4_wind06.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_06;
mpc4_wind06.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle4_06_wind = runopf(mpc4_wind06, mpopt);


mpc4_wind04.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_04; 
mpc4_wind04.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle4_04_wind = runopf(mpc4_wind04, mpopt);

LDC4_wind = (((results_cycle4_10_wind.f * 43800 * 0.2) + (results_cycle4_08_wind.f * 43800 * 0.3) + (results_cycle4_06_wind.f * 43800 * 0.3) + (results_cycle4_04_wind.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_wind*3 in billions of pounds = ', num2str(LDC4_wind)]);

Total_Maximum_Generation4_wind = sum(mpc4_wind10.gen(:,9)); 
Total_Peak_Demand4_wind = sum(mpc4_wind10.bus(:,3)); 

if Total_Maximum_Generation4_wind < Total_Peak_Demand4_wind * 1.05 
    disp('Increased generation in cycle 4_wind*3 is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 4-CCGT

%---------------------------------------------------------------------------------------------------

mpc4_CCGT = mpc3_CCGT;

mpc4O10 = mpc4_CCGT;
mpc4O08 = mpc4_CCGT;
mpc4O06 = mpc4_CCGT;
mpc4O04 = mpc4_CCGT;

mpc4O10.bus(:,3) = Pd_Orig * demand_factor^3;
mpc4O10.bus(:,4) = Qd_Orig * demand_factor^3;

results_cycle_4O10 = runopf(mpc4O10, mpopt);
check_line_upgrades(results_cycle_4O10, '4C');

mpc4O08.bus(:,3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4O08.bus(:,4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle_4O08 = runopf(mpc4O08, mpopt);

mpc4O06.bus(:,3) = Pd_Orig * demand_factor^3* loadfactor_06;
mpc4O06.bus(:,4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle_4O06 = runopf(mpc4O06, mpopt);

mpc4O04.bus(:,3) = Pd_Orig * demand_factor^3 * loadfactor_04;
mpc4O04.bus(:,4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle_4O04 = runopf(mpc4O04, mpopt);

LDC4_CCGT = (((results_cycle_4O10.f * 43800 * 0.2) + (results_cycle_4O08.f * 43800 * 0.3) + (results_cycle_4O06.f * 43800 * 0.3) + (results_cycle_4O04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_CCGT in billions of pounds = ', num2str(LDC4_CCGT)]);

Total_Maximum_Generation_4O = sum(mpc4O10.gen(:,9));
Total_Peak_Demand_4O = sum(mpc4O10.bus(:,3)); 

if Total_Maximum_Generation_4O < Total_Peak_Demand_4O * 1.05 
    disp('Increased generation in cycle 4_CCGT is required.');

end

%---------------------------------------------------------------------------------------------------

%CYCLE 4-SOLAR

%---------------------------------------------------------------------------------------------------

mpc4_solar = mpc3_solar;


new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc4_solar.gen = [mpc4_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc4_solar.gencost = [mpc4_solar.gencost; solar_cost_row];

mpc4_solar10 = mpc4_solar;
mpc4_solar08 = mpc4_solar;
mpc4_solar06= mpc4_solar;
mpc4_solar04 = mpc4_solar; 

mpc4_solar10.bus(:, 3) = Pd_Orig * demand_factor^3;
mpc4_solar10.bus(:, 4) = Qd_Orig * demand_factor^3;

results_cycle4_10_solar = runopf(mpc4_solar10, mpopt);
check_line_upgrades(results_cycle4_10_solar, '4S');

mpc4_solar08.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4_solar08.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle4_08_solar = runopf(mpc4_solar08, mpopt);

mpc4_solar06.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_06;
mpc4_solar06.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle4_06_solar = runopf(mpc4_solar06, mpopt);

mpc4_solar04.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_04; 
mpc4_solar04.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle4_04_solar = runopf(mpc4_solar04, mpopt);

LDC4_solar = (((results_cycle4_10_solar.f * 43800 * 0.2) + (results_cycle4_08_solar.f * 43800 * 0.3) + (results_cycle4_06_solar.f * 43800 * 0.3) + (results_cycle4_04_solar.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_solar in billions of pounds = ', num2str(LDC4_solar)]);


Total_Maximum_Generation4_solar = sum(mpc4_solar10.gen(:,9)); 
Total_Peak_Demand4_solar = sum(mpc4_solar10.bus(:,3)); 

if Total_Maximum_Generation4_solar < Total_Peak_Demand4_solar * 1.05 
    disp('Increased generation in cycle 4_solar is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 4-NUCLEAR

%---------------------------------------------------------------------------------------------------

mpc4_nuclear = mpc3_nuclear;

mpc4_nuclear10 = mpc4_nuclear;
mpc4_nuclear08 = mpc4_nuclear;
mpc4_nuclear06 = mpc4_nuclear;
mpc4_nuclear04 = mpc4_nuclear; 
mpc4_nuclear10.bus(:, 3) = Pd_Orig * demand_factor^3;
mpc4_nuclear10.bus(:, 4) = Qd_Orig * demand_factor^3;

results_cycle4_10_nuclear = runopf(mpc4_nuclear10, mpopt);
check_line_upgrades(results_cycle4_10_nuclear, '4N');

mpc4_nuclear08.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_08;
mpc4_nuclear08.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_08;

results_cycle4_08_nuclear = runopf(mpc4_nuclear08, mpopt);

mpc4_nuclear06.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_06;
mpc4_nuclear06.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_06;

results_cycle4_06_nuclear = runopf(mpc4_nuclear06, mpopt);

mpc4_nuclear04.bus(:, 3) = Pd_Orig * demand_factor^3 * loadfactor_04; 
mpc4_nuclear04.bus(:, 4) = Qd_Orig * demand_factor^3 * loadfactor_04;

results_cycle4_04_nuclear = runopf(mpc4_nuclear04, mpopt);


LDC4_nuclear = (((results_cycle4_10_nuclear.f * 43800 * 0.2) + (results_cycle4_08_nuclear.f * 43800 * 0.3) + (results_cycle4_06_nuclear.f * 43800 * 0.3) + (results_cycle4_04_nuclear.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_nuclear in billions of pounds = ', num2str(LDC4_nuclear)]);

Total_Maximum_Generation4_nuclear = sum(mpc4_nuclear10.gen(:,9));
Total_Peak_Demand4_nuclear = sum(mpc4_nuclear10.bus(:,3)); 

if Total_Maximum_Generation4_nuclear < Total_Peak_Demand4_nuclear * 1.05 
    disp('Increased generation in cycle 4_nuclear is required.');
end




%---------------------------------------------------------------------------------------------------


%CYCLE 5


%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND+SOLAR+SOLAR+SOLAR

%---------------------------------------------------------------------------------------------------

mpc5_WSSS = mpc4_wind_plus_solar;
mpc5_WSSS.branch(9, 6) = mpc5_WSSS.branch(9, 6) * 2; 

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 5, 4 and 9
mpc5_WSSS.gen = [mpc5_WSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSS.gencost = [mpc5_WSSS.gencost; solar_cost_row];

mpc5WSSS10 = mpc5_WSSS;
mpc5WSSS08 = mpc5_WSSS;
mpc5WSSS06= mpc5_WSSS;
mpc5WSSS04 = mpc5_WSSS;

mpc5WSSS10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5WSSS10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_WSSS = runopf(mpc5WSSS10, mpopt);
check_line_upgrades(results_cycle5_10_WSSS, '5WSSS');


mpc5WSSS08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5WSSS08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_WSSS = runopf(mpc5WSSS08, mpopt);


mpc5WSSS06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5WSSS06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_WSSS = runopf(mpc5WSSS06, mpopt);


mpc5WSSS04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5WSSS04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_WSSS = runopf(mpc5WSSS04, mpopt);


LDC5_WSSS = (((results_cycle5_10_WSSS.f * 43800 * 0.2) + (results_cycle5_08_WSSS.f * 43800 * 0.3) + (results_cycle5_06_WSSS.f * 43800 * 0.3) + (results_cycle5_04_WSSS.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind+solar+solar+solar in billions of pounds = ', num2str(LDC5_WSSS)]);

Total_Maximum_Generation5_WSSS = sum(mpc5WSSS10.gen(:,9)); 
Total_Peak_Demand5_WSSS = sum(mpc5WSSS10.bus(:,3)); 

if Total_Maximum_Generation5_WSSS < Total_Peak_Demand5_WSSS * 1.05
    disp('Increased generation in cycle 5_wind+solar+solar+solar is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND+SOLAR+SOLAR+CCGT

%---------------------------------------------------------------------------------------------------

mpc5_WSSG = mpc4_wind_plus_solar;

new_CCGT_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc5_WSSG.gen = [mpc5_WSSG.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc5_WSSG.gencost = [mpc5_WSSG.gencost; CCGT_cost_row];

mpc5WSSG10 = mpc5_WSSG;
mpc5WSSG08 = mpc5_WSSG;
mpc5WSSG06= mpc5_WSSG;
mpc5WSSG04 = mpc5_WSSG;

mpc5WSSG10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5WSSG10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_WSSG = runopf(mpc5WSSG10, mpopt);
check_line_upgrades(results_cycle5_10_WSSG, '5WSSG');

mpc5WSSG08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5WSSG08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_WSSG = runopf(mpc5WSSG08, mpopt);

mpc5WSSG06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5WSSG06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_WSSG = runopf(mpc5WSSG06, mpopt);

mpc5WSSG04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5WSSG04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_WSSG = runopf(mpc5WSSG04, mpopt);

LDC5_WSSG = (((results_cycle5_10_WSSG.f * 43800 * 0.2) + (results_cycle5_08_WSSG.f * 43800 * 0.3) + (results_cycle5_06_WSSG.f * 43800 * 0.3) + (results_cycle5_04_WSSG.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind+solar+solar+CCGT in billions of pounds = ', num2str(LDC5_WSSG)]);

Total_Maximum_Generation5_WSSG = sum(mpc5WSSG10.gen(:,9)); 
Total_Peak_Demand5_WSSG = sum(mpc5WSSG10.bus(:,3));

if Total_Maximum_Generation5_WSSG < Total_Peak_Demand5_WSSG * 1.05 
    disp('Increased generation in cycle 5_wind+solar+solar+CCGT is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND+SOLAR+SOLAR+WIND

%---------------------------------------------------------------------------------------------------

mpc5_WSSW = mpc4_wind_plus_solar;


new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_WSSW.gen = [mpc5_WSSW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSW.gencost = [mpc5_WSSW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_WSSW.gen = [mpc5_WSSW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSW.gencost = [mpc5_WSSW.gencost; wind_cost_row];

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_WSSW.gen = [mpc5_WSSW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSSW.gencost = [mpc5_WSSW.gencost; wind_cost_row];

mpc5WSSW10 = mpc5_WSSW;
mpc5WSSW08 = mpc5_WSSW;
mpc5WSSW06= mpc5_WSSW;
mpc5WSSW04 = mpc5_WSSW;

mpc5WSSW10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5WSSW10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_WSSW = runopf(mpc5WSSW10, mpopt);
check_line_upgrades(results_cycle5_10_WSSW, '5WSSW');

mpc5WSSW08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5WSSW08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_WSSW = runopf(mpc5WSSW08, mpopt);

mpc5WSSW06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5WSSW06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_WSSW = runopf(mpc5WSSW06, mpopt);

mpc5WSSW04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5WSSW04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_WSSW = runopf(mpc5WSSW04, mpopt);


LDC5_WSSW = (((results_cycle5_10_WSSW.f * 43800 * 0.2) + (results_cycle5_08_WSSW.f * 43800 * 0.3) + (results_cycle5_06_WSSW.f * 43800 * 0.3) + (results_cycle5_04_WSSW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind+solar+solar+wind in billions of pounds = ', num2str(LDC5_WSSW)]);

Total_Maximum_Generation5_WSSW = sum(mpc5WSSW10.gen(:,9));
Total_Peak_Demand5_WSSW = sum(mpc5WSSW10.bus(:,3));

if Total_Maximum_Generation5_WSSW < Total_Peak_Demand5_WSSW * 1.05 
    disp('Increased generation in cycle 5_wind+solar+solar+wind is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND+SOLAR+CCGT+CCGT

%---------------------------------------------------------------------------------------------------


mpc5_WSGG = mpc4_WSG;

new_CCGT_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc5_WSGG.gen = [mpc5_WSGG.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc5_WSGG.gencost = [mpc5_WSGG.gencost; CCGT_cost_row];

mpc5WSGG10 = mpc5_WSGG;
mpc5WSGG08 = mpc5_WSGG;
mpc5WSGG06= mpc5_WSGG;
mpc5WSGG04 = mpc5_WSGG; 

mpc5WSGG10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5WSGG10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_WSGG = runopf(mpc5WSGG10, mpopt);

mpc5WSGG08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5WSGG08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_WSGG = runopf(mpc5WSGG08, mpopt);

mpc5WSGG06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5WSGG06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_WSGG = runopf(mpc5WSGG06, mpopt);

mpc5WSGG04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5WSGG04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_WSGG = runopf(mpc5WSGG04, mpopt);

LDC5_WSGG = (((results_cycle5_10_WSGG.f * 43800 * 0.2) + (results_cycle5_08_WSGG.f * 43800 * 0.3) + (results_cycle5_06_WSGG.f * 43800 * 0.3) + (results_cycle5_04_WSGG.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind+solar+CCGT+CCGT in billions of pounds = ', num2str(LDC5_WSGG)]);

Total_Maximum_Generation5_WSGG = sum(mpc5WSGG10.gen(:,9)); 
Total_Peak_Demand5_WSGG = sum(mpc5WSGG10.bus(:,3)); 

if Total_Maximum_Generation5_WSGG < Total_Peak_Demand5_WSGG * 1.05
    disp('Increased generation in cycle 5_wind+solar+CCGT+CCGT is required.');
end

%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND+SOLAR+CCGT+WIND

%---------------------------------------------------------------------------------------------------

mpc5_WSGW = mpc4_WSG;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_WSGW.gen = [mpc5_WSGW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSGW.gencost = [mpc5_WSGW.gencost; wind_cost_row];

mpc5WSGW10 = mpc5_WSGW;
mpc5WSGW08 = mpc5_WSGW;
mpc5WSGW06 = mpc5_WSGW;
mpc5WSGW04 = mpc5_WSGW; 

mpc5WSGW10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5WSGW10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_WSGW = runopf(mpc5WSGW10, mpopt);
check_line_upgrades(results_cycle5_10_WSGW, '5WSGW');


mpc5WSGW08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5WSGW08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_WSGW = runopf(mpc5WSGW08, mpopt);


mpc5WSGW06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5WSGW06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_WSGW = runopf(mpc5WSGW06, mpopt);


mpc5WSGW04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5WSGW04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_WSGW = runopf(mpc5WSGW04, mpopt);


LDC5_WSGW = (((results_cycle5_10_WSGW.f * 43800 * 0.2) + (results_cycle5_08_WSGW.f * 43800 * 0.3) + (results_cycle5_06_WSGW.f * 43800 * 0.3) + (results_cycle5_04_WSGW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind+solar+CCGT+wind in billions of pounds = ', num2str(LDC5_WSGW)]);

Total_Maximum_Generation5_WSGW = sum(mpc5WSGW10.gen(:,9)); 
Total_Peak_Demand5_WSGW = sum(mpc5WSGW10.bus(:,3)); 

if Total_Maximum_Generation5_WSGW < Total_Peak_Demand5_WSGW * 1.05 
    disp('Increased generation in cycle 5_wind+solar+CCGT+wind is required.');
end

%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND+SOLAR+WIND+WIND

%---------------------------------------------------------------------------------------------------

mpc5_WSWW = mpc4_WSW;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_WSWW.gen = [mpc5_WSWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSWW.gencost = [mpc5_WSWW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_WSWW.gen = [mpc5_WSWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_WSWW.gencost = [mpc5_WSWW.gencost; wind_cost_row];

mpc5WSWW10 = mpc5_WSWW;
mpc5WSWW08 = mpc5_WSWW;
mpc5WSWW06 = mpc5_WSWW;
mpc5WSWW04 = mpc5_WSWW; 

mpc5WSWW10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5WSWW10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_WSWW = runopf(mpc5WSWW10, mpopt);
check_line_upgrades(results_cycle5_10_WSWW, '5WSWW');


mpc5WSWW08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5WSWW08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_WSWW = runopf(mpc5WSWW08, mpopt);


mpc5WSWW06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5WSWW06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_WSWW = runopf(mpc5WSWW06, mpopt);


mpc5WSWW04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5WSWW04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_WSWW = runopf(mpc5WSWW04, mpopt);

LDC5_WSWW = (((results_cycle5_10_WSWW.f * 43800 * 0.2) + (results_cycle5_08_WSWW.f * 43800 * 0.3) + (results_cycle5_06_WSWW.f * 43800 * 0.3) + (results_cycle5_04_WSWW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind+solar+wind+wind in billions of pounds = ', num2str(LDC5_WSWW)]);


Total_Maximum_Generation5_WSWW = sum(mpc5WSWW10.gen(:,9)); 
Total_Peak_Demand5_WSWW = sum(mpc5WSWW10.bus(:,3));

if Total_Maximum_Generation5_WSWW < Total_Peak_Demand5_WSWW * 1.05 
    disp('Increased generation in cycle 5_wind+solar+wind+wind is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 5-WIND

%---------------------------------------------------------------------------------------------------
mpc5_wind = mpc4_wind;

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_wind.gen = [mpc5_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_wind.gencost = [mpc5_wind.gencost; wind_cost_row];

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_wind.gen = [mpc5_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_wind.gencost = [mpc5_wind.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc5_wind.gen = [mpc5_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_wind.gencost = [mpc5_wind.gencost; wind_cost_row];

mpc5_wind10 = mpc5_wind;
mpc5_wind08 = mpc5_wind;
mpc5_wind06 = mpc5_wind;
mpc5_wind04 = mpc5_wind; 

mpc5_wind10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5_wind10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_wind = runopf(mpc5_wind10, mpopt);
check_line_upgrades(results_cycle5_10_wind, '5W');

mpc5_wind08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5_wind08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_wind = runopf(mpc5_wind08, mpopt);

mpc5_wind06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5_wind06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_wind = runopf(mpc5_wind06, mpopt);

mpc5_wind04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5_wind04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_wind = runopf(mpc5_wind04, mpopt);

LDC5_wind = (((results_cycle5_10_wind.f * 43800 * 0.2) + (results_cycle5_08_wind.f * 43800 * 0.3) + (results_cycle5_06_wind.f * 43800 * 0.3) + (results_cycle5_04_wind.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_wind in billions of pounds = ', num2str(LDC5_wind)]);


Total_Maximum_Generation5_wind = sum(mpc5_wind10.gen(:,9));
Total_Peak_Demand5_wind = sum(mpc5_wind10.bus(:,3)); 

if Total_Maximum_Generation5_wind < Total_Peak_Demand5_wind * 1.05
    disp('Increased generation in cycle 5_wind is required.');
end



%---------------------------------------------------------------------------------------------------

%CYCLE 5-CCGT

%---------------------------------------------------------------------------------------------------
mpc5_CCGT = mpc4_CCGT;

new_CCGT_unit = [11, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc5_CCGT.gen = [mpc5_CCGT.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc5_CCGT.gencost = [mpc5_CCGT.gencost; CCGT_cost_row];

mpc5O10 = mpc5_CCGT;
mpc5O08 = mpc5_CCGT;
mpc5O06 = mpc5_CCGT;
mpc5O04 = mpc5_CCGT;

mpc5O10.bus(:,3) = Pd_Orig * demand_factor^4;
mpc5O10.bus(:,4) = Qd_Orig * demand_factor^4;

results_cycle_5O10 = runopf(mpc5O10, mpopt);
check_line_upgrades(results_cycle_5O10, '5C');


mpc5O08.bus(:,3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5O08.bus(:,4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle_5O08 = runopf(mpc5O08, mpopt);

mpc5O06.bus(:,3) = Pd_Orig * demand_factor^4* loadfactor_06;
mpc5O06.bus(:,4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle_5O06 = runopf(mpc5O06, mpopt);


mpc5O04.bus(:,3) = Pd_Orig * demand_factor^4 * loadfactor_04;
mpc5O04.bus(:,4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle_5O04 = runopf(mpc5O04, mpopt);


LDC5_CCGT = (((results_cycle_5O10.f * 43800 * 0.2) + (results_cycle_5O08.f * 43800 * 0.3) + (results_cycle_5O06.f * 43800 * 0.3) + (results_cycle_5O04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_CCGT in billions of pounds = ', num2str(LDC5_CCGT)]);


Total_Maximum_Generation_5O = sum(mpc5O10.gen(:,9)); 
Total_Peak_Demand_5O = sum(mpc5O10.bus(:,3)); 

if Total_Maximum_Generation_5O < Total_Peak_Demand_5O * 1.05 
    disp('Increased generation in cycle 5_CCGT is required.');

end

%---------------------------------------------------------------------------------------------------

%CYCLE 5-SOLAR

%---------------------------------------------------------------------------------------------------

mpc5_solar = mpc4_solar;
mpc5_solar.branch(9, 6) = mpc5_solar.branch(9, 6) * 2; 

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_solar.gen = [mpc5_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc5_solar.gencost = [mpc5_solar.gencost; solar_cost_row];

mpc5_solar10 = mpc5_solar;
mpc5_solar08 = mpc5_solar;
mpc5_solar06= mpc5_solar;
mpc5_solar04 = mpc5_solar; 

mpc5_solar10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5_solar10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_solar = runopf(mpc5_solar10, mpopt);
check_line_upgrades(results_cycle5_10_solar, '5S');

mpc5_solar08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5_solar08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_solar = runopf(mpc5_solar08, mpopt);

mpc5_solar06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5_solar06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_solar = runopf(mpc5_solar06, mpopt);

mpc5_solar04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5_solar04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_solar = runopf(mpc5_solar04, mpopt);


LDC5_solar = (((results_cycle5_10_solar.f * 43800 * 0.2) + (results_cycle5_08_solar.f * 43800 * 0.3) + (results_cycle5_06_solar.f * 43800 * 0.3) + (results_cycle5_04_solar.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_solar in billions of pounds = ', num2str(LDC5_solar)]);

Total_Maximum_Generation5_solar = sum(mpc5_solar10.gen(:,9)); 
Total_Peak_Demand5_solar = sum(mpc5_solar10.bus(:,3)); 

if Total_Maximum_Generation5_solar < Total_Peak_Demand5_solar * 1.05
    disp('Increased generation in cycle 5_solar is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 5-NUCLEAR

%---------------------------------------------------------------------------------------------------

mpc5_nuclear = mpc4_nuclear;
mpc5_nuclear.branch(6, 6) = mpc5_nuclear.branch(6, 6) * 2; 

reactor_3 = [3, 0, 0, 200, -50, 1.05, 100, 1, 800, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc5_nuclear.gen = [mpc5_nuclear.gen; reactor_3];

nuc_cost_row = [2, 1500, 0, 3, 0, 4, 510]; 
mpc5_nuclear.gencost = [mpc5_nuclear.gencost; nuc_cost_row;];

mpc5_nuclear10 = mpc5_nuclear;
mpc5_nuclear08 = mpc5_nuclear;
mpc5_nuclear06 = mpc5_nuclear;
mpc5_nuclear04 = mpc5_nuclear;

mpc5_nuclear10.bus(:, 3) = Pd_Orig * demand_factor^4;
mpc5_nuclear10.bus(:, 4) = Qd_Orig * demand_factor^4;

results_cycle5_10_nuclear = runopf(mpc5_nuclear10, mpopt);
check_line_upgrades(results_cycle5_10_nuclear, '5N');

mpc5_nuclear08.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_08;
mpc5_nuclear08.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_08;

results_cycle5_08_nuclear = runopf(mpc5_nuclear08, mpopt);

mpc5_nuclear06.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_06;
mpc5_nuclear06.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_06;

results_cycle5_06_nuclear = runopf(mpc5_nuclear06, mpopt);

mpc5_nuclear04.bus(:, 3) = Pd_Orig * demand_factor^4 * loadfactor_04; 
mpc5_nuclear04.bus(:, 4) = Qd_Orig * demand_factor^4 * loadfactor_04;

results_cycle5_04_nuclear = runopf(mpc5_nuclear04, mpopt);

LDC5_nuclear = (((results_cycle5_10_nuclear.f * 43800 * 0.2) + (results_cycle5_08_nuclear.f * 43800 * 0.3) + (results_cycle5_06_nuclear.f * 43800 * 0.3) + (results_cycle5_04_nuclear.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_nuclear in billions of pounds = ', num2str(LDC5_nuclear)]);

Total_Maximum_Generation5_nuclear = sum(mpc5_nuclear10.gen(:,9));
Total_Peak_Demand5_nuclear = sum(mpc5_nuclear10.bus(:,3));

if Total_Maximum_Generation5_nuclear < Total_Peak_Demand5_nuclear * 1.05 
    disp('Increased generation in cycle 5_nuclear is required.');
end

%-----------------------------------------------------------------------------------------------------




%---------------------------------------------------------------------------------------------------


%CYCLE 6


%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+SOLAR+SOLAR+SOLAR

%---------------------------------------------------------------------------------------------------

mpc6_WSSSS = mpc5_WSSS;
mpc6_WSSSS.branch(8, 6) = mpc6_WSSSS.branch(8, 6) * 2; 

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSSS.gen = [mpc6_WSSSS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSSS.gencost = [mpc6_WSSSS.gencost; solar_cost_row];


mpc6WSSSS10 = mpc6_WSSSS;
mpc6WSSSS08 = mpc6_WSSSS;
mpc6WSSSS06= mpc6_WSSSS;
mpc6WSSSS04 = mpc6_WSSSS;

mpc6WSSSS10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSSSS10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSSSS = runopf(mpc6WSSSS10, mpopt);
check_line_upgrades(results_cycle6_10_WSSSS, '6WSSSS');


mpc6WSSSS08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSSSS08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSSSS = runopf(mpc6WSSSS08, mpopt);


mpc6WSSSS06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSSSS06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSSSS = runopf(mpc6WSSSS06, mpopt);


mpc6WSSSS04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSSSS04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSSSS = runopf(mpc6WSSSS04, mpopt);


LDC6_WSSSS = (((results_cycle6_10_WSSSS.f * 43800 * 0.2) + (results_cycle6_08_WSSSS.f * 43800 * 0.3) + (results_cycle6_06_WSSSS.f * 43800 * 0.3) + (results_cycle6_04_WSSSS.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+solar+solar+solar in billions of pounds = ', num2str(LDC6_WSSSS)]);

Total_Maximum_Generation6_WSSSS = sum(mpc6WSSSS10.gen(:,9)); 
Total_Peak_Demand6_WSSSS = sum(mpc6WSSSS10.bus(:,3));

if Total_Maximum_Generation6_WSSSS < Total_Peak_Demand6_WSSSS * 1.05 
    disp('Increased generation in cycle 6_wind+solar+solar+solar+solar is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+SOLAR+SOLAR+CCGT

%---------------------------------------------------------------------------------------------------

mpc6_WSSSC = mpc5_WSSS;

new_CCGT_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc6_WSSSC.gen = [mpc6_WSSSC.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc6_WSSSC.gencost = [mpc6_WSSSC.gencost; CCGT_cost_row];

mpc6WSSSC10 = mpc6_WSSSC;
mpc6WSSSC08 = mpc6_WSSSC;
mpc6WSSSC06= mpc6_WSSSC;
mpc6WSSSC04 = mpc6_WSSSC;

mpc6WSSSC10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSSSC10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSSSC = runopf(mpc6WSSSC10, mpopt);
check_line_upgrades(results_cycle6_10_WSSSC, '6WSSSC');

mpc6WSSSC08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSSSC08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSSSC = runopf(mpc6WSSSC08, mpopt);

mpc6WSSSC06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSSSC06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSSSC = runopf(mpc6WSSSC06, mpopt);

mpc6WSSSC04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSSSC04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSSSC = runopf(mpc6WSSSC04, mpopt);

LDC6_WSSSC = (((results_cycle6_10_WSSSC.f * 43800 * 0.2) + (results_cycle6_08_WSSSC.f * 43800 * 0.3) + (results_cycle6_06_WSSSC.f * 43800 * 0.3) + (results_cycle6_04_WSSSC.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+solar+solar+CCGT in billions of pounds = ', num2str(LDC6_WSSSC)]);

Total_Maximum_Generation6_WSSSC = sum(mpc6WSSSC10.gen(:,9)); 
Total_Peak_Demand6_WSSSC = sum(mpc6WSSSC10.bus(:,3));

if Total_Maximum_Generation6_WSSSC < Total_Peak_Demand6_WSSSC * 1.05 
    disp('Increased generation in cycle 6_wind+solar+solar+solar+CCGT is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+SOLAR+CCGT+WIND

%---------------------------------------------------------------------------------------------------

mpc6_WSSCW = mpc5_WSSG;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSSCW.gen = [mpc6_WSSCW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSCW.gencost = [mpc6_WSSCW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSSCW.gen = [mpc6_WSSCW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSCW.gencost = [mpc6_WSSCW.gencost; wind_cost_row];

mpc6WSSCW10 = mpc6_WSSCW;
mpc6WSSCW08 = mpc6_WSSCW;
mpc6WSSCW06= mpc6_WSSCW;
mpc6WSSCW04 = mpc6_WSSCW;

mpc6WSSCW10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSSCW10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSSCW = runopf(mpc6WSSCW10, mpopt);
check_line_upgrades(results_cycle6_10_WSSCW, '6WSSCW');

mpc6WSSCW08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSSCW08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSSCW = runopf(mpc6WSSCW08, mpopt);

mpc6WSSCW06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSSCW06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSSCW = runopf(mpc6WSSCW06, mpopt);

mpc6WSSCW04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSSCW04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSSCW = runopf(mpc6WSSCW04, mpopt);

LDC6_WSSCW = (((results_cycle6_10_WSSCW.f * 43800 * 0.2) + (results_cycle6_08_WSSCW.f * 43800 * 0.3) + (results_cycle6_06_WSSCW.f * 43800 * 0.3) + (results_cycle6_04_WSSCW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+solar+CCGT+wind in billions of pounds = ', num2str(LDC6_WSSCW)]);

Total_Maximum_Generation6_WSSCW = sum(mpc6WSSCW10.gen(:,9));
Total_Peak_Demand6_WSSCW = sum(mpc6WSSCW10.bus(:,3)); 

if Total_Maximum_Generation6_WSSCW < Total_Peak_Demand6_WSSCW * 1.05
    disp('Increased generation in cycle 6_wind+solar+solar+CCGT+wind is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+SOLAR+CCGT+CCGT

%---------------------------------------------------------------------------------------------------


mpc6_WSSCC = mpc5_WSSG;

new_CCGT_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc6_WSSCC.gen = [mpc6_WSSCC.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc6_WSSCC.gencost = [mpc6_WSSCC.gencost; CCGT_cost_row];

mpc6WSSCC10 = mpc6_WSSCC;
mpc6WSSCC08 = mpc6_WSSCC;
mpc6WSSCC06= mpc6_WSSCC;
mpc6WSSCC04 = mpc6_WSSCC;

mpc6WSSCC10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSSCC10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSSCC = runopf(mpc6WSSCC10, mpopt);
check_line_upgrades(results_cycle6_10_WSSCC, '6WSSCC');


mpc6WSSCC08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSSCC08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSSCC = runopf(mpc6WSSCC08, mpopt);


mpc6WSSCC06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSSCC06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSSCC = runopf(mpc6WSSCC06, mpopt);


mpc6WSSCC04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSSCC04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSSCC = runopf(mpc6WSSCC04, mpopt);

LDC6_WSSCC = (((results_cycle6_10_WSSCC.f * 43800 * 0.2) + (results_cycle6_08_WSSCC.f * 43800 * 0.3) + (results_cycle6_06_WSSCC.f * 43800 * 0.3) + (results_cycle6_04_WSSCC.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+solar+CCGT+CCGT in billions of pounds = ', num2str(LDC6_WSSCC)]);

Total_Maximum_Generation6_WSSCC = sum(mpc6WSSCC10.gen(:,9)); 
Total_Peak_Demand6_WSSCC = sum(mpc6WSSCC10.bus(:,3));

if Total_Maximum_Generation6_WSSCC < Total_Peak_Demand6_WSSCC * 1.05 
    disp('Increased generation in cycle 6_wind+solar+solar+CCGT+CCGT is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+SOLAR+WIND+WIND

%---------------------------------------------------------------------------------------------------

mpc6_WSSWW = mpc5_WSSW;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSSWW.gen = [mpc6_WSSWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWW.gencost = [mpc6_WSSWW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSSWW.gen = [mpc6_WSSWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWW.gencost = [mpc6_WSSWW.gencost; wind_cost_row];

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSSWW.gen = [mpc6_WSSWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWW.gencost = [mpc6_WSSWW.gencost; wind_cost_row];

mpc6WSSWW10 = mpc6_WSSWW;
mpc6WSSWW08 = mpc6_WSSWW;
mpc6WSSWW06= mpc6_WSSWW;
mpc6WSSWW04 = mpc6_WSSWW;

mpc6WSSWW10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSSWW10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSSWW = runopf(mpc6WSSWW10, mpopt);
check_line_upgrades(results_cycle6_10_WSSWW, '6WSSWW');

mpc6WSSWW08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSSWW08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSSWW = runopf(mpc6WSSWW08, mpopt);

mpc6WSSWW06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSSWW06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSSWW = runopf(mpc6WSSWW06, mpopt);

mpc6WSSWW04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSSWW04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSSWW = runopf(mpc6WSSWW04, mpopt);

LDC6_WSSWW = (((results_cycle6_10_WSSWW.f * 43800 * 0.2) + (results_cycle6_08_WSSWW.f * 43800 * 0.3) + (results_cycle6_06_WSSWW.f * 43800 * 0.3) + (results_cycle6_04_WSSWW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+solar+wind+wind in billions of pounds = ', num2str(LDC6_WSSWW)]);

Total_Maximum_Generation6_WSSWW = sum(mpc6WSSWW10.gen(:,9)); 
Total_Peak_Demand6_WSSWW = sum(mpc6WSSWW10.bus(:,3));

if Total_Maximum_Generation6_WSSWW < Total_Peak_Demand6_WSSWW * 1.05
    disp('Increased generation in cycle 6_wind+solar+solar+wind+wind is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+SOLAR+WIND+SOLAR

%---------------------------------------------------------------------------------------------------

mpc6_WSSWS = mpc5_WSSW;
mpc6_WSSWS.branch(8, 6) = mpc6_WSSWS.branch(8, 6) * 2; 
mpc6_WSSWS.branch(9, 6) = mpc6_WSSWS.branch(9, 6) * 2; 

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %5,4,9
mpc6_WSSWS.gen = [mpc6_WSSWS.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSSWS.gencost = [mpc6_WSSWS.gencost; solar_cost_row];


mpc6WSSWS10 = mpc6_WSSWS;
mpc6WSSWS08 = mpc6_WSSWS;
mpc6WSSWS06= mpc6_WSSWS;
mpc6WSSWS04 = mpc6_WSSWS;

mpc6WSSWS10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSSWS10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSSWS = runopf(mpc6WSSWS10, mpopt);
check_line_upgrades(results_cycle6_10_WSSWS, '6WSSWS');

mpc6WSSWS08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSSWS08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSSWS = runopf(mpc6WSSWS08, mpopt);

mpc6WSSWS06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSSWS06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSSWS = runopf(mpc6WSSWS06, mpopt);

mpc6WSSWS04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSSWS04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSSWS = runopf(mpc6WSSWS04, mpopt);


LDC6_WSSWS = (((results_cycle6_10_WSSWS.f * 43800 * 0.2) + (results_cycle6_08_WSSWS.f * 43800 * 0.3) + (results_cycle6_06_WSSWS.f * 43800 * 0.3) + (results_cycle6_04_WSSWS.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+solar+wind+solar in billions of pounds = ', num2str(LDC6_WSSWS)]);


Total_Maximum_Generation6_WSSWS = sum(mpc6WSSWS10.gen(:,9)); 
Total_Peak_Demand6_WSSWS = sum(mpc6WSSWS10.bus(:,3)); 
if Total_Maximum_Generation6_WSSWS < Total_Peak_Demand6_WSSWS * 1.05 
    disp('Increased generation in cycle 6_wind+solar+solar+wind+solar is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+CCGT+CCGT+WIND

%---------------------------------------------------------------------------------------------------

mpc6_WSCCW = mpc5_WSGG;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCCW.gen = [mpc6_WSCCW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCCW.gencost = [mpc6_WSCCW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCCW.gen = [mpc6_WSCCW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCCW.gencost = [mpc6_WSCCW.gencost; wind_cost_row];

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCCW.gen = [mpc6_WSCCW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCCW.gencost = [mpc6_WSCCW.gencost; wind_cost_row];

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCCW.gen = [mpc6_WSCCW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCCW.gencost = [mpc6_WSCCW.gencost; wind_cost_row];

mpc6WSCCW10 = mpc6_WSCCW;
mpc6WSCCW08 = mpc6_WSCCW;
mpc6WSCCW06= mpc6_WSCCW;
mpc6WSCCW04 = mpc6_WSCCW;

mpc6WSCCW10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSCCW10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSCCW = runopf(mpc6WSCCW10, mpopt);
check_line_upgrades(results_cycle6_10_WSCCW, '6WSCCW');


mpc6WSCCW08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSCCW08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSCCW = runopf(mpc6WSCCW08, mpopt);

mpc6WSCCW06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSCCW06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSCCW = runopf(mpc6WSCCW06, mpopt);

mpc6WSCCW04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSCCW04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSCCW = runopf(mpc6WSCCW04, mpopt);

LDC6_WSCCW = (((results_cycle6_10_WSCCW.f * 43800 * 0.2) + (results_cycle6_08_WSCCW.f * 43800 * 0.3) + (results_cycle6_06_WSCCW.f * 43800 * 0.3) + (results_cycle6_04_WSCCW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+CCGT+CCGT+wind in billions of pounds = ', num2str(LDC6_WSCCW)]);

Total_Maximum_Generation6_WSCCW = sum(mpc6WSCCW10.gen(:,9)); 
Total_Peak_Demand6_WSCCW = sum(mpc6WSCCW10.bus(:,3));

if Total_Maximum_Generation6_WSCCW < Total_Peak_Demand6_WSCCW * 1.05
    disp('Increased generation in cycle 6_wind+solar+CCGT+CCGT+wind is required.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+CCGT+CCGT+CCGT

%---------------------------------------------------------------------------------------------------

%-----------------------CYCLE.6.WIND+SOLAR+CCGT+CCGT+CCGT----------------------------------------

mpc6_WSCCC = mpc5_WSGG;

new_CCGT_unit = [11, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc6_WSCCC.gen = [mpc6_WSCCC.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc6_WSCCC.gencost = [mpc6_WSCCC.gencost; CCGT_cost_row];

mpc6WSCCC10 = mpc6_WSCCC;
mpc6WSCCC08 = mpc6_WSCCC;
mpc6WSCCC06= mpc6_WSCCC;
mpc6WSCCC04 = mpc6_WSCCC;

mpc6WSCCC10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSCCC10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSCCC = runopf(mpc6WSCCC10, mpopt);
check_line_upgrades(results_cycle6_10_WSCCC, '6WSCCC');


mpc6WSCCC08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSCCC08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSCCC = runopf(mpc6WSCCC08, mpopt);

mpc6WSCCC06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSCCC06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSCCC = runopf(mpc6WSCCC06, mpopt);

mpc6WSCCC04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSCCC04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSCCC = runopf(mpc6WSCCC04, mpopt);

LDC6_WSCCC = (((results_cycle6_10_WSCCC.f * 43800 * 0.2) + (results_cycle6_08_WSCCC.f * 43800 * 0.3) + (results_cycle6_06_WSCCC.f * 43800 * 0.3) + (results_cycle6_04_WSCCC.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+CCGT+CCGT+CCGT in billions of pounds = ', num2str(LDC6_WSCCC)]);

Total_Maximum_Generation6_WSCCC = sum(mpc6WSCCC10.gen(:,9)); 
Total_Peak_Demand6_WSCCC = sum(mpc6WSCCC10.bus(:,3)); 

if Total_Maximum_Generation6_WSCCC < Total_Peak_Demand6_WSCCC * 1.05 
    disp('Increased generation in cycle 6_wind+solar+CCGT+CCGT+CCGT is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+CCGT+WIND+WIND

%---------------------------------------------------------------------------------------------------
mpc6_WSCWW= mpc5_WSGW;

new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCWW.gen = [mpc6_WSCWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCWW.gencost = [mpc6_WSCWW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCWW.gen = [mpc6_WSCWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCWW.gencost = [mpc6_WSCWW.gencost; wind_cost_row];

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSCWW.gen = [mpc6_WSCWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSCWW.gencost = [mpc6_WSCWW.gencost; wind_cost_row];

mpc6WSCWW10 = mpc6_WSCWW;
mpc6WSCWW08 = mpc6_WSCWW;
mpc6WSCWW06= mpc6_WSCWW;
mpc6WSCWW04 = mpc6_WSCWW;

mpc6WSCWW10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSCWW10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSCWW = runopf(mpc6WSCWW10, mpopt);
check_line_upgrades(results_cycle6_10_WSCWW, '6WSCWW');

mpc6WSCWW08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSCWW08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSCWW = runopf(mpc6WSCWW08, mpopt);

mpc6WSCWW06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSCWW06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSCWW = runopf(mpc6WSCWW06, mpopt);

mpc6WSCWW04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSCWW04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSCWW = runopf(mpc6WSCWW04, mpopt);

LDC6_WSCWW = (((results_cycle6_10_WSCWW.f * 43800 * 0.2) + (results_cycle6_08_WSCWW.f * 43800 * 0.3) + (results_cycle6_06_WSCWW.f * 43800 * 0.3) + (results_cycle6_04_WSCWW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+CCGT+wind+wind in billions of pounds = ', num2str(LDC6_WSCWW)]);

Total_Maximum_Generation6_WSCWW = sum(mpc6WSCWW10.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand6_WSCWW = sum(mpc6WSCWW10.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation6_WSCWW < Total_Peak_Demand6_WSCWW * 1.05 %checking whether the peak demand in the third cycle with solar generator exceeds generation capacity
    disp('Increased generation in cycle 6_wind+solar+CCGT+wind+wind is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND+SOLAR+WIND+WIND+WIND

%---------------------------------------------------------------------------------------------------

mpc6_WSWWW= mpc5_WSWW;


new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSWWW.gen = [mpc6_WSWWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSWWW.gencost = [mpc6_WSWWW.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSWWW.gen = [mpc6_WSWWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSWWW.gencost = [mpc6_WSWWW.gencost; wind_cost_row];

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_WSWWW.gen = [mpc6_WSWWW.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_WSWWW.gencost = [mpc6_WSWWW.gencost; wind_cost_row];


mpc6WSWWW10 = mpc6_WSWWW;
mpc6WSWWW08 = mpc6_WSWWW;
mpc6WSWWW06= mpc6_WSWWW;
mpc6WSWWW04 = mpc6_WSWWW;

mpc6WSWWW10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6WSWWW10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_WSWWW = runopf(mpc6WSWWW10, mpopt);
check_line_upgrades(results_cycle6_10_WSWWW, '6WSWWW');

mpc6WSWWW08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6WSWWW08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_WSWWW = runopf(mpc6WSWWW08, mpopt);

mpc6WSWWW06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6WSWWW06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_WSWWW = runopf(mpc6WSWWW06, mpopt);

mpc6WSWWW04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6WSWWW04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_WSWWW = runopf(mpc6WSWWW04, mpopt);


LDC6_WSWWW = (((results_cycle6_10_WSWWW.f * 43800 * 0.2) + (results_cycle6_08_WSWWW.f * 43800 * 0.3) + (results_cycle6_06_WSWWW.f * 43800 * 0.3) + (results_cycle6_04_WSWWW.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind+solar+wind+wind+wind in billions of pounds = ', num2str(LDC6_WSWWW)]);

Total_Maximum_Generation6_WSWWW = sum(mpc6WSWWW10.gen(:,9)); 
Total_Peak_Demand6_WSWWW = sum(mpc6WSWWW10.bus(:,3)); 

if Total_Maximum_Generation6_WSWWW < Total_Peak_Demand6_WSWWW * 1.05 
    disp('Increased generation in cycle 6_wind+solar+wind+wind+wind is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-WIND

%---------------------------------------------------------------------------------------------------
mpc6_wind = mpc5_wind;


new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_wind.gen = [mpc6_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_wind.gencost = [mpc6_wind.gencost; wind_cost_row];

new_wind_unit = [11, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_wind.gen = [mpc6_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_wind.gencost = [mpc6_wind.gencost; wind_cost_row];

new_wind_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %bus 24, 11 and 9
mpc6_wind.gen = [mpc6_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_wind.gencost = [mpc6_wind.gencost; wind_cost_row];

mpc6_wind10 = mpc6_wind;
mpc6_wind08 = mpc6_wind;
mpc6_wind06 = mpc6_wind;
mpc6_wind04 = mpc6_wind; 
mpc6_wind10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6_wind10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_wind = runopf(mpc6_wind10, mpopt);
check_line_upgrades(results_cycle6_10_wind, '6W');

mpc6_wind08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6_wind08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_wind = runopf(mpc6_wind08, mpopt);

mpc6_wind06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6_wind06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_wind = runopf(mpc6_wind06, mpopt);

mpc6_wind04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6_wind04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_wind = runopf(mpc6_wind04, mpopt);

LDC6_wind = (((results_cycle6_10_wind.f * 43800 * 0.2) + (results_cycle6_08_wind.f * 43800 * 0.3) + (results_cycle6_06_wind.f * 43800 * 0.3) + (results_cycle6_04_wind.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_wind in billions of pounds = ', num2str(LDC6_wind)]);

Total_Maximum_Generation6_wind = sum(mpc6_wind10.gen(:,9));
Total_Peak_Demand6_wind = sum(mpc6_wind10.bus(:,3)); 

if Total_Maximum_Generation6_wind < Total_Peak_Demand6_wind * 1.05 
    disp('Increased generation in cycle 6_wind is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-CCGT

%---------------------------------------------------------------------------------------------------

mpc6_CCGT = mpc5_CCGT;


new_CCGT_unit = [3, 0, 0, 80, -50, 1.05, 100, 1, 600, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; %23 and 11
mpc6_CCGT.gen = [mpc6_CCGT.gen; new_CCGT_unit];
CCGT_cost_row = [2, 1500, 0, 3, 0.001562, 7.92, 561];
mpc6_CCGT.gencost = [mpc6_CCGT.gencost; CCGT_cost_row];


mpc6O10 = mpc6_CCGT;
mpc6O08 = mpc6_CCGT;
mpc6O06 = mpc6_CCGT;
mpc6O04 = mpc6_CCGT;

mpc6O10.bus(:,3) = Pd_Orig * demand_factor^5;
mpc6O10.bus(:,4) = Qd_Orig * demand_factor^5;

results_cycle_6O10 = runopf(mpc6O10, mpopt);
check_line_upgrades(results_cycle_6O10, '6C');

mpc6O08.bus(:,3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6O08.bus(:,4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle_6O08 = runopf(mpc6O08, mpopt);

mpc6O06.bus(:,3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6O06.bus(:,4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle_6O06 = runopf(mpc6O06, mpopt);

mpc6O04.bus(:,3) = Pd_Orig * demand_factor^5 * loadfactor_04;
mpc6O04.bus(:,4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle_6O04 = runopf(mpc6O04, mpopt);

LDC6_CCGT = (((results_cycle_6O10.f * 43800 * 0.2) + (results_cycle_6O08.f * 43800 * 0.3) + (results_cycle_6O06.f * 43800 * 0.3) + (results_cycle_6O04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_CCGT in billions of pounds = ', num2str(LDC6_CCGT)]);

Total_Maximum_Generation_6O = sum(mpc6O10.gen(:,9)); 
Total_Peak_Demand_6O = sum(mpc6O10.bus(:,3)); 

if Total_Maximum_Generation_6O < Total_Peak_Demand_6O * 1.05 
    disp('Increased generation in cycle 6_CCGT is required.');

end


%---------------------------------------------------------------------------------------------------

%CYCLE 6-SOLAR

%---------------------------------------------------------------------------------------------------

mpc6_solar = mpc5_solar;
mpc6_solar.branch(8, 6) = mpc6_solar.branch(8, 6) * 2; 

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [5, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [4, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

new_solar_unit = [9, 0, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_solar.gen = [mpc6_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc6_solar.gencost = [mpc6_solar.gencost; solar_cost_row];

mpc6_solar10 = mpc6_solar;
mpc6_solar08 = mpc6_solar;
mpc6_solar06= mpc6_solar;
mpc6_solar04 = mpc6_solar;

mpc6_solar10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6_solar10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_solar = runopf(mpc6_solar10, mpopt);
check_line_upgrades(results_cycle6_10_solar, '6S');

mu_sf_10 = results_cycle6_10_solar.branch(:, MU_SF);
mu_st_10 = results_cycle6_10_solar.branch(:, MU_ST);

mpc6_solar08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6_solar08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_solar = runopf(mpc6_solar08, mpopt);


mpc6_solar06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6_solar06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_solar = runopf(mpc6_solar06, mpopt);


mpc6_solar04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6_solar04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_solar = runopf(mpc6_solar04, mpopt);

LDC6_solar = (((results_cycle6_10_solar.f * 43800 * 0.2) + (results_cycle6_08_solar.f * 43800 * 0.3) + (results_cycle6_06_solar.f * 43800 * 0.3) + (results_cycle6_04_solar.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_solar in billions of pounds = ', num2str(LDC6_solar)]);

Total_Maximum_Generation6_solar = sum(mpc6_solar10.gen(:,9)); 
Total_Peak_Demand6_solar = sum(mpc6_solar10.bus(:,3)); 

if Total_Maximum_Generation6_solar < Total_Peak_Demand6_solar * 1.05 
    disp('Increased generation in cycle 6_solar is required.');
end

%---------------------------------------------------------------------------------------------------

%CYCLE 6-NUCLEAR

%---------------------------------------------------------------------------------------------------

mpc6_nuclear = mpc5_nuclear;


reactor_4 = [3, 0, 0, 200, -50, 1.05, 100, 1, 800, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc6_nuclear.gen = [mpc6_nuclear.gen; reactor_4];

nuc_cost_row = [2, 1500, 0, 3, 0, 4, 510]; 
mpc6_nuclear.gencost = [mpc6_nuclear.gencost; nuc_cost_row;];

mpc6_nuclear10 = mpc6_nuclear;
mpc6_nuclear08 = mpc6_nuclear;
mpc6_nuclear06 = mpc6_nuclear;
mpc6_nuclear04 = mpc6_nuclear; 

mpc6_nuclear10.bus(:, 3) = Pd_Orig * demand_factor^5;
mpc6_nuclear10.bus(:, 4) = Qd_Orig * demand_factor^5;

results_cycle6_10_nuclear = runopf(mpc6_nuclear10, mpopt);
check_line_upgrades(results_cycle6_10_nuclear, '6N');

mpc6_nuclear08.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_08;
mpc6_nuclear08.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_08;

results_cycle6_08_nuclear = runopf(mpc6_nuclear08, mpopt);

mpc6_nuclear06.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_06;
mpc6_nuclear06.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_06;

results_cycle6_06_nuclear = runopf(mpc6_nuclear06, mpopt);

mpc6_nuclear04.bus(:, 3) = Pd_Orig * demand_factor^5 * loadfactor_04; 
mpc6_nuclear04.bus(:, 4) = Qd_Orig * demand_factor^5 * loadfactor_04;

results_cycle6_04_nuclear = runopf(mpc6_nuclear04, mpopt);

LDC6_nuclear = (((results_cycle6_10_nuclear.f * 43800 * 0.2) + (results_cycle6_08_nuclear.f * 43800 * 0.3) + (results_cycle6_06_nuclear.f * 43800 * 0.3) + (results_cycle6_04_nuclear.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 6_nuclear in billions of pounds = ', num2str(LDC6_nuclear)]);

Total_Maximum_Generation6_nuclear = sum(mpc6_nuclear10.gen(:,9)); 
Total_Peak_Demand6_nuclear = sum(mpc6_nuclear10.bus(:,3));

if Total_Maximum_Generation6_nuclear < Total_Peak_Demand6_nuclear * 1.05 
    disp('Increased generation in cycle 6_nuclear is required.');
end

%-----------------------------------------------------------------------------------------------------



function check_line_upgrades(results, scenario_name)
    define_constants;
    threshold = 1e-4;
    mu_sf = results.branch(:, MU_SF);
    mu_st = results.branch(:, MU_ST);
    
    for i = 1:38
        if mu_st(i) > threshold
            disp(['Line to upgrade (ST) is : ', num2str(i), ' ' scenario_name]); 
            
        end
        
        if mu_sf(i) > threshold
            disp(['Line to upgrade (SF) is : ', num2str(i), ' ' scenario_name]);
            
        end
    end
    end
    disp(' '); 