@lazyglobal off.

// TODO: maneuver nodes, SOI transitions
function predictOrbit {
  parameter t. // target time (universal)
  parameter orbt is ship:orbit.

  if orbt:hasSuffix("orbit") { set orbt to orbt:orbit. }

  // Keep everything the same except epoch, which is shifted
  local dt to t - orbt:epoch.
  local ma to orbt:meanAnomalyAtEpoch.
  if core:version = "1.2.1.0" { set ma to ma * constant:degToRad. } // https://github.com/KSP-KOS/KOS/pull/2689
  return createOrbit(orbt:inclination, orbt:eccentricity, orbt:semiMajorAxis, orbt:longitudeOfAscendingNode, orbt:argumentOfPeriapsis, ma, orbt:epoch - dt, orbt:body).
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
    if ta = 180 { error. } // TODO: handle this case
    set ma to ea - e * sin(ea).
  }

  return createOrbit(i, e, a, lan, aop, ma, t, bdy).
}
