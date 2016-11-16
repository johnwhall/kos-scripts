@lazyglobal off.

runoncepath("lib/libphaseangle").

function nodeForHohmannTransfer {
  parameter tgt.

  if tgt:body <> ship:body {
    print "CANNOT HOHMANN TRANSFER TO TARGET ORBITING DIFFERENT BODY!".
    exit.
  }

  local xferSMA to (ship:orbit:semimajoraxis + tgt:orbit:semimajoraxis) / 2.

  local pt to 0.5 * (xferSMA / tgt:orbit:semimajoraxis) ^ 1.5.
  local ft to pt - floor(pt).
  local theta to 360 * ft.
  local pa to 180 - theta.

  local ttpa to timeToPhaseAngle(pa, tgt).

  local xferVelAtHere to sqrt(body:mu * (2 / ship:orbit:semimajoraxis - 1 / xferSMA)).
  local xferBurnDV to xferVelAtHere - ship:orbit:velocity:orbit:mag.

  return node(time:seconds + ttpa, 0, 0, xferBurnDV).
}

//add nodeForHohmannTransfer(vessel("MEO Comsat Target")).
//add nodeForHohmannTransfer(moon).
