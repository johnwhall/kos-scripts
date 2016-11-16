@lazyglobal off.

runoncepath("lib/libwarpfor").
runoncepath("lib/libsasrcsstack").
runoncepath("lib/libengine").
runoncepath("lib/libwaitforfacing").

function genericBurn {
  parameter p_pointVec.
  parameter p_burnMidTime.
  parameter p_burnTime.
  parameter p_turnTime.
  parameter p_ullageTime.
  parameter p_callback.

  lock throttle to 0.

  local lock timeToBurnMid to p_burnMidTime - time:seconds.
  warpFor1(timeToBurnMid - p_burnTime/2 - p_turnTime - p_ullageTime).

  pushSAS(false).

  lock steering to lookdirup(p_pointVec, ship:facing:topvector).
  waitForFacing(0.5, false, false).

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
