@lazyglobal off.

run once liborbitalstate.
run once libmainframe.

function doOnce {
  parameter p_mu.
  parameter p_rv1.
  parameter p_rv2.
  parameter p_tMid.
  parameter p_tStep.
  parameter p_dtMid.
  parameter p_dtStep.
  parameter p_allowLob.

  local tMin to p_tMid - 50 * p_tStep.
  local tMax to p_tMid + 50 * p_tStep.
  local dtMin to p_dtMid - 250 * p_dtStep.
  local dtMax to p_dtMid + 250 * p_dtStep.

  return mainframeLambertOptimizeVecs(p_mu,
                                      p_rv1[0], p_rv1[1],
                                      p_rv2[0], p_rv2[1],
                                      tMin, tMax, p_tStep,
                                      dtMin, dtMax, p_dtStep,
                                      p_allowLob).
}

function lambertOptimizeBounded {
  parameter p_s1.
  parameter p_s2.
  parameter p_tMin.
  parameter p_tMax.
  parameter p_dtMin.
  parameter p_dtMax.
  parameter p_allowLob.

  local tMid to (p_tMax + p_tMin) / 2.
  local tStep to (p_tMax - p_tMin) / 100.

  local dtMid to (p_dtMin + p_dtMax) / 2.
  local dtStep to (p_dtMax - p_dtMin) / 500.

  local b to p_s1:body.
  if p_s2:body <> b {
     print "bodies must be the same".
     exit.
  }

  local rv1 to getECIVecs(p_s1:orbit).
  local rv2 to getECIVecs(p_s2:orbit).

  local startTime to time:seconds.

  local res to lexicon().

  until tStep <= 1/49 and dtStep <= 1/49 {
	  set tStep to max(1, tStep).
	  set dtStep to max(1, dtStep).

	  set res to doOnce(b:mu, rv1, rv2, tMid, tStep, dtMid, dtStep, p_allowLob).
	  set tMid to res["t"].
	  set dtMid to res["dt"].
	  set tStep to tStep / 50.
	  set dtStep to dtStep / 50.
  }

  set res["t"] to res["t"] - (time:seconds - startTime).

  return res.
}

function lambertOptimize {
  parameter p_s1.
  parameter p_s2.
  parameter p_allowLob.

  local synodicPeriod to 1 / ((1 / p_s1:orbit:period) - (1 / p_s2:orbit:period)).
  local dtMin to min(p_s1:orbit:period, p_s2:orbit:period).
  local dtMax to max(p_s1:orbit:period, p_s2:orbit:period).

  return lambertOptimizeBounded(p_s1, p_s2, 0, synodicPeriod, dtMin, dtMax, p_allowLob).
}

//local res to lambertOptimize(ship, moon, false).
//local t to res["t"].
//local dt to res["dt"].
//local pro to res["prograde"].
//local norm to res["normal"].
//local rad to res["radial"].
//add node(time:seconds + t, rad, norm, pro).
