@lazyglobal off.

parameter tgtPeriod, turnTime, ullageTime.

// currently only implemented for increasing period

runoncepath("lib/libgenericburn").
runoncepath("lib/libburntime").

function valueCallback {
  return abs(tgtPeriod - ship:obt:period).
}

function pointVecCallback {
  parameter p_initial.
  if p_initial {
    return velocityat(ship, time:seconds + eta:apoapsis):orbit.
  } else {
    return prograde:vector.
  }
}

local tgtSMA to (body:mu * tgtPeriod^2 / (4 * constant:pi^2))^(1/3).
local tgtVelAtApo to sqrt(body:mu * (2 / (body:radius + ship:obt:apoapsis) - 1 / tgtSMA)).
local curVelAtApo to sqrt(body:mu * (2 / (body:radius + ship:obt:apoapsis) - 1 / ship:obt:semimajoraxis)).
local bt to burnTime(abs(tgtVelAtApo - curVelAtApo)).
print "tgtVelAtApo: " + tgtVelAtApo.
print "curVelAtApo: " + curVelAtApo.
print "bt: " + bt.
print "current SMA: " + ship:obt:semimajoraxis.
print "target SMA: " + tgtSMA.

genericBurn("apo", bt, turnTime, ullageTime, valueCallback@, pointVecCallback@).

runpath("facesun").
