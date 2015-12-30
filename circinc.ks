@lazyglobal off.

parameter tgtInc, settleFuel.

run once funs.

function calcRealAdjAmtForApo {
  parameter n.
  parameter adjAmt.

  local curEcc to orbitat(ship, time:seconds + n:eta + 1):eccentricity.

  set n:prograde to n:prograde + adjAmt.
  local newEcc to orbitat(ship, time:seconds + n:eta + 1):eccentricity.
  set n:prograde to n:prograde - adjAmt.

  if (newEcc < curEcc) {
    return adjAmt.
  } else {
    return -1 * adjAmt.
  }
}

function adjustApo {
  parameter n.
  parameter adjAmt.

  local realAdjAmt to calcRealAdjAmtForApo(n, adjAmt).

  local curEcc to orbitat(ship, time:seconds + n:eta + 1):eccentricity.
  local lastEcc to curEcc.
  until (lastEcc < curEcc) {
    set lastEcc to curEcc.
    set n:prograde to n:prograde + realAdjAmt.
    set curEcc to orbitat(ship, time:seconds + n:eta + 1):eccentricity.
  }
}

function calcRealAdjAmtForInc {
  parameter tgtInc.
  parameter n.
  parameter adjAmt.

  local curInc to orbitat(ship, time:seconds + n:eta + 1):inclination.
  local curDiff to absDiffMod(tgtInc, curInc, 360).

  set n:normal to n:normal + adjAmt.
  local newInc to orbitat(ship, time:seconds + n:eta + 1):inclination.
  local newDiff to absDiffMod(tgtInc, newInc, 360).
  set n:normal to n:normal - adjAmt.

  if (newDiff < curDiff) {
    return adjAmt.
  } else {
    return -1 * adjAmt.
  }
}

function adjustInc {
  parameter tgtInc.
  parameter n.
  parameter adjAmt.

  local realAdjAmt to calcRealAdjAmtForInc(tgtInc, n, adjAmt).

  local curDiff to absDiffMod(orbitat(ship, time:seconds + n:eta + 1):inclination, tgtInc, 360).
  local lastDiff to curDiff.
  until (lastDiff < curDiff) {
    set lastDiff to curDiff.
    set n:normal to n:normal + realAdjAmt.
    set curDiff to absDiffMod(orbitat(ship, time:seconds + n:eta + 1):inclination, tgtInc, 360).
  }
}

local n to node(time:seconds + eta:apoapsis, 0, 0, 0).
add n.

local i to 1.
until i = 20 {
  local adjAmt to (20 - i) / 4.
  adjustApo(n, adjAmt).
  adjustInc(tgtInc, n, adjAmt).
  set i to i + 1.
}

run execNode(settleFuel).
