@lazyglobal off.

runoncepath("lib/libcosinerule").
runoncepath("lib/libmanat").

function nodeToCircIncAtApo {
  parameter tgtInc.

  local tgtSMA to body:radius + apoapsis.
  local curSMA to ship:orbit:semimajoraxis.

  local Vc to sqrt(body:mu / tgtSMA).
  local Vt to sqrt(body:mu * (2 / (body:radius + apoapsis) - 1 / curSMA)).
  local Vd to solveCosineRule(Vc, Vt, tgtInc - ship:orbit:inclination).

  local phi to arccos((Vt^2 + Vd^2 - Vc^2) / (2 * Vt * Vd)).
  local alpha to 180 - phi.
  local Vp to Vd * cos(alpha).
  local Vn to Vd * sin(alpha).

  local n to manAt("anode").
  if Vn > 0 {
    set n to manAt("dnode").
  }
  set n:prograde to Vp.
  set n:normal to Vn.

  return n.
}
