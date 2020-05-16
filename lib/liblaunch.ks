@lazyglobal off.

runoncepath("lib/libmath").
runoncepath("lib/liborbit").
runoncepath("lib/libengine").
runoncepath("lib/libstring").
runoncepath("lib/libsecant").

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

function simBurn {
  parameter r. // e.g. -body:position
  parameter v. // e.g. ship:velocity:orbit
  parameter Isp. // s
  parameter thrust. // kN
  parameter m0. // e.g. ship:mass
  parameter mu. // e.g. body:mu
  parameter bt. // burn time
  parameter dt to 0.5.

  local mDot to thrust / (Isp * constant:g0).
  local i to 0.
  local t to i * dt.

  until t >= bt {
    local accGrav to -(mu / r:sqrmagnitude) * r:normalized.
    local accThrust to (thrust / (m0 - mDot * t)) * vxcl(r, v):normalized.
    local a to accGrav + accThrust.
    set r to r + v * dt.
    set v to v + a * dt.

    set i to i + 1.
    set t to i * dt.
  }

  return lexicon("t", t, "r", r, "v", v).
}

function calcCircBurnTime {
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

    local burnDat to simBurn(rBurn, vBurn, Isp, thrust, ship:mass, body:mu, bt, 0.5).
    local vertSpd to burnDat:v * burnDat:r:normalized.
    print "offset: " + offset + " vertSpd: " + vertSpd + " ttbe: " + (burnDat:t + tBurn - time:seconds).
    return vertSpd.
  }.

  local offset to secantMethod(tryOffset, 0, bt, 0.1).

  print "ideal offset: " + offset.
  return tApo - offset.
}
