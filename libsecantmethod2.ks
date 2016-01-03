@lazyglobal off.

run once libnummth.

function secantMethod {
  parameter p_funNum.
  parameter p_x0.
  parameter p_x1.
  parameter p_maxIter.
  parameter p_tol.

  local xnm2 to p_x0.
  local xnm1 to p_x1.

  local fxnm1 to evaluateInputFunction(p_funNum, xnm1).
  local fxnm2 to evaluateInputFunction(p_funNum, xnm2).

  local iter to 1.
  until iter > p_maxIter {
    local x to xnm1 - fxnm1 * (xnm1 - xnm2) / (fxnm1 - fxnm2).
    local fx to evaluateInputFunction(p_funNum, x).

    if abs(fx) < p_tol {
      return x.
    }

    set xnm2 to xnm1.
    set fxnm2 to fxnm1.
    set xnm1 to x.
    set fxnm1 to fx.
    set iter to iter + 1.
  }

  print "FAILED TO CONVERGE!".
  exit.
}

run deleteifexists("nummthfun1.ks").
log "parameter x." to nummthfun1.
log "set RETVAL to x^2 - 612." to nummthfun1.
local x to secantMethod(1, 10, 30, 7, 1e-5).
run deleteifexists("nummthfun1.ks").
print x.
