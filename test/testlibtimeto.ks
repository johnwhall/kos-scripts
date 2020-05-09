@lazyglobal off.

runoncepath("test/libtest").
runoncepath("lib/libtimeto").
runoncepath("lib/liborbit").
runoncepath("lib/libstring").

local inc to 28.6.
local e to 0.05.
local sma to (earth:mu * 7200^2 / (4 * constant:pi ^ 2)) ^ (1/3). // 2 hour orbital period
local lan to 30.
local argPe to 45.

function mo {
  parameter inc, e, sma, lan, argPe, mEp, t, bdy.
  return subst("makeOrbit({}, {}, {}, {}, {}, {}, {}, {})", inc, e, sma, lan, argPe, mEp, t, bdy:name).
}

until false {
  clearscreen.

  print "time to apoapsis:".
  local tta to timeToApoapsis().
  print tta.
  print s2ydhms(tta).

  print " ".
  print "time to periapsis:".
  local ttp to timeToPeriapsis().
  print ttp.
  print s2ydhms(ttp).

  print " ".
  print "time to ascending node:".
  local ttan to timeToAscendingNode().
  print ttan.
  print s2ydhms(ttan).

  print " ".
  print "time to descending node:".
  local ttdn to timeToDescendingNode().
  print ttdn.
  print s2ydhms(ttdn).

  wait 0.5.
}

runSimpleOr(subst("currentMeanAnomaly({}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 360, 1e-6).
runSimple(subst("currentMeanAnomaly({}, 0)", mo(inc, e, sma, lan, argPe, 180, 0, earth)), 180, 1e-6).
runSimple(subst("currentMeanAnomaly({}, 0)", mo(inc, e, sma, lan, argPe, 90, 0, earth)), 90, 1e-6).
runSimple(subst("currentMeanAnomaly({}, 0)", mo(inc, e, sma, lan, argPe, 270, 0, earth)), 270, 1e-6).
runSimpleOr(subst("currentMeanAnomaly({}, -7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 360, 1e-6).
runSimple(subst("currentMeanAnomaly({}, -3600)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 180, 1e-6).
runSimple(subst("currentMeanAnomaly({}, -5400)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 90, 1e-6).
runSimple(subst("currentMeanAnomaly({}, -1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 270, 1e-6).
runSimpleOr(subst("currentMeanAnomaly({}, 7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 360, 1e-6).
runSimple(subst("currentMeanAnomaly({}, 3600)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 180, 1e-6).
runSimple(subst("currentMeanAnomaly({}, 5400)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 270, 1e-6).
runSimple(subst("currentMeanAnomaly({}, 1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 90, 1e-6).

runSimpleOr(subst("timeToMeanAnomaly(0, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToMeanAnomaly(90, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 1800, 1e-6).
runSimple(subst("timeToMeanAnomaly(180, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToMeanAnomaly(270, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 5400, 1e-6).
runSimpleOr(subst("timeToMeanAnomaly(360, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimpleOr(subst("timeToMeanAnomaly(0, {}, -7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToMeanAnomaly(90, {}, -1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToMeanAnomaly(90, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 1800, earth)), 3600, 1e-6).

runSimpleOr(subst("timeToPeriapsis({}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToPeriapsis({}, 0)", mo(inc, e, sma, lan, argPe, 180, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToPeriapsis({}, 0)", mo(inc, e, sma, lan, argPe, 90, 0, earth)), 5400, 1e-6).
runSimple(subst("timeToPeriapsis({}, 0)", mo(inc, e, sma, lan, argPe, 270, 0, earth)), 1800, 1e-6).
runSimpleOr(subst("timeToPeriapsis({}, -7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToPeriapsis({}, -3600)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToPeriapsis({}, -5400)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 5400, 1e-6).
runSimple(subst("timeToPeriapsis({}, -1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 1800, 1e-6).
runSimpleOr(subst("timeToPeriapsis({}, 7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToPeriapsis({}, 3600)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToPeriapsis({}, 5400)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 1800, 1e-6).
runSimple(subst("timeToPeriapsis({}, 1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 5400, 1e-6).

runSimple(subst("timeToApoapsis({}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimpleOr(subst("timeToApoapsis({}, 0)", mo(inc, e, sma, lan, argPe, 180, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToApoapsis({}, 0)", mo(inc, e, sma, lan, argPe, 90, 0, earth)), 1800, 1e-6).
runSimple(subst("timeToApoapsis({}, 0)", mo(inc, e, sma, lan, argPe, 270, 0, earth)), 5400, 1e-6).
runSimple(subst("timeToApoapsis({}, -7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimpleOr(subst("timeToApoapsis({}, -3600)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToApoapsis({}, -5400)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 1800, 1e-6).
runSimple(subst("timeToApoapsis({}, -1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 5400, 1e-6).
runSimple(subst("timeToApoapsis({}, 7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimpleOr(subst("timeToApoapsis({}, 3600)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToApoapsis({}, 5400)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 5400, 1e-6).
runSimple(subst("timeToApoapsis({}, 1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 1800, 1e-6).

runSimpleOr(subst("timeToTrueAnomaly(0, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToTrueAnomaly(90, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 1800, 1e-6).
runSimple(subst("timeToTrueAnomaly(180, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToTrueAnomaly(270, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 5400, 1e-6).
runSimpleOr(subst("timeToTrueAnomaly(360, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimpleOr(subst("timeToTrueAnomaly(0, {}, -7200)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 0, 7200, 1e-6).
runSimple(subst("timeToTrueAnomaly(90, {}, -1800)", mo(inc, e, sma, lan, argPe, 0, 0, earth)), 3600, 1e-6).
runSimple(subst("timeToTrueAnomaly(90, {}, 0)", mo(inc, e, sma, lan, argPe, 0, 1800, earth)), 3600, 1e-6).

print " ".
print " ".

local ttan to timeToAscendingNode().
print ttan.
print s2dhms(ttan).
