@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").
runoncepath("lib/liblaunch").

local tgtInc to 28.6.
local launchAzimuth to 90.

local rollControl to true.
local initialTopVec to ship:facing:topVector.
local lock tgtTopVec to choose initialTopVec if rollControl else ship:facing:topVector.

local gtPitch0 to 80.
local gtSpd0 to 65.
local gtSpdf to gtSpd0 + 50.

print "INITIAL".
sas off.
rcs off.
//lock throttle to 1.
set ship:control:pilotmainthrottle to 1.
lock steering to lookDirUp(ship:up:vector, tgtTopVec).
stage. // ignite engine

wait until currentThrust() > 0.95 * ship:availableThrust.
print "LAUNCH".
stage. // disconnect launch clamp

local upVecDraw to vecDraw(ship:position, { return 20 * ship:up:vector. }, white, "", 1, true).
local steeringVecDraw to vecDraw(ship:position, { return 20 * toVector(steering). }, blue, "", 1, true).
local horizonVecDraw to vecDraw(ship:position, { return 20 * horizon(). }, red, "", 1, true).

wait until ship:verticalspeed > gtSpd0.
print "GRAVITY TURN INITIAL".
lock steering to lookDirUp(heading(launchAzimuth, lerp(90, gtPitch0, ship:verticalSpeed, gtSpd0, gtSpdf, true)):vector, tgtTopVec).

// Wait for turn, then wait for velocity vector to catch up
wait until abs(pitch() - gtPitch0) < 0.25.
wait until pitch(ship, ship:velocity:surface) < gtPitch0.
print "GRAVITY TURN".
local headPicker to HeadingPicker(launchAzimuth, tgtInc).
lock steering to lookDirUp(heading(headPicker:pick(), pitch(ship, ship:velocity:surface)):vector, tgtTopVec).

wait until currentThrust() <= 0.01 * ship:availableThrust. // MECO
print "COAST".
wait until ship:altitude > 100000.
//lock throttle to 0.
set ship:control:pilotmainthrottle to 0.
stage. // decouple 1st stage & fairings
rcs on.
//lock steering to lookDirUp(heading(headPicker:pick(), -3):vector, tgtTopVec).
lock steering to lookDirUp(heading(head(ship, ship:velocity:orbit), 0):vector, tgtTopVec).

wait until angleToSteering() < 0.25.
//wait until eta:apoapsis < 85.
//print "SPIN STABILIZE".
//
unlock throttle.
//unlock steering.
//set ship:control:roll to 1.

wait until eta:apoapsis < 45.
print "PROPELLANT STABILIZE".
set ship:control:fore to 1.

wait until propellantStable().
print "SECOND STAGE".
//set ship:control:neutralize to true.

lock throttle to 1.
stage. // decouple control module & ignite 2nd stage

wait until currentThrust() > 0.95 * ship:availableThrust.
wait until currentThrust() <= 0.01 * ship:availableThrust. // SECO

set ship:control:neutralize to true.
print "ORBIT".
