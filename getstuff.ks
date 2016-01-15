@lazyglobal off.

run once liborbitalstate.
run once libmainframe.

//print ship:orbit:period.
//print getECIVecs(ship:orbit).
//print getECIVecs(moon:orbit).

local tMin to 0.
local tMax to 6000.
local tStep to 60.
local dtMin to 2 * 24 * 60 * 60.
local dtMax to 8 * 24 * 60 * 60.
local dtStep to 100.

local result to mainframeLambertOptimize(ship, moon, tMin, tMax, tStep, dtMin, dtMax, dtStep).

local dt to result[0].
local pro to result[1].
local norm to result[2].
local rad to result[3].

print "dt = " + dt.
print "pro = " + pro.
print "norm = " + norm.
print "rad = " + rad.

add node(time:seconds + dt, rad, norm, pro).
