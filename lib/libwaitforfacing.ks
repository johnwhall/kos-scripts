@lazyglobal off.

runoncepath("lib/libfacediff").

function waitForFacing {
  parameter tgtDiff, includeRoll is true, stabilizeAtEnd is true.

  if kuniverse:timewarp:mode = "RAILS" {
    // Just in case something accidentally left us in rails warp,
    // set it to zero so we can turn
    set kuniverse:timewarp:warp to 0.
  }

  local minDiff to faceDiff(includeRoll).

  local curDiff to minDiff.
  until curDiff < tgtDiff {
    if curDiff < minDiff {
      set minDiff to curDiff.
    } else if curDiff > 1.05 * minDiff {
      set kuniverse:timewarp:mode to "RAILS".
      set kuniverse:timewarp:warp to 1.
      wait until kuniverse:timewarp:issettled.
      set kuniverse:timewarp:warp to 0.
      set minDiff to faceDiff(includeRoll).
    }

    set curDiff to faceDiff(includeRoll).
  }

  if stabilizeAtEnd {
    set kuniverse:timewarp:mode to "RAILS".
    set kuniverse:timewarp:warp to 1.
    wait until kuniverse:timewarp:issettled.
    set kuniverse:timewarp:warp to 0.
  }
}
