@lazyglobal off.

run once libsasrcsstack.
run once libfacediff.
run once libwarpfor.

function waitForLAN {
  parameter p_tgtLan.

  local lan to ship:orbit:longitudeofascendingnode.
  local dlan to p_tgtLan - lan.
  if lan > p_tgtLan {
    set dlan to (360 - lan) + p_tgtLan.
  }

  warpFor1(body:rotationperiod * dlan / 360).
}

waitForLAN(2).

run launch(5, 55).

unlock steering.
sas off.

panels on.

wait 10.

stage.

wait 45.

rcs on.
set steeringmanager:pitchts to 20.
set steeringmanager:yawts to 20.
lock steering to lookdirup(retrograde:vector, ship:facing:topvector).
wait until faceDiff() < 0.5.

lock throttle to 1.
wait until ship:orbit:periapsis < 80000.
lock throttle to 0.

rcs off.
unlock steering.
unlock throttle.
wait 0.01.
