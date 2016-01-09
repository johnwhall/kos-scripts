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
  }
  print "UNKNOWN CALLBACK: " + p_cbScript.
  exit.
}
