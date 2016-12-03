@lazyglobal off.

parameter tgtApoapsis.

runoncepath("lib/libwaitforfacing").
runoncepath("lib/libwarpto").

rcs off.

myWarpTo("per", 60).

if tgtApoapsis < ship:obt:apoapsis {
  lock steering to lookdirup(retrograde:vector, ship:facing:topvector).
} else {
  lock steering to lookdirup(prograde:vector, ship:facing:topvector).
}

waitForFacing(0.5, false).
rcs on.
set ship:control:fore to 0.5.

if tgtApoapsis < ship:obt:apoapsis {
  wait until ship:obt:apoapsis < tgtApoapsis.
} else {
  wait until ship:obt:apoapsis > tgtApoapsis.
}

rcs off.
