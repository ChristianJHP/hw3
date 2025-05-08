# Sets
set FLIGHTS;
set AIRPORTS;
set AIRPLANES;
set CAPTAINS;
set FIRST_OFFICERS;

# Parameters
param dep_airport {FLIGHTS} symbolic in AIRPORTS;
param arr_airport {FLIGHTS} symbolic in AIRPORTS;
param dep_time {FLIGHTS} >= 0, <= 1;
param arr_time {FLIGHTS} >= 0, <= 1;
param flight_airplane {FLIGHTS} symbolic in AIRPLANES;
param captain_base {CAPTAINS} symbolic in AIRPORTS;
param fo_base {FIRST_OFFICERS} symbolic in AIRPORTS;
param captain_cost {CAPTAINS, FLIGHTS} >= 0 default 0;
param fo_cost {FIRST_OFFICERS, FLIGHTS} >= 0 default 0;
param max_duty_time >= 0;
param min_rest_time >= 0;

# Decision Variables
var Assign_Captain {c in CAPTAINS, f in FLIGHTS} binary;
var Assign_FO {fo in FIRST_OFFICERS, f in FLIGHTS} binary;

# Objective: Minimize Total Cost
minimize Total_Cost:
    sum {c in CAPTAINS, f in FLIGHTS} captain_cost[c,f] * Assign_Captain[c,f] +
    sum {fo in FIRST_OFFICERS, f in FLIGHTS} fo_cost[fo,f] * Assign_FO[fo,f];

# Constraints
subject to One_Captain_Per_Flight {f in FLIGHTS}:
    sum {c in CAPTAINS} Assign_Captain[c,f] = 1;

subject to One_FO_Per_Flight {f in FLIGHTS}:
    sum {fo in FIRST_OFFICERS} Assign_FO[fo,f] = 1;

subject to Duty_Time_Captain {c in CAPTAINS}:
    sum {f in FLIGHTS} (arr_time[f] - dep_time[f]) * Assign_Captain[c,f] <= max_duty_time;

subject to Duty_Time_FO {fo in FIRST_OFFICERS}:
    sum {f in FLIGHTS} (arr_time[f] - dep_time[f]) * Assign_FO[fo,f] <= max_duty_time;

subject to Rest_Captain {c in CAPTAINS, f1 in FLIGHTS, f2 in FLIGHTS: f1 != f2 and arr_time[f1] + min_rest_time > dep_time[f2]}:
    Assign_Captain[c,f1] + Assign_Captain[c,f2] <= 1;

subject to Rest_FO {fo in FIRST_OFFICERS, f1 in FLIGHTS, f2 in FLIGHTS: f1 != f2 and arr_time[f1] + min_rest_time > dep_time[f2]}:
    Assign_FO[fo,f1] + Assign_FO[fo,f2] <= 1;

subject to Captain_Return {c in CAPTAINS, f in FLIGHTS: arr_airport[f] != captain_base[c]}:
    Assign_Captain[c,f] <= sum {g in FLIGHTS: dep_airport[g] = arr_airport[f]} Assign_Captain[c,g];

subject to FO_Return {fo in FIRST_OFFICERS, f in FLIGHTS: arr_airport[f] != fo_base[fo]}:
    Assign_FO[fo,f] <= sum {g in FLIGHTS: dep_airport[g] = arr_airport[f]} Assign_FO[fo,g];

# Run file commands
reset;
model crew_scheduling_task2.mod;
data crew_scheduling_task2.dat;
solve;
display Total_Cost, Assign_Captain, Assign_FO;
