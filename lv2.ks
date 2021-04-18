@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").
runoncepath("lib/liblaunch").

local tgtLAN to 0.
local lanDiff to tgtLan - orbit:lan.
if lanDiff < 0 { set lanDiff to 360 + lanDiff. }
local waitTime to (lanDiff / 360) * body:rotationPeriod.
kUniverse:timeWarp:warpTo(time:seconds + waitTime).
wait until kUniverse:timeWarp:rate = 1 and kUniverse:timeWarp:isSettled.
wait 3. // TODO: why isn't the above line enough
if abs(tgtLan - orbit:lan) > 2 { print "warp to lan failed". exit. }

local tgtInc to latitude.
local laz to launchAzimuth(tgtInc, 200000).
print "Launch azimuth: " + round(laz, 2).

local gtPitch0 to 80.
local gtSpd0 to 85.
local gtSpdf to gtSpd0 + 50.

local rollControl to false. // TODO: until I figure out how to keep roll steady
local initialTopVec to facing:topVector.
local lock tgtTopVec to choose initialTopVec if rollControl else facing:topVector.

print "INITIAL".
sas off.
rcs off.
set ship:control:pilotmainthrottle to 1.
lock steering to lookDirUp(up:vector, tgtTopVec).

stage. // ignite engine

wait until currentThrust() > 0.95 * availableThrust.
print "LAUNCH".
stage. // disconnect launch clamp

wait until verticalSpeed > gtSpd0.
print "GRAVITY TURN INITIAL".
lock steering to lookDirUp(heading(laz, lerp(90, gtPitch0, verticalSpeed, gtSpd0, gtSpdf, true)):vector, tgtTopVec).

// Wait for turn, then wait for velocity vector to catch up
wait until abs(pitch() - gtPitch0) < 0.25.
wait until pitch(ship, velocity:surface) < gtPitch0.
print "GRAVITY TURN".
local headPicker to HeadingPicker(laz, tgtInc).
lock steering to lookDirUp(heading(headPicker:pick(), pitch(ship, velocity:surface)):vector, tgtTopVec).

wait until currentThrust() <= 0.01 * availableThrust. // MECO
set ship:control:pilotmainthrottle to 0.
stage. // decouple 1st stage

print "PROPELLANT STABILIZE".
rcs on.
set ship:control:fore to 1.
wait until propellantStable() and stage:ready.

stage. // ignite 2nd stage
set ship:control:pilotmainthrottle to 1.
set ship:control:fore to 0.
wait until currentThrust() > 0.95 * availableThrust.

wait until altitude > 100000.
print "PAYLOAD FAIRING SEP".
stage. // decouple payload fairings

local tth0 to time:seconds.
local p0 to pitch().
local tthf to time:seconds + p0 / 3.
lock steering to lookDirUp(heading(head(ship, velocity:orbit), lerp(p0, 0, time:seconds, tth0, tthf, true)):vector, tgtTopVec).

wait until angleToSteering() < 0.25.

local tgtPitchPID to pidloop(0.2, 0, 0, -5, 5).
lock steering to lookDirUp(heading(head(ship, velocity:orbit), tgtPitchPID:output):vector, tgtTopVec).
local mDot to availableThrust / (specificImpulse() * 9.80665).
local minEcc to orbit:eccentricity.
until periapsis > body:atm:height and orbit:eccentricity > 1.1 * minEcc {
  local resLex to stage:resourcesLex.
  local ker to resLex["Kerosene"].
  local lox to resLex["LqdOxygen"].
  local propMass to ker:amount * ker:density + lox:amount * lox:density.
  local ttbo to propMass / mDot.
  if ttbo > 5 { tgtPitchPID:update(time:seconds, eta:apoapsis - ttbo). }

  set minEcc to min(minEcc, orbit:eccentricity).
  wait 0.0001.
}

set ship:control:pilotmainthrottle to 0.
set ship:control:neutralize to true.
print "ORBIT".
print "apoapsis: " + apoapsis.
print "periapsis: " + periapsis.
print "eccentricity: " + orbit:eccentricity.
