@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").
runoncepath("lib/liblaunch").

local tgtInc to 90.
local launchAzimuth to 3.

local rollControl to false.
local initialTopVec to ship:facing:topVector.
local lock earlyRoll to choose initialTopVec if rollControl else ship:facing:topVector.

local gtPitch0 to 80.
local gtSpd0 to 50.
local gtSpdf to 100.

print "INITIAL".
sas off.
rcs off.
lock throttle to 1.
lock steering to lookDirUp(ship:up:vector, earlyRoll).
stage. // ignite engine

wait until currentThrust() > 0.95 * ship:availableThrust.
print "LAUNCH".
stage. // disconnect launch clamp

local upVecDraw to vecDraw(ship:position, { return 20 * ship:up:vector. }, white, "", 1, true).
local steeringVecDraw to vecDraw(ship:position, { return 20 * toVector(steering). }, blue, "", 1, true).
local horizonVecDraw to vecDraw(ship:position, { return 20 * horizon(). }, red, "", 1, true).

wait until ship:verticalspeed > gtSpd0.
print "GRAVITY TURN INITIAL".
lock steering to lookDirUp(heading(launchAzimuth, lerp(90, gtPitch0, ship:verticalSpeed, gtSpd0, gtSpdf, true)):vector, earlyRoll).

// Wait for turn, then wait for velocity vector to catch up
wait until pitch() - gtPitch0 < 0.25.
wait until pitch(ship, ship:velocity:surface) < gtPitch0.
print "GRAVITY TURN".
local headPicker to HeadingPicker(launchAzimuth, tgtInc).
lock steering to lookDirUp(heading(headPicker:pick(), pitch(ship, ship:velocity:surface)):vector, earlyRoll).
//lock steering to lookDirUp(ship:velocity:surface, earlyRoll). // TODO: use launch azimuth

wait until ship:altitude > 100000.
print "COAST".
lock throttle to 0.
stage. // decouple 1st stage & fairings
rcs on.
//local head0 to head().
// TODO: base this on orbital heading instead of surface heading
//       or just force to launch azimuth until we start needing to fine-tune inclination
//lock steering to lookDirUp(heading(head0, -6):vector, earlyRoll).

lock steering to lookDirUp(heading(headPicker:pick(), -3):vector, earlyRoll).

wait until angleToSteering() < 0.25.
wait until eta:apoapsis < 85.
print "SPIN STABILIZE".

unlock throttle.
unlock steering.
set ship:control:roll to 1.

wait until eta:apoapsis < 75.
print "PROPELLANT STABILIZE".
set ship:control:fore to 1.

wait until propellantStable().
print "SECOND STAGE".
set ship:control:neutralize to true.

// we are about to lose avionics control - switch to pilotmainthrottle
set ship:control:pilotmainthrottle to 1.
stage. // decouple control module & ignite 2nd stage

wait until currentThrust() > 0.95 * ship:availableThrust.
wait until currentThrust() <= 0.01 * ship:availableThrust. // SECO
print "THIRD STAGE".
stage. // decouple 2nd stage & ignite 3rd stage

// wait until 3rd stage burnout to unlock throttle
wait until currentThrust() > 0.95 * ship:availableThrust.
wait until currentThrust() <= 0.01 * ship:availableThrust.
set ship:control:neutralize to true.
print "ORBIT".
