@lazyglobal off.

runoncepath("lib/libabsdiffmod").
runoncepath("lib/libsecantmethod").

function angleToPrograde {
  // This is slightly inaccurate due to the fact that it doesn't account for the
  // body's motion around its body (e.g. for ship orbiting earth: earth's motion
  // around sun). But this is only a problem when
  // p_bcShipPos != ship:position - body:position.

  // bc = body-centric (for ship orbiting earth: earth-centric)
  // bb = body's body (for ship orbiting earth: sun)
  // b = body (for ship orbiting earth: earth)

  parameter p_body.
  parameter p_bcShipPos.

  local bcBBPos to p_body:body:position - p_body:position.
  local bcBPro to p_body:orbit:velocity:orbit.

  local bObtNrml to vcrs(bcBBPos, bcBPro).
  local bcShipProjOntoPlane to vxcl(bObtNrml, p_bcShipPos).

  local angToPro to vang(bcShipProjOntoPlane, bcBPro).

  if vdot(vcrs(bcShipProjOntoPlane, bcBPro), bObtNrml) > 0 {
    set angToPro to 360 - angToPro.
  }

  return angToPro.
}

function timeToAngleToPrograde {
  // This is slightly inaccurate due to the fact that it doesn't account for the
  // body's motion around its body (e.g. for ship orbiting earth: earth's motion
  // around sun).
  parameter p_tgtAngle.

  local curAngle to angleToPrograde(body, ship:position - body:position).

  function cb {
    parameter p_deltaTimeGuess.
    local guessSCShipPos to positionat(ship, time:seconds + p_deltaTimeGuess).
    local guessBCShipPos to guessSCShipPos - body:position.
    local guessAngle to angleToPrograde(body, guessBCShipPos).
    return absDiffMod(guessAngle, p_tgtAngle, 360).
  }

  local deltaAngle to curAngle - p_tgtAngle.
  if deltaAngle < 0 {
    set deltaAngle to deltaAngle + 360.
  }

  local guess1 to deltaAngle / (360 / ship:obt:period).
  local guess2 to guess1 + 100.
  local result to secantMethod(cb@, guess1, guess2, 10, 1e-2).

  return result.
}

//local tgtAngle to 270.
//local ttatp to timeToAngleToPrograde(tgtAngle).
////add node(time:seconds + ttatp, 0, 0, 0).
//
//local scShipPosAt to positionat(ship, time:seconds + ttatp).
//local bcShipPosAt to scShipPosAt - body:position.
//
//print "Current ATP: " + angleToPrograde(body, ship:position - body:position).
//print "Target ATP: " + tgtAngle.
//print "Time to Target: " + ttatp.
//print "Position at Target Time: " + scShipPosAt.
//print "Calculated ATP: " + angleToPrograde(body, bcShipPosAt).
