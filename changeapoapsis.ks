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

function pointVecCallback {
  parameter initial.
  if tgtApo > ship:obt:apoapsis {
    if initial {
      //return velocityat(ship, time:seconds + halfDVTime):orbit. // huh? missing time between now and burn start
      return velocityat(ship, targetTime - halfDVTime):orbit.
    } else {
      return prograde:vector.
    }
  } else {
    if initial {
      //return -velocityat(ship, time:seconds + halfDVTime):orbit. // huh? missing time between now and burn start
      return -velocityat(ship, targetTime - halfDVTime):orbit.
    } else {
      return retrograde:vector.
    }
  }
}

function valueCallback {
  return abs(ship:obt:apoapsis - tgtApo).
}

genericBurn(burnMidTime, bt, turnTime, ullageTime, valueCallback@, pointVecCallback@).
