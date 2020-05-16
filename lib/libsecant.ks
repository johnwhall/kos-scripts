@lazyglobal off.

function secantMethod {
  parameter f, x0, x1, tol is 1e-6, maxIter is 100.

  local fx0 to f(x0).
  local fx1 to f(x1).

  until maxIter <= 0 {
    local x2 to x1 - fx1 * (x1 - x0) / (fx1 - fx0).
    local fx2 to f(x2).

    if abs(fx2) < tol { return x2. }

    set x0 to x1.
    set x1 to x2.
    set fx0 to fx1.
    set fx1 to fx2.

    set maxIter to maxIter - 1.
  }

  print "Convergence failure".
  exit.
}
