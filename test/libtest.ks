@lazyglobal off.

global runSimpleTestNum to 0.

function runSimple {
  parameter cmd.
  parameter expected.
  parameter eps is 0.

  local cmdFile to "test/runSimpleTests/test" + runSimpleTestNum + ".ks".
  set runSimpleTestNum to runSimpleTestNum + 1.
  deletepath(cmdFile).
  if defined doTest { unset doTest. }.
  log "@lazyglobal off." to cmdFile.
  log "global lock doTest to (" + cmd + ")." to cmdFile.

  runpath(cmdFile).
  local actual is doTest().

  local msg to cmd + " = " + actual + " (expected " + expected + ")".
  assertEquals(expected, actual, eps, msg).
}

function assertEquals {
  parameter expected.
  parameter actual.
  parameter eps is 0.
  parameter msg is "".

  if not isEqual(expected, actual, eps) {
    if msg = "" { set msg to "assertEquals failure (expected: " + expected + " actual: " + actual + ")". }
    print msg.
    return false.
  }
  return true.
}

local function isEqual {
  parameter expected.
  parameter actual.
  parameter eps.

  if expected:typename = "String" { return expected = actual. }
  else if expected:typename = "Scalar" { return abs(expected - actual) < eps. }
  else if expected:typename = "Vector" { return abs(expected:x - actual:x) < eps and abs(expected:y - actual:y) < eps and abs(expected:z - actual:z) < eps. }
  else if expected:typename = "Direction" { return abs(expected:pitch - actual:pitch) < eps and abs(expected:yaw - actual:yaw) < eps and abs(expected:roll - actual:roll) < eps. }
  else unknownType. // error
}
