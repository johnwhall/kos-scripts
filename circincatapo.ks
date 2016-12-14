@lazyglobal off.

parameter tgtInc, turnTime, ullageTime, maxBurnTime, faceSunBetween.

runoncepath("lib/libcircincatapo").
runoncepath("lib/libburntime").
runoncepath("lib/libisp").
runoncepath("lib/libgenericburn").

local done to false.
until done {
  local n to nodeToCircIncAtApo(tgtInc).
  add n.
  local bt to burnTime(n:deltaV:mag).

  local burnStartTime to 0.
  local lastPrint to time:seconds.
  function valueCallback {
    if burnStartTime = 0 { set burnStartTime to time:seconds. }

    if time:seconds - lastPrint > 60 {
      set lastPrint to time:seconds.
      print "Burn time remaining: " + ((maxBurnTime + burnStartTime) - time:seconds).
    }

    if time:seconds >= burnStartTime + maxBurnTime { return 99999999. }
    return nextnode:deltaV:mag.
  }

  function nnDV {
    parameter p_x.
    return nextnode:deltaV.
  }

  local realBurnTime to min(bt, maxBurnTime).
  if realBurnTime = bt { set done to true. }
  genericBurn("apo", realBurnTime, turnTime, ullageTime, valueCallback@, nnDV@).
  remove nextnode.

  if not done and faceSunBetween {
    runpath("faceSun").
  }
}
