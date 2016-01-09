@lazyglobal off.

run once funs.
run once libsecantmethod.ks.

function angleToPrograde {
  // This is slightly inaccurate due to the fact that it doesn't account for the
  // body's motion around its body (e.g. for ship orbiting earth: earth's motion
  // around sun). But this is only a problem when
  // p_bcShipPos != ship:position - body:position.

  // bc = body-centric (for ship orbiting earth: earth-centric)
  // bb = body's body (for ship orbiting earth: sun)
  // b = body (for ship orbiting earth: earth)

  parameter p_bcShipPos.

  local bcBBPos to body:body:position - body:position.
  local bcBPro to body:orbit:velocity:orbit.

  local bObtNrml to vcrs(bcBBPos, bcBPro).
  local bcShipProjOntoPlane to vxcl(bObtNrml, p_bcShipPos).

  local angToPro to vang(bcShipProjOntoPlane, bcBPro).

  if vdot(vcrs(bcShipProjOntoPlane, bcBPro), bObtNrml) > 0 {
    set angToPro to 360 - angToPro.
  }

  return angToPro.
}

function ttatpf {
  parameter p_deltaTimeGuess.
  parameter p_tgtAngle.
  local guessSCShipPos to positionat(ship, time:seconds + p_deltaTimeGuess).
  local guessBCShipPos to guessSCShipPos - body:position.
  local guessAngle to angleToPrograde(guessBCShipPos).
  return absDiffMod(guessAngle, p_tgtAngle, 360).
}

function timeToAngleToPrograde {
  // This is slightly inaccurate due to the fact that it doesn't account for the
  // body's motion around its body (e.g. for ship orbiting earth: earth's motion
  // around sun).
  parameter p_tgtAngle.

  local curAngle to angleToPrograde(ship:position - body:position).
  local tgtAngle to p_tgtAngle.

  local deltaAngle to curAngle - tgtAngle.
  if deltaAngle < 0 {
    set deltaAngle to deltaAngle + 360.
  }

  local initialGuess to deltaAngle / (360 / ship:obt:period).
  local initialVal to ttatpf(initialGuess, tgtAngle).

  local state to list().
  local curGuess to initialGuess + 100.
  secantMethodInitState(10, 1e-2, initialGuess, initialVal, curGuess, state).
  local converged to false.
  local pastMaxIter to false.

  until converged or pastMaxIter {
    local curVal to ttatpf(curGuess, tgtAngle).

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
//local ttatp to timeToAngleToPrograde(tgtAngle).
////add node(time:seconds + ttatp, 0, 0, 0).
//
//local scShipPosAt to positionat(ship, time:seconds + ttatp).
//local bcShipPosAt to scShipPosAt - body:position.
//
//print "Current ATP: " + angleToPrograde(ship:position - body:position).
//print "Target ATP: " + tgtAngle.
//print "Time to Target: " + ttatp.
//print "Position at Target Time: " + scShipPosAt.
//print "Calculated ATP: " + angleToPrograde(bcShipPosAt).
