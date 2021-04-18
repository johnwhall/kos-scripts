@lazyglobal off.

function halleysMethod {
  parameter f.
  parameter fp.
  parameter fpp.
  parameter x0.
  parameter eps is 1e-6.
  parameter maxIter is 100.

  local x to x0.
  local iter to 1.
  local fx to f(x).
  until iter > maxIter {
    local fpx to fp(x).
    local fppx to fpp(x).
    //print "iter " + iter + ": fx=" + fx + " fpx=" + fpx + " fppx=" + fppx.
    set x to x - (2*fx*fpx)/(2*fpx*fpx - fx*fppx).
    set fx to f(x).
    if abs(fx) < eps { return lexicon("converged", true, "x", x). }
    set iter to iter + 1.
  }

  // error
  return lexicon("converged", false).
}

//local x to halleysMethod({ parameter x. return x^2 - 612. },
//                         { parameter x. return 2*x. },
//                         { parameter x. return 2. },
//                         10, 1e-6, 100).
//print x.
