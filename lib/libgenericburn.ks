@lazyglobal off.

runoncepath("lib/libwarpfor").
runoncepath("lib/libwarpto").
runoncepath("lib/libsasrcsstack").
runoncepath("lib/libengine").
runoncepath("lib/libwaitforfacing").
runoncepath("lib/libtimeto").

function genericBurnRCS {
  parameter p_when.
  parameter p_burnTime.
  parameter p_turnTime.
  parameter p_callback.
  parameter p_turnWithRCS is false.

  lock throttle to 0.

  local burnMidTime to libgenericburn_getBurnMidTime(p_when).

  local lock timeToBurnMid to burnMidTime - time:seconds.
  local lock burnStartTime to time:seconds + timeToBurnMid - p_burnTime / 2.
  local lock burnEndTime to time:seconds + timeToBurnMid + p_burnTime / 2.
  local lock turnStartTime to burnStartTime - p_turnTime.

  print " ".
  print "Waiting for turn at " + time:seconds.
  print "Time to turn start: " + (turnStartTime - time:seconds).
  print "Time to burn start: " + (burnStartTime - time:seconds).
  print "Time to burn middle: " + timeToBurnMid.
  print "Time to burn end: " + (burnEndTime - time:seconds).
  print "Burn time: " + p_burnTime.
  print "Burn mid time: " + burnMidTime.

  libgenericburn_warpToTurn(p_when, p_turnTime, 0, p_burnTime, turnStartTime).

  // We might have just warped a lot, so update the values
  set burnMidTime to libgenericburn_getBurnMidTime(p_when).

  if p_turnWithRCS { pushRCS(true). }
  else { pushRCS(false). }
  pushSAS(false).

  // call callback with predictDir=true so it can predict the value ahead of time
  local callbackResult to p_callback(true, -1, -1).
  local dir to callbackResult["dir"].
  lock steering to lookdirup(dir, ship:facing:topvector).

  print " ".
  print "Waiting for facing at " + time:seconds.
  print "Time to burn start: " + (burnStartTime - time:seconds).
  print "Time to burn middle: " + timeToBurnMid.
  print "Time to burn end: " + (burnEndTime - time:seconds).
  print "Burn time: " + p_burnTime.
  print "Burn mid time: " + burnMidTime.

  waitForFacing(0.5, false, false, false).
  print "Facing achieved. Waiting to start burn".
  wait until time:seconds > burnStartTime.

  print " ".
  print "Starting burn at " + time:seconds.
  print "Time to burn middle: " + timeToBurnMid.
  print "Time to burn end: " + (burnEndTime - time:seconds).
  print "Burn time: " + p_burnTime.

  popRCS().
  pushRCS(true).

  // call callback with predictDir=false so it can give the most up-to-date value
  set callbackResult to p_callback(false, -1, -1).
  set dir to callbackResult["dir"].
  set ship:control:fore to callbackResult["throt"].

  local curVal to callbackResult["val"].
  local initVal to curVal.

  // The numbers go a little haywire at first, so wait until the value
  // has changed at least 5% before starting the main loop.
  until abs(curVal - initVal) / initVal > 0.05 {
    wait 0.05.
    set callbackResult to p_callback(false, -1, -1).
    set curVal to callbackResult["val"].
    set dir to callbackResult["dir"].
    set ship:control:fore to callbackResult["throt"].
  }

  local lastVal to curVal.
  local lastTime to time:seconds.

  until curVal > lastVal {
    set lastVal to curVal.
    wait 0.05.
    set callbackResult to p_callback(false, lastVal, lastTime).
    set lastTime to time:seconds.
    set curVal to callbackResult["val"].
    set dir to callbackResult["dir"].
    set ship:control:fore to callbackResult["throt"].
  }

  unlock steering.
  set ship:control:fore to 0.
  popRCS().
  popSAS().
  wait 0.05.
}

function genericBurn {
  parameter p_when.
  parameter p_burnTime.
  parameter p_turnTime.
  parameter p_ullageTime.
  parameter p_callback.

  local throt to 0.
  lock throttle to throt.

  local burnMidTime to libgenericburn_getBurnMidTime(p_when).

  local lock timeToBurnMid to burnMidTime - time:seconds.
  local lock burnStartTime to time:seconds + timeToBurnMid - p_burnTime / 2.
  local lock burnEndTime to time:seconds + timeToBurnMid + p_burnTime / 2.
  local lock ullageStartTime to burnStartTime - p_ullageTime.
  local lock turnStartTime to ullageStartTime - p_turnTime.

  libgenericburn_warpToTurn(p_when, p_turnTime, p_ullageTime, p_burnTime, turnStartTime).

  // We might have just warped a lot, so update the values
  set burnMidTime to libgenericburn_getBurnMidTime(p_when).

  pushSAS(false).

  // call callback with predictDir=true so it can predict the value ahead of time
  local callbackResult to p_callback(true, -1, -1).
  local dir to callbackResult["dir"].
  lock steering to lookdirup(dir, ship:facing:topvector).

  print " ".
  print "Waiting for facing at " + time:seconds.
  print "Time to ullage start: " + (ullageStartTime - time:seconds).
  print "Time to burn start: " + (burnStartTime - time:seconds).
  print "Time to burn middle: " + timeToBurnMid.
  print "Time to burn end: " + (burnEndTime - time:seconds).
  print "Burn time: " + p_burnTime.
  print "Burn mid time: " + burnMidTime.

  waitForFacing(0.5, false, false).
  warpFor1(ullageStartTime - time:seconds).

  print " ".
  print "Settling fuel at " + time:seconds.
  print "Time to burn start: " + (burnStartTime - time:seconds).
  print "Time to burn middle: " + timeToBurnMid.
  print "Time to burn end: " + (burnEndTime - time:seconds).
  print "Burn time: " + p_burnTime.

  if p_ullageTime <> 0 {
    pushRCS(true).
    set ship:control:fore to 1.
    wait p_ullageTime.
    set ship:control:fore to 0.
    popRCS().
  }

  print " ".
  print "Starting burn at " + time:seconds.
  print "Time to burn middle: " + timeToBurnMid.
  print "Time to burn end: " + (burnEndTime - time:seconds).
  print "Burn time: " + p_burnTime.

  // call callback with predictDir=false so it can give the most up-to-date value
  set callbackResult to p_callback(false, -1, -1).
  set dir to callbackResult["dir"].
  set throt to callbackResult["throt"].

  local curVal to callbackResult["val"].
  local initVal to curVal.

  wait until atFullThrust().

  // The numbers go a little haywire at first, so wait until the value
  // has changed at least 5% before starting the main loop.
  until abs(curVal - initVal) / initVal > 0.05 {
    wait 0.05.
    set callbackResult to p_callback(false, -1, -1).
    set curVal to callbackResult["val"].
    set dir to callbackResult["dir"].
    set throt to callbackResult["throt"].
  }

  local lastVal to curVal.
  local lastTime to time:seconds.

  until curVal > lastVal {
    set lastVal to curVal.
    wait 0.05.
    set callbackResult to p_callback(false, lastVal, lastTime).
    set lastTime to time:seconds.
    set curVal to callbackResult["val"].
    set dir to callbackResult["dir"].
    set throt to callbackResult["throt"].
  }

  lock throttle to 0.
  unlock steering.
  popSAS().
  wait until atZeroThrust().
  wait 0.05.
}

function libgenericburn_getBurnMidTime {
  parameter p_when.
  if p_when:typename() = "string" {
    return time:seconds + timeTo1(p_when). 
  } else {
    return p_when. 
  }
}

function libgenericburn_warpToTurn {
  parameter p_when, p_turnTime, p_ullageTime, p_burnTime, turnStartTime.

  if p_when:typename() = "string" {
    myWarpTo(p_when, p_turnTime + p_ullageTime + p_burnTime / 2).
  } else {
    warpFor1(turnStartTime - time:seconds).
  }
}
