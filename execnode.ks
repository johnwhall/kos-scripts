@lazyglobal off.

run once funs.
run once genericburn.funs.ks.

parameter param_turnTime, param_ullageTime, param_ts.

local bt to burnTime1(nextnode:deltav:mag).
local burnMidTime to time:seconds + nextnode:eta.

local state to list().
genericBurnStart(nextnode:deltav, burnMidTime, bt, param_turnTime, param_ullageTime, param_ts, nextnode:deltav:mag, state).
wait until not genericBurnContinue(nextnode:deltav:mag, state).
genericBurnStop(state).
remove nextnode.
