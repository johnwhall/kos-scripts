@lazyglobal off.

runoncepath("lib/libengine").
runoncepath("lib/libfacing").

set steeringManager:maxStoppingTime to 5.
set steeringManager:pitchPID:kd to 1.
set steeringManager:yawPID:kd to 1.
set steeringManager:pitchTS to 8.
set steeringManager:yawTS to 8.

local burnMidTime to time:seconds + nextNode:eta.
local burnStartTime to burnMidTime - burnTime(nextNode:deltaV:mag / 2, 235.4, 13.763, 0.347).
//local burnStartTime to burnMidTime - burnTime(nextNode:deltaV:mag / 2, 231, 21.280).
//local burnStartTime to burnMidTime - burnTime(nextNode:deltaV:mag / 2, 267, 33).
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
set ship:control:fore to 0.

wait until currentThrust() > 0.95 * ship:availableThrust.
local minDV to nextNode:deltaV:mag.
until nextNode:deltaV:mag > 1.1 * minDV { set minDV to min(minDV, nextNode:deltaV:mag). }

wait until orbit:hasNextPatch and orbit:nextPatch:body:name = "Moon".
//local minPer to orbit:nextPatch:periapsis.
//until false {
//  if orbit:hasNextPatch {
//    local nextPer to orbit:nextPatch:periapsis.
//    print nextPer.
//    if nextPer > 1.1 * minPer { break. }
//    set minPer to min(minPer, nextPer).
//  }
//  wait 0.0001.
//}

set ship:control:pilotmainthrottle to 0.
set ship:control:neutralize to true.
