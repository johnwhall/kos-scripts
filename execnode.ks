@lazyglobal off.

parameter p_turnTime, p_ullageTime.

runoncepath("lib/libburntime").
runoncepath("lib/libgenericburn").

local bt to burnTime1(nextnode:deltav:mag).
local burnMidTime to time:seconds + nextnode:eta.

function nnDV {
  return nextnode:deltav:mag.
}

genericBurn(nextnode:deltav, burnMidTime, bt, p_turnTime, p_ullageTime, nnDV@).

remove nextnode.
