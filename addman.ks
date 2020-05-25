@lazyglobal off.

parameter where, radial is 0, normal is 0, prograde is 0.

runoncepath("lib/libtimeto").

local tt to -1.
if where = "apo" or where = "apoapsis" { set tt to timeToApoapsis(). }
if where = "per" or where = "periapsis" { set tt to timeToPeriapsis(). }

if tt < 0 { print "invalid tt: " + tt. exit. }

local man to node(time:seconds + tt, radial, normal, prograde).
add man.
