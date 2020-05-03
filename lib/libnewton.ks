@lazyglobal off.

function newtonsMethod {
  parameter f.
  parameter fp.
  parameter x0.
  parameter eps is 1e-6.
  parameter maxIter is 100.

  local x to x0.
  local iter to 1.
  until iter > maxIter {
    set x to x - f(x) / fp(x).
    set iter to iter + 1.
    if abs(f(x)) < eps { return x. }
  }

  // error
  failedToConverge.
}
