@lazyglobal off.

// LAN increases approx. 6 degrees during Cape Canaveral eastward launch

parameter initialTurnAngle, initialTurnStartSpeed, orbitalTurnEndAltitude, targetInclination, targetAltitude.

runoncepath("lib/libsasrcsstack").
runoncepath("lib/libengine").
runoncepath("lib/libsmoothturn").
runoncepath("lib/libburntime").

local LOGFILE to "log/lastlaunch.log".
deletepath(LOGFILE).

function engineFlamedOut {
  parameter igEs.
  for e in igEs {
    if e:flameout {
      return true.
    }
  }
  return false.
}

// Source: http://www.orbiterwiki.org/wiki/Launch_Azimuth
local val to cos(targetInclination) / cos(ship:latitude).
local betaInertial to arcsin(max(-1, min(1, cos(targetInclination) / cos(ship:latitude)))).
local vEqRot to 2 * constant:pi * body:radius / body:rotationperiod.
local vOrbit to sqrt(body:mu / (body:radius + targetAltitude)).
local launchAzimuth to arctan((vOrbit * sin(betaInertial) -  vEqRot * cos(ship:latitude)) / (vOrbit * cos(betaInertial))).

log "Launching at " + time:seconds to LOGFILE.
log "Inputs:" to LOGFILE.
log "  Initial Turn Angle: " + initialTurnAngle to LOGFILE.
log "  Initial Turn Start Speed: " + initialTurnStartSpeed to LOGFILE.
log "  Orbital Turn End Altitude: " + orbitalTurnEndAltitude to LOGFILE.
log "  Target Inclination: " + targetInclination to LOGFILE.
log "  Target Altitude: " + targetAltitude to LOGFILE.
log "launch azimuth: " + launchAzimuth to LOGFILE.

local lock obtProProjOntoHorizon to ship:velocity:orbit - vdot(ship:velocity:orbit, up:vector) * up:vector.
local lock srfProProjOntoHorizon to ship:velocity:surface - vdot(ship:velocity:surface, up:vector) * up:vector.
local lock obtHdng to vang(obtProProjOntoHorizon, north:vector).
local lock srfHdng to vang(srfProProjOntoHorizon, north:vector).
local lock obtPitch to 90 - vang(ship:velocity:orbit, up:vector).
local lock srfPitch to 90 - vang(ship:velocity:surface, up:vector).

set ship:control:pilotmainthrottle to 0.
pushSAS(true).
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

lock steering to smoothScalarBasedTurn(ship:verticalspeed, initialTurnStartSpeed, initialTurnStartSpeed * 1.25,
                                       heading(launchAzimuth, 90):vector,
                                       heading(launchAzimuth, 90 - initialTurnAngle):vector,
                                       ship:facing:topvector).

wait until vang(ship:velocity:surface, up:vector) > initialTurnAngle.
lock steering to lookdirup(heading(launchAzimuth, srfPitch):vector, ship:facing:topvector).

local maxQ to ship:q.
until ship:q < 0.75 * maxQ {
  set maxQ to max(maxQ, ship:q).
  wait 0.05.
}

local startAlt to ship:altitude.
local igEs to ignitedEngines().
until engineFlamedOut(igEs) {
  local lock turnStart to lookdirup(heading(launchAzimuth, srfPitch):vector, ship:facing:topvector):vector.
  local lock turnEnd to lookdirup(heading(launchAzimuth, obtPitch):vector, ship:facing:topvector):vector.
  lock steering to smoothScalarBasedTurn(ship:altitude, startAlt, orbitalTurnEndAltitude,
                                         turnStart, turnEnd, ship:facing:topvector).

  // Limit acceleration (doesn't limit to exactly 5g, but it's close enough)
  lock throttle to max(0, min(1, mass * 5 * 9.82 / max(0.1, maxthrust))).
}

pushRCS(true).
set ship:control:fore to 1.
stage. // jettison interstage fairing and decouple booster
wait 2.

// We probably had no steering control for a while. Instead of abruptly snapping back to
// the intended steering as soon as the engines turn on, unlock steering for a few
// seconds.
unlock steering.

stage. // second stage ignition
set ship:control:fore to 0.
popRCS().
wait 8. // wait for SAS and the engine to help stabilize us
when ship:altitude > body:atm:height then { stage. } // jettison payload fairing

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
until ship:orbit:periapsis > body:atm:height and lastEcc < ship:orbit:eccentricity {
  local dvToCirc to sqrt(body:mu / (body:radius + apoapsis)) - ship:velocity:orbit:mag.
  local ttcirc to burnTime(dvToCirc).

  local dt to time:seconds - lastTime.
  //print "lastEta = " + lastEta..
  //print "eta:apoapsis = " + eta:apoapsis..
  //print "dt = " + dt.
  local etaRate to (lastETA - eta:apoapsis) / dt.
  //print "etaRate = " + etaRate.
  local tteta to eta:apoapsis / etaRate.
  if eta:periapsis < eta:apoapsis {
    set tteta to ttcirc.
  }

  if time:seconds - lastPitchUpdateTime > pitchUpdatePeriod {
    // for every 1 minute we are short of tteta, raise the nose by 7
    // degrees (or point down if we are accelerating too fast)
    local pitchOffsetMax to 30.
    set pitchOffset to 7 * (ttcirc - tteta) / 60.
    set pitchOffset to min(pitchOffsetMax, max(-pitchOffsetMax, pitchOffset)).

    if etaRate < 0 and eta:apoapsis < eta:periapsis {
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

  log "lastEcc: " + lastEcc to LOGFILE.
  log "ship:orbit:eccentricity: " + ship:orbit:eccentricity to LOGFILE.
  log "lastETA: " + lastETA to LOGFILE.
  log "eta:apoapsis: " + eta:apoapsis to LOGFILE.
  log "dt: " + dt to LOGFILE.
  log "etaRate: " + etaRate to LOGFILE.
  log "tteta: " + tteta to LOGFILE.
  log "ttcirc: " + ttcirc to LOGFILE.
  log "obtPitch: " + obtPitch to LOGFILE.
  log "pitchStart: " + pitchStart to LOGFILE.
  log "pitchEnd: " + pitchEnd to LOGFILE.
  log "pitchOffset: " + pitchOffset to LOGFILE.
  log "lastPitchUpdateTime: " + lastPitchUpdateTime to LOGFILE.
  log "smoothPitch: " + smoothPitch to LOGFILE.
  log "curLAN: " + curLAN to LOGFILE.
  log "lastLAN: " + lastLAN to LOGFILE.
  log "lanROC: " + lanROC to LOGFILE.
  log "hdngOffset: " + hdngOffset to LOGFILE.

  lock steering to lookdirup(heading(launchAzimuth, smoothPitch):vector, ship:facing:topvector).

  log "-----------------------------------------------------------------------------" to LOGFILE.

  set lastEcc to ship:orbit:eccentricity.
  set lastLAN to curLAN.
  set lastETA to eta:apoapsis.
  set lastTime to time:seconds.
  wait 0.05.
}

unlock steering.
lock throttle to 0.
popSAS().

wait 1. // wait for throttle change to take effect.
unlock throttle.
