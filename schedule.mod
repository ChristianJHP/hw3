# Sets
set COURSES := { 'A', 'B', 'C', 'D', 'E' };
set ROOMS := { 1, 2, 3 };
set TIMES := { 1, 2, 3, 4, 5 };

# Parameters
param capacity{ROOMS};
param enrollment{COURSES};
param length{COURSES};

# Feasible starting times for each course
set FEASIBLE_STARTS{c in COURSES} := { t in TIMES: t <= 5 - length[c] + 1 };

# Feasible room assignments based on capacity
set FEASIBLE_ROOMS{c in COURSES} := { r in ROOMS: enrollment[c] <= capacity[r] };

# Decision Variables
var x{COURSES, ROOMS, TIMES} binary;

# Dummy Objective
minimize Dummy: 0;

# Constraints
# 1. Each course must be scheduled exactly once
subject to ScheduleOnce{c in COURSES}:
    sum{r in FEASIBLE_ROOMS[c], t in FEASIBLE_STARTS[c]} x[c,r,t] = 1;

# 2. Non-overlapping in each room at each time slot
subject to NoOverlap{r in ROOMS, t in TIMES}:
    sum{c in COURSES, tstart in FEASIBLE_STARTS[c]: tstart <= t < tstart + length[c]} 
        (if r in FEASIBLE_ROOMS[c] then x[c,r,tstart] else 0) <= 1;