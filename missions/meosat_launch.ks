@lazyglobal off.

// TODO: the probe decoupler forces don't seem to be uniform

run launch(5, 60).

panels on.

// disable probe RCS thrusters so they don't waste fuel
ag1 on. toggle ag1. // stupid KSP

// extend antennae
toggle ag2.

// wait for all that to happen
wait 5.

rcs on.
run changeapoapsis("dnode", 3000000, true).
sas off.
rcs off.

wait 5.

// release satellites
stage.
wait 120.
stage.
wait 120.
stage.
wait 120.
stage.
wait 120.

// deorbit
warpFor1(30 * 60).
rcs on.
lock steering to retrograde.
wait until faceDiff() < 1.
lock throttle to 1.
wait until periapsis < 70000.
lock throttle to 0.
unlock steering.
rcs off.
