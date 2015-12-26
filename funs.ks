@lazyglobal off.

function isp {
  local es to list().
  list engines in es.

  local tSum to 0.
  local bSum to 0.

  for e in es {
    if (e:ignition) {
      set tSum to tSum + e:maxthrust.
      set bSum to bSum + (e:maxthrust / e:visp).
    }
  }

  return tSum / bSum.
}

function burnTime1 {
  parameter dv.
  return burnTime4(isp(), mass, maxthrust, dv).
}

function burnTime4 {
  parameter myIsp.
  parameter myMass.
  parameter myMaxThrust.
  parameter myDV.

  local ve to myIsp * 9.82.
  return (myMass * ve / myMaxThrust) * (1 - constant():e^(-myDV / ve)).
}

function absDiffMod {
  parameter x1.
  parameter x2.
  parameter modulus.

  local diff1 to abs(x1 - x2).
  local diff2 to abs(abs(x1 - x2) - modulus).
  return min(diff1, diff2).
}

function faceDiff {
  // assumes steering is a rotation, not a vector

  local pitchDiff to absDiffMod(steering:pitch, facing:pitch, 360).
  local yawDiff to absDiffMod(steering:yaw, facing:yaw, 360).
  local rollDiff to absDiffMod(steering:roll, facing:roll, 360).
  return V(pitchDiff, yawDiff, rollDiff):mag.
}

function warpFor1 {
  parameter dt.

  local warpSpeeds to list(1, 10, 100, 1000, 10000, 100000, 1000000, 6000000).
  local endTime to time:seconds + dt.
  local i to warpSpeeds:length - 1.

  until time:seconds > endTime or i < 1 {
    if (warpSpeeds[i] > (endTime - time:seconds) * 4) {
      set i to i - 1.
    } else {
      set warp to i.
      wait 0.1.
    }
  }

  set warp to 0.
  wait until time:seconds > endTime.
}

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
  local curMA to curE - ship:obt:eccentricity * sin(curE).

  local tgtE to eccAnomFromTrueAnom(ta).
  local tgtMA to tgtE - ship:obt:eccentricity * sin(tgtE).
  if (tgtMA < curMA) { set tgtMA to tgtMA + 360. }

  local deltaMA to tgtMA - curMA.
  local madt to 360 / ship:obt:period.

  return deltaMA / madt.
}

function timeTo1 {
  parameter where.

  local nodeEta to 0.
  if (where = "anode") {
    return timeToTrueAnom(360 - ship:obt:argumentofperiapsis).
  } else if (where = "dnode") {
    return timeToTrueAnom(abs(180 - ship:obt:argumentofperiapsis)).
  } else if (where = "apo" or where = "apoapsis") {
    return eta:apoapsis.
  } else if (where = "per" or where = "peri" or where = "periapsis") {
    return eta:periapsis.
  } else {
    print "Invalid where: " + where.
    exit.
  }
}

function manAt {
  parameter where.
  return node(time:seconds + timeTo1(where), 0, 0, 0).
}

function ignitedEngines {
  local ignited to list().

  local es to list().
  list engines in es.

  for e in es {
    if (e:ignition) {
      ignited:add(e).
    }
  }

  return ignited.
}

function elementByName {
  parameter name.
  parameter l.
  for i in l {
    if i:name = name {
      return i.
    }
  }
  return 0.
}

function recordIndexByName {
  parameter name.
  parameter l.

  local i to 0.
  until i >= l:length {
    if l[i][0] = name {
      return i.
    }
    set i to i + 1.
  }
  return -1.
}

function initTimeToBurnOut {
  return list(time:seconds, lexicon()).
}

function timeToBurnOut {
  // Won't work well when close to burnout because fuel/oxidizer consumption rate
  // tends to trail off rather than abruptly drop to 0.
  parameter resources.
  parameter state.

  local timeNow to time:seconds.
  local dt to timeNow - state[0].
  set state[0] to timeNow.

  local shortestBO to 999999.

  for r in resources {
    if state[1]:hasKey(r:name) {
      local oldAmount to state[1][r:name].

      local rate to (oldAmount - r:amount) / dt.
      if rate > 0 {
        set shortestBO to min(shortestBO, r:amount / rate).
      }
    }

    set state[1][r:name] to r:amount.
  }

  return shortestBO.
}

function smoothScalarBasedTurn {
  // TODO: allow endVal < startVal
  // (e.g. start a high altitude, finish at low altitude)
  parameter curVal, startVal, endVal, startVec, endVec, upVec.

  if curVal < startVal {
    return lookdirup(startVec, upVec).
  } else if curVal > endVal {
    return lookdirup(endVec, upVec).
  } else {
    local frac to (curVal - startVal) / (endVal - startVal).
    local pointVec to frac * endVec + (1 - frac) * startVec.
    return lookdirup(pointVec, upVec).
  }
}
