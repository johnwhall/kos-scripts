@lazyglobal off.

function faceDiff {
  // assumes steering is a rotation, not a vector

  local pitchDiff to absDiffMod(steering:pitch, facing:pitch, 360).
  local yawDiff to absDiffMod(steering:yaw, facing:yaw, 360).
  local rollDiff to absDiffMod(steering:roll, facing:roll, 360).
  return V(pitchDiff, yawDiff, rollDiff):mag.
}
