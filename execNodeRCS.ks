@lazyglobal off.

run funs.

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.
rcs on.

local bt to burnTime1(nextnode:deltav:mag).

warpFor1(nextnode:eta - bt - 90).

lock steering to nextnode:deltav:direction.
wait until faceDiff() < 0.5.

//warpFor1(nextnode:eta - (bt / 2) - 5).
//wait until nextnode:eta < (bt / 2) - 5.

set ship:control:fore to 1.
//wait 5.
//rcs off.

//set throt to 1.
local lastDV to nextnode:deltav:mag.
wait 0.55.
until lastDV < nextnode:deltav:mag {
  set lastDV to nextnode:deltav:mag.
  wait 0.05.
}

//wait until nextnode:deltav:mag < 0.1.

set throt to 0.
set sas to prevSAS.

remove nextnode.
