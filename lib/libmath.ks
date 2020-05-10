@lazyglobal off.

function vangs360 {
  parameter a, b, n is vcrs(a, b).
  local a180 to vangs180(a, b, n).
  return choose a180 if a180 >= 0 else 360 + a180.
}

function vangs180 {
  // https://stackoverflow.com/a/33920320
  parameter a, b, n is vcrs(a, b).
  if n = V(0, 0, 0) { return 0. }
  return arctan2(vcrs(a, b) * n:normalized, a * b).
}

function lerp {
  parameter v0, v1, t, t0 is 0, t1 is 1, clampT is false.
  local tn to (t - t0) / (t1 - t0).
  if clampT { set tn to clamp(tn, 0, 1). }
  return (1 - tn) * v0 + tn * v1.
}

function toVector {
  parameter vecOrDir.
  if vecOrDir:typename = "Direction" { return vecOrDir:vector. }
  else { return vecOrDir. }
}

function clamp {
  parameter v, vMin, vMax.
  return min(max(v, vMin), vMax).
}
