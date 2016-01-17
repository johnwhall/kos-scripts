@lazyglobal off.

function warpFor1 {
  parameter dt.

  local warpSpeeds to list(1, 10, 100, 1000, 10000, 100000, 1000000, 6000000).
  local endTime to time:seconds + dt.
  local i to warpSpeeds:length - 1.

  until time:seconds > endTime or i < 1 {
    if (warpSpeeds[i] > (endTime - time:seconds) * 4) {
      set i to i - 1.
    } else {
      set warp to i.
      set warpmode to "RAILS".
      wait 0.1.
    }
  }

  set warp to 0.
  wait until time:seconds > endTime.
}
