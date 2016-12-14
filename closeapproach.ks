@lazyglobal off.

parameter tgt, tgtDist.

runoncepath("lib/libsasrcsstack").
runoncepath("lib/libfacediff").

pushSAS(false).
pushRCS(true).

local lock tgtVel to 0.
if tgt:istype("Orbitable") { lock tgtVel to tgt:obt:velocity:orbit. }
else if tgt:istype("Part") { lock tgtVel to tgt:ship:obt:velocity:orbit. }
else { print "Unknown target type: " + tgt:typename(). exit. }
local lock tgtRelVel to ship:obt:velocity:orbit - tgtVel.

lock steering to lookdirup(tgt:position, ship:facing:topvector).
wait until faceDiff(false) < 0.5.

until tgt:position:mag < tgtDist and tgtRelVel:mag < 0.05 {
  set ship:control:top to max(-1, min(1, 5 * -vdot(ship:facing:topvector, tgtRelVel))).
  set ship:control:starboard to max(-1, min(1, 5 * -vdot(ship:facing:starvector, tgtRelVel))).

  local tgtCloseRate to max(0.2, min(2, (tgt:position:mag - tgtDist) / 50)).
  if tgt:position:mag > 1000 + tgtDist { set tgtCloseRate to 5. }
  if tgt:position:mag < tgtDist { set tgtCloseRate to 0. }
  
  local actualCloseRate to vdot(tgt:position, tgtRelVel) / tgt:position:mag.
  set ship:control:fore to max(-1, min(1, 5 * (tgtCloseRate - actualCloseRate))).
}

popRCS().
popSAS().
