@lazyglobal off.

run once libnummth.
run once libsign.

function bisectionMethod {
  parameter p_funNum.
  parameter p_a.
  parameter p_b.
  parameter p_maxIter.
  parameter p_tol.

  local a to p_a.
  local b to p_b.

  local iter to 1.
  until iter > p_maxIter {
    print "iter = " + iter.
    local c to (a + b) / 2.
    local fc to evaluateInputFunction(p_funNum, c).

    print "a = " + a + ", b = " + b + ", c = " + c + ", f(c) = " + fc.
    if abs(fc) < p_tol or (b - a) / 2 < p_tol {
      return c.
    }
    set iter to iter + 1.
    if sign(fc) = sign(evaluateInputFunction(p_funNum, a)) {
      set a to c.
    } else {
      set b to c.
    }
  }

  print "FAILED TO CONVERGE!".
  exit.
}

//run deleteifexists("nummthfun3.ks").
//log "parameter x." to nummthfun3.
//log "set RETVAL to x^3 - x - 2." to nummthfun3.
//local x to bisectionMethod(3, 1, 2, 20, 1e-5).
//run deleteifexists("nummthfun3.ks").
//print x.
