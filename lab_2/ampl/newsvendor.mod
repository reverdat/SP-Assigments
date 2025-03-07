
# ------ PARAMETERS -------
param N > 0; # Number of scenarios
set SCENARIOS := {1..N}; # Scenarios

param q >0; # Revenue newspaper sold / unit
param u >=0; # Warehouse max capacity
param m >=0; # Lower bound on demand rv
param M >=0; # Upper bound on demand rv

param c >0; # Newspaper cost / unit
param r >=0; # Revenue newspaper returned / unit

param demand {s in SCENARIOS} := m + (M-m)*(s-1)/(N-1); # DEMAND (rv): Discretized uniformly-distributed rv with support [m, M]

# ------ VARIABLES -------
# 1st Stage
var x >= 0, <= u; # Num of newspapers to be bought

# ----------> We observe the DEMAND rv

# 2nd Stage
var y {SCENARIOS} >=0; # Num of newspapers sold
var w {SCENARIOS} >=0; # Excess of newspapers to be returned

#  ------ PROBLEM DEFINITION -------
minimize Total_Cost: c*x  - sum {s in SCENARIOS} 1/N*(q*y[s]+r*w[s]);
subject to Demand_Constraint {s in SCENARIOS}: y[s] <= demand[s];
subject to Total_Stock_Constraint {s in SCENARIOS}: y[s]+w[s] <= x;