# AMPL model for Albert Cornman problem

param buy_price := 
    1 300, 
    2 350, 
    3 350, 
    4 500, 
    5 500, 
    6 500;

param sell_price := 
    1 250, 
    2 400, 
    3 350, 
    4 550, 
    5 550, 
    6 600;

var B {i in 1..6} >= 0; # Bought each month
var S {i in 1..6} >= 0; # Sold each month
var X {i in 2..6} >= 0; # Inventory at start of month (after weight loss)
var C {i in 2..7} >= 0; # Cash at start of month

maximize Final_Cash: C[7]; # Objective: Maximize cash at end of June

subject to Inventory_Balance_1: X[2] = 0.96*(50 + B[1]) - S[1];
subject to Inventory_Balance_2: X[3] = 0.96*(X[2] + B[2]) - S[2];
subject to Inventory_Balance_3: X[4] = 0.96*(X[3] + B[3]) - S[3];
subject to Inventory_Balance_4: X[5] = 0.96*(X[4] + B[4]) - S[4];
subject to Inventory_Balance_5: X[6] = 0.96*(X[5] + B[5]) - S[5];
subject to Inventory_Balance_6: 0.96*(X[6] + B[6]) - S[6] = 0;

subject to Cash_Balance_1: C[2] = (15000 - B[1]*300)*1.005 + S[1]*250;
subject to Cash_Balance_2: C[3] = (C[2] - B[2]*350)*1.005 + S[2]*400;
subject to Cash_Balance_3: C[4] = (C[3] - B[3]*350)*1.005 + S[3]*350;
subject to Cash_Balance_4: C[5] = (C[4] - B[4]*500)*1.005 + S[4]*550;
subject to Cash_Balance_5: C[6] = (C[5] - B[5]*500)*1.005 + S[5]*550;
subject to Cash_Balance_6: C[7] = (C[6] - B[6]*500)*1.005 + S[6]*600;

subject to Storage_1: 50 + B[1] <= 100;
subject to Storage_2: X[2] + B[2] <= 100;
subject to Storage_3: X[3] + B[3] <= 100;
subject to Storage_4: X[4] + B[4] <= 100;
subject to Storage_5: X[5] + B[5] <= 100;
subject to Storage_6: X[6] + B[6] <= 100;

solve;
display B, S, X, C;
display Final_Cash;