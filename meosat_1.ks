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

rcs off.
