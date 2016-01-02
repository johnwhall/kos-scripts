@lazyglobal off.

global g_rcsStack to stack().
global g_sasStack to stack().
g_rcsStack:clear().
g_sasStack:clear().

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
