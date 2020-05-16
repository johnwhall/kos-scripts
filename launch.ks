@lazyglobal off.

runoncepath("lib/libcompass").
runoncepath("lib/libengine").
runoncepath("lib/libfacing").
runoncepath("lib/liblaunch").

//local lanDiff to 170 - ship:orbit:lan.
//if lanDiff < 0 { set lanDiff to 360 + lanDiff. }
//local waitTime to (lanDiff / 360) * body:rotationPeriod.
//kUniverse:timeWarp:warpTo(time:seconds + waitTime).
//
//wait until kUniverse:timeWarp:rate = 1 and kUniverse:timeWarp:isSettled.
//wait 5. // TODO: why isn't the above line enough

local tgtInc to ship:latitude.
local laz to launchAzimuth(tgtInc, 200000).
print "Launch azimuth: " + round(laz, 2).

local gtPitch0 to 80.
local gtSpd0 to 73.
local gtSpdf to gtSpd0 + 50.

local rollControl to false. // TODO: until I figure out how to keep roll steady
local initialTopVec to ship:facing:topVector.
local lock tgtTopVec to choose initialTopVec if rollControl else ship:facing:topVector.

print "INITIAL".
sas off.
rcs off.
set ship:control:pilotmainthrottle to 1.
lock steering to lookDirUp(ship:up:vector, tgtTopVec).
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
print "COAST".
wait until ship:altitude > 100000.
set ship:control:pilotmainthrottle to 0.
stage. // decouple 1st stage & fairings

// Wait until we leave the atmosphere or else we'll waste RCS propellant fighting it
wait until ship:altitude > body:atm:height.

rcs on.
//lock steering to lookDirUp(heading(headPicker:pick(), 0):vector, tgtTopVec).
lock steering to lookDirUp(heading(head(ship, ship:velocity:orbit), 0):vector, tgtTopVec).

local cbt0 to time:seconds.
local circBurnTime to calcCircBurnTime(267, 33).
local cbtf to time:seconds.
print "circBurnTime took " + round(cbtf - cbt0, 2) + " seconds".

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
