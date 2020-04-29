@lazyglobal off.

function vangs {
  // Angle to rotate a to b about axis n (counterclockwise is positive)
  // See https://math.stackexchange.com/questions/2140504/how-to-calculate-signed-angle-between-two-vectors-in-3d
  parameter n.
  parameter a.
  parameter b.

  return arcsin(vcrs(n:normalized, a) * b / (a:mag * b:mag)).
}
