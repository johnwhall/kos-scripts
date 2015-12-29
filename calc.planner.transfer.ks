@lazyglobal off.

parameter bod, initAlt, initInc, tgtAlt, tgtInc.

run once calc.funs.ks.

local initRadius to bod:radius + initAlt.
local tgtRadius to bod:radius + tgtAlt.

local initVel to sqrt(bod:mu / initRadius).
local tgtVel to sqrt(bod:mu / tgtRadius).

local xferSMA to (initRadius + tgtRadius) / 2.
local xferBurnVel to sqrt(bod:mu * (2 / initRadius - 1 / xferSMA)).
local xferBurnDeltaV to abs(xferBurnVel - initVel).

local xferTime to constant:pi * xferSMA / sqrt(bod:mu / xferSMA).

local deltaInc to abs(tgtInc - initInc).

local tgtVel to sqrt(bod:mu / tgtRadius).
local circBurnInitialVel to sqrt(bod:mu * (2 / tgtRadius - 1 / xferSMA)).
local circBurnDeltaV to solveCosineRule(circBurnInitialVel, tgtVel, deltaInc).

// Calculation for prograde and normal components
// TODO: check signs since deltaInc is abs (I think I can just remove the abs).
local phi to arccos((circBurnInitialVel^2 + circBurnDeltaV^2 - tgtVel^2) / (2 * circBurnInitialVel * circBurnDeltaV)).
local alpha to 180 - phi.
local circBurnProgradeDeltaV to circBurnDeltaV * cos(alpha).
local circBurnNormalDeltaV to circBurnDeltaV * sin(alpha).

local totalDetlaV to xferBurnDeltaV + circBurnDeltaV.
local totalDeltaVNoInc to solveCosineRule(circBurnInitialVel, tgtVel, 0) + xferBurnDeltaV.
local inclinationDeltaV to totalDetlaV - totalDeltaVNoInc.

print "Initial Orbital Velocity: " + round(initVel, 2) + " m/s".
print "Transfer Burn Delta-V: " + round(xferBurnDeltaV, 2) + " m/s".
print "Transfer Time: " + formatYdhms(s2ydhms(xferTime)) + " (" + round(xferTime, 2) + " s)".
print "Inclination Change: " + round(deltaInc, 2) + " deg".
print "Circularization Burn Delta-V: " + round(circBurnDeltaV, 2) + " m/s".
print "Circularization Burn Prograde: " + round(circBurnProgradeDeltaV, 2) + " m/s".
print "Circularization Burn Normal: " + round(circBurnNormalDeltaV, 2) + " m/s".
print "Target Orbital Velocity: " + round(tgtVel, 2) + " m/s".
print "Total Delta-V: " + round(totalDetlaV, 2) + " m/s".
print "Delta-V Lost Due to Inclination Change: " + round(inclinationDeltaV, 2) + " m/s".
