@lazyglobal off.

run once libradtrig.

function liblambert_callback_phiy_function {
  parameter p_y.
  if p_y = 0 { set p_y to 1e-10. }
  local h to sqrt(1 - p_y^2).
  return radarctan(h / p_y) - (2 + p_y^2) * h / (3 * p_y).
}
