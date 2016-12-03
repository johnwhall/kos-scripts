@lazyglobal off.

parameter tgtPeriapsis.

runoncepath("lib/libwaitforfacing").
runoncepath("lib/libwarpto").

rcs off.

myWarpTo("apo", 60).

if tgtPeriapsis < ship:obt:periapsis {
  lock steering to lookdirup(retrograde:vector, ship:facing:topvector).
} else {
  lock steering to lookdirup(prograde:vector, ship:facing:topvector).
}

waitForFacing(0.5, false).
rcs on.
set ship:control:fore to 0.5.

if tgtPeriapsis < ship:obt:periapsis {
  wait until ship:obt:periapsis < tgtPeriapsis.
} else {
  wait until ship:obt:periapsis > tgtPeriapsis.
}

rcs off.
