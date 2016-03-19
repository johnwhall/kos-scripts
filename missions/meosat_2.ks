@lazyglobal off.

run once circincatapo.funs.ks.
run once execnode.funs.ks.
run once funs.ks.

function partialCircInc {
  local n to nodeToCircIncAtApo(0).
  add n.

  local startLatSign to sign(ship:geoposition:lat).
  local execNodeState to list().
  execNodeStart(false, execNodeState).
  until sign(ship:geoposition:lat) <> startLatSign {
    if not execNodeContinue(execNodeState) {
      break.
    }
  }

  execNodeStop(execNodeState).

  remove n.
}

function ensurePeriodDifference {
  parameter tgt, tgtPDiff.

  if abs(tgt:orbit:period - ship:orbit:period) < tgtPDiff {
    warpFor1(eta:periapsis - 30).

    lock steering to lookdirup(ship:orbit:velocity:orbit, ship:facing:topvector).
    if (ship:orbit:period < tgt:orbit:period) {
      lock steering to lookdirup(-ship:orbit:velocity:orbit, ship:facing:topvector).
    }
    wait until faceDiff() < 0.5.

    set ship:control:fore to 1.
    wait until abs(tgt:orbit:period - ship:orbit:period) > tgtPDiff.
    set ship:control:fore to 0.
    unlock steering.
  }
}

function matchPeriod {
  parameter tgt.

  warpFor1(eta:periapsis - 30).
  lock steering to lookdirup(ship:orbit:velocity:orbit, ship:facing:topvector).
  if (ship:orbit:period > tgt:orbit:period) {
    lock steering to lookdirup(-ship:orbit:velocity:orbit, ship:facing:topvector).
  }
  wait until faceDiff() < 0.5.

  local lastDiff to abs(tgt:orbit:period - ship:orbit:period).
  set ship:control:fore to 0.25.
  wait 1.
  until abs(tgt:orbit:period - ship:orbit:period) > lastDiff {
    set lastDiff to abs(tgt:orbit:period - ship:orbit:period).
    wait 0.05.
  }

  set ship:control:fore to 0.
  unlock steering.
}

stage. // dummy decoupler stage
wait until stage:ready.
stage. // activate engines
rcs on.
toggle ag1. // turn RCS thrusters back on

// Do this a few times so it is more accurate
partialCircInc().
partialCircInc().

// And finally finish it
run circincatapo(0, false).

local sat1 to vessel("MEO Comsat 1").
ensurePeriodDifference(sat1, 60).
set warp to 4.
wait until abs(vang(-body:position, sat1:position - body:position) - 90) < 1.
set warp to 0.
matchPeriod(sat1).

rcs off.
