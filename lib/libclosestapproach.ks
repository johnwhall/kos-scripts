@lazyglobal off.

runoncepath("lib/libbmmethod").

function closestApproach {
  parameter tgt, fromTime, toTime, tol is 1.

  function dist {
    parameter t.
    local pos1 to positionat(ship, t).
    local pos2 to positionat(tgt, t).
    return (pos1 - pos2):mag.
  }

  local res to bracketingMinimizationMethod1(dist@, fromTime, toTime, 10, tol).
  return lexicon("time", res["x"], "minDist", res["min"]).
}

//local calcStartTime to time:seconds.
//local res to closestApproach(vessel("JSS"), time:seconds + 6 * 60, time:seconds + 6 * 60 + 5, 1).
//local calcEndTime to time:seconds.
//print res["minDist"].
//print res["time"].
//print "(" + ((res["time"] - time:seconds)/60) + " min from now)".
//print "calc time: " + (calcEndTime - calcStartTime).
