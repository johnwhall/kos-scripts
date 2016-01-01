run once funs.

function execNodeStart {
  parameter settleFuel, state.

  lock throttle to 0.
  local prevSAS to sas.
  sas off.

  local bt to burnTime1(nextnode:deltav:mag).
  run prepareForBurn(nextnode:deltav, time:seconds + nextnode:eta, bt, settleFuel, 10).
  lock steering to lookdirup(nextnode:deltav, ship:facing:topvector).

  lock throttle to 1.
  local lastDV to nextnode:deltav:mag.
  wait until atFullThrust().
  wait 0.05.

  local dummy to state:clear.
  state:add(prevSAS).
  state:add(lastDV).
}

function execNodeContinue {
  // return false if node is finished
  parameter token.

  local lastDV to token[1].
  set token[1] to nextnode:deltav:mag.

  wait 0.05.

  return lastDV >= token[1].
}

function execNodeStop {
  parameter token.

  local prevSAS to token[0].

  lock throttle to 0.
  unlock steering.
  set sas to prevSAS.

  wait until atZeroThrust().
  wait 0.05.
}
