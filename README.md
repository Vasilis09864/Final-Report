Code For The Framework Generation Expansion Plan Used In This Report



The code provided includes a main_simulation and case24_ieee_rts. The main simulation is used to find the objective function
of each node transition in the decision tree. This is done by performing AC OPF on each power system configuration. Furthermore,
this code also performs simplified transmission expansion planning, detecting shadow prices at each node transition in the decision 
tree. The output of each objective function is produced in the terminal.

To run this code, use MATPOWER, an extension of MATLAB. Firstly, run the case24_ieee_rts file, this provides the IEEE-RTS data, the 
original system in which the model uses. Afterwards, run the main_simulation and the objective function at each node transition will
be displayed.
