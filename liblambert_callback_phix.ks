@lazyglobal off.

run once libradtrig.

function liblambert_callback_phix_function {
  parameter p_x.
  if p_x = 0 { set p_x to 1e-10. }
  if p_x = 1 { set p_x to 1 - 1e-10. }
  local g to sqrt(1 - p_x^2).
  return radarccot(p_x / g) - (2 + p_x^2) * g / (3 * p_x).
}
