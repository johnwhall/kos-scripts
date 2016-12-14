@lazyglobal off.

runoncepath("lib/libisp").

function burnTime {
  parameter myDV, myIsp is isp(), myMaxThrust is maxthrust, myMass is mass.
  local ve to myIsp * 9.80665.
  return (myMass * ve / myMaxThrust) * (1 - constant:e^(-myDV / ve)).
}
