@lazyglobal off.

runoncepath("lib/libisp").

function burnTime1 {
  parameter dv.
  return burnTime4(isp(), mass, maxthrust, dv).
}

function burnTime4 {
  parameter myIsp.
  parameter myMass.
  parameter myMaxThrust.
  parameter myDV.

  local ve to myIsp * 9.80665.
  return (myMass * ve / myMaxThrust) * (1 - constant():e^(-myDV / ve)).
}

