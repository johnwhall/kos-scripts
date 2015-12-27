@lazyglobal off.

run once funs.

local oldPitchTS to steeringmanager:pitchts.
local oldYawTS to steeringmanager:yawts.
set steeringmanager:pitchts to 10.
set steeringmanager:yawts to 10.

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

local bt to burnTime1(nextnode:deltav:mag).

warpFor1(nextnode:eta - bt - 90).

lock steering to lookdirup(nextnode:deltav, ship:facing:topvector).

wait until faceDiff() < 5.

set steeringmanager:pitchts to oldPitchTS.
set steeringmanager:yawts to oldYawTS.
wait until faceDiff() < 0.5.

warpFor1(nextnode:eta - (bt / 2) - 5).

wait until nextnode:eta - 5 < (bt / 2).

rcs on.
set ship:control:fore to 1.
wait 5.
rcs off.

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
