@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").

local topVec to ship:facing:topVector.
local gtPitch0 to 80.
local gtSpd0 to 50.
local gtSpdf to 100.

print "INITIAL".
sas off.
rcs off.
lock throttle to 1.
lock steering to lookDirUp(ship:up:vector, topVec).
stage. // ignite engine

wait until currentThrust() > 0.95 * ship:availableThrust.
print "LAUNCH".
stage. // disconnect launch clamp

local upVecDraw to vecDraw(ship:position, { return 20 * ship:up:vector. }, white, "", 1, true).
local steeringVecDraw to vecDraw(ship:position, { return 20 * toVector(steering). }, blue, "", 1, true).
local horizonVecDraw to vecDraw(ship:position, { return 20 * horizon(). }, red, "", 1, true).

wait until ship:verticalspeed > gtSpd0.
print "GRAVITY TURN INITIAL".
lock steering to lookDirUp(heading(90, lerp(90, gtPitch0, ship:verticalSpeed, gtSpd0, gtSpdf, true)):vector, topVec).

wait until vang(ship:velocity:surface, heading(90, gtPitch0):vector) < 0.25.
print "GRAVITY TURN RETRACT".
local pitch0 to pitch().
local t0 to time:seconds.
local tf to t0 + 5.
lock steering to lookDirUp(heading(head(), lerp(pitch0, gtPitch0, time:seconds, t0, tf, true)):vector, topVec).

wait until vang(ship:velocity:surface, ship:facing:vector) < 0.25.
print "GRAVITY TURN".
lock steering to lookDirUp(ship:velocity:surface, topVec).

wait until ship:altitude > 100000.
print "COAST".
lock throttle to 0.
stage. // decouple 1st stage & fairings
rcs on.
local head0 to head().
lock steering to lookDirUp(heading(head0, -6):vector, topVec).

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
