@lazyglobal off.

runoncepath("lib/libabsdiffmod").

function faceDiff {
  parameter includeRoll is true.

  local steer to steering.
  if steering:typename() = "vector" {
    set steer to steering:direction.
  }

  local pitchDiff to absDiffMod(steer:pitch, facing:pitch, 360).
  local yawDiff to absDiffMod(steer:yaw, facing:yaw, 360).
  local rollDiff to 0.
  if includeRoll {
    set rollDiff to absDiffMod(steer:roll, facing:roll, 360).
  }
  return V(pitchDiff, yawDiff, rollDiff):mag.
}
