#Stochastic model of farmer problem


set SCENARIOS; # Possible scenarios
set CROP1;
set CROP2;
set CROP := CROP1 union CROP2;

param yield {CROP, SCENARIOS} >= 0; 		#productivity Tones/acre
param cplant {CROP} >= 0; 		#planting cost ($/acre)
param min_crop {CROP1} >= 0; 	#minimun crop required
param psell {CROP1} >= 0; 		#selling price ($/Tona)
param ppurchase {CROP1} >= 0; 	#purchasing price ($/Tona)
param pvbelow >= 0; 			#selling price corn below 6000T production
param pvabove >= 0;				#selling price corn above 6000T production
param land_total >= 0;
param pscenario >= 0; 			# (Equal) Probability of each scenario

#Decision Variables
var x {i in CROP} >= 0;			#Ha of land devoted to wheat, corn and sugarbeet
var w {i in CROP1, s in SCENARIOS} >= 0;		#Tons of wheat and corn to be sold
var y {i in CROP1, s in SCENARIOS} >= 0;		#Tons of wheat and corn to be purchased
var wbelow {i in CROP2, s in SCENARIOS} >= 0;	#Tons of sugar beet sold at the favorable price
var wabove {i in CROP2, s in SCENARIOS} >= 0;	#Tons of sugar beet sold at the lowest price

#Objective function
minimize Cost_total: 
		sum {i in CROP} cplant[i] * x[i] +
		sum {s in SCENARIOS} 
			pscenario*(
				sum {i in CROP1} (ppurchase[i] * y[i, s]- psell[i] * w[i, s])
				- sum {i in CROP2} (pvbelow * wbelow[i, s] + pvabove * wabove[i, s])
			);

#Constraints
subject to Land_total:
	sum {i in CROP} x[i] <= land_total;

subject to Min_crop {s in SCENARIOS, i in CROP1}:
	yield[i, s]*x[i]+y[i, s]-w[i, s] >= min_crop[i];
	

subject to Prod_controlled1 {s in SCENARIOS, i in CROP2}:
	wbelow[i, s]+wabove[i, s] <= yield[i, s]*x[i];

subject to Prod_controlled2 {s in SCENARIOS, i in CROP2}:
	wbelow[i, s] <= 6000;





