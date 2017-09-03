@lazyglobal off.

{
  parameter p_turnTime, p_ullageTime.
  runoncepath("lib/libexecnode").
  execNode(p_turnTime, p_ullageTime).
}
