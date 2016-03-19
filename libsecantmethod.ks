@lazyglobal off.

function secantMethod {
  parameter p_f.
  parameter p_x0.
  parameter p_x1.
  parameter p_maxIter.
  parameter p_tol.

  local xnm2 to p_x0.
  local xnm1 to p_x1.

  local fxnm1 to p_f(xnm1).
  local fxnm2 to p_f(xnm2).

  local iter to 1.
  until iter > p_maxIter {
    local x to xnm1 - fxnm1 * (xnm1 - xnm2) / (fxnm1 - fxnm2).
    local fx to p_f(x).

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

//function testFun {
//  parameter p_offset.
//  parameter p_x.
//  print "Evaluating f(" + p_x + ").".
//  return p_x^2 - p_offset.
//}

//local x to secantMethod(testFun@:bind(612), 10, 30, 7, 1e-5).
//print x.
//local x to secantMethod(testFun@:bind(700), 10, 30, 7, 1e-5).
//print x.
