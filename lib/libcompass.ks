@lazyglobal off.

runoncepath("lib/libmath.ks").

function horizon {
  parameter shp is ship, vec is shp:facing:vector.
  return vxcl(shp:up:vector, vec):normalized.
}

function head {
  parameter shp is ship, vec is shp:facing:vector.
  return vangs360(shp:north:vector, horizon(shp, vec), shp:up:vector).
}

function pitch {
  parameter shp is ship, vec is shp:facing:vector.
  return 90 - vang(shp:up:vector, vec).
}

function roll {
  // TODO: credit KSPLib libnavball
  parameter shp is ship, vec is shp:facing:topVector.
  local x to vdot(shp:facing:topVector, shp:up:vector).
  if x < 1e-6 { return 0. }
  return -arctan2(vdot(shp:facing:topVector, vcrs(shp:up:vector, shp:facing:vector)), x).
}
