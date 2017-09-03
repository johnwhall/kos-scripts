@lazyglobal off.

{
  parameter cb.

  runoncepath("lib/libsmoothturn").
  runoncepath("lib/libabsdiffmod").

  local cbRes to cb().
  local loc to cbRes["loc"].
  lock wheelsteering to loc.

  local throttlepid to pidloop(0.77625, 0.44357, 0, -1, 1).
  set throttlepid:setpoint to cbRes["speed"].

  local whlthrot to 0.
  lock wheelthrottle to whlthrot.

  local nextPrintTime to time:seconds.

  until loc:position:mag < 5 {
    brakes off.

    if time:seconds >= nextPrintTime {
      print "distance: " + loc:position:mag.
      set nextPrintTime to time:seconds + 10.
    }

    local pidout to throttlepid:update(time:seconds, ship:velocity:surface:mag).
    set whlthrot to pidout.

    set cbRes to cb().
    set loc to cbRes["loc"].
    if abs(loc:bearing) > 5 { set throttlepid:setpoint to 0.125 * cbRes["speed"]. }
    else { set throttlepid:setpoint to cbRes["speed"]. }
    wait 0.05.
  }

  brakes on.
}
