@lazyglobal off.

run lib_fuelflow.

local ffdat to fuelflow_init().
wait 1.
local ttbo to fuelflow_timeToBurnOut(ffdat).
print ttbo.

wait 5.
set ttbo to fuelflow_timeToBurnOut(ffdat).
print ttbo.
