@lazyglobal off.

runoncepath("lib/libfacediff").

function waitForFacing {
  parameter tgtDiff, includeRoll is true, stabilizeAtEnd is true, stabilizeDuring is true, tgtRate is 99999.

  if kuniverse:timewarp:mode = "RAILS" {
    // Just in case something accidentally left us in rails warp,
    // set it to zero so we can turn
    set kuniverse:timewarp:warp to 0.
  }

  local nextPrintTime to time:seconds.

  local minDiff to faceDiff(includeRoll).
  local lastDiff to minDiff.
  local lastTime to time:seconds.

  wait 0.05.

  local curDiff to faceDiff(includeRoll).
  local curTime to time:seconds.
  local lock diffRate to (curDiff - lastDiff) / (curTime - lastTime).
  local lock done to curDiff < tgtDiff and abs(diffRate) < tgtRate.
  until done {
    if time:seconds >= nextPrintTime {
      print "Waiting for facing. Current offset: " + curDiff + " Current rate: " + diffRate.
      set nextPrintTime to time:seconds + 10.
    }

    if stabilizeDuring {
      if curDiff < minDiff {
        set minDiff to curDiff.
      } else if curDiff > 1.05 * minDiff {
        set kuniverse:timewarp:mode to "RAILS".
        set kuniverse:timewarp:warp to 1.
        wait until kuniverse:timewarp:issettled.
        set kuniverse:timewarp:warp to 0.
        set minDiff to faceDiff(includeRoll).
      }
    }

    wait 0.05.
    set lastDiff to curDiff.
    set lastTime to curTime.
    set curDiff to faceDiff(includeRoll).
    set curTime to time:seconds.
  }

  if stabilizeAtEnd {
    set kuniverse:timewarp:mode to "RAILS".
    set kuniverse:timewarp:warp to 1.
    wait until kuniverse:timewarp:issettled.
    set kuniverse:timewarp:warp to 0.
    wait until kuniverse:timewarp:issettled.
  }

  // Force some game ticks so flight controls work immediately after returning.
  // For some reason, a single tick isn't enough.
  wait 1.
}
