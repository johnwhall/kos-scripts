@lazyglobal off.

function currentMeanAnomaly {
  parameter obt is ship:orbit, tm is time:seconds.
  local ma to mod(obt:meanAnomalyAtEpoch + 360 * (tm - obt:epoch) / obt:period, 360).
  return choose ma if ma >= 0 else 360 + ma.
}

function timeToMeanAnomaly {
  parameter tgtMA, obt is ship:orbit, tm is time:seconds.
  local curMA to currentMeanAnomaly(obt, tm).
  local angle to choose tgtMA - curMA if tgtMA >= curMA else 360 + tgtMA - curMA.
  return obt:period * angle / 360.
}

// TODO: parabolic/hyperbolic orbits
function timeToPeriapsis {
  parameter obt is ship:orbit, tm is time:seconds.
  return timeToMeanAnomaly(0, obt, tm).
}

// TODO: parabolic/hyperbolic orbits  (?? :))
function timeToApoapsis {
  parameter obt is ship:orbit, tm is time:seconds.
  return timeToMeanAnomaly(180, obt, tm).
}

// TODO: parabolic/hyperbolic orbits
function timeToTrueAnomaly {
  parameter tgtTA, obt is ship:orbit, tm is time:seconds.
  local tgtEA to arctan2(sin(tgtTA) * sqrt(1 - obt:eccentricity ^ 2), obt:eccentricity + cos(tgtTA)).
  local tgtMA to (tgtEA - constant:radToDeg * obt:eccentricity * sin(tgtEA)).
  return timeToMeanAnomaly(tgtMA, obt, tm).
}

function timeToAscendingNode {
  parameter obt is ship:orbit, tm is time:seconds.
  return timeToTrueAnomaly(360 - obt:argumentOfPeriapsis, obt, tm).
}

function timeToDescendingNode {
  parameter obt is ship:orbit, tm is time:seconds.
  return timeToTrueAnomaly(abs(180 - obt:argumentOfPeriapsis), obt, tm).
}
