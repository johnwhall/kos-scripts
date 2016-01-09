@lazyglobal off.

run once libabsdiffmod.
run once libsecantmethod.

function phaseAngle {
  parameter p_atTime.
  parameter p_tgt.

  local bcShipPos to positionat(ship, p_atTime) - body:position.
  local bcTgtPos to positionat(p_tgt, p_atTime) - body:position.

  local bcShipPosProj to vxcl(north:vector, bcShipPos).
  local bcTgtPosProj to vxcl(north:vector, bcTgtPos).

  local ang to vang(bcShipPosProj, bcTgtPosProj).
  if vdot(vcrs(bcShipPosProj, bcTgtPosProj), north:vector) > 0 {
    set ang to 360 - ang.
  }

  return ang.
}

function ttpaf {
  parameter p_deltaTimeGuess.
  parameter p_tgtAngle.
  parameter p_tgt.

  local timeGuess to time:seconds + p_deltaTimeGuess.
  local guessSCShipPos to positionat(ship, timeGuess).
  local guessBCShipPos to guessSCShipPos - body:position.
  local guessAngle to phaseAngle(timeGuess, p_tgt).
  return absDiffMod(guessAngle, p_tgtAngle, 360).
}

function timeToPhaseAngle {
  // Probably won't work well for targets with similar orbital periods.
  parameter p_tgtAngle.
  parameter p_tgt.

  local curAngle to phaseAngle(time:seconds, p_tgt).
  local tgtAngle to p_tgtAngle.

  local deltaAngle to curAngle - tgtAngle.
  if deltaAngle < 0 {
    set deltaAngle to 360 + deltaAngle.
  }

  local synodicPeriod to 1 / ((1 / ship:orbit:period) - (1 / p_tgt:orbit:period)).
  local initialGuess to deltaAngle / (360 / synodicPeriod).
  local initialVal to ttpaf(initialGuess, tgtAngle, p_tgt).

  local state to list().
  local curGuess to initialGuess + 100.
  secantMethodInitState(10, 1e-2, initialGuess, initialVal, curGuess, state).
  local converged to false.
  local pastMaxIter to false.

  until converged or pastMaxIter {
    local curVal to ttpaf(curGuess, tgtAngle, p_tgt).

    if secantMethodConverged(curVal, state) {
      set converged to true.
    } else if secantMethodPastMaxIter(state) {
      set pastMaxIter to true.
    } else {
      set curGuess to secantMethodIter(curVal, state).
    }
  }

  if pastMaxIter { print "PAST MAX ITER!". }
  if not converged { print "DID NOT CONVERGE!". }

  return curGuess.
}

//local tgtAngle to 270.
//local tt to timeToPhaseAngle(tgtAngle, moon).
////add node(time:seconds + tt, 0, 0, 0).
//
//print "Current Phase Angle: " + phaseAngle(time:seconds, moon).
//print "Target Phase Angle: " + tgtAngle.
//print "Time to Target: " + tt.
//print "Calculated Phase Angle: " + phaseAngle(time:seconds + tt, moon).
