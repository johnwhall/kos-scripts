@lazyglobal off.

runoncepath("lib/libmath").
runoncepath("lib/liborbit").
runoncepath("lib/libengine").
runoncepath("lib/libstring").

// TODO: Basing this off the sign might not be good if the sign would flip normally?  (tgtInc=180?)
//       Instead, wait until absolute difference is minimized?
//       But if there is a temporary increase for some reason, that would be bad, too.
//       So just wait until abs diff is small enough, then snap?
//       But if update rate is slow, we might jump past small abs diffs.
//       So wait until curAbsDiff > 2*minAbsDiff
//       Also, we might overshoot if the heading difference at flip is far from the heading calculated from the target inclination,
//       so maybe switch to a PID controller once abs diff gets to a certain amount, but then how to tune?
function HeadingPicker {
  parameter laz, tgtInc.

  local this to lexicon().
  set this:laz to laz.
  set this:tgtInc to tgtInc.
  set this:incFlipped to false.
  set this:initialSign to sign(ship:orbit:inclination - this:tgtInc).

  print "laz: " + this:laz + " tgtInc: " + this:tgtInc + " initialSign: " + this:initialSign.

  set this:pick to {
    if this:incFlipped { return this:pickFromTargetInclination(). }

    if sign(ship:orbit:inclination - this:tgtInc) <> this:initialSign {
      set this:incFlipped to true.
      print "FLIPPED!".
      return this:pickFromTargetInclination().
    } else {
      return this:laz.
    }
  }.

  set this:pickFromTargetInclination to {
    return this:laz.
  }.

  return this.
}

function launchAzimuth {
  parameter tgtInc, tgtAlt.

  // Source: http://www.orbiterwiki.org/wiki/Launch_Azimuth
  local betaInertial to arcsin(clamp(cos(tgtInc) / cos(ship:latitude), -1, 1)).
  local vEqRot to 2 * constant:pi * body:radius / body:rotationPeriod.
  local vOrbit to sqrt(body:mu / (body:radius + tgtAlt)).
  return arctan((vOrbit * sin(betaInertial) -  vEqRot * cos(ship:latitude)) / (vOrbit * cos(betaInertial))).
}

function logIt {
  parameter t, r0, v0.
  local fv to { parameter v. return formatVector(v, 1, 3, 3). }.
  local fd to { parameter d. return formatDecimal(d, 1, 3, 3). }.
  local vertSpd to v0 * r0:normalized.
  local horzSpd to vxcl(r0, v0):mag.
  //print "t: " + fd(t) + " r0: " + fv(r0) + " v0: " + fv(v0) + " vertSpd: " + fd(vertSpd) + " horzSpd: " + fd(horzSpd).
}

function simBurn {
  parameter r0. // e.g. -body:position
  parameter v0. // e.g. ship:velocity:orbit
  parameter Isp. // s
  parameter thrust. // kN
  parameter m0. // e.g. ship:mass
  parameter mu. // e.g. body:mu
  parameter stopDel to { parameter t, r0, v0. exit. }.
  parameter dt to 0.1.

  local mDot to thrust / (Isp * constant:g0).
  local i to 0.
  local lock t to i * dt.

  logIt(t, r0, v0).

  until stopDel(t, r0, v0) {
    local accGrav to -(mu / r0:sqrmagnitude) * r0:normalized.
    local accThrust to (thrust / (m0 - mDot * t)) * vxcl(r0, v0):normalized.
    local a to accGrav + accThrust.
    local r1 to r0 + v0 * dt.
    local v1 to v0 + a * dt.

    set r0 to r1.
    set v0 to v1.
    set i to i + 1.

    if mod(i, 1 / dt) = 0 { logIt(t, r0, v0). }
  }

  if mod(i, 1 / dt) <> 0 { logIt(t, r0, v0). }

  return lexicon("t", t, "r", r0, "v", v0).
}

//function ttab {
//  runoncepath("lib/liborbit").
//  runoncepath("lib/libengine").
//  local tApo to time:seconds + eta:apoapsis.
//  local orbtApo0 to predictOrbit(tApo).
//  local vCirc to sqrt(body:mu / (body:radius + orbtApo0:apoapsis)).
//  local dv to vCirc - orbtApo0:velocity:orbit:mag.
//  local bt to burnTime(dv, 267, 33, ship:mass).
//  print "dv: " + dv + " bt: " + bt.
//
//  local bestOffset to bt.
//  local bestAbsVertSpd to 9999999.
//  from { local offset to bt. } until offset <= 0 step { set offset to offset - 0.1. } do {
//    local tBurn to tApo - offset.
//    local orbtBurn to predictOrbit(tBurn).
//    local rBurn to orbtBurn:position - body:position.
//    local vBurn to orbtBurn:velocity:orbit.
//
//    local burnDat to simBurn(rBurn, vBurn, 267, 33, ship:mass, body:mu, { parameter t, r0, v0. return t >= bt. }, 0.1).
//    local vertSpd to burnDat:v * burnDat:r:normalized.
//    local horzSpd to vxcl(burnDat:r, burnDat:v):mag.
//    print "offset: " + offset + " vertSpd: " + vertSpd + " horzSpd: " + horzSpd.
//
//    if abs(vertSpd) < bestAbsVertSpd {
//      set bestAbsVertSpd to vertSpd.
//      set bestOffset to offset.
//    }
//  }
//
//  print "bestOffset: " + bestOffset + " bestAbsVertSpd: " + bestAbsVertSpd.
//}

function ttab {
  parameter Isp, thrust.
  local tApo to time:seconds + eta:apoapsis.
  local orbtApo0 to predictOrbit(tApo).
  local vCirc to sqrt(body:mu / (body:radius + orbtApo0:apoapsis)).
  local dv to vCirc - orbtApo0:velocity:orbit:mag.
  local bt to burnTime(dv, Isp, thrust, ship:mass).
  print "dv: " + dv + " bt: " + bt.

  local tryOffset to {
    parameter offset.

    local tBurn to tApo - offset.
    local orbtBurn to predictOrbit(tBurn).
    local rBurn to orbtBurn:position - body:position.
    local vBurn to orbtBurn:velocity:orbit.

    local burnDat to simBurn(rBurn, vBurn, 267, 33, ship:mass, body:mu, { parameter t, r0, v0. return t >= bt. }, 0.5).
    local vertSpd to burnDat:v * burnDat:r:normalized.
    print "offset: " + offset + " vertSpd: " + vertSpd.
    return vertSpd.
  }.

  local offsetLeft to 0.
  local offsetRight to bt.
  until offsetRight - offsetLeft < 0.1 {
    local offsetMid to (offsetLeft + offsetRight) / 2.
    local offset14 to (offsetLeft + offsetMid) / 2.
    local offset34 to (offsetMid + offsetRight) / 2.

    local vertSpd14 to abs(tryOffset(offset14)).
    local vertSpd34 to abs(tryOffset(offset34)).

    if vertSpd14 < vertSpd34 { set offsetRight to offsetMid. }
    else { set offsetLeft to offsetMid. }
  }

  local idealOffset to (offsetLeft + offsetRight) / 2.
  print "ideal offset: " + idealOffset.
  return tApo - idealOffset.
}
