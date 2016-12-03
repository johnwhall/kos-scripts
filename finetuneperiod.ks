@lazyglobal off.

parameter tgtPeriod.

runoncepath("lib/libwaitforfacing").

rcs off.

if tgtPeriod < ship:obt:period {
  lock steering to retrograde.
} else {
  lock steering to prograde.
}

waitForFacing(0.5, false).
rcs on.
set ship:control:fore to 0.06.

if tgtPeriod < ship:obt:period {
  wait until ship:obt:period < tgtPeriod.
} else {
  wait until ship:obt:period > tgtPeriod.
}

rcs off.
