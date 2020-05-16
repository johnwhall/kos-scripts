@lazyglobal off.

runoncepath("lib/libmath").

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
