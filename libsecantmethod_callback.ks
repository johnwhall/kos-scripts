global g_libsecantmethod_callback_offset to 612.

function libsecantmethod_callback_function {
  parameter x.
  print "Evaluating f(" + x + ").".
  return x^2 - g_libsecantmethod_callback_offset.
}
