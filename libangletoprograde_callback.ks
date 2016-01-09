@lazyglobal off.

run once libabsdiffmod.

global g_libangletoprograde_callback_tgtAngle to 0.

function libangletoprograde_callback_function {
  parameter p_deltaTimeGuess.
  local guessSCShipPos to positionat(ship, time:seconds + p_deltaTimeGuess).
  local guessBCShipPos to guessSCShipPos - body:position.
  local guessAngle to angleToPrograde(guessBCShipPos).
  return absDiffMod(guessAngle, g_libangletoprograde_callback_tgtAngle, 360).
}
