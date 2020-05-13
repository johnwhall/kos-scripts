@lazyglobal off.

function vangs360 {
  // NOTE: This returns the right-handed angle
  parameter a, b, n.
  local a180 to vangs180(a, b, n).
  return choose a180 if a180 >= 0 else 360 + a180.
}

function vangs180 {
  // https://stackoverflow.com/a/33920320
  // NOTE: This returns the right-handed angle
  parameter a, b, n.
  if n = V(0, 0, 0) { return choose 0 if vdot(a, b) >= 0 else 180. }
  return arctan2(vcrs(a, b) * n:normalized, a * b). // vcrs args swapped due to left-handed KSP
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
