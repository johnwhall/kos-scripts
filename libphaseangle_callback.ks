@lazyglobal off.

run once libabsdiffmod.

global g_libphaseangle_callback_tgtAngle to 0.
global g_libphaseangle_callback_tgt to 0.

function libphaseangle_callback_function {
  parameter p_deltaTimeGuess.

  local timeGuess to time:seconds + p_deltaTimeGuess.
  local guessSCShipPos to positionat(ship, timeGuess).
  local guessBCShipPos to guessSCShipPos - body:position.
  local guessAngle to phaseAngle(timeGuess, g_libphaseangle_callback_tgt).
  return absDiffMod(guessAngle, g_libphaseangle_callback_tgtAngle, 360).
}
