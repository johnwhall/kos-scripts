@lazyglobal off.

parameter tgtInc, turnTime, ullageTime, maxBurnTime.

runoncepath("lib/libcircincatapo").
runoncepath("lib/libburntime").
runoncepath("lib/libisp").

local done to false.
until done {
  local n to nodeToCircIncAtApo(tgtInc).
  add n.
  local bt to burnTime1(n:deltaV:mag).

  if bt > maxBurnTime {

    local ve to isp() * 9.80665.
    local maxDV to ve * ln(mass / (mass - maxBurnTime * (maxthrust / ve))).
    local frac to maxDV / n:deltaV:mag.

    set n:prograde to frac * n:prograde.
    set n:radialout to frac * n:radialout.
    set n:normal to frac * n:normal.

    set done to true.

  } else {
    set done to true.
  }

  //run execnode(turnTime, ullageTime).

}
