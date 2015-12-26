@lazyglobal off.

run funs.

function atFullThrust {
  parameter es.
  for e in es {
    if (e:thrust / e:availablethrust < 0.95) {
      return false.
    }
  }
  return true.
}

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

// wait for engines to reach full thrust
local igEs to ignitedEngines().
wait until atFullThrust(igEs).

stage.

wait 1.

local forevec to heading(90, 90):vector.
local upvec to ship:facing:topvector.
lock steering to lookdirup(forevec, upvec).

wait until ship:verticalspeed > 60.

sas off. // turn SAS off so kOS doesn't fight it
set forevec to heading(90, 85):vector.

wait until faceDiff() < 0.5.
sas on.

wait until vang(ship:velocity:surface, ship:facing:vector) < 0.5.

lock steering to lookdirup(ship:velocity:surface, upvec).

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

set igEs to ignitedEngines().
wait until engineFlamedOut(igEs).
stage.
wait 3.
stage.
wait 8.
stage.

// TODO: remove?
wait until ship:altitude > 100000.

local ttboState to initTimeToBurnOut().
local lastEcc to ship:orbit:eccentricity.
local lastETA to eta:apoapsis.
local lastTime to time:seconds.
wait 1.

until lastEcc < ship:orbit:eccentricity {
  local ttbo to timeToBurnOut(stage:resources, ttboState).

  print "lastEcc: " + lastEcc.
  print "ship:orbit:eccentricity" + ship:orbit:eccentricity.
  print "lastETA: " + lastETA.
  print "eta:apoapsis: " + eta:apoapsis.

  local dt to lastTime - time:seconds.
  print "dt: " + dt.

  local etaRate to lastETA - eta:apoapsis.
  local tteta to eta:apoapsis / etaRate.
  print "etaRate: " + etaRate.
  print "tteta: " + tteta.

  local ttbMid to ttbo / 2.
  print "ttbo: " + ttbo.
  print "ttbMid: " + ttbMid.

  // for every 1 minute we are short of tteta, raise the nose by 3
  // degrees (or point down if we are accelerating too fast)
  local offset to 3 * (ttbo - tteta) / 60.
  set offset to min(5, max(-5, offset)).
  print "offset: " + offset.
  if eta:apoapsis > 5 {
    lock steering to lookdirup(heading(hdng, angleProgradeFromHorizon + offset):vector, upvec).
  }
  print "-----------------------------------------------------------------------------".

  set lastEcc to ship:orbit:eccentricity.
  set lastETA to eta:apoapsis.
  set lastTime to time:seconds.
  wait 0.25.
}

unlock steering.
unlock throttle.
