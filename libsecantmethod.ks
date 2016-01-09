@lazyglobal off.

run once libcallback.

function secantMethod {
  parameter p_cbScript.
  parameter p_x0.
  parameter p_x1.
  parameter p_maxIter.
  parameter p_tol.

  local xnm2 to p_x0.
  local xnm1 to p_x1.

  local fxnm1 to doCallbackR1(p_cbScript, xnm1).
  local fxnm2 to doCallbackR1(p_cbScript, xnm2).

  local iter to 1.
  until iter > p_maxIter {
    local x to xnm1 - fxnm1 * (xnm1 - xnm2) / (fxnm1 - fxnm2).
    local fx to doCallbackR1(p_cbScript, x).

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

//run once libsecantmethod_callback.
//local x to secantMethod("libsecantmethod_callback", 10, 30, 7, 1e-5).
//print x.
//set g_libsecantmethod_callback_offset to 700.
//local x to secantMethod("libsecantmethod_callback", 10, 30, 7, 1e-5).
//print x.
