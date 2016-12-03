@lazyglobal off.

function warpFor1 {
  parameter p_dt.

  local endTime to time:seconds + p_dt.
  warpUntilZero({ return endTime - time:seconds. }).
}

function warpFor {
  parameter p_dt.
  warpFor1(p_dt).
}

function warpUntilZero {
  parameter callback.

  local curVal to callback().
  if (curVal < 0) {
    print "Skipping warp. Current value: " + curVal.
    return.
  }

  print "Warping. Current value: " + curVal.

  local warpSpeeds to kuniverse:timewarp:railsratelist.
  local i to 0.
  local lastTime to time:seconds.
  local lastVal to callback().

  wait 1.

  local curVal to lastVal.
  local curTime to time:seconds.
  lock dt to curTime - lastTime.

  function getRate {
    parameter curVal, lastVal, dt.
    if curVal = lastVal {
      return -999999999.
    } else {
      return (curVal - lastVal) / dt.
    }
  }

  lock rate to getRate(curVal, lastVal, dt).
  lock timeToZero to -curVal / rate.

  until curVal <= 0 {
    if timeToZero < warpSpeeds[i] * 1.5 {
      // if it takes less than 1.5 seconds to reach zero, slow down
      set i to max(0, i - 1).
    } else if i < warpSpeeds:length - 1 and timeToZero / 1.5 > warpSpeeds[i+1] {
      // if the next highest speed takes more than 1.5 seconds to reach zero, speed up
      set i to min(warpSpeeds:length, i + 1).
    }

    if warp <> i {
      set warp to i.
      set warpmode to "RAILS".
    }

    wait min(timeToZero, 0.5).

    set lastVal to curVal.
    set curVal to callback().
    set lastTime to curTime.
    set curTime to time:seconds.
  }

  print "ending warp".
  set warp to 0. // just in case
}
