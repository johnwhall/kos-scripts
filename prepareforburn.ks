@lazyglobal off.

parameter pointVec, burnMidTime, burnTime, settleFuel, ts.

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

local settleTime to 0.
if settleFuel { set settleTime to 5. }

warpFor1(timeToBurnMid - (burnTime / 2) - settleTime).

wait until timeToBurnMid - settleTime < (burnTime / 2).

if settleFuel {
  local prevRCS to rcs.
  rcs on.
  set ship:control:fore to 1.
  wait settleTime.
  set rcs to prevRCS.
}
