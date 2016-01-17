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

local obtProProjOntoHorizon to 0.
lock obtProProjOntoHorizon to ship:velocity:orbit - vdot(ship:velocity:orbit, up:vector) * up:vector.

local srfProProjOntoHorizon to 0.
lock srfProProjOntoHorizon to ship:velocity:surface - vdot(ship:velocity:surface, up:vector) * up:vector.

local obtHdng to 0.
lock obtHdng to vang(obtProProjOntoHorizon, north:vector).

local srfHdng to 0.
lock srfHdng to vang(srfProProjOntoHorizon, north:vector).

local obtPitch to 0.
lock obtPitch to 90 - vang(ship:velocity:orbit, up:vector).

local srfPitch to 0.
lock srfPitch to 90 - vang(ship:velocity:surface, up:vector).

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
lock steering to lookdirup(heading(launchHeading, srfPitch):vector, ship:facing:topvector).

local maxQ to ship:q.
until ship:q < 0.75 * maxQ {
  set maxQ to max(maxQ, ship:q).
  wait 0.05.
}

local startAlt to ship:altitude.
local igEs to ignitedEngines().
until engineFlamedOut(igEs) {
  lock steering to smoothScalarBasedTurn(ship:altitude, startAlt, 50000,
                                         ship:velocity:surface, ship:velocity:orbit,
                                         ship:facing:topvector).

  // Limit acceleration (doesn't limit to exactly 5g, but it's close enough)
  lock throttle to max(0, min(1, mass * 5 * 9.82 / max(0.1, maxthrust))).
}

stage.
wait 3.

// We probably had no steering control for a while. Instead of abruptly snapping back to
// the intended steering as soon as the engines turn on, unlock steering for a few
// seconds.
unlock steering.

stage.
wait 8.
stage.

local lastEcc to ship:orbit:eccentricity.
local lastLAN to ship:orbit:longitudeofascendingnode.
local lastETA to eta:apoapsis.
local lastTime to time:seconds.
local lanPID to PIDLoop(1, 0, 0, -1, 1).
local pitchUpdatePeriod to 5.
local lastPitchUpdateTime to 0.
local pitchOffset to 0.
local pitchStart to obtPitch.
local pitchEnd to pitchStart.
wait 1.

local startTime to time:seconds.
until lastEcc < ship:orbit:eccentricity {
  local dvToCirc to sqrt(body:mu / (body:radius + apoapsis)) - ship:velocity:orbit:mag.
  local ttcirc to burnTime1(dvToCirc).

  local dt to time:seconds - lastTime.
  local etaRate to (lastETA - eta:apoapsis) / dt.
  local tteta to eta:apoapsis / etaRate.

  if time:seconds - lastPitchUpdateTime > pitchUpdatePeriod {
    // for every 1 minute we are short of tteta, raise the nose by 7
    // degrees (or point down if we are accelerating too fast)
    local pitchOffsetMax to 30.
    set pitchOffset to 7 * (ttcirc - tteta) / 60.
    set pitchOffset to min(pitchOffsetMax, max(-pitchOffsetMax, pitchOffset)).

    if etaRate < 0 {
      set pitchOffset to -pitchOffsetMax.
    }

    set lastPitchUpdateTime to time:seconds.
    local curPitch to 90 - vang(ship:facing:vector, up:vector).
    set pitchStart to curPitch.
    set pitchEnd to obtPitch + pitchOffset.
  }

  local smoothPitch to smoothScalarBasedProgression(time:seconds, lastPitchUpdateTime, lastPitchUpdateTime + pitchUpdatePeriod * 4, pitchStart, pitchEnd).

  // try to keep LAN stable
  local curLAN to ship:orbit:longitudeofascendingnode.
  local lanROC to (curLAN - lastLAN) / dt.
  local hdngOffset to -lanPID:update(time:seconds, lanROC).

  print "lastEcc: " + lastEcc.
  print "ship:orbit:eccentricity: " + ship:orbit:eccentricity.
  print "lastETA: " + lastETA.
  print "eta:apoapsis: " + eta:apoapsis.
  print "dt: " + dt.
  print "etaRate: " + etaRate.
  print "tteta: " + tteta.
  print "ttcirc: " + ttcirc.
  print "obtPitch: " + obtPitch.
  print "pitchStart: " + pitchStart.
  print "pitchEnd: " + pitchEnd.
  print "pitchOffset: " + pitchOffset.
  print "lastPitchUpdateTime: " + lastPitchUpdateTime.
  print "smoothPitch: " + smoothPitch.
  print "curLAN: " + curLAN.
  print "lastLAN: " + lastLAN.
  print "lanROC: " + lanROC.
  print "hdngOffset: " + hdngOffset.

  lock steering to lookdirup(heading(obtHdng + hdngOffset, smoothPitch):vector, ship:facing:topvector).

  print "-----------------------------------------------------------------------------".

  set lastEcc to ship:orbit:eccentricity.
  set lastLAN to curLAN.
  set lastETA to eta:apoapsis.
  set lastTime to time:seconds.
  wait 0.05.
}

unlock steering.
lock throttle to 0.

wait 0.05. // wait for throttle change to take effect.
