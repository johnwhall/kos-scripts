@lazyglobal off.

parameter where.
parameter tgtApo. // not including body radius
parameter settleFuel.

runoncepath("/lib/libburntime").
runoncepath("/lib/libtimeto").

local targetTime to time:seconds + timeTo1(where, list("per", "anode", "dnode")).

local tgtSMA to (ship:obt:periapsis + tgtApo + 2 * body:radius) / 2.
local v to sqrt(body:mu * (2 / (ship:obt:periapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
local tgtV to sqrt(body:mu * (2 / (ship:obt:periapsis + body:radius) - 1 / tgtSMA)).
local dv to abs(tgtV - v).
local bt to burnTime1(dv).
local halfDVTime to burnTime1(dv / 2).

local burnStartTime to targetTime - halfDVTime.
local burnEndTime to burnStartTime + bt.
local burnMidTime to (burnStartTime + burnEndTime) / 2.

print "current time = " + time:seconds.
print "targetTime = " + targetTime.
print "bt = " + bt.
print "halfDVTime = " + halfDVTime.
print "burnStartTime = " + burnStartTime.
print "burnMidTime = " + burnMidTime.
print "burnEndTime = " + burnEndTime.

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

local lock pointVec to retrograde:vector.
if (tgtApo > ship:obt:apoapsis) {
  lock pointVec to prograde:vector.
}

runpath("prepareForBurn", pointVec, burnMidTime, bt, settleFuel).
lock steering to lookdirup(pointVec, ship:facing:topvector).

local cDiff to 0.
lock cDiff to abs(ship:obt:apoapsis - tgtApo).
local lastDiff to cDiff.
set throt to 1.
wait 0.1.
until lastDiff < cDiff {
  set lastDiff to cDiff.
  wait 0.05.
}

set throt to 0.
set sas to prevSAS.
unlock steering.

wait 0.05. // wait for throttle change to take effect
