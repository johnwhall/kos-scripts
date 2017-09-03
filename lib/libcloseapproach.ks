@lazyglobal off.

runoncepath("lib/libsasrcsstack").
runoncepath("lib/libwaitforfacing").
runoncepath("lib/libsign").

function closeApproach {
  parameter tgt, p_tgtDist.

  local tgtDist to p_tgtDist.

  function tgtVel {
    parameter tgt.
    if tgt:istype("Orbitable") { return tgt:obt:velocity:orbit. }
    else if tgt:istype("Part") { return tgt:ship:obt:velocity:orbit. }
    else { print "Unknown target type: " + tgt:typename(). exit. }
  }

  pushSAS(false).
  pushRCS(true).

  local nextPrintTime to time:seconds.

  local lock tgtRelVel to ship:obt:velocity:orbit - tgtVel(tgt).

  lock steering to lookdirup(tgt:position, ship:facing:topvector).
  waitForFacing(0.5, false, false, false).

  until tgt:position:mag < p_tgtDist and tgtRelVel:mag < 0.05 {
    if time:seconds >= nextPrintTime {
      local rate to tgtRelVel:mag * -sign(vdot(tgtRelVel, tgt:position)).
      print "Approaching target. Current distance: " + tgt:position:mag + " Current rate: " + rate.
      set nextPrintTime to time:seconds + 10.
    }
    set ship:control:top to max(-1, min(1, 5 * -vdot(ship:facing:topvector, tgtRelVel))).
    set ship:control:starboard to max(-1, min(1, 5 * -vdot(ship:facing:starvector, tgtRelVel))).

    local tgtCloseRate to max(0.2, min(2, (tgt:position:mag - p_tgtDist) / 50)).
    if tgt:position:mag > 1000 + p_tgtDist { set tgtCloseRate to 5. }
    if tgt:position:mag < p_tgtDist { set tgtCloseRate to 0. }
  
    local actualCloseRate to vdot(tgt:position, tgtRelVel) / tgt:position:mag.
    set ship:control:fore to max(-1, min(1, 5 * (tgtCloseRate - actualCloseRate))).
  }

  popRCS().
  popSAS().
}
