@lazyglobal off.

function solveCosineRule {
  parameter a, b, theta.
  return sqrt(a*a + b*b - 2*a*b*cos(theta)).
}
