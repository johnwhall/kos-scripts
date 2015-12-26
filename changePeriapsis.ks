@lazyglobal off.

parameter where.
parameter tgtPer.

run once funs.

local timeToBurnMid to 0.
if (where = "apo" or where = "apoapsis") {
  lock timeToBurnMid to eta:apoapsis.
} else if (where = "anode") {
  // assumes current orbit is circular
  lock timeToBurnMid to timetoTrueAnom(360 - ship:obt:argumentofperiapsis).
} else if (where = "dnode") {
  // assumes current orbit is circular
  lock timeToBurnMid to timetoTrueAnom(360 - ship:obt:argumentofperiapsis).
} else {
  print "Invalid where: " + where.
  exit.
}

local tgtSMA to (ship:obt:apoapsis + tgtPer + 2 * body:radius) / 2.
local v to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
local tgtV to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / tgtSMA)).
local dv to abs(tgtV - v).
local bt to burnTime1(dv).

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

warpFor1(timeToBurnMid - bt - 90).

if (tgtPer > ship:obt:periapsis) {
  lock steering to prograde.
} else {
  lock steering to retrograde.
}
wait until faceDiff() < 0.5.

warpFor1(timeToBurnMid - (bt / 2) - 5).
wait until timeToBurnMid < (bt / 2).

local curDiff to 0.
lock curDiff to abs(ship:obt:periapsis - tgtPer).
local lastDiff to curDiff.
set throt to 1.
wait 0.1.
until lastDiff < curDiff {
  set lastDiff to curDiff.
  wait 0.05.
}

set throt to 0.
set sas to prevSAS.
