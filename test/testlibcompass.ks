@lazyglobal off.

runoncepath("lib/libcompass.ks").

clearvecdraws().
//local horizonVecDraw to vecdraw(ship:position, { return 10 * horizon(). }, white, "", 1, true).
//local horizon90VecDraw to vecdraw(ship:position, { return 10 * (angleAxis(90, ship:up:vector) * horizon()). }, green, "", 1, true).
//local negStarVecDraw to vecdraw(ship:position, { return 10 * -ship:facing:starvector. }, blue, "", 1, true).

local upVecDraw to vecdraw(ship:position, { return 10 * ship:up:vector. }, white, "", 1, true).
//local starVecDraw to vecdraw(ship:position, { return 10 * ship:facing:starvector. }, blue, "", 1, true).
//local horizonVecDraw to vecdraw(ship:position, { return 10 * horizon(). }, red, "", 1, true).
local topVecDraw to vecdraw(ship:position, { return 10 * ship:facing:topVector. }, blue, "", 1, true).
local facingVecDraw to vecdraw(ship:position, { return 10 * ship:facing:vector. }, green, "", 1, true).
//local northVecDraw to vecdraw(ship:position, { return 10 * ship:north:vector. }, red, "", 1, true).
//local crs1VecDraw to vecdraw(ship:position, { return 10 * vcrs(ship:north:vector, ship:facing:topVector). }, green, "", 1, true).
//local crs2VecDraw to vecdraw(ship:position, { return 10 * vcrs(ship:facing:topVector, ship:north:vector). }, cyan, "", 1, true).

local vecYVecDraw to vecdraw(ship:position, { return 10 * vcrs(ship:up:vector, ship:facing:forevector). }, red, "", 1, true).

until false {
  clearscreen.

  print "Horizon: " + horizon().
  print "Heading: " + head().
  print "Pitch  : " + pitch().
  print "Roll   : " + roll().

  wait 0.25.
}
