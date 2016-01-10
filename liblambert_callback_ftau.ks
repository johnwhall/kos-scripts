@lazyglobal off.

global g_liblambert_callback_ftau_parabolicNormalizedTime to 0.
global g_liblambert_callback_ftau_normalizedTime to 0.
global g_liblambert_callback_ftau_NRev to 0.

run once libradtrig.
run once liblambert_callback_fy.

function fy {
  parameter p_x.
  return liblambert_callback_fy_function(p_x).
}

function liblambert_callback_ftau_function {
  parameter p_x.

  local parabolicNormalizedTime to g_liblambert_callback_ftau_parabolicNormalizedTime.
  local normalizedTime to g_liblambert_callback_ftau_normalizedTime.
  local NRev to g_liblambert_callback_ftau_NRev.

//  print "ftau => parabolicNormalizedTime = " + parabolicNormalizedTime.
//  print "ftau => normalizedTime = " + normalizedTime.
//  print "ftau => NRev = " + NRev.
//  print "ftau => p_x = " + p_x.

  if p_x = 1 {
//    print "ftau => A".
    return parabolicNormalizedTime - normalizedTime.
  } else {
//    print "ftau => B".
    local y to fy(p_x).
//    print "ftau => y = " + y.
    if p_x > 1 {
//      print "ftau => C".
      local g to sqrt(p_x^2 - 1).
      local h to sqrt(y^2 - 1).
//      print "ftau => g = " + g.
//      print "ftau => h = " + h.
      return (-radarccoth(p_x / g) + radarccoth(y / h) + p_x * g - y * h) / (g * g * g) - normalizedTime.
    } else {
//      print "ftau => D".
      local g to sqrt(1 - p_x^2).
      local h to sqrt(1 - y^2).
//      print "ftau => g = " + g.
//      print "ftau => h = " + h.
      local returning to (radarccot(p_x / g) - radarctan(h / y) - p_x * g + y * h + NRev * constant:pi) / (g * g * g) - normalizedTime.
//      print "ftau => radarccot = " + radarccot(p_x / g).
//      print "ftau => radarctan = " + radarctan(h / y).
//      print "ftau => rest = " + (p_x * g + y * h + NRev * constant:pi).
//      print "ftau => first = " + (radarccot(p_x / g) - radarctan(h / y) - p_x * g + y * h + NRev * constant:pi).
//      print "ftau => returning " + returning.
      return returning.
    }
  }
}
