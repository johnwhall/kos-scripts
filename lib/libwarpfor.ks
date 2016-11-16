@lazyglobal off.

function warpFor1 {
  parameter dt.
  local endTime to time:seconds + dt.
  set kuniverse:timewarp:mode to "RAILS".
  kuniverse:timewarp:warpto(endTime).
  wait until time:seconds >= endTime.
}

function oldWarpFor1 {
  parameter dt.

  print "warping for " + dt.

  local warpSpeeds to kuniverse:timewarp:railsratelist.
  local endTime to time:seconds + dt.
  local i to warpSpeeds:length - 1.

  until time:seconds > endTime or i < 1 {
    if (warpSpeeds[i] > (endTime - time:seconds) * 4) {
      set i to i - 1.
    } else {
      if warp <> i {
        print "setting warp to " + i + " (" + warpSpeeds[i] + ")".
      }
      set warp to i.
      set warpmode to "RAILS".
      wait 0.5.
    }
  }

  set warp to 0.
  wait until time:seconds > endTime.
}
