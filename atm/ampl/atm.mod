###+++++++++++++++###
#+++ATM REFILL SP+++#
###+++++++++++++++###

### PARAMETERS
param s integer > 0; # Number of scenarios
set SCENARIOS := 1..s; # Set of scenarios

param c > 0; # Holding cost per unit
param p{i in SCENARIOS}; # Scenario probabilities
param xi{i in SCENARIOS}; # Demand realizations

param u > 0; # Capacity bounds
param l > 0; # Capacity bounds
param q > 0; # Shortage penalty cost

#------------------

param n_cut integer >= 0; # Number of cuts generated
set CUTS := 1..n_cut; # Set of cuts

param x_fix{1..3} >= 0;

param opt_cuts_rhs{CUTS}; # RHS of optimality cuts
param opt_cuts_coeff{CUTS, 1..3}; # Coefficients of optimality cuts
param feas_cuts_rhs{CUTS}; # RHS of feasibility cuts
param feas_cuts_coeff{CUTS, 1..3}; # Coefficients of feasibility cuts
param cuts_types {CUTS} symbolic within {"point", "ray"}; # Cut type classification


### DECISION VARIABLES
# First-stage
var x{1..3} >= 0; # Extended first-stage variables
var z; # Master objective approximation

# Second-stage
var y{SCENARIOS} >= 0; # Second-stage shortage variables
var surplus_y{SCENARIOS} >= 0; # Auxiliary surplus variables
var u_dual{SCENARIOS} >= 0; # Dual variables for subproblem


### OBJECTIVE 
minimize Total_Cost:
    (c*x[1] + sum{i in SCENARIOS} p[i]*q*y[i]);


minimize Master_Obj:
    z;

maximize Dual_Obj:
    sum{i in SCENARIOS} u_dual[i] * (xi[i] - x_fix[1]);


### CONSTRAINTS
subj to ATM_Capacity_Upper:
    x[1] - x[2] = l;

subj to ATM_Capacity_Lower:
    x[1] + x[3] = u;

subj to ATM_Capacity_Scenarios {i in SCENARIOS}:
    y[i] - surplus_y[i] = xi[i] - x[1];

subj to Dual_Inequality_Constraints {i in SCENARIOS}:
    u_dual[i] <= p[i]*q;


subj to Opt_Cuts {k in CUTS: cuts_types[k] = "point"}:
    z >= opt_cuts_rhs[k] + sum{j in 1..3} opt_cuts_coeff[k,j] * x[j];;

subj to Feas_Cuts {k in CUTS: cuts_types[k] = "ray"}:
    0 >= feas_cuts_rhs[k] + sum{j in 1..3} feas_cuts_coeff[k,j] * x[j];


##### PROBLEM DEFINITIONS 
problem Extensive: 
    x,
    y, 
    surplus_y,                  
    Total_Cost,           
    ATM_Capacity_Upper,         
    ATM_Capacity_Lower,
    ATM_Capacity_Scenarios;

problem Subproblem:
    u_dual,
    Dual_Obj,
    Dual_Inequality_Constraints;

problem Master:
    x,
    z,
    Master_Obj,
    ATM_Capacity_Upper,         
    ATM_Capacity_Lower,
    Opt_Cuts,
    Feas_Cuts;







