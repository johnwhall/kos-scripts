@lazyglobal off.

function doCallbackR1 {
  parameter p_cbScript.
  parameter p_p1.
  if p_cbScript = "libsecantmethod_callback" {
    return libsecantmethod_callback_function(p_p1).
  } else if p_cbScript = "libangletoprograde_callback" {
    return libangletoprograde_callback_function(p_p1).
  } else if p_cbScript = "libphaseangle_callback" {
    return libphaseangle_callback_function(p_p1).
  } else if p_cbScript = "libbisectionmethod_callback" {
    return libbisectionmethod_callback_function(p_p1).
  } else if p_cbScript = "libbrentsmethod_callback" {
    return libbrentsmethod_callback_function(p_p1).
  } else if p_cbScript = "liblambert_callback_fy" {
    return liblambert_callback_fy_function(p_p1).
  } else if p_cbScript = "liblambert_callback_ftau" {
    return liblambert_callback_ftau_function(p_p1).
  } else if p_cbScript = "liblambert_callback_anon1" {
    return liblambert_callback_anon1_function(p_p1).
  } else if p_cbScript = "liblambert_callback_anon2" {
    return liblambert_callback_anon2_function(p_p1).
  }
  print "UNKNOWN CALLBACK: " + p_cbScript.
  exit.
}
