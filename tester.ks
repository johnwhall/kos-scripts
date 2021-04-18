@lazyglobal off.

runoncepath("lib/libstring").
runoncepath("lib/libtimeto").

local i to 0.
local x to 0.
wait 0.001.
local startTime to time:seconds.
until i > 10000 {
  set x to ship:orbit:eccentricity.
  set i to i + 1.
}
local endTime to time:seconds.
print (endTime - startTime).
