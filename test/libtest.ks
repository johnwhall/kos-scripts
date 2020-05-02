@lazyglobal off.

global runSimpleTestNum to 0.

function runSimple {
  parameter cmd.
  parameter expected.

  local cmdFile to "test/runSimpleTests/test" + runSimpleTestNum + ".ks".
  set runSimpleTestNum to runSimpleTestNum + 1.
  deletepath(cmdFile).
  if defined doTest { unset doTest. }.
  log "@lazyglobal off." to cmdFile.
  log "global lock doTest to (" + cmd + ")." to cmdFile.

  runpath(cmdFile).
  local actual is doTest().

  local msg to cmd + " = " + actual + " (expected " + expected + ")".
  assertEquals(expected, actual, msg).
}

function assertEquals {
  parameter expected.
  parameter actual.
  parameter msg is "".

  if expected <> actual or expected:typename <> actual:typename {
    if msg = "" { set msg to "assertEquals failure (expected: " + expected + " actual: " + actual + ")". }
    print msg.
    return false.
  }
  return true.
}
