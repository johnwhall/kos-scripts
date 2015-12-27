@lazyglobal off.

run once funs.

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

local bt to burnTime1(nextnode:deltav:mag).
run prepareForBurn(nextnode:deltav, time:seconds + nextnode:eta, bt, 10).

set throt to 1.
local lastDV to nextnode:deltav:mag.
wait 0.05.
until lastDV < nextnode:deltav:mag {
  set lastDV to nextnode:deltav:mag.
  wait 0.05.
}

set throt to 0.
set sas to prevSAS.

remove nextnode.
