@lazyglobal off.

run funs.

sas on.
gear off.
lock throttle to 1.
wait 1. // wait for lock throttle to take effect
stage.

wait 1.

local forevec to heading(90, 90):vector.
local upvec to ship:facing:topvector.
lock steering to lookdirup(forevec, upvec).

wait until ship:verticalspeed > 100.

set forevec to heading(90, 86):vector.
wait 10.

lock steering to lookdirup(ship:velocity:surface, upvec).
wait until ship:obt:periapsis > 130000.
