@lazyglobal off.

runoncepath("lib/liborbit").

//local T to 2 * 60 * 60.
//local a to (earth:mu * T * T / (4 * constant:pi ^ 2)) ^ (1 / 3).
//local v to sqrt(earth:mu / a).
//
//print T.
//print a.
//print v.
//
//local twoHourOrbit to orbitFromStateVectors(V(a, 0, 0), V(0, 0, v), earth).
//print twoHourOrbit.
//print twoHourOrbit:velocity:orbit.
//print twoHourOrbit:period.
//print twoHourOrbit:position - ship:body:position.
//
//print ship:orbit:position.

local ofsv to orbitFromStateVectors(ship:position - body:position, ship:velocity:orbit - body:velocity:orbit, body).
print ofsv:position.
print ofsv:velocity:orbit.
print ofsv:period.

//clearVecDraws().
//
//local poHalf to predictOrbit(time:seconds + ship:orbit:period / 2).
//local halfVecDraw to vecDraw(ship:position, { return poHalf:position. }, white, "", 1, true).
//local poQuart to predictOrbit(time:seconds + ship:orbit:period / 4).
//local quartVecDraw to vecDraw(ship:position, { return poQuart:position. }, blue, "", 1, true).
//local po3Quart to predictOrbit(time:seconds + 3 * ship:orbit:period / 4).
//local threeQuartVecDraw to vecDraw(ship:position, { return po3Quart:position. }, green, "", 1, true).
//
//wait 100.
