@lazyglobal off.

run once libwarpfor.
run once libsasrcsstack.
run once libengine.
run once libfacediff.

function genericBurn {
  parameter p_pointVec.
  parameter p_burnMidTime.
  parameter p_burnTime.
  parameter p_turnTime.
  parameter p_ullageTime.
  parameter p_ts.
  parameter p_callback.

  lock throttle to 0.

  local lock timeToBurnMid to p_burnMidTime - time:seconds.
  warpFor1(timeToBurnMid - p_burnTime/2 - p_turnTime - p_ullageTime).

  pushSAS(false).

  // TODO: does changing pitchts and yawts actually help?
  local oldPitchTS to steeringmanager:pitchts.
  local oldYawTS to steeringmanager:yawts.
  set steeringmanager:pitchts to p_ts.
  set steeringmanager:yawts to p_ts.

  lock steering to lookdirup(p_pointVec, ship:facing:topvector).
  wait until faceDiff() < 5.

  // TODO: does changing pitchts and yawts actually help?
  set steeringmanager:pitchts to oldPitchTS.
  set steeringmanager:yawts to oldYawTS.
  wait until faceDiff() < 0.5.

  warpFor1(timeToBurnMid - (p_burnTime / 2) - p_ullageTime).
  wait until timeToBurnMid - p_ullageTime < (p_burnTime / 2).

  if p_ullageTime <> 0 {
    pushRCS(true).
    set ship:control:fore to 1.
    wait p_ullageTime.
    set ship:control:fore to 0.
    popRCS().
  }

  local curVal to p_callback().
  local initVal to curVal.

  lock throttle to 1.
  wait until atFullThrust().

  // The numbers go a little haywire at first, so wait until the value
  // has changed at least 5% before starting the main loop.
  until abs(curVal - initVal) / initVal > 0.05 {
    wait 0.05.
    set curVal to p_callback().
  }

  local lastVal to curVal.
  wait 0.05.

  until curVal > lastVal {
    set lastVal to curVal.
    wait 0.05.
    set curVal to p_callback().
  }

  lock throttle to 0.
  unlock steering.
  popSAS().
  wait until atZeroThrust().
  wait 0.05.
}
