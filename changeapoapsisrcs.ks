@lazyglobal off.

{
  parameter tgtApo, turnTime, rcsIsp, rcsThrust, turnWithRCS is false, where is "periapsis".

  runoncepath("lib/libtimeto").
  runoncepath("lib/libburntime").
  runoncepath("lib/libsasrcsstack").
  runoncepath("lib/libgenericburn").

  local tgtSMA to (ship:obt:periapsis + tgtApo + 2 * body:radius) / 2.
  local v to sqrt(body:mu * (2 / (ship:obt:periapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
  local tgtV to sqrt(body:mu * (2 / (ship:obt:periapsis + body:radius) - 1 / tgtSMA)).
  local dv to abs(tgtV - v).
  local bt to burnTime(dv, rcsIsp, rcsThrust).

  local dirSign to 1.
  if tgtApo < ship:obt:apoapsis { set dirSign to -1. }

  function cb {
    parameter predictDir, lastVal, lastTime.
    local val to abs(tgtApo - ship:apoapsis).
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
