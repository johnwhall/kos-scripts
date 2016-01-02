@lazyglobal off.

function elementByName {
  parameter name.
  parameter l.
  for i in l {
    if i:name = name {
      return i.
    }
  }
  return 0.
}

function recordIndexByName {
  parameter name.
  parameter l.

  local i to 0.
  until i >= l:length {
    if l[i][0] = name {
      return i.
    }
    set i to i + 1.
  }
  return -1.
}

function initTimeToBurnOut {
  return list(time:seconds, lexicon()).
}

function timeToBurnOut {
  // Won't work well when close to burnout because fuel/oxidizer consumption rate
  // tends to trail off rather than abruptly drop to 0.
  parameter resources.
  parameter state.

  local timeNow to time:seconds.
  local dt to timeNow - state[0].
  set state[0] to timeNow.

  local shortestBO to 999999.

  for r in resources {
    if state[1]:hasKey(r:name) {
      local oldAmount to state[1][r:name].

      local rate to (oldAmount - r:amount) / dt.
      if rate > 0 {
        set shortestBO to min(shortestBO, r:amount / rate).
      }
    }

    set state[1][r:name] to r:amount.
  }

  return shortestBO.
}
