@lazyglobal off.

parameter pointVec, burnMidTime, burnTime, settleFuel.

function timeStr {
  parameter t.
  return t + " (" + (t - time:seconds) + " from now)".
}

runoncepath("lib/libwaitforfacing").
runoncepath("lib/libwarpfor").

local lock timeToBurnMid to burnMidTime - time:seconds.
local settleTime to 0.
if settleFuel { set settleTime to 5. }

print "Preparing for burn".
print "Current Time: " + time:seconds.
print "Point Vec: " + pointVec.
print "Burn Times:".
print "  Duration: " + burnTime.
print "  Start   : " + timeStr(burnMidTime - burnTime / 2).
print "  Middle  : " + timeStr(burnMidTime).
print "  End     : " + timeStr(burnMidTime + burnTime / 2).
print "Settle Time: " + settleTime.

warpFor1(timeToBurnMid - burnTime - 150).

lock steering to lookdirup(pointVec, ship:facing:topvector).
waitForFacing(0.5, false).

print "Facing reached at " + time:seconds.

print "Warping for " + (timeToBurnMid - (burnTime / 2) - settleTime).
warpFor1(timeToBurnMid - (burnTime / 2) - settleTime).

wait until timeToBurnMid - settleTime < (burnTime / 2).

if settleFuel {
  print "Settling fuel at " + time:seconds.
  local prevRCS to rcs.
  rcs on.
  set ship:control:fore to 1.
  wait settleTime.
  set ship:control:fore to 0.
  set rcs to prevRCS.
}

print "Ready for burn at " + time:seconds.
