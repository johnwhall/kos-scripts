@lazyglobal off.

parameter myMaxThrust.

wait until altitude < 30000.
set warp to 0.

clearscreen.
print "alt:radar :" at (2, 10).
print "tgtVel    :" at (2, 11).
print "tgtAccel  :" at (2, 12).
print "gHere     :" at (2, 13).
print "throt     :" at (2, 14).

local tgtVel to 0.
lock tgtVel to -alt:radar / 10 - 2.

local maxEngineAccel to 0.
lock maxEngineAccel to myMaxThrust / mass.

local gHere to body:mu / (body:radius ^ 2).

sas off.

lock steering to lookdirup(-ship:obt:velocity:surface, ship:facing:topvector).
local throt to 1.
lock throttle to throt.

when (alt:radar < 500) then gear on.
when (ship:obt:velocity:surface:mag < 5) then lock steering to lookdirup(up:vector, ship:facing:topvector).

until status = "Landed" {
  local tgtAccel to tgtVel + ship:obt:velocity:surface:mag.
  set throt to (tgtAccel + gHere) / maxEngineAccel.
  print alt:radar at (15, 10).
  print tgtVel at (15, 11).
  print tgtAccel at (15, 12).
  print gHere at (15, 13).
  print throt at (15, 14).
  wait 0.05.
}

set throt to 0.
