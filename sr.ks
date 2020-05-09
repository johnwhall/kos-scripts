@lazyglobal off.

//parameter stageList is list(1.5).
//parameter stageList is list(1.5, 52.5).
parameter stageList is list(1.5, 31).

set ship:control:pilotMainThrottle to 1.

print "staging at " + missiontime.
stage.

for stageTime in stageList {
  local st0 to time:seconds.
  local stf to st0 + stageTime.
  wait until time:seconds >= stf.
  wait until stage:ready. // in case of very short stages
  print "staging at " + missiontime.
  stage.
}

set ship:control:neutralize to true.
