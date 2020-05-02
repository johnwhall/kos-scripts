@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").

local topVec to ship:facing:topVector.
local gravTurnPitch to 80.

print "INITIAL".
lock throttle to 1.
lock steering to lookDirUp(ship:up:vector, ship:facing:topVector).
stage. // ignite engine

wait until currentThrust() > 0.95 * ship:availableThrust.
print "LAUNCH".
stage. // disconnect launch clamp

local upVecDraw to vecDraw(ship:position, { return 20 * ship:up:vector. }, white, "", 1, true).
local steeringVecDraw to vecDraw(ship:position, { return 20 * toVector(steering). }, blue, "", 1, true).
local horizonVecDraw to vecDraw(ship:position, { return 20 * horizon(). }, red, "", 1, true).

wait until ship:verticalspeed > 50.
print "GRAVITY TURN INITIAL".
lock steering to lookDirUp(heading(90, lerp(90, gravTurnPitch, clamp(ship:verticalspeed, 50, 100), 50, 100)):vector, ship:facing:topVector).

wait until vang(ship:velocity:surface, heading(90, gravTurnPitch):vector) < 0.25.
print "GRAVITY TURN RETRACT".
local pitch0 to pitch().
local t0 to time:seconds.
local tf to t0 + 5.
lock steering to lookDirUp(heading(head(), lerp(pitch0, gravTurnPitch, time:seconds, t0, tf)):vector, ship:facing:topVector).

wait until vang(ship:velocity:surface, ship:facing:vector) < 0.25.
print "GRAVITY TURN".
lock steering to lookDirUp(ship:velocity:surface, ship:facing:topVector).

wait until ship:altitude > 100000.
print "COAST".
lock throttle to 0.
stage. // decouple 1st stage & fairings
rcs on.
local head0 to head().
//lock steering to lookDirUp(heading(head0, -6):vector, ship:facing:topVector).
lock steering to lookDirUp(heading(90, -6):vector, ship:facing:topVector).

wait until angleToSteering() < 0.25.
wait until eta:apoapsis < 85.
print "ROLL STABILIZE".

unlock steering.
set ship:control:roll to 1.

wait until eta:apoapsis < 75.
print "PROPELLANT STABILIZE".
set ship:control:fore to 1.

wait until propellantStability() = 100.
print "SECOND STAGE".
set ship:control:neutralize to true.
sas off.
stage. // decouple control module & ignite 2nd stage

wait until currentThrust() > 0.95 * ship:availableThrust.
wait until currentThrust() < 0.01 * ship:availableThrust. // SECO
print "THIRD STAGE".
stage. // decouple 2nd stage & ignite 3rd stage

// wait until 3rd stage burnout to unlock throttle
wait until currentThrust() > 0.95 * ship:availableThrust.
wait until currentThrust() < 0.01 * ship:availableThrust.
print "ORBIT".
