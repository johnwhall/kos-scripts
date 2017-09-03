@lazyglobal off.

until false {
  print "waiting for message".
  wait until not core:messages:empty.
  local msg to core:messages:pop().
  runpath(msg:content).
}
