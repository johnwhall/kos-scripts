@lazyglobal off.

function vangs {
  // Angle to rotate a to b about axis n (counterclockwise is positive)
  // See https://math.stackexchange.com/questions/2140504/how-to-calculate-signed-angle-between-two-vectors-in-3d
  parameter n.
  parameter a.
  parameter b.
  return arcsin(vcrs(n:normalized, a) * b / (a:mag * b:mag)).
}

function vangs360 {
  // Angle to rotate a to b about axis n (counterclockwise is positive)
  // See https://math.stackexchange.com/questions/2140504/how-to-calculate-signed-angle-between-two-vectors-in-3d
  parameter a.
  parameter b.
  parameter n is vcrs(a, b).
  local acos to arccos((a * b) / (a:mag * b:mag)).
  return choose acos if sin(vcrs(n:normalized, a) * b / (a:mag * b:mag)) >= 0 else 360 - acos.
}

function vangs180 {
  parameter a.
  parameter b.
  parameter n is vcrs(a, b).
  local va to vangs360(a, b, n).
  return choose va if va <= 180 else va - 360.
}

function lerp {
  parameter v0.
  parameter v1.
  parameter t.
  parameter t0 is 0.
  parameter t1 is 1.
  local tn to (t - t0) / (t1 - t0). // TODO: test
  //print "lerp: " + v0 + " " + v1 + " " + tn + " = " + ((1 - tn) * v0 + tn * v1).
  //log "lerp: " + v0 + " " + v1 + " " + tn + " = " + ((1 - tn) * v0 + tn * v1) to fly.log.
  return (1 - tn) * v0 + tn * v1.
}
