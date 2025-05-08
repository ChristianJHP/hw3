# Sets
set AIRPLANES;
set FLIGHTS;
set AIRPORTS;

# Parameters
param revenue{AIRPLANES, FLIGHTS};
param cost{AIRPLANES, FLIGHTS};
param leasing{AIRPLANES};
param dep_airport{FLIGHTS} symbolic within AIRPORTS;
param arr_airport{FLIGHTS} symbolic within AIRPORTS;
param dep_time{FLIGHTS};
param arr_time{FLIGHTS};
param initial_airport{AIRPLANES} symbolic within AIRPORTS;

# Variables
var x{AIRPLANES, FLIGHTS} binary;
var y{AIRPLANES} binary;

# Objective: Maximize profit
maximize Total_Profit:
    sum{a in AIRPLANES, f in FLIGHTS} (revenue[a,f] - cost[a,f]) * x[a,f] +
    sum{a in AIRPLANES} leasing[a] * y[a];

# Constraints
# Each flight is assigned exactly one airplane
subject to Flight_Assignment{f in FLIGHTS}:
    sum{a in AIRPLANES} x[a,f] <= 1;

# Airplanes can only fly from their initial airport or subsequent airports
subject to Initial_Airport{a in AIRPLANES, f in FLIGHTS: dep_airport[f] != initial_airport[a]}:
    x[a,f] <= sum{g in FLIGHTS: arr_airport[g] = dep_airport[f] and arr_time[g] + 1/24 <= dep_time[f]} x[a,g];

# Ground time of at least 1 hour between flights
subject to Ground_Time{a in AIRPLANES, f in FLIGHTS, g in FLIGHTS: f != g and arr_airport[f] = dep_airport[g] and arr_time[f] + 1/24 > dep_time[g]}:
    x[a,f] + x[a,g] <= 1;

# Airplanes are either assigned flights or leased (optional, can be omitted)
subject to Airplane_Usage{a in AIRPLANES}:
    sum{f in FLIGHTS} x[a,f] <= card(FLIGHTS) * (1 - y[a]);