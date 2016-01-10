@lazyglobal off.

global g_liblambert_callback_anon2_NRev to 0.

run once liblambert_callback_phix.
run once liblambert_callback_phiy.
run once liblambert_callback_fy.

function fy {
  parameter p_x.
  return liblambert_callback_fy_function(p_x).
}

function phix {
  parameter p_x.
  return liblambert_callback_phix_function(p_x).
}

function phiy {
  parameter p_x.
  return liblambert_callback_phiy_function(p_x).
}

function liblambert_callback_anon2_function {
  parameter p_x.
  local NRev to g_liblambert_callback_anon2_NRev.
  return phix(p_x) - phiy(fy(p_x)) + NRev * constant:pi.
}
