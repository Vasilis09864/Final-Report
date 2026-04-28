 
unction mpc = case24_ieee_rts
%CASE24_IEEE_RTS  Power flow data for the IEEE RELIABILITY TEST SYSTEM.
%   Please see CASEFORMAT for details on the case file format.
%
%   This system data is from the IEEE RELIABILITY TEST SYSTEM, see
%
%   IEEE Reliability Test System Task Force of the Applications of
%   Probability Methods Subcommittee, "IEEE reliability test system,"
%   IEEE Transactions on Power Apparatus and Systems, Vol. 98, No. 6,
%   Nov./Dec. 1979, pp. 2047-2054.
%
%   IEEE Reliability Test System Task Force of Applications of
%   Probability Methods Subcommittee, "IEEE reliability test system-96,"
%   IEEE Transactions on Power Systems, Vol. 14, No. 3, Aug. 1999,
%   pp. 1010-1020.
%
%   Cost data is from Web site run by Georgia Tech Power Systems Control
%   and Automation Laboratory:
%
%       http://pscal.ece.gatech.edu/testsys/index.html
%
%   MATPOWER case file data provided by Bruce Wollenberg.

%   MATPOWER

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	2	108	22	0	0	1	1	0	138	1	1.05	0.95;
	2	2	97	20	0	0	1	1	0	138	1	1.05	0.95;
	3	1	180	37	0	0	1	1	0	138	1	1.05	0.95;
	4	1	74	15	0	0	1	1	0	138	1	1.05	0.95;
	5	1	71	14	0	0	1	1	0	138	1	1.05	0.95;
	6	1	136	28	0	-100	2	1	0	138	1	1.05	0.95;
	7	2	125	25	0	0	2	1	0	138	1	1.05	0.95;
	8	1	171	35	0	0	2	1	0	138	1	1.05	0.95;
	9	1	175	36	0	0	1	1	0	138	1	1.05	0.95;
	10	1	195	40	0	0	2	1	0	138	1	1.05	0.95;
	11	1	0	0	0	0	3	1	0	230	1	1.05	0.95;
	12	1	0	0	0	0	3	1	0	230	1	1.05	0.95;
	13	3	265	54	0	0	3	1	0	230	1	1.05	0.95;
	14	2	194	39	0	0	3	1	0	230	1	1.05	0.95;
	15	2	317	64	0	0	4	1	0	230	1	1.05	0.95;
	16	2	100	20	0	0	4	1	0	230	1	1.05	0.95;
	17	1	0	0	0	0	4	1	0	230	1	1.05	0.95;
	18	2	333	68	0	0	4	1	0	230	1	1.05	0.95;
	19	1	181	37	0	0	3	1	0	230	1	1.05	0.95;
	20	1	128	26	0	0	3	1	0	230	1	1.05	0.95;
	21	2	0	0	0	0	4	1	0	230	1	1.05	0.95;
	22	2	0	0	0	0	4	1	0	230	1	1.05	0.95;
	23	2	0	0	0	0	3	1	0	230	1	1.05	0.95;
	24	1	0	0	0	0	4	1	0	230	1	1.05	0.95;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf	%	Unit Code
mpc.gen = [
	1	10	0	10	0	1.035	100	1	20	16	0	0	0	0	0	0	0	0	0	0	0;	%	U20
	1	10	0	10	0	1.035	100	1	20	16	0	0	0	0	0	0	0	0	0	0	0;	%	U20
	1	76	0	30	-25	1.035	100	1	76	15.2	0	0	0	0	0	0	0	0	0	0	0;	%	U76
	1	76	0	30	-25	1.035	100	1	76	15.2	0	0	0	0	0	0	0	0	0	0	0;	%	U76
	2	10	0	10	0	1.035	100	1	20	16	0	0	0	0	0	0	0	0	0	0	0;	%	U20
	2	10	0	10	0	1.035	100	1	20	16	0	0	0	0	0	0	0	0	0	0	0;	%	U20
	2	76	0	30	-25	1.035	100	1	76	15.2	0	0	0	0	0	0	0	0	0	0	0;	%	U76
	2	76	0	30	-25	1.035	100	1	76	15.2	0	0	0	0	0	0	0	0	0	0	0;	%	U76
	7	80	0	60	0	1.025	100	1	100	25	0	0	0	0	0	0	0	0	0	0	0;	%	U100
	7	80	0	60	0	1.025	100	1	100	25	0	0	0	0	0	0	0	0	0	0	0;	%	U100
	7	80	0	60	0	1.025	100	1	100	25	0	0	0	0	0	0	0	0	0	0	0;	%	U100
	13	95.1	0	80	0	1.02	100	1	197	69	0	0	0	0	0	0	0	0	0	0	0;	%	U197
	13	95.1	0	80	0	1.02	100	1	197	69	0	0	0	0	0	0	0	0	0	0	0;	%	U197
	13	95.1	0	80	0	1.02	100	1	197	69	0	0	0	0	0	0	0	0	0	0	0;	%	U197
	14	0	35.3	200	-50	0.98	100	1	0	0	0	0	0	0	0	0	0	0	0	0	0;	%	SynCond
	15	12	0	6	0	1.014	100	1	12	2.4	0	0	0	0	0	0	0	0	0	0	0;	%	U12
	15	12	0	6	0	1.014	100	1	12	2.4	0	0	0	0	0	0	0	0	0	0	0;	%	U12
	15	12	0	6	0	1.014	100	1	12	2.4	0	0	0	0	0	0	0	0	0	0	0;	%	U12
	15	12	0	6	0	1.014	100	1	12	2.4	0	0	0	0	0	0	0	0	0	0	0;	%	U12
	15	12	0	6	0	1.014	100	1	12	2.4	0	0	0	0	0	0	0	0	0	0	0;	%	U12
	15	155	0	80	-50	1.014	100	1	155	54.3	0	0	0	0	0	0	0	0	0	0	0;	%	U155
	16	155	0	80	-50	1.017	100	1	155	54.3	0	0	0	0	0	0	0	0	0	0	0;	%	U155
	18	400	0	200	-50	1.05	100	1	400	100	0	0	0	0	0	0	0	0	0	0	0;	%	U400
	21	400	0	200	-50	1.05	100	1	400	100	0	0	0	0	0	0	0	0	0	0	0;	%	U400
	22	50	0	16	-10	1.05	100	1	50	10	0	0	0	0	0	0	0	0	0	0	0;	%	U50
	22	50	0	16	-10	1.05	100	1	50	10	0	0	0	0	0	0	0	0	0	0	0;	%	U50
	22	50	0	16	-10	1.05	100	1	50	10	0	0	0	0	0	0	0	0	0	0	0;	%	U50
	22	50	0	16	-10	1.05	100	1	50	10	0	0	0	0	0	0	0	0	0	0	0;	%	U50
	22	50	0	16	-10	1.05	100	1	50	10	0	0	0	0	0	0	0	0	0	0	0;	%	U50
	22	50	0	16	-10	1.05	100	1	50	10	0	0	0	0	0	0	0	0	0	0	0;	%	U50
	23	155	0	80	-50	1.05	100	1	155	54.3	0	0	0	0	0	0	0	0	0	0	0;	%	U155
	23	155	0	80	-50	1.05	100	1	155	54.3	0	0	0	0	0	0	0	0	0	0	0;	%	U155
	23	350	0	150	-25	1.05	100	1	350	140	0	0	0	0	0	0	0	0	0	0	0;	%	U350
        
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.0026	0.0139	0.4611	175	250	200	0	0	1	-360	360;
	1	3	0.0546	0.2112	0.0572	175	208	220	0	0	1	-360	360;
	1	5	0.0218	0.0845	0.0229	175	208	220	0	0	1	-360	360;
	2	4	0.0328	0.1267	0.0343	175	208	220	0	0	1	-360	360;
	2	6	0.0497	0.192	0.052	175	208	220	0	0	1	-360	360;
	3	9	0.0308	0.119	0.0322	175	208	220	0	0	1	-360	360;
	3	24	0.0023	0.0839	0 400	175	600	1.03	0	1	-360	360;
	4	9	0.0268	0.1037	0.0281	175	208	220	0	0	1	-360	360;
	5	10	0.0228	0.0883	0.0239	175	208	220	0	0	1	-360	360;
	6	10	0.0139	0.0605	2.459	175	193	200	0	0	1	-360	360;
	7	8	0.0159	0.0614	0.0166	175	208	220	0	0	1	-360	360;
	8	9	0.0427	0.1651	0.0447	175	208	220	0	0	1	-360	360;
	8	10	0.0427	0.1651	0.0447	175	208	220	0	0	1	-360	360;
	9	11	0.0023	0.0839	0 400	510	600	1.03	0	1	-360	360;
	9	12	0.0023	0.0839	0 400	510	600	1.03	0	1	-360	360;
	10	11	0.0023	0.0839	0 400	510	600	1.02	0	1	-360	360;
	10	12	0.0023	0.0839	0 400	510	600	1.02	0	1	-360	360;
	11	13	0.0061	0.0476	0.0999	500	600	625	0	0	1	-360	360;
	11	14	0.0054	0.0418	0.0879	500	625	625	0	0	1	-360	360;
	12	13	0.0061	0.0476	0.0999	500	625	625	0	0	1	-360	360;
	12	23	0.0124	0.0966	0.203	500	625	625	0	0	1	-360	360;
	13	23	0.0111	0.0865	0.1818	500	625	625	0	0	1	-360	360;
	14	16	0.005	0.0389	0.0818	500	625	625	0	0	1	-360	360;
	15	16	0.0022	0.0173	0.0364	500	600	625	0	0	1	-360	360;
	15	21	0.0063	0.049	0.103	500	600	625	0	0	1	-360	360;
	15	21	0.0063	0.049	0.103	500	600	625	0	0	1	-360	360;
	15	24	0.0067	0.0519	0.1091	500	600	625	0	0	1	-360	360;
	16	17	0.0033	0.0259	0.0545	500	600	625	0	0	1	-360	360;
	16	19	0.003	0.0231	0.0485	500	600	625	0	0	1	-360	360;
	17	18	0.0018	0.0144	0.0303	500	600	625	0	0	1	-360	360;
	17	22	0.0135	0.1053	0.2212	500 600	625	0	0	1	-360	360;
	18	21	0.0033	0.0259	0.0545	500 600	625	0	0	1	-360	360;
	18	21	0.0033	0.0259	0.0545	500	600	625	0	0	1	-360	360;
	19	20	0.0051	0.0396	0.0833	500	600	625	0	0	1	-360	360;
	19	20	0.0051	0.0396	0.0833	500 600	625	0	0	1	-360	360;
	20	23	0.0028	0.0216	0.0455	500	600	625	0	0	1	-360	360;
	20	23	0.0028	0.0216	0.0455	500	600	625	0	0	1	-360	360;
	21	22	0.0087	0.0678	0.1424	500	600	625	0	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [								%	bus	Pmin	Pmax	Qmin	Qmax	Unit Code
	2	1500	0	3	0	130	400.6849;	%	1	16	20	0	10	U20
	2	1500	0	3	0	130	400.6849;	%	1	16	20	0	10	U20
	2	1500	0	3	0.014142	16.0811	212.3076;	%	1	15.2	76	-25	30	U76
	2	1500	0	3	0.014142	16.0811	212.3076;	%	1	15.2	76	-25	30	U76
	2	1500	0	3	0	130	400.6849;	%	2	16	20	0	10	U20
	2	1500	0	3	0	130	400.6849;	%	2	16	20	0	10	U20
	2	1500	0	3	0.014142	16.0811	212.3076;	%	2	15.2	76	-25	30	U76
	2	1500	0	3	0.014142	16.0811	212.3076;	%	2	15.2	76	-25	30	U76
	2	1500	0	3	0.052672	43.6615	781.521;	%	7	25	100	0	60	U100
	2	1500	0	3	0.052672	43.6615	781.521;	%	7	25	100	0	60	U100
	2	1500	0	3	0.052672	43.6615	781.521;	%	7	25	100	0	60	U100
	2	1500	0	3	0.00717	48.5804	832.7575;	%	13	69	197	0	80	U197
	2	1500	0	3	0.00717	48.5804	832.7575;	%	13	69	197	0	80	U197
	2	1500	0	3	0.00717	48.5804	832.7575;	%	13	69	197	0	80	U197
	2	1500	0	3	0	0	0;	%	14					SynCond
	2	1500	0	3	0.328412	56.564	86.3852;	%	15	2.4	12	0	6	U12
	2	1500	0	3	0.328412	56.564	86.3852;	%	15	2.4	12	0	6	U12
	2	1500	0	3	0.328412	56.564	86.3852;	%	15	2.4	12	0	6	U12
	2	1500	0	3	0.328412	56.564	86.3852;	%	15	2.4	12	0	6	U12
	2	1500	0	3	0.328412	56.564	86.3852;	%	15	2.4	12	0	6	U12
	2	1500	0	3	0.008342	12.3883	382.2391;	%	15	54.3	155	-50	80	U155
	2	1500	0	3	0.008342	12.3883	382.2391;	%	16	54.3	155	-50	80	U155
	2	1500	0	3	0.000213	4.4231	395.3749;	%	18	100	400	-50	200	U400
	2	1500	0	3	0.000213	4.4231	395.3749;	%	21	100	400	-50	200	U400
	2	1500	0	3	0	0.001	0.001;	%	22	10	50	-10	16	U50
	2	1500	0	3	0	0.001	0.001;	%	22	10	50	-10	16	U50
	2	1500	0	3	0	0.001	0.001;	%	22	10	50	-10	16	U50
	2	1500	0	3	0	0.001	0.001;	%	22	10	50	-10	16	U50
	2	1500	0	3	0	0.001	0.001;	%	22	10	50	-10	16	U50
	2	1500	0	3	0	0.001	0.001;	%	22	10	50	-10	16	U50
	2	1500	0	3	0.008342	12.3883	382.2391;	%	23	54.3	155	-50	80	U155
	2	1500	0	3	0.008342	12.3883	382.2391;	%	23	54.3	155	-50	80	U155
	2	1500	0	3	0.004895	11.8495	665.1094;	%	23	140	350	-25	150	U350
];

mpopt = mpoption('verbose', 0, 'out.all', 0); %removes other unwanted outputs
mpc = loadcase(case24_ieee_rts);

%DO NOT TOUCH
mpc.branch(:, 6) = mpc.branch(:, 6) * 1.15; 
%DO NOT TOUCH

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

%--------------------DEFINING-CYCLE-1-PARAMETERS----------------------------

results_cycle1_10 = runopf(mpc, mpopt);


mpc108.bus(:, 3) = Pd_Orig * loadfactor_08; % Adjust active power demand
mpc108.bus(:, 4) = Qd_Orig * loadfactor_08; % Adjust reactive power demand

results_cycle1_08 = runopf(mpc108, mpopt);


mpc106.bus(:, 3) = Pd_Orig * loadfactor_06;
mpc106.bus(:, 4) = Qd_Orig * loadfactor_06;

results_cycle1_06 = runopf(mpc106, mpopt);


mpc104.bus(:, 3) = Pd_Orig * loadfactor_04; 
mpc104.bus(:, 4) = Qd_Orig * loadfactor_04; 

results_cycle1_04 = runopf(mpc104, mpopt);


%--------------------DEFINING-CYCLE-2-PARAMETERS----------------------------

mpc210.bus(:, 3) = Pd_Orig * demand_factor;
mpc210.bus(:, 4) = Qd_Orig * demand_factor;

results_cycle2_10 = runopf(mpc210, mpopt);


mpc208.bus(:, 3) = Pd_Orig * demand_factor * loadfactor_08;
mpc208.bus(:, 4) = Qd_Orig * demand_factor * loadfactor_08;

results_cycle2_08 = runopf(mpc208, mpopt);


mpc206.bus(:, 3) = Pd_Orig * demand_factor * loadfactor_06;
mpc206.bus(:, 4) = Qd_Orig * demand_factor * loadfactor_06;

results_cycle2_06 = runopf(mpc206, mpopt);


mpc204.bus(:, 3) = Pd_Orig * demand_factor * loadfactor_04; 
mpc204.bus(:, 4) = Qd_Orig * demand_factor * loadfactor_04;

results_cycle2_04 = runopf(mpc204, mpopt);


%--------------------DEFINING-CYCLE-3-PARAMETERS----------------------------

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

%-----------------------CREATING LDC CURVE---------------------------------------

LDC1 = (((results_cycle1_10.f * 43800 * 0.2) + (results_cycle1_08.f * 43800 * 0.3) + (results_cycle1_06.f * 43800 * 0.3) + (results_cycle1_04.f * 43800 * 0.2)) * 0.72)/10^9;
LDC2 = (((results_cycle2_10.f * 43800 * 0.2) + (results_cycle2_08.f * 43800 * 0.3) + (results_cycle2_06.f * 43800 * 0.3) + (results_cycle2_04.f * 43800 * 0.2)) * 0.72)/10^9;
LDC3 = (((results_cycle3_10.f * 43800 * 0.2) + (results_cycle3_08.f * 43800 * 0.3) + (results_cycle3_06.f * 43800 * 0.3) + (results_cycle3_04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 1 in billions of pounds = ', num2str(LDC1)]);
disp(['cost of cycle 2 in billions of pounds = ', num2str(LDC2)]);
disp(['cost of cycle 3 in billions of pounds = ', num2str(LDC3)]);



%-----------------------CHECKING DEMAND VS GENERATION----------------------------

%CYCLE 1
Total_Maximum_Generation1 = sum(mpc.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand1 = sum(mpc.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation1 < Total_Peak_Demand1 %checking whether the peak demand in the first cycle exceeds generation capacity
    disp('Increased generation in cycle 1 is required.');
else
    disp('Generation in cycle 1 is OK.');
end

%CYCLE 2
Total_Maximum_Generation2 = sum(mpc210.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand2 = sum(mpc210.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation2 < Total_Peak_Demand2 %checking whether the peak demand in the second cycle exceeds generation capacity
    disp('Increased generation in cycle 2 is required.');
else
    disp('Generation in cycle 2 is OK.');
end

%CYCLE 3
Total_Maximum_Generation3 = sum(mpc310.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand3 = sum(mpc310.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation3 < Total_Peak_Demand3 %checking whether the peak demand in the third cycle exceeds generation capacity
    disp('Increased generation in cycle 3 is required.');
else
    disp('Generation in cycle 3 is OK.');
end

%-----------------------CYCLE.3.WIND------------------------------------------

mpc3_wind = mpc310;


new_wind_unit = [24, 0, 0, 0, 0, 1.05, 100, 1, 148, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_wind.gen = [mpc3_wind.gen; new_wind_unit];
wind_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_wind.gencost = [mpc3_wind.gencost; wind_cost_row];


Total_Maximum_Generation3_wind = sum(mpc3_wind.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand3_wind = sum(mpc3_wind.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation3_wind < Total_Peak_Demand3_wind %checking whether the peak demand in the third cycle with wind generator exceeds generation capacity
    disp('Increased generation in cycle 3_wind is required.');
end

%-----------------------CYCLE.3.SOLAR------------------------------------------

mpc3_solar = mpc310;

new_solar_unit = [5, 1500, 0, 0, 0, 1.05, 100, 1, 52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_solar.gen = [mpc3_solar.gen; new_solar_unit];
solar_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_solar.gencost = [mpc3_solar.gencost; solar_cost_row];


Total_Maximum_Generation3_solar = sum(mpc3_solar.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand3_solar = sum(mpc3_solar.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation3_solar < Total_Peak_Demand3_solar %checking whether the peak demand in the third cycle with solar generator exceeds generation capacity
    disp('Increased generation in cycle 3_solar is required.');
end

%-----------------------CYCLE.3.HYDRO------------------------------------------

mpc3_hydro = mpc310;

new_hydro_unit = [19, 1500, 0, 16, -10, 1.05, 100, 1, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_hydro.gen = [mpc3_hydro.gen; new_hydro_unit];
hydro_cost_row = [2, 0, 0, 3, 0, 0, 0];
mpc3_hydro.gencost = [mpc3_hydro.gencost; hydro_cost_row];


Total_Maximum_Generation3_hydro = sum(mpc3_hydro.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand3_hydro = sum(mpc3_hydro.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation3_hydro < Total_Peak_Demand3_hydro %checking whether the peak demand in the third cycle with hydro generator exceeds generation capacity
    disp('Increased generation in cycle 3_hydro is required.');
end


%-----------------------RUNNING-OPF-CYLCE-3-gasct---------------------------------------



%-----------------------CYCLE.3.GAS-CT------------------------------------------

%{
mpc3_gasct = mpc310;

new_gasct_unit = [24, 1500, 0, 19, -15, 1.05, 100, 1, 55, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_gasct.gen = [mpc3_gasct.gen; new_gasct_unit];
gasct_cost_row = [2, 0, 0, 2, 3, 40, 20];
mpc3_gasct.gencost = [mpc3_gasct.gencost; gasct_cost_row];


Total_Maximum_Generation3_gasct = sum(mpc3_gasct.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand3_gasct = sum(mpc3_gasct.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation3_gasct < Total_Peak_Demand3_gasct %checking whether the peak demand in the third cycle with gasct generator exceeds generation capacity
    disp('Increased generation in cycle 3_gasct is required.');
end
%}

%-----------------------RUNNING-OPF-CYLCE-3-gasct---------------------------------------
%{
mpc3_gasct10 = mpc3_gasct;
mpc3_gasct08 = mpc3_gasct;
mpc3_gasct06 = mpc3_gasct;
mpc3_gasct04 = mpc3_gasct; %this code defines the mpcs needed for the gas generator, we can't simply use the original cycle 3 mpc as a gas unit has been added

results_cycle3_10_gasct = runopf(mpc3_gasct10, mpopt);

mpc3_gasct08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3_gasct08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;

results_cycle3_08_gasct = runopf(mpc3_gasct08, mpopt);


mpc3_gasct06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3_gasct06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_gasct = runopf(mpc3_gasct06, mpopt);


mpc3_gasct04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3_gasct04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_gasct = runopf(mpc3_gasct04, mpopt);

%-----------------------CREATING LDC CURVE 3_gasct---------------------------------------

LDC3_gasct = (((results_cycle3_10_gasct.f * 43800 * 0.2) + (results_cycle3_08_gasct.f * 43800 * 0.3) + (results_cycle3_06_gasct.f * 43800 * 0.3) + (results_cycle3_04_gasct.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_gas-ct in billions of pounds = ', num2str(LDC3_gasct)]);

%}

%-----------------------CYCLE.3.OIL-FIRED-STEAM-UNIT------------------------------------------

mpc3_oil = mpc310;

new_oil_unit = [23, 0, 0, 80, -50, 1.05, 100, 1, 200, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
mpc3_oil.gen = [mpc3_oil.gen; new_oil_unit];
oil_cost_row = [2, 1500, 0, 3, 0.00482, 7.97, 78];
mpc3_oil.gencost = [mpc3_oil.gencost; oil_cost_row];


Total_Maximum_Generation3_oil = sum(mpc3_oil.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand3_oil = sum(mpc3_oil.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation3_oil < Total_Peak_Demand3_oil %checking whether the peak demand in the third cycle with solar generator exceeds generation capacity
    disp('Increased generation in cycle 3_oil is required.');
end

%-----------------------RUNNING-OPF-CYLCE-3-OIL---------------------------------------

mpc3_oil10 = mpc3_oil;
mpc3_oil08 = mpc3_oil;
mpc3_oil06 = mpc3_oil;
mpc3_oil04 = mpc3_oil; %this code defines the mpcs needed for the oil generator, we can't simply use the original cycle 3 mpc as an oil unit has been added

results_cycle3_10_oil = runopf(mpc3_oil10, mpopt);

mpc3_oil08.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_08;
mpc3_oil08.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_08;
z
results_cycle3_08_oil = runopf(mpc3_oil08, mpopt);


mpc3_oil06.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_06;
mpc3_oil06.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_06;

results_cycle3_06_oil = runopf(mpc3_oil06, mpopt);


mpc3_oil04.bus(:, 3) = Pd_Orig * demand_factor * demand_factor * loadfactor_04; 
mpc3_oil04.bus(:, 4) = Qd_Orig * demand_factor * demand_factor * loadfactor_04;

results_cycle3_04_oil = runopf(mpc3_oil04, mpopt);

%-----------------------CREATING-LDC-CURVE-3_OIL---------------------------------------

LDC3_oil = (((results_cycle3_10_oil.f * 43800 * 0.2) + (results_cycle3_08_oil.f * 43800 * 0.3) + (results_cycle3_06_oil.f * 43800 * 0.3) + (results_cycle3_04_oil.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 3_oil in billions of pounds = ', num2str(LDC3_oil)]);


%---------------------------------------------------------------------------------------------------

%CYCLE 4 


%---------------------------------------------------------------------------------------------------


%CYCLE 4-OIL


%---------------------------------------------------------------------------------------------------


%--------------------RUNNING-OPF-CYCLE-4-OIL--------------------------------------------
mpc4_oil = mpc;

mpc4O10 = mpc4_oil;
mpc4O08 = mpc4_oil;
mpc4O06 = mpc4_oil;
mpc4O04 = mpc4_oil;

mpc4O10.bus(:,3) = Pd_Orig * demand_factor * demand_factor *demand_factor;
mpc4O10.bus(:,4) = Qd_Orig * demand_factor * demand_factor *demand_factor;

results_cycle_4O10 = runopf(mpc4O10, mpopt);


mpc4O08.bus(:,3) = Pd_Orig * demand_factor * demand_factor * demand_factor * loadfactor_08;
mpc4O08.bus(:,4) = Qd_Orig * demand_factor * demand_factor * demand_factor * loadfactor_08;

results_cycle_4O08 = runopf(mpc4O08, mpopt);

mpc4O06.bus(:,3) = Pd_Orig * demand_factor * demand_factor * demand_factor * loadfactor_06;
mpc4O06.bus(:,4) = Qd_Orig * demand_factor * demand_factor * demand_factor * loadfactor_06;

results_cycle_4O06 = runopf(mpc4O06, mpopt);


mpc4O04.bus(:,3) = Pd_Orig * demand_factor * demand_factor * demand_factor * loadfactor_04;
mpc4O04.bus(:,4) = Qd_Orig * demand_factor * demand_factor * demand_factor * loadfactor_04;

results_cycle_4O04 = runopf(mpc4O04, mpopt);


%-----------------------CREATING LDC CURVE---------------------------------------

LDC4_oil = (((results_cycle_4O10.f * 43800 * 0.2) + (results_cycle_4O08.f * 43800 * 0.3) + (results_cycle_4O06.f * 43800 * 0.3) + (results_cycle_4O04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 4_oil in billions of pounds = ', num2str(LDC4_oil)]);


%-----------------------CHECKING DEMAND VS GENERATION----------------------------

%CYCLE 4_oil
Total_Maximum_Generation_4O = sum(mpc4_oil.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand_4O = sum(mpc4_oil.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation_4O < Total_Peak_Demand_4O %checking whether the peak demand in the fourth-oil cycle exceeds generation capacity
    disp('Increased generation in cycle 4 is required.');
else
    disp('Generation in cycle 4-oil is OK.');
end


%---------------------------------------------------------------------------------------------------

%CYCLE 5


%---------------------------------------------------------------------------------------------------

%---------------------------------------------------------------------------------------------------


%CYCLE 5-OIL


%---------------------------------------------------------------------------------------------------

mpc5_oil = mpc;

mpc5O10 = mpc5_oil;
mpc5O08 = mpc5_oil;
mpc5O06 = mpc5_oil;
mpc5O04 = mpc5_oil;

mpc5O10.bus(:,3) = Pd_Orig * demand_factor * demand_factor *demand_factor * demand_factor;
mpc5O10.bus(:,4) = Qd_Orig * demand_factor * demand_factor *demand_factor * demand_factor;

results_cycle_5O10 = runopf(mpc5O10, mpopt);


mpc5O08.bus(:,3) = Pd_Orig * demand_factor * demand_factor * demand_factor * demand_factor * loadfactor_08;
mpc5O08.bus(:,4) = Qd_Orig * demand_factor * demand_factor * demand_factor * demand_factor * loadfactor_08;

results_cycle_5O08 = runopf(mpc5O08, mpopt);

mpc5O06.bus(:,3) = Pd_Orig * demand_factor * demand_factor * demand_factor * demand_factor * loadfactor_06;
mpc5O06.bus(:,4) = Qd_Orig * demand_factor * demand_factor * demand_factor * demand_factor * loadfactor_06;

results_cycle_5O06 = runopf(mpc5O06, mpopt);


mpc5O04.bus(:,3) = Pd_Orig * demand_factor * demand_factor * demand_factor * demand_factor * loadfactor_04;
mpc5O04.bus(:,4) = Qd_Orig * demand_factor * demand_factor * demand_factor * demand_factor * loadfactor_04;

results_cycle_5O04 = runopf(mpc5O04, mpopt);


%-----------------------CREATING LDC CURVE---------------------------------------

LDC5_oil = (((results_cycle_5O10.f * 43800 * 0.2) + (results_cycle_5O08.f * 43800 * 0.3) + (results_cycle_5O06.f * 43800 * 0.3) + (results_cycle_5O04.f * 43800 * 0.2)) * 0.72)/10^9;
disp(['cost of cycle 5_oil in billions of pounds = ', num2str(LDC5_oil)]);


%-----------------------CHECKING DEMAND VS GENERATION----------------------------

%CYCLE 4_oil
Total_Maximum_Generation_5O = sum(mpc5_oil.gen(:,9)); %sums pmax of all generation units
Total_Peak_Demand_5O = sum(mpc5_oil.bus(:,3)); %sums pd of all loads

if Total_Maximum_Generation_5O < Total_Peak_Demand_5O %checking whether the peak demand in the fifth-oil cycle exceeds generation capacity
    disp('Increased generation in cycle 5 is required.');
else
    disp('Generation in cycle 5-oil is OK.');
end