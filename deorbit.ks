@lazyglobal off.

{
  parameter rcsOnly is false.

  runoncepath("lib/libsasrcsstack").
  runoncepath("lib/libwaitforfacing").

  pushSAS(false).
  pushRCS(true).

  lock steering to lookdirup(retrograde:vector, ship:facing:topvector).
  waitForFacing(0.5).

  if rcsOnly {
    set ship:control:fore to 1.
  } else {
    lock throttle to 1.
  }

  wait until ship:periapsis < 0.

  if rcsOnly {
    set ship:control:fore to 0.
  } else {
    unlock throttle.
  }

  popSAS().
  popRCS().
}
