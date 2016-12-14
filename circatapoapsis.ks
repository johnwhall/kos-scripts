@lazyglobal off.

run once funs.

local vApo to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
local vCirc to sqrt(body:mu / (ship:obt:apoapsis + body:radius)).
local dv to vCirc - vApo.
local bt to burnTime(dv).

local throt to 0.
lock throttle to throt.
local prevSAS to sas.
sas off.

warpFor1(eta:apoapsis - bt - 60).

lock steering to prograde.
wait until faceDiff() < 0.5.

warpFor1(eta:apoapsis - (bt / 2)).

local lastEcc to ship:obt:eccentricity.
set throt to 1.
until lastEcc < ship:obt:eccentricity {
  set lastEcc to ship:obt:eccentricity.
  wait 0.01.
}

set throt to 0.
set sas to prevSAS.
