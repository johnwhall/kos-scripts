@lazyglobal off.

//parameter myMaxThrust.
local myMaxThrust to 180.16.

function trueAlt {
  if abs(altitude) < 0.05 or abs(altitude - alt:radar) / altitude > 0.05 {
    return alt:radar.
  } else {
    return altitude - ship:geoposition:terrainheight.
  }
}

local gSurf to body:mu / (body:radius ^ 2).
sas off.
gear off.

when (trueAlt() < 15000) then set warp to 0.

wait until trueAlt() < 4000.

clearscreen.
print "trueAlt   :" at (2, 10).
print "tgtVel    :" at (2, 11).
print "tgtAccel  :" at (2, 12).
print "gSurf     :" at (2, 13).
print "throt     :" at (2, 14).

local tgtVel to 0.
lock tgtVel to -trueAlt() / 20 - 2.

local maxEngineAccel to 0.
lock maxEngineAccel to myMaxThrust / mass.

lock steering to lookdirup(-ship:obt:velocity:surface, ship:facing:topvector).
local throt to 0.
lock throttle to throt.

when (ship:obt:velocity:surface:mag < 150) then stage.
when (ship:obt:velocity:surface:mag < 50) then {
  ag2 on. // cut parachutes
  steeringmanager:resetpids(). // forget about accumulated error from parachutes
}
when (trueAlt() < 500) then gear on.
when (ship:obt:velocity:surface:mag < 5) then lock steering to lookdirup(up:vector, ship:facing:topvector).

// this might be helping or it might not
set steeringmanager:maxstoppingtime to 10.

until status = "Landed" {
  local tgtAccel to tgtVel + ship:obt:velocity:surface:mag.
  set throt to (tgtAccel + gSurf) / maxEngineAccel.
  print trueAlt() at (15, 10).
  print tgtVel at (15, 11).
  print tgtAccel at (15, 12).
  print gSurf at (15, 13).
  print throt at (15, 14).
  wait 0.05.
}

set throt to 0.
