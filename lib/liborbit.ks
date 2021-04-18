@lazyglobal off.

function dumpOrbit {
  parameter obt.
  print "Orbit Dump:".
  print "  sma: " + obt:semiMajorAxis.
  print "  ecc: " + obt:eccentricity.
  print "  inc: " + (constant:degToRad * obt:inclination) + " (" + obt:inclination + "°)".
  print "  MAe: " + (constant:degToRad * obt:meanAnomalyAtEpoch) + " (" + obt:meanAnomalyAtEpoch + "°)".
  print "  lan: " + (constant:degToRad * obt:longitudeOfAscendingNode) + " (" + obt:longitudeOfAscendingNode + "°)".
  print "  aop: " + (constant:degToRad * obt:argumentOfPeriapsis) + " (" + obt:argumentOfPeriapsis + "°)".
  print "  epoch: " + obt:epoch.
  print "  ta: " + (constant:degToRad * obt:trueAnomaly) + " (" + obt:trueAnomaly + "°)".
  print "  mu: " + obt:body:mu.
  print "  period: " + obt:period.
  print "  period (calc): " + (2 * constant:pi * sqrt((obt:semiMajorAxis^3) / obt:body:mu)).
}

function makeOrbit {
  parameter inc, e, sma, lan, argPe, mEp, t, bdy.
  if core:version = "1.2.1.0" { set mEp to mEp * constant:degToRad. } // https://github.com/KSP-KOS/KOS/pull/2689
  return createOrbit(inc, e, sma, lan, argPe, mEp, t, bdy).
}

function predictPosition {
  parameter t. // target time (universal)
  parameter orbt is ship. // Orbit or Orbital

  if orbt:isType("Orbitable") {
    if career():canMakeNodes { return positionAt(orbt, time(t)). }
    else { set orbt to orbt:orbit. }
  }

  // Keep everything the same except epoch, which is shifted
  local dt to t - orbt:epoch.
  return makeOrbit(orbt:inclination, orbt:eccentricity, orbt:semiMajorAxis, orbt:longitudeOfAscendingNode, orbt:argumentOfPeriapsis, orbt:meanAnomalyAtEpoch, orbt:epoch - dt, orbt:body):position.
}

function predictVelocity {
  parameter t. // target time (universal)
  parameter orbt is ship. // Orbit or Orbital

  if orbt:isType("Orbitable") {
    if career():canMakeNodes { return velocityAt(orbt, time(t)). }
    else { set orbt to orbt:orbit. }
  }

  // Keep everything the same except epoch, which is shifted
  local dt to t - orbt:epoch.
  return makeOrbit(orbt:inclination, orbt:eccentricity, orbt:semiMajorAxis, orbt:longitudeOfAscendingNode, orbt:argumentOfPeriapsis, orbt:meanAnomalyAtEpoch, orbt:epoch - dt, orbt:body):velocity.
}

// DOES NOT WORK FOR TIDALLY LOCKED BODIES
// DOES NOT ALWAYS AGREE WITH ORBITAT (WHICH DOESN'T WORK ANYWAY)
// TODO: maneuver nodes, SOI transitions
function predictOrbit {
  parameter t. // target time (universal)
  parameter orbt is ship:orbit.

  if orbt:isType("Orbitable") { set orbt to orbt:orbit. }

  // Keep everything the same except epoch, which is shifted
  local dt to t - orbt:epoch.
  return makeOrbit(orbt:inclination, orbt:eccentricity, orbt:semiMajorAxis, orbt:longitudeOfAscendingNode, orbt:argumentOfPeriapsis, orbt:meanAnomalyAtEpoch, orbt:epoch - dt, orbt:body).
}

// TODO: KSP swaps y and z components of vectors?
function orbitFromStateVectors {
  parameter rVec.
  parameter vVec.
  parameter bdy is ship:body.
  parameter t is time:seconds.

  local mu to bdy:mu.
  local r to rVec:mag.
  local v to vVec:mag.
  local hVec to vcrs(rVec, vVec).
  local eVec to vcrs(vVec, hVec) / mu - rVec:normalized. // unit vector pointing toward periapsis
  local nVec to V(-hVec:y, -hVec:x, 0). // unit vector pointing toward ascending node
  local n to nVec:mag.

  local a to 1 / ((2 / r) - (v * v) / mu).
  print "a = " + a.
  local e to eVec:mag.
  print "e = " + e.
  local i to arccos(hVec:z / hVec:mag).
  print "i = " + i.
  local lan to choose arccos(nVec:x / n) if nVec:y >= 0 else 360 - arccos(nVec:x / n).
  print "lan = " + lan.
  local aop to 0.
  if n * e <> 0 { set aop to choose arccos(nVec * eVec / (n * e)) if eVec:z >= 0 else 360 - arccos(nVec * eVec / (n * e)). }
  print "aop = " + aop.

  local ma to 0.
  if e * r <> 0 {
    local ta to choose arccos(eVec * rVec / (e * r)) if rVec * vVec >= 0 else 360 - arccos(eVec * rVec / (e * r)). // true anomaly
    local ea to choose arccos((e + cos(ta)) / (1 + e * cos(ta))) if ta < 180 else 360 - arccos((e + cos(ta)) / (1 + e * cos(ta))). // eccentric anomaly
    if ta = 180 { error. } // TODO: handle this case TODO: why? it is already correct (ea=180)
    set ma to ea - e * sin(ea).
  }

  // TODO: https://github.com/KSP-KOS/KOS/pull/2689
  return createOrbit(i, e, a, lan, aop, ma, t, bdy).
}

// TODO: test
function synodicPeriod {
  parameter obt1, obt2.
  if obt1:period < obt2:period { return 1 / (1 / obt1:period - 1 / obt2:period). }
  else { return 1 / (1 / obt2:period - 1 / obt1:period). }
}
