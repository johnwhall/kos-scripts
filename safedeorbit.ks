@lazyglobal off.

{
  parameter rcsOnly is false, tgtPeri is 50000.

  runoncepath("lib/libengine").
  runoncepath("lib/libsasrcsstack").
  runoncepath("lib/libwaitforfacing").
  runoncepath("lib/libwarpfor").
  runoncepath("lib/libantenna").

  pushSAS(false).
  pushRCS(true).

  lock steering to lookdirup(retrograde:vector, ship:facing:topvector).
  waitForFacing(0.5).

  print "Lowering periapsis".
  set ship:control:fore to 1.
  if not rcsOnly {
    print "Waiting for stable propellant".
    waitForStablePropellant().
    print "Increasing throttle".
    lock throttle to 1.
    print "Stopping ullage".
    set ship:control:fore to 0.
  }
  print "Waiting for periapsis change".

  wait until ship:periapsis < tgtPeri.

  set ship:control:fore to 0.
  if not rcsOnly {
    unlock throttle.
  }

  panels off.
  retractAntennae().

  print "Turning to retrograde".
  lock steering to lookdirup(-ship:orbit:velocity:surface, ship:facing:topvector).
  waitForFacing(0.5).
  print "Decoupling everything below heat shield".
  stage. // Decouple engine/tanks/etc. We might not have steering control after this
  wait 1.
  set kuniverse:activevessel to ship.

  print "Waiting to enter atmosphere".
  warpUntilZero({ return ship:altitude - body:atm:height. }).

  print "Waiting for 5 km altitude".
  wait until ship:altitude < 5000.
  unlock steering.
  print "Decoupling heat shield".
  stage. // Decouple heat shield
  set kuniverse:activevessel to ship.
  wait until stage:ready.
  print "Deploying parachutes".
  chutes on.
  stage. // Deploy parachutes

  popSAS().
  popRCS().

  wait until status = "Landed" or status = "Splashed".
}
