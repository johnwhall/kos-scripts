@lazyglobal off.

runoncepath("lib/libmath.ks").

function horizon {
  parameter shp is ship.
  return vxcl(shp:up:vector, shp:facing:vector).
}

function head {
  parameter shp is ship.
  return vangs360(shp:north:vector, horizon(shp), shp:up:vector).
}

function pitch {
  parameter shp is ship.
  // TODO: there has got to be an easier way to do this
  return vangs180(shp:facing:vector, horizon(shp), heading(head(shp) + 90, 0):vector).
}

function roll {
  parameter shp is ship.
  local h to horizon(shp).
  return vangs180(angleAxis(90, shp:up:vector) * h, shp:facing:starvector, h).
}
