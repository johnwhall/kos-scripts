@lazyglobal off.

function vangs360 {
  // Angle to rotate a to b from vantage point of n looking toward -n (counterclockwise is positive)
  // NOT from vantage point of -n looking toward n
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
  local tn to (t - t0) / (t1 - t0).
  return (1 - tn) * v0 + tn * v1.
}

function toVector {
  parameter vecOrDir.
  if vecOrDir:typename() = "Direction" { return vecOrDir:vector. }
  else { return vecOrDir. }
}

function clamp {
  parameter v.
  parameter vMin.
  parameter vMax.
  if v < vMin { return vMin. }
  else if v > vMax { return vMax. }
  return v.
}
