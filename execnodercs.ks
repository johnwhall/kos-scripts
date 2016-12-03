@lazyglobal off.

parameter p_isp, p_thrust, p_turnTime.

runoncepath("lib/libburntime").
runoncepath("lib/libgenericburn").

local bt to burnTime(nextnode:deltav:mag, p_isp, p_thrust).
local burnMidTime to time:seconds + nextnode:eta.

function cb {
  parameter predictDir, lastVal, lastTime.
  local val to nextnode:deltav:mag.
  local throt to 1.

  if lastVal >= 0 {
    local rate to (val - lastVal) / (time:seconds - lastTime).
    local ttzero to val / (-rate).
    set throt to max(0.1, min(1, ttzero)).
    //print "ttzero: "  + ttzero.
  }

  return lexicon("dir", nextnode:deltav, "throt", throt, "val", nextnode:deltav:mag).
}

genericBurnRCS(burnMidTime, bt, p_turnTime, cb@).
remove nextnode.
