@lazyglobal off.

//parameter myMaxThrust.
local myMaxThrust to 307.30.
when (trueAlt() < 15000) then set warp to 0.

function trueAlt {
  if abs(altitude - alt:radar) / altitude > 0.05 {
    return alt:radar.
  } else {
    return altitude - ship:geoposition:terrainheight.
  }
}

wait until trueAlt() < 6000.
set warp to 0.

stage.

clearscreen.
print "trueAlt   :" at (2, 11).
print "tgtVel    :" at (2, 12).
print "tgtAccel  :" at (2, 13).
print "gHere     :" at (2, 14).
print "throt     :" at (2, 15).

local tgtVel to 0.
lock tgtVel to -trueAlt() / 20 - 2.

local maxEngineAccel to 0.
lock maxEngineAccel to myMaxThrust / mass.

local gHere to body:mu / (body:radius ^ 2).

sas off.

lock steering to lookdirup(-ship:obt:velocity:surface, ship:facing:topvector).
local throt to 1.
lock throttle to throt.

when (trueAlt() < 500) then gear on.
when (ship:obt:velocity:surface:mag < 5) then lock steering to lookdirup(up:vector, ship:facing:topvector).

until status = "Landed" {
  local tgtAccel to tgtVel + ship:obt:velocity:surface:mag.
  set throt to (tgtAccel + gHere) / maxEngineAccel.
  print trueAlt() at (15, 11).
  print tgtVel at (15, 12).
  print tgtAccel at (15, 13).
  print gHere at (15, 14).
  print throt at (15, 15).
  wait 0.05.
}

set throt to 0.
