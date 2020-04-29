@lazyglobal off.

function currentThrust {
  local engs to list().
  list engines in engs.

  local t is 0.
  for eng in engs {
    if (eng:ignition) { set t to t + eng:thrust. }
  }

  return t.
}

function atFullThrust {
  parameter threshold is 0.95.
  return currentThrust() > 0.95 * ship:availablethrust.
}

function resourceAmount {
  parameter resList.
  parameter resName.
  local s to 0.
  for res in resList {
    if (res:name = resName) { set s to s + res:amount. }
  }
  return s.
}

//lock throttle to 1.
//stage. // ignite engine
//wait until atFullThrust().
//print (currentThrust() < (0.01 * ship:availablethrust)).
//stage. // disconnect launch clamp
//print (currentThrust() < (0.01 * ship:availablethrust)).
//print currentThrust().
//print ship:availablethrust.
//print 0.01 * ship:availablethrust.
//wait until currentThrust() < (0.01 * ship:availablethrust). // MECO
//print (currentThrust() < (0.01 * ship:availablethrust)).
//asd.
//stage. // decouple first stage & fairings

//local rd103 to ship:partsnamed("ROE-RD100")[0].
//lock throttle to 1.
//stage. // ignite engine
//wait until rd103:thrust > 0.95 * rd103:availablethrust.
//stage. // disconnect launch clamp
//wait until rd103:thrust < 0.01 * rd103:availablethrust. // MECO
//stage. // decouple first stage & fairings

lock throttle to 0.
wait until stage:ready.
stage. // enable RCS
rcs on.

local vecAtBurn to velocityAt(ship, eta:apoapsis - 60).
lock steering to lookdirup(vecAtBurn, ship:up:vector).

wait until eta:apoapsis < 60.
lock throttle to 1.
wait until resourceAmount(ship:resources, "Helium") < 5.
stage. // spin motors

wait until stage:ready.
stage. // ignite 2nd stage
wait until atFullThrust().
wait until currentThrust() < 0.01 * ship:availablethrust. // SECO

stage. // ignite 3rd stage
wait until atFullThrust().
wait until currentThrust() < 0.01 * ship:availablethrust.
