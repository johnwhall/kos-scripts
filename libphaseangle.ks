@lazyglobal off.

run once libabsdiffmod.
run once libbisectionmethod.
run once calc.funs.ks.

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
  run nummthfun4(p_deltaTimeGuess).
  return RETVAL.
}

function timeToPhaseAngle {
  // Probably won't work well for targets with similar orbital periods.
  // Probably also won't work for targets which are not celestial bodies
  // (e.g. vessels you want to rendezvous with).
  parameter p_tgtAngle.
  parameter p_tgt.

  local curAngle to phaseAngle(time:seconds, p_tgt).
  local tgtAngle to p_tgtAngle.

//  if tgtAngle < curAngle {
//    set tgtAngle to 360 - tgtAngle.
//  }

  run deleteifexists("nummthfun4.ks").
  log "parameter x." to nummthfun4.
  log "local tgtAngle to " + p_tgtAngle + "." to nummthfun4.
  log "local tgt to " + p_tgt:name + "." to nummthfun4.
  log "local curPA to " + curAngle + "." to nummthfun4.
  log "local timeGuess to time:seconds + x." to nummthfun4.
  log "local guessSCShipPos to positionat(ship, timeGuess)." to nummthfun4.
  log "local guessBCShipPos to guessSCShipPos - body:position." to nummthfun4.
  log "local guessAngle to phaseAngle(timeGuess, tgt)." to nummthfun4.
  log "if guessAngle < curPA { set guessAngle to 360 - guessAngle. }" to nummthfun4.
  log "set RETVAL to guessAngle - tgtAngle." to nummthfun4.

  local synodicPeriod to 1 / ((1 / ship:orbit:period) - (1 / p_tgt:orbit:period)).
  print "synodicPeriod = " + s2ydhms(synodicPeriod).
  local lowerBound to 0.
  local upperBound to synodicPeriod.

  local tt to bisectionMethod(4, lowerBound, upperBound, 100, 1e-5).

  run deleteifexists("nummthfun4.ks").

  return tt.
}

local tt to timeToPhaseAngle(90, moon).
add node(time:seconds + tt, 0, 0, 0).
print phaseAngle(time:seconds + tt, moon).
