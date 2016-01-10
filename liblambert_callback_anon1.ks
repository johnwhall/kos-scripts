@lazyglobal off.

global g_liblambert_callback_anon1_NRev to 0.

run once liblambert_callback_phix.

function phix {
  parameter p_x.
  return liblambert_callback_phix_function(p_x).
}

function liblambert_callback_anon1_function {
  parameter p_x.
  local NRev to g_liblambert_callback_anon1_NRev.
  return phix(x) + NRev * constant:pi.
}
