@lazyglobal off.

parameter bod, alt, count, powerReq.

run once calc.funs.ks.

function eclipseAngle {
  parameter r. // body radius
  parameter d. // body's distance from sun
  parameter a. // spacecraft sma around body

  return 2 * abs(constant:pi / 2 + arcsin(r / d) - arccos(r / a)).
}

run calc.orbit.circ.ks(bod, alt).

local a to bod:radius + alt.
local T to 2 * constant:pi * a / sqrt(bod:mu / a).

local covgAngle to 2 * arccos(bod:radius / a).
local fullCovg to false.
if count * covgAngle >= 360 { set fullCovg to true. }
local distBetween to a * sqrt(2 * (1 - cos(360 / count))).
local maxEclipseAng to eclipseAngle(body:radius, body:orbit:periapsis, a).
local timeInSunlight to (360 - maxEclipseAng) * T / 360.
local timeInEclipse to maxEclipseAng * T / 360.
local batReq to powerReq * timeInEclipse.
local genReq to powerReq + batReq / timeInSunlight.

print "Coverage Angle: " + round(covgAngle, 2) + " deg".
print "Full Equatorial Coverage: " + fullCovg.
print "Distance Between Satellites: " + round(distBetween / 1000, 3) + " km".
print "Maximum Eclipse Angle: " + round(maxEclipseAng, 2) + " deg".
print "Time in Sunlight: " + formatYdhms(s2ydhms(timeInSunlight)) + " (" + round(timeInSunlight, 2) + " s)".
print "Time in Eclipse: " + formatYdhms(s2ydhms(timeInEclipse)) + " (" + round(timeInEclipse, 2) + " s)".
print "Battery Required: " + round(batReq, 2) + " EC".
print "Generator Required: " + round(genReq, 2) + " EC/s" + " (" + round(genReq * 60, 2) + " EC/m)".
