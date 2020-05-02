@lazyglobal off.

function angleToSteering {
  parameter what is ship:facing:vector.
  local steer to steering.
  if steering:typename() = "Direction" { set steer to steering:vector. }
  return vang(steer, what).
}
