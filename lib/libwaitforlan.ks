@lazyglobal off.

runoncepath("lib/libwarpfor").

function waitForLAN {
  parameter p_tgtLan.

  local lan to ship:orbit:longitudeofascendingnode.
  local dlan to p_tgtLan - lan.
  if lan > p_tgtLan {
    set dlan to (360 - lan) + p_tgtLan.
  }

  warpFor1(body:rotationperiod * dlan / 360).
}
