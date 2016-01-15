run once libwarpfor.
run once funs.

function genericBurnWait {
  parameter p_burnMidTime, p_burnTime, p_turnTime.
  lock throttle to 0.
  local timeToBurnMid to p_burnMidTime - time:seconds.
  warpFor1(timeToBurnMid - p_burnTime - p_turnTime).
}

function genericBurnStart {
  parameter param_pointVec.
  parameter param_burnMidTime.
  parameter param_burnTime.
  parameter param_turnTime.
  parameter param_ullageTime.
  parameter param_ts.
  parameter param_curVal.
  parameter param_state.

  local prevSAS to sas.
  sas off.

  local oldPitchTS to steeringmanager:pitchts.
  local oldYawTS to steeringmanager:yawts.
  set steeringmanager:pitchts to param_ts.
  set steeringmanager:yawts to param_ts.

  local lock timeToBurnMid to param_burnMidTime - time:seconds.

  lock steering to lookdirup(param_pointVec, ship:facing:topvector).
  wait until faceDiff() < 5.

  set steeringmanager:pitchts to oldPitchTS.
  set steeringmanager:yawts to oldYawTS.
  wait until faceDiff() < 0.5.

  print "time: " + time:seconds.
  print "burnTime: " + param_burnTime.
  print "burnMidTime: " + param_burnMidTime.
  print "ullageTime: " + param_ullageTime.
  print "timeToBurnMid: " + timeToBurnMid.
  print "warping for: " + (timeToBurnMid - (param_burnTime / 2) - param_ullageTime).
  warpFor1(timeToBurnMid - (param_burnTime / 2) - param_ullageTime).

  print "starting wait at " + time:seconds.
  wait until timeToBurnMid - param_ullageTime < (param_burnTime / 2).
  print "ending wait at " + time:seconds.

  if param_ullageTime <> 0 {
    local prevRCS to rcs.
    rcs on.
    set ship:control:fore to 1.
    wait param_ullageTime.
    set ship:control:fore to 0.
    set rcs to prevRCS.
  }

  local dummy to param_state:clear.
  param_state:add(prevSAS).
  param_state:add(param_curVal).

  print "initializing val to " + param_curVal.

  print "starting burn at " + time:seconds.
  lock throttle to 1.
  wait until atFullThrust().
  wait 0.05.
}

function genericBurnContinue {
  // return false if node is finished
  parameter param_pointVec.
  parameter param_curVal.
  parameter param_state.

  lock steering to lookdirup(param_pointVec, ship:facing:topvector).

  local lastVal to param_state[1].
  set param_state[1] to param_curVal.

  print "lastVal = " + lastVal.
  print "curVal = " + param_curVal.

  wait 0.05.

  return lastVal >= param_state[1].
}

function genericBurnStop {
  parameter param_state.

  local prevSAS to param_state[0].

  lock throttle to 0.
  unlock steering.
  set sas to prevSAS.
  print "ending burn at " + time:seconds.

  wait until atZeroThrust().
  wait 0.05.
}
