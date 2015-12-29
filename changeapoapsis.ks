@lazyglobal off.

parameter where.
parameter tgtApo. // not including body radius
parameter settleFuel.

run once funs.

local timeToBurnMid to 0.
if (where = "per" or where = "peri" or where = "periapsis") {
  lock timeToBurnMid to eta:periapsis.
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

local tgtSMA to (ship:obt:periapsis + tgtApo + 2 * body:radius) / 2.
local v to sqrt(body:mu * (2 / (ship:obt:periapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
local tgtV to sqrt(body:mu * (2 / (ship:obt:periapsis + body:radius) - 1 / tgtSMA)).
local dv to abs(tgtV - v).
local bt to burnTime1(dv).

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

local lock pointVec to retrograde:vector.
if (tgtApo > ship:obt:apoapsis) {
  lock pointVec to prograde:vector.
}

run prepareForBurn(pointVec, time:seconds + timeToBurnMid, bt, settleFuel, 10).

local curDiff to 0.
lock curDiff to abs(ship:obt:apoapsis - tgtApo).
local lastDiff to curDiff.
set throt to 1.
wait 0.1.
until lastDiff < curDiff {
  set lastDiff to curDiff.
  wait 0.05.
}

set throt to 0.
set sas to prevSAS.
unlock steering.

wait 0.05. // wait for throttle change to take effect
