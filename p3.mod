set Months := {1, 2, 3, 4, 5, 6};

param buy_price {Months};
param sell_price {Months};
param storage_capacity;
param initial_corn;
param initial_cash;
param weight_loss;
param interest_rate;

var b {Months} >= 0; # Tons of corn bought in month t
var s {Months} >= 0; # Tons of corn sold in month t
var w {Months} >= 0; # Tons of corn in storage at end of month t
var c {Months} >= 0; # Cash balance at end of month t

maximize TotalCash: c[6];

subject to CashBalance {t in Months}:
    c[t] = if (t = 1) then (initial_cash * (1 + interest_rate) - b[t] * buy_price[t] + s[t] * sell_price[t])
          else (c[t-1] * (1 + interest_rate) - b[t] * buy_price[t] + s[t] * sell_price[t]);

subject to StorageBalance {t in Months}:
    w[t] = if (t = 1) then (initial_corn * weight_loss + b[t] - s[t])
          else (w[t-1] * weight_loss + b[t] - s[t]);

    

subject to StorageCapacity {t in Months}:
    w[t] <= storage_capacity;

subject to FinalCorn:
    w[6] = 0;

# Data Section
param buy_price :=
1 300
2 350
3 350
4 500
5 500
6 500;

param sell_price :=
1 250
2 400
3 350
4 550
5 550
6 600;

param storage_capacity := 100;
param initial_corn := 50;
param initial_cash := 15000;
param weight_loss := 0.96;
param interest_rate := 0.005;

