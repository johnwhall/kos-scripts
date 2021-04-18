@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").
runoncepath("lib/liblaunch").

//runoncepath("lib/libstring").
//local LOGFILE to "log/launch.log".
//if exists(LOGFILE) { deletepath(LOGFILE). }
//local initialAltitude to ship:altitude.
//function logHeader { log join(" ", list("T(s)", "alt(m)", "mass(t)", "pitch(deg)", "thrust(kN)", "vSrf(m/s)", "vObt(m/s)", "vVert(m/s)", "vHorz(m/s)")) to LOGFILE.  }
//function logInfo { log (missiontime + " " + (altitude - initialAltitude) + " " + mass + " " + pitch() + " " + ship:availablethrust + " " + velocity:surface:mag + " " + velocity:orbit:mag + " " + verticalSpeed + " " + groundSpeed) to LOGFILE.  }
//logHeader().

local tgtLAN to 0.
local lanDiff to tgtLan - ship:orbit:lan.
if lanDiff < 0 { set lanDiff to 360 + lanDiff. }
local waitTime to (lanDiff / 360) * body:rotationPeriod.
kUniverse:timeWarp:warpTo(time:seconds + waitTime).
wait until kUniverse:timeWarp:rate = 1 and kUniverse:timeWarp:isSettled.
wait 3. // TODO: why isn't the above line enough
if abs(tgtLan - ship:orbit:lan) > 2 { print "warp to lan failed". exit. }

local tgtInc to ship:latitude.
local laz to launchAzimuth(tgtInc, 200000).
print "Launch azimuth: " + round(laz, 2).

local gtPitch0 to 80.
local gtSpd0 to 70.
local gtSpdf to gtSpd0 + 50.

local rollControl to false. // TODO: until I figure out how to keep roll steady
local initialTopVec to ship:facing:topVector.
local lock tgtTopVec to choose initialTopVec if rollControl else ship:facing:topVector.

print "INITIAL".
sas off.
rcs off.
set ship:control:pilotmainthrottle to 1.
lock steering to lookDirUp(ship:up:vector, tgtTopVec).

//wait 0.001.
//on missiontime {
//  logInfo().
//  return true.
//}
//wait 0.001.

stage. // ignite engine

wait until currentThrust() > 0.95 * ship:availableThrust.
print "LAUNCH".
stage. // disconnect launch clamp

wait until ship:verticalSpeed > gtSpd0.
print "GRAVITY TURN INITIAL".
lock steering to lookDirUp(heading(laz, lerp(90, gtPitch0, ship:verticalSpeed, gtSpd0, gtSpdf, true)):vector, tgtTopVec).

// Wait for turn, then wait for velocity vector to catch up
wait until abs(pitch() - gtPitch0) < 0.25.
wait until pitch(ship, ship:velocity:surface) < gtPitch0.
print "GRAVITY TURN".
local headPicker to HeadingPicker(laz, tgtInc).
lock steering to lookDirUp(heading(headPicker:pick(), pitch(ship, ship:velocity:surface)):vector, tgtTopVec).

wait until currentThrust() <= 0.01 * ship:availableThrust. // MECO
set ship:control:pilotmainthrottle to 0.
print "COAST".

wait until ship:altitude > 100000.
stage. // decouple 1st stage & fairings
//lock steering to lookDirUp(heading(headPicker:pick(), 0):vector, tgtTopVec).
lock steering to lookDirUp(heading(head(ship, ship:velocity:orbit), 0):vector, tgtTopVec).

when ship:altitude > body:atm:height then {
  // Do this after we leave the atmosphere or else we'll waste RCS propellant fighting it
  rcs on.
}

local vCirc to sqrt(body:mu / (body:radius + apoapsis)).
local vApo to sqrt(body:mu * (2 / (body:radius + apoapsis) - 1 / orbit:semiMajorAxis)).
local circDV to vCirc - vApo.
local circBurnTime to time:seconds + eta:apoapsis - burnTime(circDV / 2, 267, 33).

//local cbt0 to time:seconds.
//local circBurnTime to calcCircBurnTime(267, 33).
//local cbtf to time:seconds.
//print "circBurnTime took " + round(cbtf - cbt0, 2) + " seconds (done at T+" + round(missiontime, 2) + " alt: " + round(ship:altitude) + ")".

wait until angleToSteering() < 0.25.

// cancel manual timewarp
wait until time:seconds > circBurnTime - 15.
set warp to 0.

wait until time:seconds > circBurnTime - 5.
print "PROPELLANT STABILIZE".
set ship:control:fore to 1.

wait until propellantStable().
print "SECOND STAGE".
set ship:control:pilotmainthrottle to 1.
stage. // ignite 2nd stage
set ship:control:fore to 0.

wait until currentThrust() > 0.95 * ship:availableThrust.

local minEcc to ship:orbit:eccentricity.
until ship:orbit:eccentricity > 1.1 * minEcc { set minEcc to min(minEcc, ship:orbit:eccentricity). }

set ship:control:pilotmainthrottle to 0.
set ship:control:neutralize to true.
print "ORBIT".
