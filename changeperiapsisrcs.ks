@lazyglobal off.

{
  parameter tgtPer, turnTime, rcsIsp, rcsThrust, turnWithRCS is false, where is "apoapsis".

  runoncepath("lib/libtimeto").
  runoncepath("lib/libburntime").
  runoncepath("lib/libsasrcsstack").
  runoncepath("lib/libgenericburn").

  local tgtSMA to (ship:obt:apoapsis + tgtPer + 2 * body:radius) / 2.
  local v to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
  local tgtV to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / tgtSMA)).
  local dv to abs(tgtV - v).
  local bt to burnTime(dv, rcsIsp, rcsThrust).

  local dirSign to 1.
  if tgtPer < ship:obt:periapsis { set dirSign to -1. }

  function cb {
    parameter predictDir, lastVal, lastTime.
    local val to abs(tgtPer - ship:periapsis).
    local throt to 1.

    if lastVal >= 0 {
      local rate to (val - lastVal) / (time:seconds - lastTime).
      local ttzero to val / (-rate).
      set throt to max(0.1, min(1, ttzero)).
      //print "ttzero: "  + ttzero.
    }

    local dir to ship:orbit:velocity:orbit.
    if predictDir { set dir to velocityat(ship, time:seconds + timeTo1(where)):orbit. }
    set dir to dirSign * dir.

    return lexicon("dir", dir, "throt", throt, "val", val).
  }

  genericBurnRCS(where, bt, turnTime, cb@, turnWithRCS).
}
