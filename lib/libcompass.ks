@lazyglobal off.

runoncepath("lib/libmath.ks").

function currentPitch {
  // TODO: this is wrong if you are upside down
  local horizon to vxcl(ship:up:vector, ship:facing:vector).
  return -vangs(ship:facing:starvector, horizon, ship:facing:vector).
}

function currentRoll {
  // TODO: this is wrong if you are upside down (rolled more than 90 degrees)
  local horizon to vxcl(ship:up:vector, ship:facing:vector).
  return -vangs(ship:facing:vector, vxcl(horizon, ship:facing:topvector), ship:up:vector).
}
