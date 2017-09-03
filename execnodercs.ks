@lazyglobal off.

{
  parameter p_isp, p_thrust, p_turnTime, p_turnWithRCS is false.
  runoncepath("lib/libexecnode").
  execNodeRCS(p_isp, p_thrust, p_turnTime, p_turnWithRCS).
}
