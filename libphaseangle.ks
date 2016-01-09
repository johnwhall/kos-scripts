@lazyglobal off.

run once libphaseangle_callback.
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

function timeToPhaseAngle {
  // Probably won't work well for targets with similar orbital periods.
  parameter p_tgtAngle.
  parameter p_tgt.

  local curAngle to phaseAngle(time:seconds, p_tgt).
  local tgtAngle to p_tgtAngle.

  set g_libphaseangle_callback_tgtAngle to tgtAngle.
  set g_libphaseangle_callback_tgt to p_tgt.

  local deltaAngle to curAngle - tgtAngle.
  if deltaAngle < 0 {
    set deltaAngle to 360 + deltaAngle.
  }

  local synodicPeriod to 1 / ((1 / ship:orbit:period) - (1 / p_tgt:orbit:period)).
  local guess1 to deltaAngle / (360 / synodicPeriod).
  local guess2 to guess1 + 100.
  local result to secantMethod("libphaseangle_callback", guess1, guess2, 10, 1e-2).

  return result.
}

//local tgtAngle to 270.
//local tt to timeToPhaseAngle(tgtAngle, moon).
////add node(time:seconds + tt, 0, 0, 0).
//
//print "Current Phase Angle: " + phaseAngle(time:seconds, moon).
//print "Target Phase Angle: " + tgtAngle.
//print "Time to Target: " + tt.
//print "Calculated Phase Angle: " + phaseAngle(time:seconds + tt, moon).
