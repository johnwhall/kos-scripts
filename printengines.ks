@lazyglobal off.

local es to 0.
list engines in es.

for e in es {
  print e:name.
  print "  Title: " + e:title.
  print "  Stage: " + e:stage.
  print "  Mass: " + e:mass.
  print "  Thrust Limit: " + e:thrustlimit.
  print "  Max Thrust: " + e:maxthrust.
  print "  Thrust: " + e:thrust.
  print "  Fuel Flow: " + e:fuelflow.
  print "  Isp: " + e:isp.
  print "  Vacuum Isp: " + e:visp.
  print "  Sea Level Isp: " + e:slisp.
  print "  Flamed Out: " + e:flameout.
  print "  Ignited: " + e:ignition.
  print "  Allows Restart: " + e:allowrestart.
  print "  Allows Shutdown: " + e:allowshutdown.
  print "  Throttle Locked: " + e:throttlelock.
}
