@lazyglobal off.

runoncepath("lib/libpid.ks").
runoncepath("lib/libcompass.ks").
runoncepath("lib/libmath.ks").

deletepath("fly.log").
create("fly.log").

local lock horizon to vxcl(ship:up:vector, ship:facing:vector).
local lock curPitch to currentPitch().
local lock curRoll to currentRoll().

clearvecdraws().
local horizonVecDraw to vecdraw(ship:position, { return 10 * horizon. }, white, "", 1, true).

gear on.
lock throttle to 1.
toggle ag7.
wait 1.
toggle ag7.

local pitchPID to createPIDNoOvershoot(0.25, 0.92).
set pitchPID:setpoint to 0.

local aoaPID to createPIDNoOvershoot(0.25, 0.92). // TODO: tune
set aoaPID:setpoint to 0.

local rollPID to pidloop(0.01, 0, 0).
set rollPID:setpoint to 0.

set ship:control:pitch to 0.
set ship:control:yaw to 0.
set ship:control:roll to 0.

stage.

wait until ship:velocity:surface:mag > 120.

print "rotate".

set ship:control:pitch to 0.75.

wait until alt:radar > 15.
gear off.
toggle ag6.
wait 1.
toggle ag6.
pitchPID:reset().
wait until alt:radar > 150.

print "airborne".

local tgtAoA to 5.
local lock tgtPitchA to vang(horizon, angleaxis(-tgtAoA, ship:facing:starvector) * ship:velocity:surface).
local lock tgtPitch to choose tgtPitchA if vang(up:vector, angleaxis(-tgtAoA, ship:facing:starvector) * ship:facing:vector) < vang(up:vector, horizon) else -tgtPitchA.
local tgtPitchVecDraw to vecdraw(ship:position, { return 10 * (angleaxis(-tgtPitch, ship:facing:starvector) * horizon). }, red, "", 1, true).

on time:seconds {
  local tPrev to pitchPID:lastSampleTime.
  local dt to time:seconds - tPrev.

  set pitchPID:setpoint to tgtPitch.

  pitchPID:update(time:seconds, curPitch).
  local gradualUpdate to ship:control:pitch + (pitchPID:output - ship:control:pitch) * 0.25 * dt.
  set ship:control:pitch to gradualUpdate.

  local rollUpdate to rollPID:update(time:seconds, curRoll).
  set ship:control:roll to -rollUpdate. // minus sign is to match MechJeb's readout
  return true.
}

wait until ship:altitude > 500.
set tgtAoA to 2.

wait until ship:altitude > 9000.
lock tgtPitch to -10.

wait until false.

print "end".

set ship:control:neutralize to true.
clearvecdraws().
