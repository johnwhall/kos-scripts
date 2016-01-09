@lazyglobal off.

run once libcallback.
run once libsign.

function bisectionMethod {
  parameter p_cbScript.
  parameter p_a.
  parameter p_b.
  parameter p_maxIter.
  parameter p_tol.

  local a to p_a.
  local b to p_b.

  local iter to 1.
  until iter > p_maxIter {
    local c to (a + b) / 2.
    local fc to doCallbackR1(p_cbScript, c).

    if abs(fc) < p_tol or (b - a) / 2 < p_tol {
      return c.
    }
    set iter to iter + 1.
    if sign(fc) = sign(doCallbackR1(p_cbScript, a)) {
      set a to c.
    } else {
      set b to c.
    }
  }

  print "FAILED TO CONVERGE!".
  exit.
}

//run once libbisectionmethod_callback.
//local x to bisectionMethod("libbisectionmethod_callback", 1, 2, 20, 1e-5).
//print x.
