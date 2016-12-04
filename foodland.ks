@lazyglobal off.

//parameter myMaxThrust.
local myMaxThrust to 180.16.
when (trueAlt() < 15000) then set warp to 0.

function trueAlt {
  if abs(altitude - alt:radar) / altitude > 0.05 {
    return alt:radar.
  } else {
    return altitude - ship:geoposition:terrainheight.
  }
}

sas off.
gear off.

wait until trueAlt() < 3000.

clearscreen.
print "trueAlt   :" at (2, 11).
print "sVel      :" at (2, 12).
print "tgtVel    :" at (2, 13).
print "tgtAccel  :" at (2, 14).
print "gHere     :" at (2, 15).
print "throt     :" at (2, 16).

local lock tgtVel to -trueAlt() / 20 - 2.

local lock maxEngineAccel to myMaxThrust / mass.

local gHere to body:mu / (body:radius ^ 2).

lock steering to lookdirup(-ship:obt:velocity:surface, ship:facing:topvector).
local throt to 0.
lock throttle to throt.

when (throt > 0.005) then stage.
when (trueAlt() < 500) then gear on.
when (ship:obt:velocity:surface:mag < 25) then ag2 on.
when (ship:obt:velocity:surface:mag < 5) then lock steering to lookdirup(up:vector, ship:facing:topvector).

local steerArrow to vecdraw().
set steerArrow:vec to steering:vector.
set steerArrow:show to true.
set steerArrow:scale to 10.
set steerArrow:color to rgb(1,0,0).

local steerTopArrow to vecdraw().
set steerTopArrow:vec to steering:topvector.
set steerTopArrow:show to true.
set steerTopArrow:scale to 10.
set steerTopArrow:color to rgb(1,1,1).

local retroArrow to vecdraw().
set retroArrow:vec to -ship:obt:velocity:surface.
set retroArrow:show to true.
set retroArrow:scale to 10.
set retroArrow:color to rgb(0,0,1).

local topArrow to vecdraw().
set topArrow:vec to ship:facing:topvector.
set topArrow:show to true.
set topArrow:scale to 10.
set topArrow:color to rgb(0,1,0).

until status = "Landed" {
  set steerArrow:vec to steering:vector.
  set steerTopArrow:vec to steering:topvector.
  set retroArrow:vec to -ship:obt:velocity:surface.
  set topArrow:vec to ship:facing:topvector.

  local tgtAccel to tgtVel + ship:obt:velocity:surface:mag.
  set throt to (tgtAccel + gHere) / maxEngineAccel.
  print trueAlt() at (15, 11).
  print ship:obt:velocity:surface:mag at (15, 12).
  print tgtVel at (15, 13).
  print tgtAccel at (15, 14).
  print gHere at (15, 15).
  print throt at (15, 16).
  wait 0.05.
}

set throt to 1.
stage.
