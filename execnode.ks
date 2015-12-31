@lazyglobal off.

run once funs.

parameter settleFuel.

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

local bt to burnTime1(nextnode:deltav:mag).
run prepareForBurn(nextnode:deltav, time:seconds + nextnode:eta, bt, settleFuel, 10).
lock steering to lookdirup(nextnode:deltav, ship:facing:topvector).

set throt to 1.
local lastDV to nextnode:deltav:mag.
wait until atFullThrust().
wait 0.05.
until lastDV < nextnode:deltav:mag {
  set lastDV to nextnode:deltav:mag.
  wait 0.05.
}

unlock steering.
set throt to 0.
set sas to prevSAS.

safeRemoveNextNode().
