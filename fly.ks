@lazyglobal off.

runoncepath("lib/libpid.ks").
runoncepath("lib/libcompass.ks").
runoncepath("lib/libmath.ks").

deletepath("fly.log").
create("fly.log").
deletepath("fly-pitchPID.log").
create("fly-pitchPID.log").
logPIDHeader("fly-pitchPID.log").
deletepath("fly-vertVelPID.log").
create("fly-vertVelPID.log").
logPIDHeader("fly-vertVelPID.log").

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
set pitchPID:minoutput to -1.
set pitchPID:maxoutput to 1.
set pitchPID:setpoint to 0.

//local vertVelPID to pidloop(3, 0, 0). // TODO: tune
//local vertVelPID to createPIDNoOvershoot(2, 8.14).
//local vertVelPID to createPIDNoOvershoot(3, 7.92).
//local vertVelPID to createPIDNoOvershoot(5, 6.92).
local vertVelPID to pidloop(2, 0.8, 2).
set vertVelPID:setpoint to 0.

// TODO: vertVelPID to control tgtPitch, not tgtAoA

local rollPID to pidloop(0.01, 0, 0). // TODO: tune
set rollPID:setpoint to 0.

set ship:control:pitch to 0.
set ship:control:yaw to 0.
set ship:control:roll to 0.

stage.

wait until ship:velocity:surface:mag > 140.

print "rotate".

set ship:control:pitch to 0.5.

wait until alt:radar > 15.
gear off.
toggle ag6.
wait 1.
toggle ag6.
pitchPID:reset().
wait until alt:radar > 150.

print "airborne".

local lock tgtVertVel to 5.
//local tgtAoA to 5.
local startAoA to vangs(ship:facing:starvector, ship:facing:vector, ship:velocity:surface).
local lerpTgtAoA to 2.
local lerpTgtAlt to 2000.
//local lock tgtAoA to lerp(startAoA, lerpTgtAoA, ship:altitude / lerpTgtAlt).
local lerpStartAlt to ship:altitude.
local lock tgtAoA to lerp(startAoA, lerpTgtAoA, ship:altitude, lerpStartAlt, lerpTgtAlt).

local tgtPitch to {
  local tgtPitchA to vang(horizon, angleaxis(-tgtAoA, ship:facing:starvector) * ship:velocity:surface).
  return choose tgtPitchA if vang(up:vector, angleaxis(-tgtAoA, ship:facing:starvector) * ship:facing:vector) < vang(up:vector, horizon) else -tgtPitchA.
}.

//local lock tgtPitchA to vang(horizon, angleaxis(-tgtAoA, ship:facing:starvector) * ship:velocity:surface).
//local lock tgtPitch to choose tgtPitchA if vang(up:vector, angleaxis(-tgtAoA, ship:facing:starvector) * ship:facing:vector) < vang(up:vector, horizon) else -tgtPitchA.
//local tgtPitchVecDraw to vecdraw(ship:position, { return 10 * (angleaxis(-tgtPitch, ship:facing:starvector) * horizon). }, red, "", 1, true).

on time:seconds {
  local tPrev to pitchPID:lastSampleTime.
  local dt to time:seconds - tPrev.

  set vertVelPID:setpoint to tgtVertVel.
  vertVelPID:update(time:seconds, ship:verticalspeed).
  //set tgtAoA to vertVelPID:output.

  local tp to tgtPitch.
  if tgtPitch:typename = "UserDelegate" { set tp to tgtPitch(). }
  set pitchPID:setpoint to tp.
  pitchPID:update(time:seconds, curPitch).
  local gradualUpdate to ship:control:pitch + (pitchPID:output - ship:control:pitch) * 0.25 * dt.
  set ship:control:pitch to gradualUpdate.

  local rollUpdate to rollPID:update(time:seconds, curRoll).
  set ship:control:roll to -rollUpdate. // minus sign is to match MechJeb's readout

  //logPID(pitchPID, "fly-pitchPID.log").
  //logPID(vertVelPID, "fly-vertVelPID.log").

  return true.
}

wait until ship:altitude > 2000.
//set tgtAoA to 2.

print "changing lerp settings".
log "changing lerp settings" to fly.log.
set startAoA to vangs(ship:facing:starvector, ship:facing:vector, ship:velocity:surface).
set lerpTgtAoA to 1.5.
set lerpStartAlt to ship:altitude.
set lerpTgtAlt to 7000.

wait until ship:altitude > 7000.
//lock tgtPitch to -10.
set tgtPitch to -10.

wait until false.

print "end".

set ship:control:neutralize to true.
clearvecdraws().
