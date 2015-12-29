@lazyglobal off.

parameter tgtInc, settleFuel.

run once calc.funs.ks.

local tgtSMA to body:radius + apoapsis.
local curSMA to ship:orbit:semimajoraxis.

local Vc to sqrt(body:mu / tgtSMA).
local Vt to sqrt(body:mu * (2 / (body:radius + apoapsis) - 1 / curSMA)).
local Vd to solveCosineRule(Vc, Vt, tgtInc - ship:orbit:inclination).

local phi to arccos((Vt^2 + Vd^2 - Vc^2) / (2 * Vt * Vd)).
local alpha to 180 - phi.
local Vp to Vd * cos(alpha).
local Vn to Vd * sin(alpha).

run addman("apo").
set nextnode:prograde to Vp.
set nextnode:normal to Vn.

run execnode(settleFuel).
