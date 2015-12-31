@lazyglobal off.

stage. // dummy decoupler stage
wait until stage:ready.
stage. // activate engines
rcs on.
toggle ag1. // turn RCS thrusters back on

// Do this a few times so it is more accurate
run circincatapo(0, false).
run circincatapo(0, false).
run circincatapo(0, false).

rcs off.
