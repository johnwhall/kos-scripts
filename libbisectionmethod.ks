@lazyglobal off.

run once libsign.

function bisectionMethod {
  parameter p_f.
  parameter p_a.
  parameter p_b.
  parameter p_maxIter.
  parameter p_tol.

  local a to p_a.
  local b to p_b.

  local iter to 1.
  until iter > p_maxIter {
    local c to (a + b) / 2.
    local fc to p_f(c).

    if abs(fc) < p_tol or (b - a) / 2 < p_tol {
      return c.
    }
    set iter to iter + 1.
    if sign(fc) = sign(p_f(a)) {
      set a to c.
    } else {
      set b to c.
    }
  }

  print "FAILED TO CONVERGE!".
  exit.
}

//function testFun {
//  parameter p_x.
//  return p_x^3 - p_x - 2.
//}

//local x to bisectionMethod(testFun@, 1, 2, 20, 1e-5).
//print x.
