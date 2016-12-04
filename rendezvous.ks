@lazyglobal off.

parameter tgt, turnTime, ullageTime, tgtDist.

runoncepath("lib/liblambertoptimize").
runoncepath("lib/libclosestapproach").
runoncepath("lib/libgenericburn").
runoncepath("lib/libburntime").
runoncepath("lib/libsasrcsstack").

local lambertCalcTime to 5 * 60.

local res to lambertOptimize(ship, tgt, true, true, time:seconds + turnTime + ullageTime + lambertCalcTime).
add node(res["t"], res["radial"], res["normal"], res["prograde"]).
runpath("execnode", turnTime, ullageTime).

local fineTuneTime to time:seconds + turnTime + lambertCalcTime.
set res to lambertOptimizeBounded(ship, tgt, fineTuneTime, fineTuneTime + 5).
add node(res["t"], res["radial"], res["normal"], res["prograde"]).

local lastCATime to res["t"] + res["dt"].
local dir to nextnode:deltav.
local burnMidTime to time:seconds + nextnode:eta.
remove nextnode.

function fineTuneCallback {
  parameter predictDir, lastVal, lastTime.

  local ca to closestApproach(tgt, lastCATime - 5, lastCATime + 5, 0.05).
  local val to ca["minDist"].
  set lastCATime to ca["time"].
  print "minDist: " + val.

  local throt to 1.
  if lastVal >= 0 {
    local rate to (val - lastVal) / (time:seconds - lastTime).
    local ttzero to val / (-rate).
    set throt to max(0.1, min(1, ttzero)).
  }

  return lexicon("dir", dir, "throt", throt, "val", val).
}

genericBurnRCS(burnMidTime, 1, turnTime, fineTuneCallback@).

runpath("facesun").

local caTime to closestApproach(tgt, lastCATime - 5, lastCATime + 5, 0.05)["time"].
//local caTime to closestApproach(tgt, time:seconds, time:seconds + ship:obt:period, 0.05)["time"].
local syncDV to (velocityat(ship, caTime):orbit - velocityat(tgt, caTime):orbit):mag.
local syncBT to burnTime(syncDV).
local syncTime to caTime - syncBT. // allow a decent buffer

function syncCallback {
  parameter predictDir, lastVal, lastTime.

  local dir to tgt:obt:velocity:orbit - ship:obt:velocity:orbit.
  local val to dir:mag.

  local throt to 1.
  if lastVal >= 0 {
    local rate to (val - lastVal) / (time:seconds - lastTime).
    local ttzero to val / (-rate).
    set throt to max(0.1, min(1, ttzero)).
  }

  return lexicon("dir", dir, "throt", throt, "val", val).
}

genericBurn(syncTime, syncBT, turnTime, ullageTime, syncCallback@).
genericBurnRCS(time:seconds + turnTime, 1, turnTime, syncCallback@).

local lock tgtRelVel to tgt:obt:velocity:orbit - ship:obt:velocity:orbit.

lock steering to tgt:position.
wait until faceDiff(false) < 0.5.

pushRCS(true).

until tgt:position:mag < tgtDist and tgtRelVel:mag < 0.05 {
  local lock unwantedVel to vxcl(tgt:position, tgtRelVel).
  local lock unwantedTopVel to vxcl(ship:facing:starvector, unwantedVel).
  local lock unwantedStarVel to vxcl(ship:facing:topvector, unwantedVel).

  local topSign to 1.
  if vang(ship:facing:topvector, unwantedTopVel) > 45 {
    set topSign to -1.
  }

  local starSign to 1.
  if vang(ship:facing:starvector, unwantedStarVel) > 45 {
    set starSign to -1.
  }

  set ship:control:top to max(-1, min(1, topSign * 5 * unwantedTopVel:mag)).
  set ship:control:starboard to max(-1, min(1, starSign * 5 * unwantedStarVel:mag)).

  local tgtCloseRate to max(0.1, min(2, (tgt:position:mag - tgtDist) / 50)).
  if tgt:position:mag < tgtDist {
    set tgtCloseRate to 0.
  }
  set ship:control:fore to max(-1, min(1, 5 * (tgtCloseRate - tgtRelVel:mag))).
}

popRCS().
unlock steering.
