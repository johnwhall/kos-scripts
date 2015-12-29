@lazyglobal off.

parameter bod, alt.

run once calc.funs.ks.

local a to bod:radius + alt.
local v to sqrt(bod:mu / a).
local T to 2 * constant:pi * a / v.

print "SMA: " + round(a / 1000, 3) + " km".
print "Orbital Velocity: " + round(v, 2) + " m/s".
print "Orbital Period: " + formatYdhms(s2ydhms(T)) + " (" + round(T, 2) + " s)".
