@lazyglobal off.

parameter p_turnTime, p_ullageTime.

runoncepath("lib/libburntime").
runoncepath("lib/libgenericburn").

local bt to burnTime1(nextnode:deltav:mag).
local burnMidTime to time:seconds + nextnode:eta.

function execnode_cb {
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

genericBurn(burnMidTime, bt, p_turnTime, p_ullageTime, execnode_cb@).
remove nextnode.
