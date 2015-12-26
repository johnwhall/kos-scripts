@lazyglobal off.

parameter where.

if (where = "per" or where = "peri" or where = "periapsis") {
  set where to "per".
} else {
  print "Unknown where: " + where.
  exit.
}

run once funs.

local man to manAt(where).

local vThere to velocityat(ship, time:seconds + man:eta):orbit:mag.
local rThere to (positionat(ship, time:seconds + man:eta) - body:position):mag.
local vCirc to sqrt(body:mu / rThere).

print ship:obt:semimajoraxis.

print vThere.
print rThere.
print vCirc.
print (vCirc - vThere).

set man:prograde to vCirc - vThere.
print man:prograde.

add man.
