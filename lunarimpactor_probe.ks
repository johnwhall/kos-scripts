@lazyglobal off.

run once libmainframe.
run once liblambertoptimize.

local es to list().
list engines in es.
es[0]:activate().

wait 5.

local result to lambertOptimize(ship, moon).

local t to result[0].
local pro to result[1].
local norm to result[2].
local rad to result[3].
local dt to result[4].

print "t = " + t.
print "pro = " + pro.
print "norm = " + norm.
print "rad = " + rad.
print "dt = " + dt.

add node(time:seconds + t, rad, norm, pro).

rcs on.
run execnode(30, 0, 10).
rcs off.
