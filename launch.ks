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

wait until ship:verticalspeed > 65.

sas off. // turn SAS off so kOS doesn't fight it
set forevec to heading(90, 85):vector.

wait until faceDiff() < 0.5.
sas on.

wait until vang(ship:velocity:surface, ship:facing:vector) < 0.5.

lock steering to lookdirup(ship:velocity:surface, upvec).

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

local boRet to timeToBurnOut(stage:resources, 0).
local lastEcc to ship:orbit:eccentricity.
wait 1.

until lastEcc < ship:orbit:eccentricity {
  print "lastEcc: " + lastEcc.
  print "ship:orbit:eccentricity" + ship:orbit:eccentricity.
  local boRet to timeToBurnOut(stage:resources, boRet[1]).
  local ttbMid to boRet[0] / 2.
  print "ttbo: " + boRet[0].
  print "eta:apoapsis: " + eta:apoapsis.
  print "ttbMid: " + ttbMid.
  // for every 1 minute we are short of eta:apoapsis, raise the nose by 3
  // degrees (or point down if we are accelerating too fast)
  local offset to 3 * (ttbMid - eta:apoapsis) / 60.
  set offset to min(30, max(-30, offset)).
  print "offset: " + offset.
  lock steering to lookdirup(heading(hdng, angleProgradeFromHorizon + offset):vector, upvec).
  print "-----------------------------------------------------------------------------".
  set lastEcc to ship:orbit:eccentricity.
  wait 0.25.
}

unlock steering.
unlock throttle.
