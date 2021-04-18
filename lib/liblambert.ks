@lazyglobal off.

runoncepath("lib/libhalley").

local π to constant:pi.
local π2d to constant:RadToDeg.
local d2π to constant:DegToRad.

function sinr {
  parameter Θ.
  return sin(Θ * π2d).
}

function cosr {
  parameter Θ.
  return cos(Θ * π2d).
}

function tanr {
  parameter Θ.
  return tan(Θ * π2d).
}

function arctanr {
  parameter x.
  return d2π * arctan(x).
}

function lancasterBlanchard {
  parameter μ, r1Vec, r2Vec, Δt, m.

  local r1 to r1Vec:mag.
  local r2 to r2Vec:mag.
  local Θ to d2π * vang(r1Vec, r2Vec).
  if vcrs(r1Vec, r2Vec):z < 0 { set Θ to 2 * π - Θ. }

  //print "lancasterBlanchard(" + r1 + ", " + r2 + ", " + Θ + ")".
  //print "lancasterBlanchard(" + μ + ", " + r1Vec + ", " + r2Vec + ", " + Δt + ", " + m + ")".

  local c to sqrt(r1*r1 + r2*r2 - 2*r1Vec*r2Vec).
  local s to (r1 + r2 + c) / 2.
  local q to cosr(Θ/2) * sqrt(r1*r2) / s.
  local K to q * q.
  local tgtT to sqrt(8 * μ / s) * Δt / s.

  //print "Θ=" + Θ + " c=" + c + " s=" + s + " q=" + q + " K=" + K + " tgtT=" + tgtT.

  local E to 0.
  local y to 0.
  local z to 0.
  local f to 0.
  local g to 0.
  local d to 0.
  local T to 0.
  local dT to 0.

  function fun {
    parameter x.
    set E to x*x - 1.
    set y to sqrt(abs(E)).
    set z to sqrt(1 + K*E).
    set f to y*(z - q*x).
    set g to x*z - q*E.
    set d to choose m * π + arctanr(f / g) if E < 0 else ln(f + g).
    set T to 2 * (x - q*z - d/y) / E.
    //print "fun: x=" + x + " E=" + E + " y=" + y + " z=" + z + " f=" + f + " g=" + g + " d=" + d + " T=" + T.
    return T - tgtT.
  }

  function funp {
    parameter x.
    set dT to (4 - 4*q*K*x/z - 3*x*T) / E.
    return dT.
  }

  function funpp {
    parameter x.
    return (-4*q*K*(1 - x*x*K/(z*z))/z - 3*T - 5*x*dT)/E.
  }

  local hmResult to halleysMethod(fun@, funp@, funpp@, 0, 1e-10, 10).
  if not hmResult:converged { return lexicon("converged", false). }
  local x to hmResult:x.

  local a to s / (-2 * E).
  local r1Dot to sqrt(2*μ*s) * (q*z*(s - r1) - x*(s - r2)) / (c * r1).
  local r2Dot to sqrt(2*μ*s) * (x*(s - r1) - q*z*(s - r2)) / (c * r2).
  local ecc2 to (1 - r1/a)^2 + ((r1*r1Dot)^2)/(μ*a).
  local p to a * (1 - ecc2).
  local vΘ1 to sqrt(μ * p) / r1.
  local vΘ2 to sqrt(μ * p) / r2.
  local cscΘ to 1 / sinr(Θ).
  local cotΘ to 1 / tanr(Θ).
  local r1VecNorm to r1Vec / r1.
  local r2VecNorm to r2Vec / r2.
  local v1Vec to r1VecNorm * (r1Dot - vΘ1 * cotΘ) + r2VecNorm * (vΘ1 * cscΘ).
  local v2Vec to r1VecNorm * (-vΘ2 * cscΘ) + r2VecNorm * (r2Dot + vΘ2 * cotΘ).
  return lexicon("converged", true, "v1Vec", v1Vec, "v2Vec", v2Vec).
}

//local μ to earth:mu.
//local r1 to 10000000.
//local r2 to 16000000.
//local Θ to d2π * 100.
//local Δt to 3072.
//local r1Vec to V(r1, 0, 0).
//local r2Vec to V(r2 * cosr(Θ), r2 * sinr(Θ), 0).
//local m to 0.
//
//local start to kUniverse:realTime.
//local sol to 0.
//for i in range(1) {
//  set sol to lancasterBlanchard(μ, r1Vec, r2Vec, Δt, m).
//}
//local end to kUniverse:realTime.
//local dur to end - start.
//print "dur: " + dur.
//print "v1Vec: " + sol:v1Vec.
//print "v2Vec: " + sol:v2Vec.
