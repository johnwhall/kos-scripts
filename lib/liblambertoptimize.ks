@lazyglobal off.

runoncepath("lib/liborbitalstate").
runoncepath("lib/libmainframe").

function lambertOptimizeBounded {
  parameter s1.
  parameter s2.
  parameter tMin.
  parameter tMax.
  parameter dtMin is 0.
  parameter dtMax is max(s1:orbit:period, s2:orbit:period).
  parameter allowLob is true.
  parameter optArrival is true.

  local calcStartTime to time:seconds.
  print "Calc start time: " + calcStartTime.
  print "Passed tMin: " + tMin.
  print "Passed tMax: " + tMax.

  set tMin to tMin - time:seconds.
  set tMax to tMax - time:seconds.
  print "Adjusted tMin: " + tMin.
  print "Adjusted tMax: " + tMax.

  local MIN_STEP_T to 1.
  local MIN_STEP_DT to 1.

  set tMin to max(0, tMin).
  set tMax to max(tMin + 1e-8, tMax).

  set dtMin to max(0, dtMin).
  set dtMax to max(dtMin + 1e-8, dtMax).

  local b to s1:body.
  if s2:body <> b {
    print "bodies must be the same".
    exit.
  }

  local rv1 to getECIVecs(s1:orbit).
  local rv2 to getECIVecs(s2:orbit).

  local res to lexicon().

  // initialize these to force us into the loop, then immediately recalculate
  local tStep to 2 * MIN_STEP_T.
  local dtStep to 2 * MIN_STEP_DT.

  // pure equality check is ok since these are assigned directly, not computed
  until tStep = MIN_STEP_T and dtStep = MIN_STEP_DT {
    // do this at the beginning of the loop (after checking the until condition) so
    // we loop at least once with tStep = dtStep = 1
    set tStep to max(MIN_STEP_T, (tMax - tMin) / 10000).
    set dtStep to max(MIN_STEP_DT, (dtMax - dtMin) / 500).

    set res to mainframeLambertOptimizeVecs(b:mu,
                                            rv1[0], rv1[1],
                                            rv2[0], rv2[1],
                                            tMin, tMax, tStep,
                                            dtMin, dtMax, dtStep,
                                            allowLob, optArrival).

    set tMin to max(0, res["t"] - tStep).
    set tMax to tMin + 2 * tStep.

    set dtMin to max(0, res["dt"] - dtStep).
    set dtMax to dtMin + 2 * dtStep.

    //set tStep to MIN_STEP_T.
    //set dtStep to MIN_STEP_DT.
  }

  local calcEndTime to time:seconds.
  print "Calc end time: " + calcEndTime + " (total time: " + (calcEndTime - calcStartTime) + ")".
  print "answer from mainframe: " + res["t"].

  set res["t"] to res["t"] + calcStartTime.
  print "returning " + res["t"] + " (" + (res["t"] - time:seconds) + " from now)".

  return res.
}

function lambertOptimize {
  parameter s1.
  parameter s2.
  parameter allowLob is true.
  parameter optArrival is true.
  parameter startTime is time:seconds.

  local synodicPeriod to 1 / ((1 / s1:orbit:period) - (1 / s2:orbit:period)).
  local dtMin to 0.
  local dtMax to max(s1:orbit:period, s2:orbit:period).

  local res to lambertOptimizeBounded(s1, s2, startTime, startTime + synodicPeriod, dtMin, dtMax, allowLob, optArrival).
  
  return res.
}

//local res to lambertOptimize(ship, target, true).
//local res to lambertOptimize(ship, moon, false).
//local t to res["t"].
//local dt to res["dt"].
//local pro to res["prograde"].
//local norm to res["normal"].
//local rad to res["radial"].
//add node(rad, norm, pro).
