@lazyglobal off.

global g_rcsStack to stack().
global g_sasStack to stack().
global g_tsStack to stack().
g_rcsStack:clear().
g_sasStack:clear().
g_tsStack:clear().

function pushRCS {
  parameter newRCS.
  g_rcsStack:push(rcs).
  set rcs to newRCS.
  wait 0.01.
}

function popRCS {
  local prevRCS to g_rcsStack:pop().
  set rcs to prevRCS.
  wait 0.01.
}

function pushSAS {
  parameter newSAS.
  g_sasStack:push(sas).
  set sas to newSAS.
  wait 0.01.
}

function popSAS {
  local prevSAS to g_sasStack:pop().
  set sas to prevSAS.
  wait 0.01.
}

function pushTS {
  parameter newTS.
  g_tsStack:push(list(steeringmanager:pitchts, steeringmanager:yawts, steeringmanager:rollts)).
  set steeringmanager:pitchts to newTS.
  set steeringmanager:yawts to newTS.
  set steeringmanager:rollts to newTS.
  wait 0.01.
}

function popTS {
  local prevTS to g_sasStack:pop().
  set steeringmanager:pitchts to prevTS[0].
  set steeringmanager:yawts to prevTS[1].
  set steeringmanager:rollts to prevTS[2].
  wait 0.01.
}
