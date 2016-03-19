@lazyglobal off.

run once libsign.

local eps to 1e-10.

function brentsMethod {
  // Converted from https://alexmoon.github.io/ksp/javascripts/roots.js
  parameter p_f.
  parameter p_a.
  parameter p_b.
  parameter p_maxIter.
  parameter p_relAcc.

//  print "brent => p_a = " + p_a.
//  print "brent => p_b = " + p_b.

  local a to p_a.
  local b to p_b.
  local fa to p_f(a).
  local fb to p_f(b).
  local c to a.
  local fc to fa.
  local d to b - a.
  local e to d.
  local relAcc to p_relAcc + 0.5 * eps.

//  print "brent => fa = " + fa.
//  print "brent => fb = " + fb.

  if sign(fa) = sign(fb) {
    return list(false, 0).
  }

  local i to 0.
  until false {
    if abs(fc) < abs(fb) {
      set a to b.
      set b to c.
      set c to a.
      set fa to fb.
      set fb to fc.
      set fc to fa.
    }

    local tol to relAcc * abs(b).
    local m to 0.5 * (c - b).

    if abs(fb) < eps or abs(m) <= tol {
      return list(true, b).
    }

    if i > p_maxIter {
      return list(false, 1).
    }

    if abs(e) < tol or abs(fa) <= abs(fb) {
      set d to m.
      set e to m.
    } else {
      local s to fb / fa.

      local p to 2 * m * s.
      local q to 1 - s.
      if a <> c {
        set q to fa / fc.
        local r to fb / fc.
        set p to s * (2 * m * q * (q - r) - (b - a) * (r - 1)).
        set q to (q - 1) * (r - 1) * (s - 1).
      }

      if p > 0 {
        set q to -q.
      } else {
        set p to -p.
      }

      if 2 * p < min(3 * m * q - abs(tol * q), abs(e * q)) {
        set e to d.
        set d to p / q.
      } else {
        set d to m.
        set e to m.
      }
    }

    set a to b.
    set fa to fb.
    if abs(d) > tol {
      set b to b + d.
    } else {
      local v to -tol.
      if m > 0 { set v to tol. }
      set b to b + v.
    }

    set fb to p_f(b).
    if (fb < 0 and fc < 0) or (fb > 0 and fc > 0) {
      set c to a.
      set fc to fa.
      set d to b - a.
      set e to b - a.
    }

    set i to i + 1.
  }
}

// function testFun {
//   parameter p_x.
//   return (p_x + 3) * (p_x - 1)^2.
// }
//
// local x to brentsMethod(testFun@, -4, 4/3, 20, 1e-4).
// print x.
