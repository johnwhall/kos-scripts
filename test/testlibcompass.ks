@lazyglobal off.

runoncepath("lib/libcompass.ks").

clearvecdraws().
local horizonVecDraw to vecdraw(ship:position, { return 10 * horizon(). }, white, "", 1, true).

until false {
  clearscreen.

  print "Horizon: " + horizon().
  print "Heading: " + head().
  print "Pitch  : " + pitch().
  print "Roll   : " + roll().

  wait 0.001.
}
