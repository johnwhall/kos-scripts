@lazyglobal off.

parameter where.
parameter tgtApo. // not including body radius
parameter turnTime.
parameter ullageTime.

runoncepath("lib/libburntime").
runoncepath("lib/libtimeto").
runoncepath("lib/libgenericburn").

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

function changeapoapsis_cb {
  parameter predictDir, lastVal, lastTime.
  local val to abs(ship:obt:apoapsis - tgtApo).

  local throt to 1.
  if lastVal >= 0 {
    local rate to (val - lastVal) / (time:seconds - lastTime).
    local ttzero to val / (-rate).
    set throt to max(0.1, min(1, ttzero)).
  }

  local dir to prograde:vector.
  if predictDir { set dir to velocityat(ship, targetTime - halfDVTime):orbit. }
  if tgtApo < ship:obt:apoapsis { set dir to R(180, 0, 0) * dir. }

  return lexicon("dir", dir, "throt", throt, "val", val).
}

genericBurn(burnMidTime, bt, turnTime, ullageTime, changeapoapsis_cb@).
