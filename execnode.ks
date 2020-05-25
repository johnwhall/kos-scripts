@lazyglobal off.

runoncepath("lib/libengine").
runoncepath("lib/libfacing").

set steeringManager:maxStoppingTime to 5.
set steeringManager:pitchPID:kd to 1.
set steeringManager:yawPID:kd to 1.
set steeringManager:pitchTS to 4.
set steeringManager:yawTS to 4.

local burnMidTime to time:seconds + nextNode:eta.
local burnStartTime to burnMidTime - burnTime(nextNode:deltaV:mag / 2, 235.4, 13.763, 0.347).
local propStabTime to burnStartTime - 5.
local rollStabTime to propStabTime - 15.
local turnStartTime to rollStabTime - 120.

// cancel manual timewarp
wait until time:seconds > turnStartTime - 20.
set warp to 0.

wait until time:seconds > turnStartTime.
print "Turning to node".
rcs on.
lock steering to lookDirUp(nextNode:deltaV, ship:facing:topVector).
wait until angleToSteering() < 0.25. // TODO: wait for low angular momentum
print "Aligned to node".

wait until time:seconds > rollStabTime.
print "Roll stabilizing".
set ship:control:roll to 1.

wait until time:seconds > propStabTime.
print "Stabilizing propellant".
set ship:control:fore to 1.
wait until propellantStable().

print "Starting burn".
set ship:control:pilotmainthrottle to 1.
stage. // TODO: temporary

//wait until currentThrust() > 0.95 * ship:availableThrust.
//local minDV to nextNode:deltaV:mag.
//until nextNode:deltaV:mag > 1.1 * minDV { set minDV to min(minDV, nextNode:deltaV:mag). }

wait until orbit:hasNextPatch.
local minPer to orbit:nextPatch:periapsis.
//until orbit:hasNextPatch and orbit:nextPatch:periapsis > 1.1 * minPer { set minPer to min(per
until false {
  if orbit:hasNextPatch {
    local nextPer to orbit:nextPatch:periapsis.
    print nextPer.
    if nextPer > 1.1 * minPer { break. }
    set minPer to min(minPer, nextPer).
  }
  wait 0.0001.
}

set ship:control:pilotmainthrottle to 0.
set ship:control:neutralize to true.
