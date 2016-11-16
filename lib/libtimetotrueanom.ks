@lazyglobal off.

function eccAnomFromTrueAnom {
  parameter ta.

  local sinE to sqrt(1 - ship:obt:eccentricity^2) * sin(ta).
  local cosE to ship:obt:eccentricity + cos(ta).
  local E to arctan2(sinE, cosE).
  if (E < 0) { set E to E + 360. }
  return E.
}

function timeToTrueAnom {
  parameter ta.

  local curE to eccAnomFromTrueAnom(ship:obt:trueanomaly).
  local curMA to (curE * constant:pi / 180 - ship:obt:eccentricity * sin(curE)) * 180 / constant:pi.

  local tgtE to eccAnomFromTrueAnom(ta).
  local tgtMA to tgtE - ship:obt:eccentricity * sin(tgtE).
  local tgtMA to (tgtE * constant:pi / 180 - ship:obt:eccentricity * sin(tgtE)) * 180 / constant:pi.
  if (tgtMA < curMA) { set tgtMA to tgtMA + 360. }

  local deltaMA to tgtMA - curMA.
  local madt to 360 / ship:obt:period.

  return deltaMA / madt.
}
