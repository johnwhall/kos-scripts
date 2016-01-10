@lazyglobal off.

global g_liblambert_callback_fy_angleParameter to 0.

function liblambert_callback_fy_function {
  parameter p_x.

//  print "fy => p_x = " + p_x.
//  print "fy => angleParameter = " + g_liblambert_callback_fy_angleParameter.

  local y to sqrt(1 - (g_liblambert_callback_fy_angleParameter^2) * (1 - p_x * p_x)).
//  print "fy => y = " + y.
  if g_liblambert_callback_fy_angleParameter < 0 {
//    print "fy => A".
    return -y.
  } else {
//    print "fy => B".
    return y.
  }
}
