@lazyglobal off.

runoncepath("lib/liblambertoptimize").
runoncepath("lib/libclosestapproach").
runoncepath("lib/libgenericburn").
runoncepath("lib/libburntime").
runoncepath("lib/libsasrcsstack").
runoncepath("lib/libcloseapproach").
runoncepath("lib/libexecnode").

function rendezvous_sync {
  parameter syncTime, syncBT, turnTime, ullageTime, turnWithRCS, rcsOnly, stopBeforeRCSSync.

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

  if rcsOnly {
    if not stopBeforeRCSSync {
      genericBurnRCS(syncTime, syncBT, turnTime, syncCallback@, turnWithRCS).
    }
  } else {
    genericBurn(syncTime, syncBT, turnTime, ullageTime, syncCallback@).
    if not stopBeforeRCSSync {
      genericBurnRCS(time:seconds + turnTime, 1, turnTime, syncCallback@, turnWithRCS).
    }
  }
}

function rendezvous {
  parameter tgt, turnTime, ullageTime, tgtDist, turnWithRCS is false, rcsOnly is false, rcsIsp is 0, rcsThrust is 0, stopBeforeRCSSync is false.
  
  pushSAS(false).
  
  local lambertCalcTime to 60.
  
  local res to lambertOptimize(ship, tgt, true, true, time:seconds + turnTime + ullageTime + lambertCalcTime).
  add node(res["t"], res["radial"], res["normal"], res["prograde"]).
  if turnWithRCS { pushRCS(true). }
  if rcsOnly {
    execNodeRCS(rcsIsp, rcsThrust, turnTime, turnWithRCS).
  } else {
    execNode(turnTime, ullageTime).
  }
  
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
  
  genericBurnRCS(burnMidTime, 1, turnTime, fineTuneCallback@, turnWithRCS).
  
  local ca to closestApproach(tgt, lastCATime - 5, lastCATime + 5, 0.05).
  //local ca to closestApproach(tgt, time:seconds, time:seconds + ship:obt:period, 0.05)["time"].
  local caTime to ca["time"].
  local syncDV to ca["speed"].
  local syncBT to 0.
  if rcsOnly { set syncBT to burnTime(syncDV, rcsIsp, rcsThrust, mass). }
  else { set syncBT to burnTime(syncDV). }
  local syncTime to caTime - syncBT.

  rendezvous_sync(syncTime, syncBT, turnTime, ullageTime, turnWithRCS, rcsOnly, stopBeforeRCSSync).
  
  if turnWithRCS { popRCS(). }
  popSAS().
  
  if not stopBeforeRCSSync {
    print "Approaching target".
    closeApproach(tgt, tgtDist).
  }
}
