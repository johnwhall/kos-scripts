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
    if msg = "" { set msg to "assertEquals failure (actual: " + actual + " expected: " + expected + ")". }
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
  else if expected:typename = "Scalar" { return abs(expected - actual) <= eps. }
  else if expected:typename = "Vector" { return abs(expected:x - actual:x) <= eps and abs(expected:y - actual:y) <= eps and abs(expected:z - actual:z) <= eps. }
  else if expected:typename = "Direction" { return abs(expected:pitch - actual:pitch) <= eps and abs(expected:yaw - actual:yaw) <= eps and abs(expected:roll - actual:roll) <= eps. }
  else unknownType. // error
}

function runSimpleOr {
  parameter cmd.
  parameter expected1.
  parameter expected2.
  parameter eps is 0.

  local cmdFile to "test/runSimpleTests/test" + runSimpleTestNum + ".ks".
  set runSimpleTestNum to runSimpleTestNum + 1.
  deletepath(cmdFile).
  if defined doTest { unset doTest. }.
  log "@lazyglobal off." to cmdFile.
  log "global lock doTest to (" + cmd + ")." to cmdFile.

  runpath(cmdFile).
  local actual is doTest().

  local msg to cmd + " = " + actual + " (expected " + expected1 + " or " + expected2 + ")".
  assertEqualsOr(expected1, expected2, actual, eps, msg).
}

function assertEqualsOr {
  parameter expected1.
  parameter expected2.
  parameter actual.
  parameter eps is 0.
  parameter msg is "".

  if not isEqual(expected1, actual, eps) and not isEqual(expected2, actual, eps) {
    if msg = "" { set msg to "assertEqualsOr failure (actual: " + actual + " expected1: " + expected1 + " expected2: " + expected2 + ")". }
    print msg.
    return false.
  }
  return true.
}
