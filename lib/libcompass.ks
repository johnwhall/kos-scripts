@lazyglobal off.

runoncepath("lib/libmath.ks").

function horizon {
  return vxcl(ship:up:vector, ship:facing:vector).
}

function head {
  //return -vangs(horizon, ship:north:vector, ship:up:vector).
  return vangs(ship:north:vector, horizon, ship:up:vector).
}

function pitch {
  // TODO: this is wrong if you are upside down
  return -vangs(ship:facing:starvector, horizon(), ship:facing:vector).
}

function roll {
  return -vangs(ship:facing:vector, vxcl(horizon(), ship:facing:topvector), ship:up:vector).
}
