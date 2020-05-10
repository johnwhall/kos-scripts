@lazyglobal off.

runoncepath("lib/libmath.ks").

function horizon {
  parameter shp is ship.
  return vxcl(shp:up:vector, shp:facing:vector):normalized.
}

function head {
  parameter shp is ship.
  return vangs360(shp:north:vector, horizon(shp), shp:up:vector).
}

function pitch {
  parameter shp is ship, vec is shp:facing:vector.
  return 90 - vangs180(shp:up:vector, vec).
}

// TODO: Sometimes this disagrees with MechJeb, e.g. when MJ's pitch=-47.6 roll=70.2 head=230.7
//       Seems the farther pitch is from 0, the roll error gets worse?
function roll {
  parameter shp is ship.
  local h to horizon(shp).
  return vangs180(angleAxis(90, shp:up:vector) * h, shp:facing:starvector, h).
}
