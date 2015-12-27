@lazyglobal off.

parameter pointVec, burnMidTime, burnTime, ts.

local oldPitchTS to steeringmanager:pitchts.
local oldYawTS to steeringmanager:yawts.
set steeringmanager:pitchts to ts.
set steeringmanager:yawts to ts.

local lock timeToBurnMid to burnMidTime - time:seconds.

warpFor1(timeToBurnMid - burnTime - 90).

lock steering to lookdirup(pointVec, ship:facing:topvector).
wait until faceDiff() < 5.

set steeringmanager:pitchts to oldPitchTS.
set steeringmanager:yawts to oldYawTS.
wait until faceDiff() < 0.5.

warpFor1(timeToBurnMid - (burnTime / 2) - 5).

wait until timeToBurnMid - 5 < (burnTime / 2).

set ship:control:fore to 1.
wait 5.
rcs off.
