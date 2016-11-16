@lazyglobal off.

function absDiffMod {
  parameter x1.
  parameter x2.
  parameter modulus.

  local diff1 to abs(x1 - x2).
  local diff2 to abs(abs(x1 - x2) - modulus).
  return min(diff1, diff2).
}
