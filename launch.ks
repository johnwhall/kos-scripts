@lazyglobal off.

parameter initialTurnAngle, initialTurnStartSpeed.

run once funs.

function engineFlamedOut {
  parameter igEs.
  for e in igEs {
    if e:flameout {
      return true.
    }
  }
  return false.
}

set ship:control:pilotmainthrottle to 0.
sas on.
gear off.
lock throttle to 1.
wait 1. // wait for lock throttle to take effect
stage.

wait until currentTWR() > 1.
wait until stage:ready.

stage.

wait 1.

lock steering to lookdirup(up:vector, ship:facing:topvector).

wait until ship:verticalspeed > initialTurnStartSpeed.

local launchHeading to 90.

lock steering to smoothScalarBasedTurn(ship:verticalspeed, initialTurnStartSpeed, 80,
                                       heading(launchHeading, 90):vector,
                                       heading(launchHeading, 90 - initialTurnAngle):vector,
                                       ship:facing:topvector).

wait until vang(ship:velocity:surface, up:vector) > initialTurnAngle.
lock steering to lookdirup(ship:velocity:surface, ship:facing:topvector).

local maxQ to ship:q.
until ship:q < 0.75 * maxQ {
  set maxQ to max(maxQ, ship:q).
  wait 0.05.
}

local startAlt to ship:altitude.
lock steering to smoothScalarBasedTurn(ship:altitude, startAlt, 100000,
                                       ship:velocity:surface, ship:velocity:orbit,
                                       ship:facing:topvector).

local progradeProjection to 0.
lock progradeProjection to ship:velocity:orbit - vdot(ship:velocity:orbit, up:vector) * up:vector.

local hdng to 0.
lock hdng to vang(progradeProjection, north:vector).

local angleProgradeFromHorizon to 0.
lock angleProgradeFromHorizon to 90 - vang(ship:velocity:orbit, up:vector).

// Limit acceleration (doesn't limit to exactly 5g, but it's close enough)
lock throttle to max(0, min(1, mass * 5 * 9.82 / max(0.1, maxthrust))).

local igEs to ignitedEngines().
wait until engineFlamedOut(igEs).
stage.
wait 3.

// We weren't turning for a while, and the staging might have changed our orientation slightly,
// so instead of jumping back to the target vector (which we are probably off of a few degrees
// by now), reset the turn.
//set startAlt to ship:altitude.
//lock steering to smoothScalarBasedTurn(ship:altitude, startAlt, 100000,
////                                       ship:velocity:surface, ship:velocity:orbit,
//                                       ship:facing:vector, ship:velocity:orbit,
//                                       ship:facing:topvector).

unlock steering.

stage.
wait 8.
stage.

local lastEcc to ship:orbit:eccentricity.
local lastETA to eta:apoapsis.
local lastTime to time:seconds.
wait 1.

until lastEcc < ship:orbit:eccentricity {
  local dvToCirc to sqrt(body:mu / (body:radius + apoapsis)) - ship:velocity:orbit:mag.
  local ttcirc to burnTime1(dvToCirc).

  local dt to time:seconds - lastTime.

  local etaRate to (lastETA - eta:apoapsis) / dt.
  local tteta to eta:apoapsis / etaRate.

  // for every 1 minute we are short of tteta, raise the nose by 7
  // degrees (or point down if we are accelerating too fast)
  local offset to 7 * (ttcirc - tteta) / 60.
  set offset to min(15, max(-15, offset)).

  if etaRate < 0 {
    set offset to -15.
  }

  print "lastEcc: " + lastEcc.
  print "ship:orbit:eccentricity: " + ship:orbit:eccentricity.
  print "lastETA: " + lastETA.
  print "eta:apoapsis: " + eta:apoapsis.
  print "dt: " + dt.
  print "etaRate: " + etaRate.
  print "tteta: " + tteta.
  print "ttcirc: " + ttcirc.
  print "offset: " + offset.
  print "-----------------------------------------------------------------------------".

  local startTime to time:seconds.
  lock steering to smoothScalarBasedTurn(time:seconds, startTime, startTime + 20,
                                         ship:facing:vector,
                                         heading(hdng, angleProgradeFromHorizon + offset):vector,
                                         ship:facing:topvector).

  set lastEcc to ship:orbit:eccentricity.
  set lastETA to eta:apoapsis.
  set lastTime to time:seconds.
  wait 0.05.
}

unlock steering.
lock throttle to 0.

wait 0.05. // wait for throttle change to take effect.
