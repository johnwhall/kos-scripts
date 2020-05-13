@lazyglobal off.

local function sign {
  // TODO: Move to libmath & add tests
  parameter x.
  if x > 0 { return 1. }
  else if x = 0 { return 0. }
  else { return -1. }
}

// TODO: Basing this off the sign might not be good if the sign would flip normally?  (tgtInc=180?)
//       Instead, wait until absolute difference is minimized?
//       But if there is a temporary increase for some reason, that would be bad, too.
//       So just wait until abs diff is small enough, then snap?
//       But if update rate is slow, we might jump past small abs diffs.
//       Also, we might overshoot if the heading difference at flip is far from the heading calculated from the target inclination,
//       so maybe switch to a PID controller once abs diff gets to a certain amount, but then how to tune?
function HeadingPicker {
  parameter launchAzimuth, tgtInc.

  local this to lexicon().
  set this:launchAzimuth to launchAzimuth.
  set this:tgtInc to tgtInc.
  set this:incFlipped to false.
  set this:initialSign to sign(ship:orbit:inclination - this:tgtInc).

  print "launchAzimuth: " + this:launchAzimuth + " tgtInc: " + this:tgtInc + " initialSign: " + this:initialSign.

  set this:pick to {
    if this:incFlipped { return this:pickFromTargetInclination(). }

    if sign(ship:orbit:inclination - this:tgtInc) <> this:initialSign {
      set this:incFlipped to true.
      print "FLIPPED!".
      return this:pickFromTargetInclination().
    } else {
      return this:launchAzimuth.
    }
  }.

  set this:pickFromTargetInclination to {
    return this:launchAzimuth.
  }.

  return this.
}
